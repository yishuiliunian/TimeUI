//
//  DZWebPluginEngine.m
//  TimeUI
//
//  Created by stonedong on 14-4-4.
//  Copyright (c) 2014年 Stone Dong. All rights reserved.
//

#import "DZWebPluginEngine.h"
#import "DZSingletonFactory.h"
#import "DZWebAppRuntimePlugin.h"
#import "DZWebOperationSystem.h"
#import "NSURL+Untils.h"
#import "SBJson4.h"
@class DZWebViewController;

@interface DZWebPluginEngine ()
{
    NSArray* _webAppPlugins;
    NSMutableDictionary* _cachedWebAppPlugins;
}
@end
@implementation DZWebPluginEngine
+ (DZWebPluginEngine*) defaultEngine
{
    return DZSingleForClass([DZWebPluginEngine class]);
}
- (instancetype) init
{
    self = [super init];
    if (!self) {
        return nil;
    }
    [self commitInit];
    
    return self;
}

- (void) commitInit
{
    _webAppPlugins = [@[[DZWebAppRuntimePlugin class],
                        ] mutableCopy];
    _cachedWebAppPlugins = [NSMutableDictionary new];
}

- (DZWebPlugin*) cachedPulginForClass:(Class)cla
{
    DZWebPlugin* plugin = _cachedWebAppPlugins[[cla moduleName]];
    if (!plugin) {
        plugin = [[cla alloc] init];
        _cachedWebAppPlugins[[cla moduleName]] = plugin;
    }
    return plugin;
}
- (BOOL) handleURLRequst:(NSURL*)url fromWebViewController:(DZWebViewController*)webVC
{
    if (![DZWebDefaultOS isWebApplicationRequst:url]) {
        return NO;
    }
    NSString *module = url.host;
    NSString *method = [url.pathComponents objectAtIndex:1];
    NSString *paramstring = [url queryComponentNamed:@"params"];
    __block NSDictionary* dic = nil;
    SBJson4Parser* jsonParser = [SBJson4Parser multiRootParserWithBlock:^(id item, BOOL *stop) {
        dic = item;
    } errorHandler:^(NSError *error) {
        
    }];
    [jsonParser parse:[paramstring dataUsingEncoding:NSUTF8StringEncoding]];
    
    for (Class plugin in _webAppPlugins) {
        if([[plugin moduleName] isEqualToString:module])
        {
            NSString* selStr = [NSString stringWithFormat:@"handleWebRequest_%@:",method];
            SEL selector = NSSelectorFromString(selStr);
            DZWebPlugin* pluginInstance = [self cachedPulginForClass:plugin];
            if ([pluginInstance respondsToSelector:selector]) {
                [pluginInstance performSelector:selector withObject:dic];
            }
        }
    }
    return YES;
}
@end
