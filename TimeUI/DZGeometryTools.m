//
//  DZGeometryTools.m
//  TimeUI
//
//  Created by Stone Dong on 13-12-10.
//  Copyright (c) 2013年 Stone Dong. All rights reserved.
//

#import "DZGeometryTools.h"
#import "DZAppConfigure.h"

void CGPrintRect(CGRect rect )
{
    DDLogCDebug(@"rec--|origin x:%f |y:%f |width:%f | height:%f", CGRectGetMinX(rect), CGRectGetMinY(rect), CGRectGetWidth(rect), CGRectGetHeight(rect));
}

@implementation DZGeometryTools

@end
