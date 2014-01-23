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

//定义前缀
#define DEFINE_CSS_PREFIX(pfix)  static NSString* const kPrefix_##pfix = @""#pfix"_";\
int lPrefix_##pfix = 0;

//初始化前缀
#define INIT_CSS_PREFIX_LENGTH(pfix) lPrefix_##pfix = kPrefix_##pfix.length;

//真正定义所有CSS的前缀
DEFINE_CSS_PREFIX(img);
DEFINE_CSS_PREFIX(font);
DEFINE_CSS_PREFIX(color)

void initPrefixLength()
{
    INIT_CSS_PREFIX_LENGTH(img);
    INIT_CSS_PREFIX_LENGTH(font);
    INIT_CSS_PREFIX_LENGTH(color);
}
//decode css





#define DEFINE_FONT_NAME(font) static NSString* const kFont_Name_##font = @""#font


DEFINE_FONT_NAME(default);
DEFINE_FONT_NAME(bold);
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
        initPrefixLength();
    }
    return self;
}


- (UIImage*) decodeImageCss:(NSString*)key
{
    return DZCachedImageByName(key);
}

- (UIFont*) decodeFontCSS:(NSString*)valueStr
{
    if (!valueStr) {
        return [UIFont systemFontOfSize:[UIFont systemFontSize]];
    }
    static NSMutableDictionary* fontCache = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        fontCache = [NSMutableDictionary new];
    });
    
    UIFont* font = [fontCache objectForKey:valueStr];
    if (!font) {
        NSArray* spes = [valueStr componentsSeparatedByString:@"_"];
        NSString* name = kFont_Name_default;
        float size = [UIFont systemFontSize];
        if (spes.count == 1) {
            NSString* s = spes[0];
            size = [s floatValue];
            if (size < 0 || size > 100) {
                size = [UIFont systemFontSize];
            }
        } else if (spes.count == 2)
        {
            name = spes[0];
            NSString* s = spes[1];
            size = [s floatValue];
            if (size < 0 || size > 100) {
                size = [UIFont systemFontSize];
            }
        }
        if ([name isEqualToString: kFont_Name_default]) {
            font = [UIFont systemFontOfSize:size];
        } else if ([name isEqualToString:kFont_Name_bold])
        {
            font = [UIFont boldSystemFontOfSize:size];
        }
        else
        {
            font = [UIFont fontWithName:name size:size];
        }
    }
    if (!font) {
        font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
    }
    [fontCache setObject:font forKey:valueStr];
    return font;
}

- (UIColor*) decodeColor:(NSString*)valueStr
{
    static NSMutableDictionary* colorCache = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        colorCache = [NSMutableDictionary new];
    });
    UIColor* color = [colorCache objectForKey:valueStr];
    if (!color) {
        color = [UIColor colorWithHexString:valueStr];
        if (color) {
            [colorCache setObject:color forKey:valueStr];
        }
    }
    return color;
}

- (void) updateCSSOfObject:(id<DZAppearanceInterface>) object
{
    if ([object respondsToSelector:@selector(loadViewCSS:forKey:)]) {
        NSString* class =  NSStringFromClass([object class]);
        NSDictionary* infos = _cssDictionary[class];
        
        if (infos) {
            NSArray* allKeys = infos.allKeys;
            #define DECODE_CSS(pfix,exp) NSString* subKey = [key substringFromIndex:lPrefix_##pfix];\
            NSString* valueStr = infos[key];\
            id value = [self exp:valueStr];\
            [object loadViewCSS:value forKey:subKey]

            for (NSString* key  in allKeys) {
                if ([key hasPrefix:kPrefix_img]) {
                    DECODE_CSS(img, decodeImageCss);
                }
                else if ([key hasPrefix:kPrefix_color])
                {
                    DECODE_CSS(color, decodeColor);
                }
                else if ([key hasPrefix:kPrefix_font])
                {
                    DECODE_CSS(font, decodeFontCSS);
                }
            }
        }
    }
}

@end
