//
//  Global.h
//  JSONConverter
//
//  Created by Wahyu Sumartha Priya D on 12/23/13.
//  Copyright (c) 2013 iProperty. All rights reserved.
//

#ifndef JSONConverter_Global_h
#define JSONConverter_Global_h

// Macro - Start the flag for block completion
#define StartBlock() __block BOOL waitingForBlock = YES

// Macro - Set the flag to stop the loop
#define EndBlock() waitingForBlock = NO 

// Macro - Wait and loop until flag is set
#define WaitUntilBlockCompletes() WaitWhile(waitingForBlock)

// Macro - Wait for condition to be NO in blocks and asynchronous call
// Each test should have its own instance of a BOOL conditiont because of non thread safe operations
#define WaitWhile(condition) \
    do { \
        while(condition) { \
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:0.1]]; \
        } \
    } while(0)
#endif
