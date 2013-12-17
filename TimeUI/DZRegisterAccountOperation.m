//
//  DZRegisterAccountOperation.m
//  TimeUI
//
//  Created by Stone Dong on 13-12-17.
//  Copyright (c) 2013年 Stone Dong. All rights reserved.
//

#import "DZRegisterAccountOperation.h"
#import "DZRouter.h"
#import "NSOperationQueue+DZ.h"
@interface DZRegisterAccountOperation ()
{
    NSString* _email;
    NSString* _password;
}
@end
@implementation DZRegisterAccountOperation

+ (void) runRegiserOperatioWithDelegate:(id<DZRegisterAccountDelegate>)delegate userEmail:(NSString *)email password:(NSString *)passwrod
{
    DZRegisterAccountOperation* op = [[DZRegisterAccountOperation alloc] initWithDelegate:delegate userEmail:email password:passwrod];
    [[NSOperationQueue backgroudQueue] addOperation:op];
}

- (instancetype) initWithDelegate:(id<DZRegisterAccountDelegate>)delegate userEmail:(NSString *)email password:(NSString *)password
{
    self = [super init];
    if (!self) {
        return self;
    }
    NSCAssert(email, @"email is nil");
    NSCAssert(password, @"password is nil");
    _delegate = delegate;
    _email = email;
    _password = password;
    return self;
}

- (void) main
{
    @autoreleasepool {
        NSDictionary* infos = @{@"email":_email , @"password":_password};
        NSError* error = nil;
        id result = [DZDefaultRouter sendAccountMethod:DZServerMethodRegiserUser bodyDatas:infos error:&error];

        NSLog(@"%@",result);
        
    }
}
@end
