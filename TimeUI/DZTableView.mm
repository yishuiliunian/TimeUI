//
//  DZTableView.m
//  TimeUI
//
//  Created by Stone Dong on 13-12-12.
//  Copyright (c) 2013年 Stone Dong. All rights reserved.
//

#import "DZTableView.h"
#import "DZTableViewCell_private.h"
#import <map>
#import <vector>
#define kDZTableViewDefaultHeight 44.0f

using namespace std;
typedef struct {
    BOOL funcNumberOfRows;
    BOOL funcCellAtRow;
    BOOL funcHeightRow;
    BOOL funcPullDownCell;
}DZTableDataSourceResponse;

typedef map<int, float> DZCellHeightMap;
typedef vector<float>   DZCellHeightVector;

@interface DZTableView ()
{
    DZTableDataSourceResponse _dataSourceReponse;
    NSMutableSet*  _cacheCells;
    NSMutableDictionary* _visibleCellsMap;
    int64_t     _numberOfCells;
    DZCellHeightVector _cellHeights;
    DZCellHeightMap _cellYOffsets;
}

@end

@implementation DZTableView
@synthesize dataSource              = _dataSource;
@synthesize topPullDownView = _topPullDownView;
- (void) setDataSource:(id<DZTableViewSourceDelegate>)dataSource
{
    _dataSource                         = dataSource;
    _dataSourceReponse.funcNumberOfRows = [_dataSource respondsToSelector:@selector(numberOfRowsInDZTableView:)];
    _dataSourceReponse.funcCellAtRow    = [_dataSource respondsToSelector:@selector(dzTableView:cellAtRow:)];
    _dataSourceReponse.funcHeightRow    = [_dataSource respondsToSelector:@selector(dzTableView:cellHeightAtRow:)];
    _dataSourceReponse.funcPullDownCell = [_dataSource respondsToSelector:@selector(pullDownCellInDZTableView:)];
}

- (DZTableViewCell*) dequeueDZTalbeViewCellForIdentifiy:(NSString*)identifiy
{
    DZTableViewCell* cell = Nil;
    for (DZTableViewCell* each  in _cacheCells) {
        if ([each.identifiy isEqualToString:identifiy]) {
            cell = each;
            break;
        }
    }
    if (cell) {
        [_cacheCells removeObject:cell];
    }
    return cell;
}

- (void) enqueueTableViewCell:(DZTableViewCell*)cell
{
    if (cell) {
        [cell prepareForReused];
        [_cacheCells addObject:cell];
        [cell removeFromSuperview];
    }
}

- (NSArray*) visibleCells
{
    return _visibleCellsMap.allValues;
}

- (DZTableViewCell*) _cellForRow:(NSInteger)rowIndex
{
    DZTableViewCell* cell = [_visibleCellsMap objectForKey:@(rowIndex)];
    if (cell) {
        return cell;
    }
    if (_dataSourceReponse.funcCellAtRow) {
        cell = [_dataSource dzTableView:self cellAtRow:rowIndex];
    }
    return cell;
}

- (void) reduceContentSize
{
    float height = 0;
    for (int i = 0  ; i < _numberOfCells; i ++) {
        float cellHeight = (_dataSourceReponse.funcHeightRow? [_dataSource dzTableView:self cellHeightAtRow:i] : kDZTableViewDefaultHeight);
        _cellHeights.push_back(cellHeight);
        height += cellHeight;
        _cellYOffsets.insert(pair<int, float>(i, height));
    }
    CGSize size = CGSizeMake(CGRectGetWidth(self.frame), height);
    [self setContentSize:size];
}
- (void) reloadData
{
    NSCAssert(_dataSourceReponse.funcCellAtRow, @"dztalbeview %@ delegate %@ not response to selector numberOfRowsInDZTableView: ", self, _dataSource);
    NSCAssert(_dataSourceReponse.funcCellAtRow, @"dztalbeview %@ delegate %@ not response to selector dzTableView:cellAtRow: ", self, _dataSource);
    _numberOfCells = [_dataSource numberOfRowsInDZTableView:self];
    [self reduceContentSize];
    [self layoutNeedDisplayCells];
}

- (NSRange) displayRange
{
    int  beginIndex = 0;
    float beiginHeight = self.contentOffset.y;
    float displayBeginHeight = -0.00000001f;
    
    for (int i = 0 ; i < _numberOfCells; i++) {
        float cellHeight = _cellHeights.at(i);
        displayBeginHeight += cellHeight;
        if (displayBeginHeight > beiginHeight) {
            beginIndex = i;
            break;
        }
    }
    
    int endIndex = beginIndex;
    float displayEndHeight = self.contentOffset.y + CGRectGetHeight(self.frame);
    for (int i = beginIndex; i < _numberOfCells; i ++) {
        float cellYoffset = _cellYOffsets.at(i);
        if (cellYoffset > displayEndHeight) {
            endIndex = i;
            break;
        }
        if (i == _numberOfCells - 1) {
            endIndex = i;
            break;
        }
    }
    return NSMakeRange(beginIndex, endIndex - beginIndex + 1);
}

- (CGRect) _rectForCellAtRow:(int)rowIndex
{
    float cellYoffSet = _cellYOffsets.at(rowIndex);
    float cellHeight  = _cellHeights.at(rowIndex);
    return CGRectMake(0, cellYoffSet - cellHeight, CGRectGetWidth(self.frame), cellHeight);
}

- (void) cleanUnusedCellsWithDispalyRange:(NSRange)range
{
    NSDictionary* dic = [_visibleCellsMap copy];
    NSArray* keys = dic.allKeys;
    for (NSNumber* rowIndex  in keys) {
        int row = [rowIndex intValue];
        if (!NSLocationInRange(row, range)) {
            DZTableViewCell* cell = [_visibleCellsMap objectForKey:rowIndex];
            [_visibleCellsMap removeObjectForKey:rowIndex];
            [self enqueueTableViewCell:cell];
        }
    }
}

- (void) displayPullDownView
{
    if (!_topPullDownView) {
        return;
    }
    if (self.contentOffset.y > 0) {
        [_topPullDownView removeFromSuperview];
    }
    else
    {
        [self addSubview:_topPullDownView];
        _topPullDownView.frame = CGRectMake(0, -_topPullDownView.height, CGRectGetWidth(self.frame), _topPullDownView.height);
    }
}

- (void) layoutNeedDisplayCells
{
    NSRange displayRange = [self displayRange];
    for (int i = (int)displayRange.location ; i < displayRange.length + displayRange.location; i ++) {
        DZTableViewCell* cell = [self _cellForRow:i];
        [self addSubview:cell];
        cell.frame = [self _rectForCellAtRow:i];
        [_visibleCellsMap setObject:cell  forKey:@(i)];
    }
    [self cleanUnusedCellsWithDispalyRange:displayRange];
    [self displayPullDownView];
    
}

- (void) layoutSubviews
{
    [self layoutNeedDisplayCells];
}



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _visibleCellsMap = [NSMutableDictionary new];
        _cacheCells = [NSMutableSet new];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
