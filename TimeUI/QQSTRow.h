//
//  QQSTRow.h
//  QQMSFContact
//
//  Created by Stone Dong on 14-2-12.
//
//

#import <Foundation/Foundation.h>

@interface QQSTRow : NSObject
@property (nonatomic, strong) NSString* title;
@property (nonatomic, strong) NSString* detail;
@property (nonatomic, assign) id actionTarget;
@property (nonatomic, assign) SEL action;
@property (nonatomic, assign) UITableViewCellAccessoryType accessoryType;
- (instancetype) initWithTarget:(id)target action:(SEL)action;
@end
