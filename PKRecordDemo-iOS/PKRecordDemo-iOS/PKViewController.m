//
//  PKViewController.m
//  PKRecordDemo-iOS
//
//  Created by passerbycrk on 13-10-8.
//  Copyright (c) 2013年 passerbycrk. All rights reserved.
//

#import "PKViewController.h"
#import "CDAnimation.h"
#import "CDComics.h"
#import "CDGame.h"

#define PKLog(frmt, ...) [self loggingMessage:(frmt), ##__VA_ARGS__];

@interface PKViewController ()
@property (nonatomic, strong) PKRecord *record;
@property (nonatomic,   weak) PKRecordContext *persistenceContext;
@end

static id testAttri = @"aid";
static id testValue = @"2";

@implementation PKViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// 配置PKRecord
    [self setupRecord];
    // 初始化数据<使用了context进行持久化操作,也可以用record进行持久化,详细使用见以下test>
    [self testInitData];

    // 使用context进行持久化操作
    /*
     * 推荐用这个，只需要在关键时刻进行最后的持久化,比如EnterBackgroundNotification,这样能使app高效的运行。
     * 不过只在关键时刻Save也有弊端,就是无法与FRC配合使用,因为不持久化到本地FRC就不会回调delegate。。
     */
    [self testContextSaving];

    // 使用record进行持久化操作
    //[self testRecordSaving];
    
    // 使用context进行多线程持久化操作
    //[self testMutiThreadSaving];
    
    // 使用context在lock dispatchQueue中进行持久化操作
    //[self testDispatchQueueSaving];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupRecord
{
    // 设置错误回调
    [PKRecord setErrorHandlerBlock:^(NSError *error) {
        PKLog(@"PKRecord Error:%@",error)
    }];
    
    // 制定保存路径 ~/Library/DB/PKRecordDB.sqlite
    NSURL *storeDoc = [[[NSFileManager defaultManager] URLsForDirectory:NSLibraryDirectory inDomains:NSUserDomainMask] lastObject];
    NSURL *storeDirURL = [storeDoc URLByAppendingPathComponent:@"DB" isDirectory:YES];
    NSURL *storeURL=[storeDirURL URLByAppendingPathComponent:@"PKRecordDB.sqlite" isDirectory:NO];
    
    PKRecord *record = [[PKRecord alloc] init]; // 可以创建多个来配置多个CoreData Stack
    [record setModelName:@"TestDataModel"]; // 可以不设置,会自动去mainBundle查找DataModel。
    [record setupCoreDataStackAutoMigratingInStoreURL:storeURL]; // TODO:默认定制存储地址。
    self.record = record;
    
    // 保存context
    self.persistenceContext = self.record.defaultContext;
}

- (void)testInitData
{
    PKLog(@"[testInitData] start")
    // 删除全部数据
    [CDAnimation truncateAllInContext:self.persistenceContext];
    // 创建新数据
    for (int i = 0; i < 2000; i++) {
        CDAnimation *ani = [CDAnimation createInContext:self.persistenceContext];
        ani.aid = @(i);
        ani.title = [@(i) stringValue];
    }
    NSTimeInterval startTime = [[NSDate date] timeIntervalSince1970];
    [self.persistenceContext saveToPersistentStoreAndWait];
    PKLog(@"[testInitData] saveTime:%f",[[NSDate date] timeIntervalSince1970] - startTime)
    PKLog(@"[testInitData] end")
}

- (void)testContextSaving
{
    PKLog(@"[testContextSaving] start")
    CDAnimation *fetchObj = [CDAnimation findFirstByAttribute:testAttri withValue:testValue inContext:self.persistenceContext];
    PKLog(@"[testContextSaving] before change:{%@:%@}",fetchObj.aid,fetchObj.title)
    if (fetchObj) {
        fetchObj.title = @"ahahahahaha";
    }
    NSTimeInterval startTime = [[NSDate date] timeIntervalSince1970];
    [self.persistenceContext saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
        PKLog(@"[testContextSaving] saveTime:%f",[[NSDate date] timeIntervalSince1970] - startTime)
        CDAnimation *fetchObj = [CDAnimation findFirstByAttribute:testAttri withValue:testValue inContext:self.persistenceContext];
        PKLog(@"[testContextSaving] after change:{%@:%@}",fetchObj.aid,fetchObj.title)
        PKLog(@"[testContextSaving] end")
    }];
}

- (void)testRecordSaving
{
    PKLog(@"[testRecordSaving] start")
    NSTimeInterval startTime = [[NSDate date] timeIntervalSince1970];
    [self.record
     saveUsingCurrentThreadContextWithBlock:^(PKRecord *record, PKRecordContext *context)
     {
         CDAnimation *fetchObj = [CDAnimation findFirstByAttribute:testAttri withValue:testValue inContext:context];
         PKLog(@"[testRecordSaving] before change:{%@:%@}",fetchObj.aid,fetchObj.title)
         if (fetchObj) {
             fetchObj.title = @"yohohohoho";
         }
     }
     onCompleted:^(PKRecord *record, PKRecordContext *context, BOOL success, NSError *error)
     {
         PKLog(@"[testRecordSaving] count:%d success:%d error:%@",[CDAnimation countOfEntitiesWithContext:context],success,error)
         PKLog(@"[testRecordSaving] saveTime:%f",[[NSDate date] timeIntervalSince1970] - startTime)
         CDAnimation *fetchObj = [CDAnimation findFirstByAttribute:testAttri withValue:testValue inContext:context];
         PKLog(@"[testRecordSaving] after change:{%@:%@}",fetchObj.aid,fetchObj.title)
         PKLog(@"[testRecordSaving] end")
     }];
}

