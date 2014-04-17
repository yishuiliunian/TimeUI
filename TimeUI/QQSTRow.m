//
//  QQSTRow.m
//  QQMSFContact
//
//  Created by Stone Dong on 14-2-12.
//
//

#import "QQSTRow.h"

@implementation QQSTRow

- (void) commontInit
{
    _accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}
- (instancetype) initWithTarget:(id)target action:(SEL)action
{
    self = [super init];
    if (!self) {
        return self;
    }
    [self commontInit];
    _actionTarget = target;
    _action = action;
    return self;
}
@end
