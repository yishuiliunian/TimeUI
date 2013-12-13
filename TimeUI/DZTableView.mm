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

typedef map<int, float> DZCellYoffsetMap;
typedef vector<float>   DZCellHeightVector;

@interface DZTableView ()
{
    DZTableDataSourceResponse _dataSourceReponse;
    NSMutableSet*  _cacheCells;
    NSMutableDictionary* _visibleCellsMap;
    int64_t     _numberOfCells;
    DZCellHeightVector _cellHeights;
    DZCellYoffsetMap _cellYOffsets;
}

@end

@implementation DZTableView
@synthesize dataSource              = _dataSource;
@synthesize topPullDownView = _topPullDownView;

- (void) handleTapGestrue:(UITapGestureRecognizer*)tapGestrue
{
    CGPoint point = [tapGestrue locationInView:self];
    NSArray* cells = _visibleCellsMap.allValues;
    for (DZTableViewCell* each in cells) {
        CGRect rect = each.frame;
        if (CGRectContainsPoint(rect, point)) {
            if ([_actionDelegate respondsToSelector:@selector(dzTableView:didTapAtRow:)]) {
                [_actionDelegate dzTableView:self didTapAtRow:each.index];
            }
        }
    }
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _visibleCellsMap = [NSMutableDictionary new];
        _cacheCells = [NSMutableSet new];
        [self addTapTarget:self selector:@selector(handleTapGestrue:)];
    }
    return self;
}

- (void) setDataSource:(id<DZTableViewSourceDelegate>)dataSource
{
    _dataSource                         = dataSource;
    _dataSourceReponse.funcNumberOfRows = [_dataSource respondsToSelector:@selector(numberOfRowsInDZTableView:)];
    _dataSourceReponse.funcCellAtRow    = [_dataSource respondsToSelector:@selector(dzTableView:cellAtRow:)];
    _dataSourceReponse.funcHeightRow    = [_dataSource respondsToSelector:@selector(dzTableView:cellHeightAtRow:)];
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
      _numberOfCells = [_dataSource numberOfRowsInDZTableView:self];
    float height = 0;
    for (int i = 0  ; i < _numberOfCells; i ++) {
        float cellHeight = (_dataSourceReponse.funcHeightRow? [_dataSource dzTableView:self cellHeightAtRow:i] : kDZTableViewDefaultHeight);
        _cellHeights.push_back(cellHeight);
        height += cellHeight;
        _cellYOffsets.insert(pair<int, float>(i, height));
    }
    if (height < CGRectGetHeight(self.frame)) {
        height = CGRectGetHeight(self.frame) + 2;
    }
    CGSize size = CGSizeMake(CGRectGetWidth(self.frame), height);
    
    [self setContentSize:size];
}
- (void) reloadData
{
    NSCAssert(_dataSourceReponse.funcCellAtRow, @"dztalbeview %@ delegate %@ not response to selector numberOfRowsInDZTableView: ", self, _dataSource);
    NSCAssert(_dataSourceReponse.funcCellAtRow, @"dztalbeview %@ delegate %@ not response to selector dzTableView:cellAtRow: ", self, _dataSource);

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

- (void) addCell:(DZTableViewCell*)cell atRow:(NSInteger)row
{
    [self addSubview:cell];
    cell.index =  row;
    [_visibleCellsMap setObject:cell  forKey:@(row)];
}


- (void) layoutNeedDisplayCells
{
    NSRange displayRange = [self displayRange];
    for (int i = (int)displayRange.location ; i < displayRange.length + displayRange.location; i ++) {
        DZTableViewCell* cell = [self _cellForRow:i];
        [self addCell:cell atRow:i];
        cell.frame = [self _rectForCellAtRow:i];
    }
    [self cleanUnusedCellsWithDispalyRange:displayRange];
    [self displayPullDownView];
    
}

- (void) layoutSubviews
{
    [self layoutNeedDisplayCells];
}




- (NSArray*) cellsBetween:(NSInteger)start end:(NSInteger)end
{
    NSMutableArray* array = [NSMutableArray new];
    for (int i = start ; i < end; i++) {
        DZTableViewCell* cell = _visibleCellsMap[@(i)];
        if (cell) {
            [array addObject:cell];
        }
    }
    return array;
}

- (void) insertRowAt:(NSSet *)rowsSet withAnimation:(BOOL)animation
{
    NSNumber* row = [rowsSet anyObject];
    int rowIndex = [row intValue];
    NSRange displayRange  =[self displayRange];
    DZCellYoffsetMap oldCellHeightMap = DZCellYoffsetMap(_cellYOffsets);
    DZCellHeightVector oldCellHeightVecotr = DZCellHeightVector(_cellHeights);
    [self reduceContentSize];
    if (NSLocationInRange(rowIndex, displayRange)) {
        
        NSArray* afterCells = [self cellsBetween:rowIndex end:displayRange.location + displayRange.length - rowIndex];
        for (DZTableViewCell* each  in afterCells) {
            each.index += 1;
            _visibleCellsMap[@(each.index)] = each;
        }
        [_visibleCellsMap removeObjectForKey:@(rowIndex)];
        
        DZTableViewCell* anOtherCell = [self _cellForRow:rowIndex];
        [self addCell:anOtherCell atRow:rowIndex];
        CGRect anOtherCellFrame = [self _rectForCellAtRow:rowIndex];
        anOtherCell.frame = CGRectOffset(anOtherCellFrame, - CGRectGetWidth(anOtherCellFrame), 0);
        void(^animationBlock)(void) = ^(void) {
            for (DZTableViewCell* each  in afterCells) {
                CGRect rect = [self _rectForCellAtRow:each.index];
                each.frame = rect;
            }
            anOtherCell.frame = anOtherCellFrame;
        };
        if (animation) {
            [UIView animateWithDuration:DZAnimationDefualtDuration animations:animationBlock completion:^(BOOL finished) {
                
            }];
        }
        else
        {
            animationBlock();
        }
        
    }
}



@end
