//
//  EYViewController.m
//  EYLog
//
//  Created by zhengzhenxing on 09/14/2018.
//  Copyright (c) 2018 zhengzhenxing. All rights reserved.
//

#import "EYViewController.h"
#import <EYLog/EYStatistics.h>
typedef NS_ENUM(NSInteger, TestEvent) {

    TestEventNormalLog = 0,
    TestEvent1 = 1,
    TestEvent2 = 2,
    TestEvent3 = 3

};


@interface EYViewController () <EYStatisticsObserver>
@property (strong, nonatomic) NSDictionary *eventData;
@end

@implementation EYViewController
- (NSDictionary *)eventData
{

    return @{
        @(1) : @"事件1",
        @(2) : @"事件2",
        @(3) : @"事件3"
    };
}
- (NSNumber *)moduleId
{

    return @(10);
}
- (NSString *)moduleName
{
    return @"测试模块";
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.


    [[EYStatistics shareStatistics] addEventObserver:self error:nil];

    [[EYStatistics shareStatistics] addLogModuleId:@(10):@"这是一条普通日志信息"];
    [[EYStatistics shareStatistics] addEvent:1 moduleId:@(10) eventInfo:@{ @"message" : @"事件1" }];
    [[EYStatistics shareStatistics] addEvent:1 moduleId:@(10) eventInfo:@{ @"message" : @"事件1" }];
    [[EYStatistics shareStatistics] addEvent:1 moduleId:@(10) eventInfo:@{ @"message" : @"事件1" }];
    [[EYStatistics shareStatistics] addEvent:1 moduleId:@(10) eventInfo:@{ @"message" : @"事件1" }];
    [[EYStatistics shareStatistics] addEvent:1 moduleId:@(10) eventInfo:@{ @"message" : @"事件1" }];
    [[EYStatistics shareStatistics] removeEventObserver:self];
    [[EYStatistics shareStatistics] addEvent:2 moduleId:@(10) eventInfo:@{ @"message" : @"事件2" }];
    [[EYStatistics shareStatistics] addEvent:2 moduleId:@(10) eventInfo:@{ @"message" : @"事件2" }];
    [[EYStatistics shareStatistics] addEvent:2 moduleId:@(10) eventInfo:@{ @"message" : @"事件2" }];
    [[EYStatistics shareStatistics] addEvent:2 moduleId:@(10) eventInfo:@{ @"message" : @"事件2" }];
    [[EYStatistics shareStatistics] addEvent:2 moduleId:@(10) eventInfo:@{ @"message" : @"事件2" }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)handleEvent:(NSInteger)event eventInfo:(NSDictionary *)info
{

    if (event == 0) {
        NSLog(@"%@", info[@"EYLog_message"]);
    }
    else {

        NSString *eventDescription = self.eventData[@(event)];

        NSLog(@"事件【%ld】-%@:%@", event, eventDescription, info);
    }
}
@end
