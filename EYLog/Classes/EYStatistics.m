//
//  EYStatistics.m
//  EYLog
//
//  Created by 振兴郑 on 2018/9/14.
//

#import "EYStatistics.h"

@interface EYStatistics ()
@property (strong, nonatomic) NSOperationQueue *statisticsQueue;
@property (strong, nonatomic) NSMutableArray<id<EYStatisticsObserver>> *observers;
@property (nonatomic, strong) NSMutableDictionary<NSNumber *, NSString *> *observerInfos;
@end

@implementation EYStatistics
+ (instancetype)shareStatistics
{
    static EYStatistics *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
      instance = [[[self class] alloc] init];
    });
    return instance;
}
- (NSMutableDictionary<NSNumber *, NSString *> *)observerInfos
{
    if (!_observerInfos) {
        _observerInfos = ({
            [@{} mutableCopy];
        });
    }
    return _observerInfos;
}
- (void)dealloc
{
    [self.statisticsQueue cancelAllOperations];
}
- (NSOperationQueue *)statisticsQueue
{
    if (!_statisticsQueue) {
        _statisticsQueue = ({
            NSOperationQueue *queue = [NSOperationQueue new];
            queue.name = @"EYLog.statistics.queue";
            queue.maxConcurrentOperationCount = 1;
            queue;
        });
    }
    return _statisticsQueue;
}
- (NSMutableArray<id<EYStatisticsObserver>> *)observers
{
    if (!_observers) {
        _observers = ({
            [@[] mutableCopy];
        });
    }
    return _observers;
}
- (void)addLogModuleId:(NSNumber *)moduleId:(NSString *)format, ...
{

    va_list args;
    va_start(args, format);
    NSString *logString = [[NSString alloc] initWithFormat:format arguments:args];
    va_end(args);
    logString = [NSString stringWithFormat:@"#--EYLog_Message--{%@}#:%@", self.observerInfos[moduleId], logString];
    [self addEvent:0 moduleId:moduleId eventInfo:@{ @"EYLog_message" : logString }];
}
- (void)addEventObserver:(id<EYStatisticsObserver>)observer error:(NSError **)error
{
    if (![observer respondsToSelector:@selector(handleEvent:eventInfo:)]) {
        if (error != NULL) {
            *error = [NSError errorWithDomain:@"EYLog.Error.addObserver" code:110 userInfo:@{ @"message" : @"observer did not respondsToSelector:(handleEvent:eventInfo:)" }];
        }
        return;
    }
    if (!observer.moduleName || !observer.moduleId) {

        if (error != NULL) {
            *error = [NSError errorWithDomain:@"EYLog.Error.addObserver" code:110 userInfo:@{ @"message" : @"observer.moduleName or observer.moduleId is nill" }];
        }
        return;
    }
    if ([self.observers containsObject:observer]) {
        return;
    }
    NSArray<NSString *> *allObserverNames = [self.observers valueForKeyPath:@"moduleName"];
    NSArray<NSNumber *> *allObserverIds = [self.observers valueForKeyPath:@"moduleId"];
    if ([allObserverNames containsObject:observer.moduleName] || [allObserverIds containsObject:observer.moduleId]) {
        if (error != NULL) {
            *error = [NSError errorWithDomain:@"EYLog.Error.addObserver" code:110 userInfo:@{ @"message" : @"observer.moduleName or observer.moduleId already exist" }];
        }
        return;
    }
    [self.observers addObject:observer];
    self.observerInfos[observer.moduleId] = observer.moduleName;
}
- (void)removeEventObserver:(id<EYStatisticsObserver>)observer
{
    if (!observer) {
        return;
    }
    NSBlockOperation *blockOperation = [NSBlockOperation blockOperationWithBlock:^{
      [self.observers removeObject:observer];
      [self.observerInfos removeObjectForKey:observer.moduleId];
    }];
    [self.statisticsQueue addOperation:blockOperation];
}
- (void)addEvent:(NSInteger)eventId moduleId:(NSNumber *)moduleId eventInfo:(NSDictionary *)info
{
    NSBlockOperation *blockOperation = [NSBlockOperation blockOperationWithBlock:^{
      for (id<EYStatisticsObserver> observer in self.observers) {

          if ([moduleId intValue] == observer.moduleId.intValue) {

              [observer handleEvent:eventId eventInfo:info];
          }
      }
    }];
    [self.statisticsQueue addOperation:blockOperation];
}
@end
