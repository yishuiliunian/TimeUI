//
//  DZAudioManager.m
//  TimeUI
//
//  Created by Stone Dong on 13-12-12.
//  Copyright (c) 2013年 Stone Dong. All rights reserved.
//

#import "DZAudioManager.h"
#import "DZSingletonFactory.h"
#import <TheAmazingAudioEngine.h>
@implementation DZAudioManager
@synthesize audioController = _audioController;

- (instancetype) init
{
    self = [super init];
    if (self) {
        _audioController = [[AEAudioController alloc] initWithAudioDescription:[AEAudioController nonInterleaved16BitStereoAudioDescription] inputEnabled:NO];
        _audioController.preferredBufferDuration = 0.005;
        NSError* error = nil;
        [_audioController start:&error];
    }
    return self;
}

+ (DZAudioManager*) shareManager
{
    return DZSingleForClass([DZAudioManager class]);
}

- (void) playBlum
{
    NSError* error = nil;
    NSURL* resoureUrl = [[NSBundle mainBundle] URLForResource:@"test" withExtension:@"m4a"];
    AEAudioFilePlayer* oneshot = [AEAudioFilePlayer audioFilePlayerWithURL: resoureUrl
                                             audioController:_audioController
                                                       error:&error];
    oneshot.removeUponFinish = YES;
    oneshot.completionBlock = ^{
        
    };
    [_audioController addChannels:[NSArray arrayWithObject:oneshot]];
}
@end
