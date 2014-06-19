//
//  DZ24Analysis.m
//  TimeUI
//
//  Created by stonedong on 14-4-20.
//  Copyright (c) 2014年 Stone Dong. All rights reserved.
//

#import "DZ24Analysis.h"
#import "DZTimeType.h"
#import "DZTime.h"
#import "NSDate+SSToolkitAdditions.h"
#import <NSDate-TKExtensions.h>
#import "NSString+WizString.h"
#import "DZChartNode.h"

@interface DZ24Node : NSObject
@property (nonatomic, assign) NSRange range;
@property (nonatomic, strong) NSString* name;
@end

@implementation DZ24Node



@end

@interface DZ24Analysis ()
{
    NSArray* _allTypes;
    NSArray* _allTimes;
    //
    NSMutableDictionary* _typesIndexMap;
    int _granularity;
    int _timeSpitCount;
}
@end
@implementation DZ24Analysis

- (instancetype) init
{
    self = [super init];
    if (!self) {
        return nil;
    }
    [self commitInit];
    
    return self;
}

- (void) loadGranularity:(int)gr
{
    _granularity = gr;
    _timeSpitCount = 24*60 * 60 / _granularity;
}

- (void) commitInit
{
    [self loadGranularity:60];
}

- (void) loadTypesIndex
{
    _typesIndexMap = [NSMutableDictionary new];
    for (int i = 0; i < _allTypes.count; i++) {
        DZTimeType* type = _allTypes[i];
        _typesIndexMap[@(i)] = type.name;
        _typesIndexMap[type.guid]= @(i);
    }
}

- (NSArray*) loadTypes:(NSArray*)types times:(NSArray*)times
{
    if ((types.count == 0) || (times.count==0)) {
        return nil;
    }
    _allTypes = types;
    [self loadTypesIndex];
    float _analysisCache[_timeSpitCount][_allTypes.count];
    memset(_analysisCache, 0, types.count*_timeSpitCount*sizeof(float));
    for (DZTime* time  in times) {
        NSDate* begin = time.dateBegin;
        NSDate* day0 = [begin TKDateByMovingToBeginningOfDay];
        NSTimeInterval from0 = [begin timeIntervalSinceDate:day0];
        NSTimeInterval length = [time.dateEnd timeIntervalSinceDate:begin];
        for (int localLength = 0 , tIndex = (int)from0 % _timeSpitCount;
             localLength < length; localLength += _granularity, tIndex++) {
            int tpIndex = [_typesIndexMap[time.typeGuid] intValue];
            _analysisCache[tIndex%_timeSpitCount][tpIndex] += _granularity;
        }
    }
    
    NSMutableArray* nodes = [NSMutableArray new];
    DZ24Node* lastNode = nil;
    int lastMaxIndex = -1;
    for (int i = 0; i< _timeSpitCount; i++) {
        
        float max = 0;
        int maxIndex = 0;

        for (int j = 0 ; j < _allTypes.count; j++) {
            float len = _analysisCache[i][j];
            if ( len >max) {
                len = max;
                maxIndex = j;
            }
        }
        if (lastMaxIndex != -1) {
           int cost =  _analysisCache[i][lastMaxIndex];
            if (maxIndex == cost) {
                maxIndex = lastMaxIndex;
            }
        }
        if (maxIndex != lastMaxIndex) {
            lastMaxIndex = maxIndex;
            lastNode = [DZ24Node new];
            lastNode.name = _typesIndexMap[@(maxIndex)];
            lastNode.range = NSMakeRange(i, 1);
            [nodes addObject:lastNode];
        } else {
            NSRange range = lastNode.range;
            range.length += 1;
            lastNode.range = range;
        }
    }

    nodes = [[nodes sortedArrayUsingComparator:^NSComparisonResult(DZ24Node* obj1, DZ24Node* obj2) {
        return obj1.range.location > obj2.range.location;
        
    }] mutableCopy];
    
    
    for (int i = 0 ; i < nodes.count; i ++) {
        DZ24Node* node = nodes[i];
        float start = node.range.location * _granularity;
        node.range = NSMakeRange(start, node.range.length*_granularity);
    }
    return nodes;
}

+ (NSArray*) chartNodes
{
    DZ24Analysis* ana = [DZ24Analysis new];
    NSArray* array= [ana loadTypes:[DZActiveTimeDataBase allTimeTypes] times:[DZActiveTimeDataBase allTimes]];
    
    NSMutableArray* allNodes = [NSMutableArray new];
    for (DZ24Node* node in array) {
        DZChartNode* chartNode = [DZChartNode nodeWithKey:node.name value:node.range.length];
        [allNodes addObject:chartNode];
    }
    return allNodes;
}

@end
