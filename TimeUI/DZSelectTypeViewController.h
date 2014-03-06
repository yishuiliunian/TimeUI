//
//  DZSelectTypeViewController.h
//  TimeUI
//
//  Created by Stone Dong on 14-2-15.
//  Copyright (c) 2014年 Stone Dong. All rights reserved.
//

#import "DZTypesViewController.h"
@class DZSelectTypeViewController;
@protocol DZSelectTypeViewControllerDelegate <NSObject>

- (void) selectTypeViewController:(DZSelectTypeViewController*)vc didSelectedType:(DZTimeType*)type;

@end

@interface DZSelectTypeViewController : DZTypesViewController
DEFINE_PROPERTY_WEAK(id<DZSelectTypeViewControllerDelegate>, typeSelectDelegate);
@end
