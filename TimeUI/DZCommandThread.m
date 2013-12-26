//
//  DZCommandThread.m
//  TimeUI
//
//  Created by Stone Dong on 13-12-20.
//  Copyright (c) 2013年 Stone Dong. All rights reserved.
//

#import "DZCommandThread.h"
#import "DZCommandQueue.h"
@implementation DZCommandThread

- (void) main
{
    @autoreleasepool {
        for(;;)
        {
            DZCommand* command = [self.commandQueue anyCommand];
            if (command.commandBlock) {
                command.commandBlock();
            }
        }
   
    }
}

@end
