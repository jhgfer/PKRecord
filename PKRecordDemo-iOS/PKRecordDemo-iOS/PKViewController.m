//
//  PKViewController.m
//  PKRecordDemo-iOS
//
//  Created by zhongsheng on 13-10-8.
//  Copyright (c) 2013年 passerbycrk. All rights reserved.
//

#import "PKViewController.h"
#import "Animation.h"
#import "Comics.h"
#import "Game.h"

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
	// Do any additional setup after loading the view, typically from a nib.
    [self setupDataBase];
    // 初始化数据
    [self testInitData];
    
//    [self testRecordSaving];
    
//    [self testContextSaving];
    
//    [self testMutiThreadSaving];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupDataBase
{
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
    [Animation truncateAllInContext:self.persistenceContext];
    // 创建新数据
    for (int i = 0; i < 2000; i++) {
        Animation *ani = [Animation createInContext:self.persistenceContext];
        ani.aid = @(i);
        ani.title = [@(i) stringValue];
    }
    NSTimeInterval startTime = [[NSDate date] timeIntervalSince1970];
    [self.persistenceContext
     saveWithOptions:PKSaveParentContexts
     onCompleted:^(BOOL success, NSError *error)
     {
         NSLog(@"[testInitData] count:%d success:%d error:%@",[Animation countOfEntitiesWithContext:self.persistenceContext],success,error);
         NSLog(@"[testInitData] saveTime:%f",[[NSDate date] timeIntervalSince1970] - startTime);
         NSLog(@"[testInitData] end");
     }];
}

- (void)testRecordSaving
{
    NSLog(@"[testRecordSaving] start");
    NSTimeInterval startTime = [[NSDate date] timeIntervalSince1970];
    [self.record
     saveUsingCurrentThreadContextWithBlock:^(PKRecord *record, PKRecordContext *context)
     {
         Animation *fetchObj = [Animation findFirstByAttribute:testAttri withValue:testValue inContext:context];
         NSLog(@"[testRecordSaving] before change:%@",fetchObj);
         if (fetchObj) {
             fetchObj.title = @"yohohohoho";
         }
     }
     onCompleted:^(PKRecord *record, PKRecordContext *context, BOOL success, NSError *error)
     {
         NSLog(@"[testRecordSaving] count:%d success:%d error:%@",[Animation countOfEntitiesWithContext:context],success,error);
         NSLog(@"[testRecordSaving] saveTime:%f",[[NSDate date] timeIntervalSince1970] - startTime);
         Animation *fetchObj = [Animation findFirstByAttribute:testAttri withValue:testValue inContext:context];
         NSLog(@"[testRecordSaving] after change:%@",fetchObj);
         NSLog(@"[testRecordSaving] end");
     }];
}

- (void)testContextSaving
{
    NSLog(@"[testContextSaving] start");
    Animation *fetchObj = [Animation findFirstByAttribute:testAttri withValue:testValue inContext:self.persistenceContext];
    if (fetchObj) {
        fetchObj.title = @"ahahahahaha";
    }
    NSTimeInterval startTime = [[NSDate date] timeIntervalSince1970];
    [self.persistenceContext saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
        NSLog(@"[testContextSaving] saveTime:%f",[[NSDate date] timeIntervalSince1970] - startTime);
        NSLog(@"[testContextSaving] end");
    }];
}

- (void)testMutiThreadSaving
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        PKRecordContext *threadContext1 = [self.record contextForCurrentThread];
        
        NSLog(@"(Thread 1) will start change :%@",threadContext1);
        NSTimeInterval threadStartTime1 = [[NSDate date] timeIntervalSince1970];
        NSArray *fetchArray = [Animation findAllInContext:threadContext1];

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            PKRecordContext *threadContext2 = [self.record contextForCurrentThread];
            
            NSLog(@"(Thread 2) will delete in:%@",threadContext2);
            id deleteValue = @(88);
            Animation *fetchObject = [Animation findFirstByAttribute:testAttri withValue:deleteValue inContext:threadContext2];
            if (fetchObject) {
                NSLog(@"(Thread 2) delete object:%@",fetchObject);
                [fetchObject deleteInContext:threadContext2];
            }
            fetchObject = [Animation findFirstByAttribute:testAttri withValue:deleteValue inContext:threadContext2];
            NSLog(@"(Thread 2) after delete object:%@",fetchObject);
            
            NSTimeInterval threadStartTime2 = [[NSDate date] timeIntervalSince1970];
            [threadContext2 saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
                NSLog(@"(Thread 2) count:%d success:%d error:%@",[Animation countOfEntitiesWithContext:threadContext2],success,error);
                NSLog(@"(Thread 2) saveTime:%f",[[NSDate date] timeIntervalSince1970] - threadStartTime2);
            }];
        });
        
        
        [fetchArray enumerateObjectsUsingBlock:^(Animation *obj, NSUInteger idx, BOOL *stop) {
            obj.title = @"PKPKPKPKPKPKPK";
        }];
        
        [threadContext1 saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
            NSLog(@"(Thread 1) count:%d success:%d error:%@",[Animation countOfEntitiesWithContext:threadContext1],success,error);
            NSLog(@"(Thread 1) saveTime:%f",[[NSDate date] timeIntervalSince1970] - threadStartTime1);
        }];
    });
}

@end
