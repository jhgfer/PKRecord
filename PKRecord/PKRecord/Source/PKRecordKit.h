//
//  PKRecordKit.h
//  PKTestProj
//
//  Created by passerbycrk on 13-9-29.
//  Copyright (c) 2013年 passerbycrk. All rights reserved.
//


#ifndef NS_BLOCKS_AVAILABLE
#warning PKRecord requires blocks
#endif

#ifdef __OBJC__
    #if !( __has_feature(objc_arc) && __has_feature(objc_arc_weak) )
        #error PKRecord now requires ARC to be enabled
    #endif

#import <CoreFoundation/CoreFoundation.h>
#import <CoreData/CoreData.h>

#import "PKRecordContext.h"

#import "PKRecord.h"
#import "PKRecord+ErrorHandling.h"
#import "PKRecord+Threading.h"
//#import "PKRecord+iCloud.h"

#import "NSManagedObject+PKAggregation.h"
#import "NSManagedObject+PKRequest.h"
#import "NSManagedObject+PKRecord.h"
#import "NSManagedObject+PKFinder.h"

#endif
