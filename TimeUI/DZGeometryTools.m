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
    NSLog(@"rec--|origin x:%f |y:%f |width:%f | height:%f", CGRectGetMinX(rect), CGRectGetMinY(rect), CGRectGetWidth(rect), CGRectGetHeight(rect));
}



CATransform3D CATransform3DMakePerspective(CGPoint center, float disZ)
{
    CATransform3D transToCenter = CATransform3DMakeTranslation(-center.x, -center.y, 0);
    CATransform3D transBack = CATransform3DMakeTranslation(center.x, center.y, 0);
    CATransform3D scale = CATransform3DIdentity;
    scale.m34 = -1.0f/disZ;
    return CATransform3DConcat(CATransform3DConcat(transToCenter, scale), transBack);
}
CATransform3D CATransform3DPerspect(CATransform3D t, CGPoint center, float disZ)
{
    return CATransform3DConcat(t, CATransform3DMakePerspective(center, disZ));
}


CGRect CGRectUseEdge(CGRect parent, UIEdgeInsets edge)
{
    float startX =CGRectGetMinX(parent) + edge.left;
    float startY = CGRectGetMinY(parent) + edge.top;
    float endX = CGRectGetMaxX(parent) - edge.right;
    float endY = CGRectGetMaxY(parent) - edge.bottom;
    return CGRectMake(startX, startY, endX - startX, endY - startY);
}

CGPoint CGPointCenterRect(CGRect rect)
{
    return CGPointMake(CGRectGetWidth(rect)/2, CGRectGetHeight(rect)/2);
}

float CGDistanceBetweenPoints(CGPoint p1, CGPoint p2)
{
    return sqrt(pow(p1.x - p2.x, 2) + pow(p1.y - p2.y, 2));
}
@implementation DZGeometryTools

@end
