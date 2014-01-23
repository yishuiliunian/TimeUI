//
//  DZAstirFrameViewController.h
//  TimeUI
//
//  Created by Stone Dong on 13-12-9.
//  Copyright (c) 2013年 Stone Dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DZAppearanceInterface.h"
#import "DZViewController.h"
@interface DZAstirFrameViewController : DZViewController <DZAppearanceInterface>
{
    float _maxHeight;
    float _minHeight;
}
@property (nonatomic, assign) float maxHeight;
@property (nonatomic, assign) float minHeight;
@end
