//
//  PKRecord+ErrorHandling.h
//  PKRecord
//
//  Created by zhongsheng on 13-10-8.
//  Copyright (c) 2013年 passerbycrk. All rights reserved.
//

#import "PKRecord.h"

typedef void(^PKRecordErrorHandlerBlock)(NSError *error);

@interface PKRecord (ErrorHandling)

+ (void)handleErrors:(NSError *)error;

+ (void)setErrorHandlerTarget:(id)target action:(SEL)action;

+ (void)setErrorHandlerBlock:(PKRecordErrorHandlerBlock)errorBlock;

+ (id)errorHandlerTarget;

@end
