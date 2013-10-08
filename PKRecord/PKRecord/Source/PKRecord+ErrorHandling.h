//
//  PKRecord+ErrorHandling.h
//  PKTestProj
//
//  Created by zhongsheng on 13-9-29.
//  Copyright (c) 2013年 zhongsheng. All rights reserved.
//

#import "PKRecord.h"

typedef void(^PKRecordErrorHandlerBlock)(NSError *error);

@interface PKRecord (ErrorHandling)

+ (void)handleErrors:(NSError *)error;

+ (void)setErrorHandlerTarget:(id)target action:(SEL)action;

+ (void)setErrorHandlerBlock:(PKRecordErrorHandlerBlock)errorBlock;

+ (id)errorHandlerTarget;

@end
