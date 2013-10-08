//
//  Comics.h
//  PKRecordDemo-iOS
//
//  Created by zhongsheng on 13-10-8.
//  Copyright (c) 2013年 passerbycrk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Comics : NSManagedObject

@property (nonatomic, retain) NSNumber * cid;
@property (nonatomic, retain) NSString * title;

@end
