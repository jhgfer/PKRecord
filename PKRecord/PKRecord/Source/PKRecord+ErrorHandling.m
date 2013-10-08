//
//  PKRecord+ErrorHandling.m
//  PKTestProj
//
//  Created by zhongsheng on 13-9-29.
//  Copyright (c) 2013年 zhongsheng. All rights reserved.
//

#import "PKRecord+ErrorHandling.h"

static id errorHandlerTarget = nil;

static SEL errorHandlerAction = nil;

static PKRecordErrorHandlerBlock errorHandlerBlock = nil;

@implementation PKRecord (ErrorHandling)

+ (void)handleErrors:(NSError *)error
{
    if (error)
	{
        NSLog(@"%@",error);
        
        if (errorHandlerBlock) {
            errorHandlerBlock(error);
        }
        
        if (errorHandlerTarget != nil && errorHandlerAction != nil)
		{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [errorHandlerTarget performSelector:errorHandlerAction withObject:error];
#pragma clang diagnostic pop
        }
    
    }
}

+ (void)setErrorHandlerTarget:(id)target action:(SEL)action
{
    errorHandlerTarget = target;    /* Deliberately don't retain to avoid potential retain cycles */
    errorHandlerAction = action;
}

+ (void)setErrorHandlerBlock:(PKRecordErrorHandlerBlock)errorBlock
{
    errorHandlerBlock = errorBlock;
}

+ (id)errorHandlerTarget
{
    return errorHandlerTarget;
}

@end
