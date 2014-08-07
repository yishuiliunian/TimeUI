//
//  DZDeletedObject.h
//  TimeUI
//
//  Created by stonedong on 14-8-6.
//  Copyright (c) 2014年 Stone Dong. All rights reserved.
//

#import "DZObject.h"


static NSString* kDZObjectTypeTime = @"Time";
static NSString* kDZObjectTypeType = @"Type";

static NSString* const SJKeyDeletedType = @"Type";
static NSString* const SJKeyDeletedDate = @"Time";

@interface DZDeletedObject : DZObject
@property (nonatomic, strong) NSString* type;
@property (nonatomic, strong) NSDate* deletedDate;

- (NSDictionary*)toJsonObject;
@end