- (void)testMutiThreadSaving
{
    NSLock *lock = [[NSLock alloc] init];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        PKRecordContext *threadContext1 = [self.record contextForCurrentThread];
        [threadContext1 setWorkingName:@"THREAD-1"];
        
        PKLog(@"(Thread 1) will start change :%@",threadContext1)
        NSTimeInterval threadStartTime1 = [[NSDate date] timeIntervalSince1970];
        NSArray *fetchArray = [CDAnimation findAllInContext:threadContext1];

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            PKRecordContext *threadContext2 = [self.record contextForCurrentThread];
            [threadContext2 setWorkingName:@"THREAD-2"];
            PKLog(@"(Thread 2) will delete in:%@",threadContext2)
            id deleteValue = @(88);
            CDAnimation *fetchObject = [CDAnimation findFirstByAttribute:testAttri withValue:deleteValue inContext:threadContext2];
            if (fetchObject) {
                [lock lock];
                PKLog(@"(Thread 2) delete object:%@",fetchObject.title)
                [fetchObject deleteInContext:threadContext2];
                [lock unlock];
            }
            fetchObject = [CDAnimation findFirstByAttribute:testAttri withValue:deleteValue inContext:threadContext2];
            PKLog(@"(Thread 2) after delete object:%@",fetchObject.title)
            
            NSTimeInterval threadStartTime2 = [[NSDate date] timeIntervalSince1970];
            [threadContext2 saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
                PKLog(@"(Thread 2) count:%d success:%d error:%@",[CDAnimation countOfEntitiesWithContext:threadContext2],success,error)
                PKLog(@"(Thread 2) saveTime:%f",[[NSDate date] timeIntervalSince1970] - threadStartTime2)
                
            }];
        });
        
        [lock lock];
        [fetchArray enumerateObjectsUsingBlock:^(CDAnimation *obj, NSUInteger idx, BOOL *stop) {
            obj.title = @"PKPKPKPKPKPKPK";
        }];
        [lock unlock];
        
        [threadContext1 saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
            PKLog(@"(Thread 1) count:%d success:%d error:%@",[CDAnimation countOfEntitiesWithContext:threadContext1],success,error)
            PKLog(@"(Thread 1) saveTime:%f",[[NSDate date] timeIntervalSince1970] - threadStartTime1)
        }];
    });
}


- (void)testDispatchQueueSaving
{
    dispatch_queue_t lockQueue = dispatch_queue_create("com.PKRecord.test.queue", NULL);
    
    dispatch_async(lockQueue, ^{
        
        PKRecordContext *context = [self.record contextForCurrentThread];
        
        PKLog(@"[0](action 1) will start change :%@",context)
        NSTimeInterval startTime1 = [[NSDate date] timeIntervalSince1970];
        NSArray *fetchArray = [CDAnimation findAllInContext:context];
        
        dispatch_async(lockQueue, ^{
            PKLog(@"[3](action 2) will delete in:%@",context)
            id deleteValue = @(888);
            CDAnimation *fetchObject = [CDAnimation findFirstByAttribute:testAttri withValue:deleteValue inContext:context];
            if (fetchObject) {
                PKLog(@"[4](action 2) delete object:%@",fetchObject.title)
                [fetchObject deleteInContext:context];
            }
            fetchObject = [CDAnimation findFirstByAttribute:testAttri withValue:deleteValue inContext:context];
            PKLog(@"[5](action 2) after delete object:%@",fetchObject.title)
            
            NSTimeInterval startTime2 = [[NSDate date] timeIntervalSince1970];
            [context saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
                PKLog(@"[6](action 2) count:%d success:%d error:%@",[CDAnimation countOfEntitiesWithContext:context],success,error)
                PKLog(@"[7](action 2) saveTime:%f",[[NSDate date] timeIntervalSince1970] - startTime2)
            }];
        });
        
        [fetchArray enumerateObjectsUsingBlock:^(CDAnimation *obj, NSUInteger idx, BOOL *stop) {
            obj.title = @"PKPKPKPKPKPKPK";
        }];
        
        PKLog(@"[1](action 1) will save ")
        [context saveToPersistentStoreAndWait];
        PKLog(@"[2](action 1) saveTime:%f",[[NSDate date] timeIntervalSince1970] - startTime1)
    });
}


#pragma mark - Log

- (void)loggingMessage:(NSString *)message,...
{
    va_list args;
	if (message)
	{
		va_start(args, message);
		
		NSString *logMsg = [[NSString alloc] initWithFormat:message arguments:args];
        
        NSLog(@"%@",logMsg);
        
		dispatch_async(dispatch_get_main_queue(), ^{
            NSString *text = [self.textView.text stringByAppendingFormat:@"\n\n%@",logMsg];
            self.textView.text = text;
        });
        
		va_end(args);
	}
}

@end
