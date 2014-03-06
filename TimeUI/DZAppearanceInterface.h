//
//  DZAppearanceInterface.h
//  TimeUI
//
//  Created by Stone Dong on 14-1-6.
//  Copyright (c) 2014年 Stone Dong. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DZAppearanceInterface <NSObject>
- (void) loadViewCSS:(id)cssValue forKey:(NSString*)key;
@end
