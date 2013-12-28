//
//  DZObject.h
//  TimeUI
//
//  Created by Stone Dong on 13-12-27.
//  Copyright (c) 2013年 Stone Dong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DZObject : NSObject
{
    BOOL isMarshalSucceed;
}
@property (nonatomic, assign, readonly) BOOL isMarshalSucceed;
@property (nonatomic, strong) NSString* guid;
- (instancetype) initGenGUID;
- (NSDictionary*) toJsonObject;
@end
