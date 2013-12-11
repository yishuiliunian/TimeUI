//
//  DZAnimationState.h
//  TimeUI
//
//  Created by Stone Dong on 13-12-9.
//  Copyright (c) 2013年 Stone Dong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DZKVODefines.h"

#define DZAnimationStateZero  [DZAnimationState zeroState]

typedef enum {
    DZAnimationKeyFrame = 1,
    DZAnimationKeyAlpha = 1<< 1
}DZAnimationKey;

#define bDZAnimationSupporttKey( types ,key)  ((types&key) != 0)

@interface DZAnimationState : NSObject
@property (nonatomic, assign) int64_t supportAnimationKeys;
@property (nonatomic, assign) CGRect frame;
@property (nonatomic, assign) float alpha;

+ (DZAnimationState*) zeroState;
+ (DZAnimationState*) animationStateWithDic:(NSDictionary*)dic;

- (instancetype) initWithDic:(NSDictionary*)dic;

- (DZAnimationState*) stateMoveTo:(DZAnimationState*)state inProcess:(float)process;

- (BOOL) isSupportAnimationKey:(DZAnimationKey)key;
@end

extern DZAnimationState* DZAnimatinStateCreateWithDic(NSDictionary* dic);