//
//  DZMessage.h
//  TimeUI
//
//  Created by Stone Dong on 13-12-15.
//  Copyright (c) 2013年 Stone Dong. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    DZMessageTypeError,
    DZMessageTypeInfo,
    DZMessageTypeWarning,
    DZMessageTypeSuccess
}DZMessageType;

@interface DZMessage : NSObject
@property (nonatomic, strong) NSString* text;
@property (nonatomic, assign) DZMessageType type;
@property (nonatomic, assign) float showTime;
@end
