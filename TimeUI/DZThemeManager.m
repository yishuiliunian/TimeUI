//
//  DZThemeManager.m
//  TimeUI
//
//  Created by Stone Dong on 13-12-20.
//  Copyright (c) 2013年 Stone Dong. All rights reserved.
//

#import "DZThemeManager.h"
#import "DZSingletonFactory.h"
#import <GLKit/GLKit.h>
#import <GLKit/GLKTextureLoader.h>
#import "DZAppearanceInterface.h"
#import "DZImageCache.h"
#import <HexColor.h>

static NSString* const kPrefixImage = @"img_";
static NSString* const kPrefixColor = @"color_";

@interface DZThemeManager ()
{
    NSMutableDictionary* _cssDictionary;
}
@end

@implementation DZThemeManager

+ (DZThemeManager*) shareManager
{
    return DZSingleForClass([DZThemeManager class]);
}

- (instancetype) init
{
    self = [super init];
    if (self) {
        NSString* path = [[NSBundle mainBundle] pathForResource:@"ThemeResources" ofType:@"plist"];
        NSDictionary* dic = [NSDictionary dictionaryWithContentsOfFile:path];
        _cssDictionary = dic[@"CSS"];
    }
    return self;
}

- (void) updateCSSOfObject:(id<DZAppearanceInterface>) object
{
    if ([object respondsToSelector:@selector(loadViewCSS:forKey:)]) {
        NSString* class =  NSStringFromClass([object class]);
        NSDictionary* infos = _cssDictionary[class];
        if (infos) {
            NSArray* allKeys = infos.allKeys;
            static int imageKeyLength = 4;
            static int colorKeyLength = 6;
            for (NSString* key  in allKeys) {
                if ([key hasPrefix:kPrefixImage]) {
                    NSString* subKey = [key substringFromIndex:imageKeyLength];
                    NSString* imageName = infos[key];
                    UIImage* image = DZCachedImageByName(imageName);
                    [object loadViewCSS:image forKey:subKey];
                } else if ([key hasPrefix:kPrefixColor]) {
                    NSString* subKey = [key substringFromIndex:colorKeyLength];
                    NSString* colorStr = infos[key];
                    UIColor* color = [UIColor colorWithHexString:colorStr];
                    [object loadViewCSS:color forKey:subKey];
                }
            }
        }
    }
}

@end
