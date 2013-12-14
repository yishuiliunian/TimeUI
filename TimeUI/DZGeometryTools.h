//
//  DZGeometryTools.h
//  TimeUI
//
//  Created by Stone Dong on 13-12-10.
//  Copyright (c) 2013年 Stone Dong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DZDevices.h"

#ifdef __cplusplus



extern "C"
{
#endif
    /**
     *  打印一个CGRect
     *
     *  @param rect 要打印的CGRect
     */
    void CGPrintRect(CGRect rect );
    float CGDistanceBetweenPoints(CGPoint p1, CGPoint p2);
    CGPoint CGPointCenterRect(CGRect rect);
    CGRect CGRectUseEdge(CGRect parent, UIEdgeInsets edge);
    CATransform3D CATransform3DPerspect(CATransform3D t, CGPoint center, float disZ);
    CATransform3D CATransform3DMakePerspective(CGPoint center, float disZ);
#ifdef __cplusplus
}
#endif
@interface DZGeometryTools : NSObject

@end
