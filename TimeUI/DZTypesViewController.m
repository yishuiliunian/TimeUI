//
//  DZTypesViewController.m
//  TimeUI
//
//  Created by Stone Dong on 13-12-11.
//  Copyright (c) 2013年 Stone Dong. All rights reserved.
//

#import "DZTypesViewController.h"
#import "DZDBManager.h"
#import "DZTimeType.h"
#import "DZTypeCell.h"
#import "DZMessageContainerView.h"
#import "DZNotificationCenter.h"
#import "DZTestInterface.h"
#import "DZAnalysisManager.h"
#import "DZImageCache.h"
#import <KXKiOSGradients.h>
#import "DZSawtoothView.h"
#import "DZSelecteTypeInterface.h"
#import "DZTimeTrickManger.h"
#import "NSString+WizString.h"
#import "DZFileUtility.h"
#import "DZAccountManager.h"
@interface DZTypesViewController () 
@end

@implementation DZTypesViewController
@synthesize selectDelegate = _selectDelegate;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [[DZNotificationCenter defaultCenter] addObserver:self forKey:kDZNotification_DidReloadTypes];
    }
    return self;
}
- (void) loadViewCSS:(id)cssValue forKey:(NSString *)key
{
    if ([key isEqualToString:@"background"]) {
        self.backgroudView.image =  cssValue;
    }  else if ([key isEqualToString:@"table_gradient"])
    {
        self.tableView.gradientColor = cssValue;
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
    DZSawtoothView* tooth = [[DZSawtoothView alloc] initWithFrame:CGRectMake(0, 0, 0, 10)];
    self.tableView.bottomView = tooth;
    tooth.color = [UIColor lightGrayColor];
    
    [self reloadAllData];
    
    
}

- (void) printTypes
{
//    for (int i = 0; i < _timeTypes.count; i++) {
//        NSLog(@"type %d is %@",i, [_timeTypes[i] name]);
//    }
}
- (void) sortTypes
{
    NSString* filePath = [DZActiveAccount.documentsPath stringByAppendingPathComponent:@"sortstypes"];
     NSMutableDictionary* typesSortMap = nil;
    typesSortMap = [NSMutableDictionary dictionaryWithContentsOfFile:filePath];
    if (!typesSortMap) {
        typesSortMap = [NSMutableDictionary new];
    }
    [self printTypes];
    
    [_timeTypes sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        DZTimeType* t1 = (DZTimeType*)obj1;
        DZTimeType* t2 = (DZTimeType*)obj2;
        NSNumber* index1 = typesSortMap[t1.name];
        NSNumber* index2 = typesSortMap[t2.name];
        return (NSComparisonResult)( [index1 intValue] - [index2 intValue]);
    }];
    [self printTypes];
    [self localizedSotreTypes];
}
- (void) localizedSotreTypes
{
    NSString* filePath = [DZActiveAccount.documentsPath stringByAppendingPathComponent:@"sortstypes"];
    NSMutableDictionary* typesSortMap = [NSMutableDictionary new];
    for (int i = 0 ; i < _timeTypes.count; i++) {
        DZTimeType* type = _timeTypes[i];
        typesSortMap[type.name] = @(i);
        [[DZAnalysisManager shareManager] triggleAnaylysisWeekWithType:type];
    }
    [typesSortMap writeToFile:filePath atomically:YES];
}
- (void) reloadAllData
{
    _timeTypes = [[DZActiveTimeDataBase allUnFinishedTimeTypes] mutableCopy];
    [self sortTypes];
    
    [self.tableView reloadData];
    [[DZAnalysisManager shareManager] triggleAnaylysisTimeCount];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (CGFloat) dzTableView:(DZTableView *)tableView cellHeightAtRow:(NSInteger)row
{
    return DZTypeCellHeight;
}
- (NSInteger) numberOfRowsInDZTableView:(DZTableView *)tableView
{
    return _timeTypes.count;
}

- (DZTableViewCell*) dzTableView:(DZTableView *)tableView cellAtRow:(NSInteger)row
{
    static NSString* const cellIdentifiy = @"detifail";
    DZTypeCell* cell = (DZTypeCell*)[tableView dequeueDZTalbeViewCellForIdentifiy:cellIdentifiy];
    if (!cell) {
        cell = [[DZTypeCell alloc] initWithIdentifiy:cellIdentifiy];
        cell.nameLabel.textColor = [UIColor whiteColor];
        cell.nameLabel.font = [UIFont systemFontOfSize:28];
    }
    if (row == _timeTypes.count) {
        return cell;
    }
    DZTimeType* type = [_timeTypes objectAtIndex:row];
    cell.nameLabel.text = type.name;
    cell.countLabel.text = [@([DZShareAnalysisManager numberOfTimeForType:type]) stringValue];
    cell.costLabel.text = [NSString readableTimeStringWithInterval:[DZShareAnalysisManager timeCostOfType:type]];
    cell.backgroundColor = [UIColor clearColor];
    cell.type = type;
    return cell;
}
- (void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.tableView.topPullDownView.topYOffSet = self.tableView.contentOffset.y ;
}

- (void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (self.tableView.topPullDownView.state == DZPullDownViewStateToggled) {
        DZInputCellView* inputView = [[DZInputCellView alloc] init];
        inputView.delegate = self;
        [inputView showInView:[UIApplication sharedApplication].keyWindow withAnimation:YES completion:^{
            
        }];
    }
}


- (void) dzInputCellView:(DZInputCellView *)inputView hideWithText:(NSString *)text
{
    DZTimeType* type = [[DZTimeType alloc] initGenGUID];
    type.name = text;
    type.detail = text;
    [DZActiveTimeDataBase updateTimeType:type];
    [_timeTypes insertObject:type atIndex:0];
    [self.tableView insertRowAt:[NSSet setWithObject:@(0)] withAnimation:YES];
    [self printTypes];
    [self localizedSotreTypes];
    [self didAddTypes:type];
}

- (void) dzInputCellViewUserCancel:(DZInputCellView *)inputView
{
    
}

- (void) dzTableView:(DZTableView *)tableView deleteCellAtRow:(NSInteger)row
{
    DZTimeType* type = _timeTypes[row];
    [_timeTypes removeObjectAtIndex:row];
    [self.tableView removeRowAt:row withAnimation:YES];
    [DZActiveTimeDataBase delteTimeType:type];
    [self localizedSotreTypes];
    
    [DZShareAnalysisManager triggleAnaylysisTimeCost];
    
    [self didRemoveTypes:type];
}

- (void) dzTableView:(DZTableView *)tableView editCellDataAtRow:(NSInteger)row
{
    [DZShareAnalysisManager triggleCommand:@""];
}

- (void) didAddTypes:(DZTimeType *)type
{
    
}

- (void) didRemoveTypes:(DZTimeType *)type
{
    
}

- (void) globalDidReloadTypes
{
    [self reloadAllData];
}
@end