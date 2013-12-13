//
//  DZAudioManager.h
//  TimeUI
//
//  Created by Stone Dong on 13-12-12.
//  Copyright (c) 2013年 Stone Dong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AEAudioController.h>
@interface DZAudioManager : NSObject
@property (nonatomic, strong, readonly) AEAudioController* audioController;
+ (DZAudioManager*) shareManager;
- (void) playBlum;
@end
