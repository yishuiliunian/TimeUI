//
//  DZEditTypesViewController.m
//  TimeUI
//
//  Created by stonedong on 14-7-12.
//  Copyright (c) 2014年 Stone Dong. All rights reserved.
//

#import "DZEditTypesViewController.h"
#import "DZTimeType.h"
#import "DZSwitchCell.h"
#import "DZChangedTypesNI.h"

static int const kEnableIndex = 0;
static int const kDisableIndex = 1;



@interface DZEditTypesViewController () <DZSwitchCellDelegate>
DEFINE_PROPERTY_STRONG(NSMutableArray*, allTypes);
@end

@implementation DZEditTypesViewController

- (void) viewDidLoad
{
    [super viewDidLoad];
    _allTypes = [NSMutableArray new];
    [self reloadData];
}

void(^SortTypesArray)(NSMutableArray*) = ^(NSMutableArray* types) {
    [types sortUsingComparator:^NSComparisonResult(DZTimeType* obj1, DZTimeType* obj2) {
        return [obj1.name compare:obj2.name];
    }];
};

- (void) reloadData
{


    NSArray* types = [DZActiveTimeDataBase allTimeTypes];
    NSMutableArray* enableTypes = [NSMutableArray new];
    NSMutableArray* disableTypes = [NSMutableArray new];
    
    [_allTypes removeAllObjects];
    
    [_allTypes insertObject:enableTypes atIndex:kEnableIndex];
    [_allTypes insertObject:disableTypes atIndex:kDisableIndex];
    
    for (DZTimeType* type  in types) {
        if (type.isFinished) {
            [disableTypes addObject:type];
        } else {
            [enableTypes addObject:type];
        }
    }
    SortTypesArray(disableTypes);
    SortTypesArray(enableTypes);
    
    [self.tableView reloadData];
}
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return _allTypes.count;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_allTypes[section] count];
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* const cellIdentify = @"switch cell";
    DZSwitchCell* cell = (DZSwitchCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentify];
    if (!cell) {
        cell = [[DZSwitchCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentify];
        cell.delegate = self;
    }
    
    DZTimeType* type = _allTypes[indexPath.section][indexPath.row];
    cell.enabled = !(type.isFinished);
    cell.titleLabel.text = type.name;
    return cell;
}

- (NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == kEnableIndex) {
        return @"显示中的时间种类";
    } if (section == kDisableIndex) {
        return @"隐藏掉的时间种类";
    }
    return @"";
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35;
}


- (void) switchCell:(DZSwitchCell *)cell didChangedEnable:(BOOL)enable
{
    NSIndexPath* indexPath = [self.tableView indexPathForCell:cell];
    
    DZTimeType* type = _allTypes[indexPath.section][indexPath.row];
    type.isFinished = !enable;
    [_allTypes[indexPath.section] removeObject:type];
    
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    ////
    int index = enable ? kEnableIndex : kDisableIndex;
    
    NSMutableArray* types = _allTypes[index];
    [types addObject:type];
    SortTypesArray(types);
    int typeIndex = NSNotFound;
    for (int i = 0; i < types.count; i++) {
        DZTimeType* t = types[i];
        if (t == type) {
            typeIndex = i;
            break;
        }
    }
    
    if (typeIndex != NSNotFound) {
        [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:typeIndex inSection:index]] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    
    type.localChanged = YES;
    if( [DZActiveTimeDataBase updateTimeType:type])
    {
        NSMutableDictionary* infos = [NSMutableDictionary dictionary];
        if (type) {
            infos[@"type"] = type;
        }
        infos[@"method"] = kDZTypesChangedModified;
        [DZDefaultNotificationCenter postMessage:kDZNotification_TypesChanged userInfo:infos];
    }
}

- (BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
- (void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        DZTimeType* type = _allTypes[indexPath.section][indexPath.row];
        DBDeleteTimeTypeRow(type);
        
        NSMutableDictionary* infos = [NSMutableDictionary dictionary];
        if (type) {
            infos[@"type"] = type;
        }
        infos[@"method"] = kDZTypesChangedRemove;
        [DZDefaultNotificationCenter postMessage:kDZNotification_TypesChanged userInfo:infos];
    }
    
}
@end
