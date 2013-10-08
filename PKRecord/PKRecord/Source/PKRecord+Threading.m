//
//  PKRecord+Threading.m
//  PKTestProj
//
//  Created by passerbycrk on 13-9-29.
//  Copyright (c) 2013年 passerbycrk. All rights reserved.
//

#import "PKRecord+Threading.h"
#import "PKRecordContext.h"

static NSString const * kPKRecordContextForThreadKey = @"PKRecordContextForThreadKey";

@implementation PKRecord (Threading)

- (PKRecordContext *)contextForCurrentThread
{
    if ([NSThread isMainThread])
	{
		return self.defaultContext;
	}
	else
	{
		NSMutableDictionary *threadDict = [[NSThread currentThread] threadDictionary];
		PKRecordContext *threadContext = [threadDict objectForKey:kPKRecordContextForThreadKey];
		if (threadContext == nil)
		{
            threadContext = [PKRecordContext contextWithParent:self.defaultContext];
			[threadDict setObject:threadContext forKey:kPKRecordContextForThreadKey];
		}
		return threadContext;
	}
}

- (void)resetContextForCurrentThread
{
    [[self contextForCurrentThread] reset];
}

@end
