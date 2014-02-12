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
            static int i = 0;
            DZCommand* command = [self.commandQueue anyCommand];
            i ++;
            if (command.commandBlock) {
                command.commandBlock();
            }
        }
   
    }
}

@end
