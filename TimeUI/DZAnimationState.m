//
//  DZAnimationState.m
//  TimeUI
//
//  Created by Stone Dong on 13-12-9.
//  Copyright (c) 2013年 Stone Dong. All rights reserved.
//

#import "DZAnimationState.h"

#define DZProgress(origin, aim, process) ((origin) + ((aim) - (origin)) * process)

@implementation DZAnimationState
@synthesize supportAnimationKeys = _supportAnimationKeys;
@synthesize alpha = _alpha;
@synthesize frame = _frame;
+ (DZAnimationState*) zeroState
{
    static DZAnimationState* state = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        state = [[DZAnimationState alloc] init];
    });
    return state;
}
+ (DZAnimationState*) animationStateWithDic:(NSDictionary *)dic
{
    return [[DZAnimationState alloc] initWithDic:dic];
}

- (void) commonInit
{
    _alpha = 1.0;
    _frame = CGRectZero;
}
- (instancetype) init
{
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (DZAnimationState*) stateMoveTo:(DZAnimationState *)state inProcess:(float)process
{
    if (process < 0) {
        process = 0;
    } else if (process > 1.0)
    {
        process = 1.0;
    }
    DZAnimationState* inState = [[DZAnimationState alloc] init];
    inState.supportAnimationKeys = state.supportAnimationKeys;
    if (bDZAnimationSupporttKey(_supportAnimationKeys, DZAnimationKeyAlpha)) {
        inState.alpha = self.alpha + (state.alpha - self.alpha) * process;
    }
    if (bDZAnimationSupporttKey(_supportAnimationKeys, DZAnimationKeyFrame)) {
        CGRect rect = CGRectZero;
        rect.size.width = DZProgress(CGRectGetWidth(self.frame), CGRectGetWidth(state.frame), process);
        rect.size.height = DZProgress(CGRectGetHeight(self.frame), CGRectGetHeight(state.frame), process);
        rect.origin.x = DZProgress(CGRectGetMinX(self.frame), CGRectGetMinX(state.frame), process);
        rect.origin.y = DZProgress(CGRectGetMinY(self.frame), CGRectGetMinY(state.frame), process);
        inState.frame = rect;
    }
    return inState;
}


- (BOOL) isSupportAnimationKey:(DZAnimationKey)key
{
    return bDZAnimationSupporttKey(_supportAnimationKeys, key);
}

- (void) setValue:(id)value forKey:(NSString *)key
{
    
    if ([key isEqual:kDZKeyAlpha]) {
        _alpha = [value floatValue];
        _supportAnimationKeys = _supportAnimationKeys | DZAnimationKeyAlpha;
    }
    else if ([key isEqual:kDZKeyFrame])
    {
        _frame = [value CGRectValue];
        _supportAnimationKeys = _supportAnimationKeys | DZAnimationKeyFrame;
    }
}

- (instancetype) initWithDic:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        [self commonInit];
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

@end

DZAnimationState* DZAnimatinStateCreateWithDic(NSDictionary* dic)  {return [DZAnimationState animationStateWithDic:dic];}
