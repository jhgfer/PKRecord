//
//  PKRecord+Threading.h
//  PKTestProj
//
//  Created by passerbycrk on 13-9-29.
//  Copyright (c) 2013年 passerbycrk. All rights reserved.
//

#import "PKRecord.h"

@interface PKRecord (Threading)

- (PKRecordContext *)contextForCurrentThread;

- (void)resetContextForCurrentThread;

@end
