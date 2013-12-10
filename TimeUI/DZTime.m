//
//  DZTime.m
//  TimeUI
//
//  Created by Stone Dong on 13-12-10.
//  Copyright (c) 2013年 Stone Dong. All rights reserved.
//

#import "DZTime.h"

@implementation DZTime

-(NSString*) description
{
    return [NSString stringWithFormat:@" %@ %@ %@ %@ %@", self.begin, self.end, self.detail, self.typeId, self.guid];
}
@end
