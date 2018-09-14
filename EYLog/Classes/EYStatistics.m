//
//  EYStatistics.m
//  EYLog
//
//  Created by 振兴郑 on 2018/9/14.
//

#import "EYStatistics.h"

@interface EYStatistics ()
@property (strong, nonatomic)NSOperationQueue *statisticsQueue;
@property (strong, nonatomic)NSMutableArray<id<EYStatisticsObserver>>* observers;
@end

@implementation EYStatistics
+(instancetype)shareStatistics{
    static EYStatistics * instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[[self class] alloc] init];
    });
    return instance;
}
-(void)dealloc{
    [self.statisticsQueue cancelAllOperations];
}
-(NSOperationQueue *)statisticsQueue{
    if (!_statisticsQueue) {
        _statisticsQueue = ({
            NSOperationQueue * queue = [NSOperationQueue new];
            queue.name = @"EYLog.statistics.queue";
            queue.maxConcurrentOperationCount = 1;
            queue;
        });
    }
    return _statisticsQueue;
}
-(NSMutableArray<id<EYStatisticsObserver>> *)observers{
    if (!_observers) {
        _observers = ({
            [@[] mutableCopy];
        });
    }
    return _observers;
}
-(void)addLog:(NSString *)format, ...{
    
    va_list args;
    va_start(args, format);
    NSString * logString = [[NSString alloc] initWithFormat:format arguments:args];
    va_end(args);
    logString = [NSString stringWithFormat:@"#--EYLog_Message--#:%@",logString];
    [self addEvent:0 eventInfo:@{@"EYLog_message":logString}];
}
-(void)addEventObserver:(id<EYStatisticsObserver>)observer{
    if (![observer respondsToSelector:@selector(handleEvent:eventInfo:)]) {
        return;
    }
    if ([self.observers containsObject:observer]) {
        return;
    }
    [self.observers addObject:observer];
}
-(void)removeEventObserver:(id<EYStatisticsObserver>)observer{
    if (!observer) {
        return;
    }
    [self.observers removeObject:observer];
}
-(void)addEvent:(NSInteger)event eventInfo:(NSDictionary *)info{
    NSBlockOperation * blockOperation = [NSBlockOperation blockOperationWithBlock:^{
        for (id<EYStatisticsObserver> observer in self.observers) {
            [observer handleEvent:event eventInfo:info];
        }
    }];
    [self.statisticsQueue addOperation:blockOperation];
}
@end
