//
//  EYViewController.m
//  EYLog
//
//  Created by zhengzhenxing on 09/14/2018.
//  Copyright (c) 2018 zhengzhenxing. All rights reserved.
//

#import "EYViewController.h"
#import <EYLog/EYStatistics.h>
typedef NS_ENUM(NSInteger,TestEvent) {
    
    TestEventNormalLog = 0,
    TestEvent1 = 1,
    TestEvent2 = 2,
    TestEvent3 = 3
    
};



@interface EYViewController ()<EYStatisticsObserver>
@property (strong, nonatomic)NSDictionary * eventData;
@end

@implementation EYViewController
-(NSDictionary *)eventData{
    
    return @{
             @(1):@"事件1",
             @(2):@"事件2",
             @(3):@"事件3"
             };
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [[EYStatistics shareStatistics] addEventObserver:self];
    
    [[EYStatistics shareStatistics] addLog:@"这是一条普通的日志信息"];
    
    [[EYStatistics shareStatistics] addEvent:TestEvent1 eventInfo:@{@"info":@"事件1信息"}];
    
    [[EYStatistics shareStatistics] addEvent:TestEvent2 eventInfo:@{@"info":@"事件2信息"}];
    
    [[EYStatistics shareStatistics] addEvent:TestEvent3 eventInfo:@{@"info":@"事件3信息"}];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)handleEvent:(NSInteger)event eventInfo:(NSDictionary *)info{
    
    if (event == 0) {
        NSLog(@"%@",info[@"EYLog_message"]);
    }else{
        
        NSString * eventDescription = self.eventData[@(event)];
        
        NSLog(@"事件【%ld】-%@:%@",event,eventDescription,info);
    }
    
}
@end
