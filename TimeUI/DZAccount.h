//
//  DZAccount.h
//  TimeUI
//
//  Created by Stone Dong on 13-12-10.
//  Copyright (c) 2013年 Stone Dong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DZAccount : NSObject
@property (nonatomic, strong) NSString* identifiy;
@property (nonatomic, strong) NSString* email;
@property (nonatomic, strong) NSString* password;
@property (nonatomic, strong, readonly) NSString* documentsPath;
@property (nonatomic, strong, readonly) NSString* timeDatabasePath;
@end
