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
     * 推荐用这个，而且只需要在关键时刻进行最后的持久化,比如enterBackground,这样能使app高效的运行。
     * 不过这么用有弊端,就是无法与FRC配合使用,因为不持久化到本地FRC就不会回调。。
     */
    [self testContextSaving];

    // 使用record进行持久化操作
    //[self testRecordSaving];
    
    // 使用context进行多线程持久化操作
    //[self testMutiThreadSaving];
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
        NSLog(@"error:%@",error);
    }];
    
    // 制定保存路径 ~/Library/DB/PKRecordDB.sqlite
    NSURL *storeDoc = [[[NSFileManager defaultManager] URLsForDirectory:NSLibraryDirectory inDomains:NSUserDomainMask] lastObject];
    NSURL *storeDirURL = [storeDoc URLByAppendingPathComponent:@"DB" isDirectory:YES];
    NSURL *storeURL=[storeDirURL URLByAppendingPathComponent:@"PKRecordDB.sqlite" isDirectory:NO];
    
    PKRecord *record = [[PKRecord alloc] init]; // 可以创建多个来连接不同DB
    [record setModelName:@"TestDataModel"]; // 不设置的话，自动去mainBundle查找。
    [record setupCoreDataStackAutoMigratingInStoreURL:storeURL]; // TODO:不设置默认定制存储地址。
    self.record = record;
    
    // 保存context
    self.persistenceContext = self.record.defaultContext;
}

- (void)testInitData
{
    NSLog(@"[testInitData] start");
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
    NSLog(@"[testInitData] saveTime:%f",[[NSDate date] timeIntervalSince1970] - startTime);
    NSLog(@"[testInitData] end");
}

- (void)testContextSaving
{
    NSLog(@"[testContextSaving] start");
    CDAnimation *fetchObj = [CDAnimation findFirstByAttribute:testAttri withValue:testValue inContext:self.persistenceContext];
    NSLog(@"[testContextSaving] before change:{%@:%@}",fetchObj.aid,fetchObj.title);
    if (fetchObj) {
        fetchObj.title = @"ahahahahaha";
    }
    NSTimeInterval startTime = [[NSDate date] timeIntervalSince1970];
    [self.persistenceContext saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
        NSLog(@"[testContextSaving] saveTime:%f",[[NSDate date] timeIntervalSince1970] - startTime);
        CDAnimation *fetchObj = [CDAnimation findFirstByAttribute:testAttri withValue:testValue inContext:self.persistenceContext];
        NSLog(@"[testRecordSaving] after change:{%@:%@}",fetchObj.aid,fetchObj.title);
        NSLog(@"[testContextSaving] end");
    }];
}

- (void)testRecordSaving
{
    NSLog(@"[testRecordSaving] start");
    NSTimeInterval startTime = [[NSDate date] timeIntervalSince1970];
    [self.record
     saveUsingCurrentThreadContextWithBlock:^(PKRecord *record, PKRecordContext *context)
     {
         CDAnimation *fetchObj = [CDAnimation findFirstByAttribute:testAttri withValue:testValue inContext:context];
         NSLog(@"[testRecordSaving] before change:{%@:%@}",fetchObj.aid,fetchObj.title);
         if (fetchObj) {
             fetchObj.title = @"yohohohoho";
         }
     }
     onCompleted:^(PKRecord *record, PKRecordContext *context, BOOL success, NSError *error)
     {
         NSLog(@"[testRecordSaving] count:%d success:%d error:%@",[CDAnimation countOfEntitiesWithContext:context],success,error);
         NSLog(@"[testRecordSaving] saveTime:%f",[[NSDate date] timeIntervalSince1970] - startTime);
         CDAnimation *fetchObj = [CDAnimation findFirstByAttribute:testAttri withValue:testValue inContext:context];
         NSLog(@"[testRecordSaving] after change:{%@:%@}",fetchObj.aid,fetchObj.title);
         NSLog(@"[testRecordSaving] end");
     }];
}

- (void)testMutiThreadSaving
{
    NSLock *lock = [[NSLock alloc] init];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        PKRecordContext *threadContext1 = [self.record contextForCurrentThread];
        [threadContext1 setWorkingName:@"THREAD-1"];
        
        NSLog(@"(Thread 1) will start change :%@",threadContext1);
        NSTimeInterval threadStartTime1 = [[NSDate date] timeIntervalSince1970];
        NSArray *fetchArray = [CDAnimation findAllInContext:threadContext1];

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            PKRecordContext *threadContext2 = [self.record contextForCurrentThread];
            [threadContext2 setWorkingName:@"THREAD-2"];
            NSLog(@"(Thread 2) will delete in:%@",threadContext2);
            id deleteValue = @(88);
            CDAnimation *fetchObject = [CDAnimation findFirstByAttribute:testAttri withValue:deleteValue inContext:threadContext2];
            if (fetchObject) {
                [lock lock];
                NSLog(@"(Thread 2) delete object:%@",fetchObject);
                [fetchObject deleteInContext:threadContext2];
                [lock unlock];
            }
            fetchObject = [CDAnimation findFirstByAttribute:testAttri withValue:deleteValue inContext:threadContext2];
            NSLog(@"(Thread 2) after delete object:%@",fetchObject);
            
            NSTimeInterval threadStartTime2 = [[NSDate date] timeIntervalSince1970];
            [threadContext2 saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
                NSLog(@"(Thread 2) count:%d success:%d error:%@",[CDAnimation countOfEntitiesWithContext:threadContext2],success,error);
                NSLog(@"(Thread 2) saveTime:%f",[[NSDate date] timeIntervalSince1970] - threadStartTime2);
                
            }];
        });
        
        [lock lock];
        [fetchArray enumerateObjectsUsingBlock:^(CDAnimation *obj, NSUInteger idx, BOOL *stop) {
            obj.title = @"PKPKPKPKPKPKPK";
        }];
        [lock unlock];
        
        [threadContext1 saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
            NSLog(@"(Thread 1) count:%d success:%d error:%@",[CDAnimation countOfEntitiesWithContext:threadContext1],success,error);
            NSLog(@"(Thread 1) saveTime:%f",[[NSDate date] timeIntervalSince1970] - threadStartTime1);
            
        }];
    });
}

@end
