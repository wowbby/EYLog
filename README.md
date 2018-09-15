# EYLog

[![CI Status](https://img.shields.io/travis/zhengzhenxing/EYLog.svg?style=flat)](https://travis-ci.org/zhengzhenxing/EYLog)
[![Version](https://img.shields.io/cocoapods/v/EYLog.svg?style=flat)](https://cocoapods.org/pods/EYLog)
[![License](https://img.shields.io/cocoapods/l/EYLog.svg?style=flat)](https://cocoapods.org/pods/EYLog)
[![Platform](https://img.shields.io/cocoapods/p/EYLog.svg?style=flat)](https://cocoapods.org/pods/EYLog)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

EYLog is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'EYLog'
```

## Author

zhengzhenxing, 116676237@qq.com

## License

EYLog is available under the MIT license. See the LICENSE file for more info.

# 日志组件-EYLog

EYLog是一个统计信息统一接入，然后由EYLog进行统一分发的一个组件；
EYLog接受普通日志信息和各个模块定义好的事件信息的输入，接受被分发对象的添加和删除；其中对日志信息进行统一的标识和格式化处理；
具体的日志信息由被分发对象具体实现，事件的定义也由各个模块自己实现；

## installation

> podfile

```
pod 'EYLog'
```
## start


```
#import <EYLog/EYStatistics.h>
```

普通日志和事件日志的回调
```
@protocol EYStatisticsObserver <NSObject>
@property (strong, nonatomic, readonly) NSString *moduleName;
@property (strong, nonatomic, readonly) NSNumber *moduleId;
/**
 添加统计事件回调，对事件的打印，统计、分析、记录由 EYStatisticsObserver的具体实现

 @param event 事件ID
 @param info 事件信息
 */
- (void)handleEvent:(NSInteger)event eventInfo:(NSDictionary *)info;
@end
```


```
@interface EYStatistics : NSObject

/**
 单例

 @return EYStatistics instance
 */
+ (instancetype)shareStatistics;

/**
 普通日志打印，事件ID内部实现默认为0

 @param format 日志信息
 */
- (void)addLogModuleId:(NSNumber *)moduleId format:(NSString *)format, ...;

/**
 添加事件监听回调

 @param observer 监听者
 */
- (void)addEventObserver:(id<EYStatisticsObserver>)observer error:(NSError **)error;

/**
 移除事件监听回调

 @param observer 监听者
 */
- (void)removeEventObserver:(id<EYStatisticsObserver>)observer;

/**
 添加事件

 @param eventId 事件ID------请将普通日志输出定义枚举的时候保留【0】值，0值作为普通日志输入的标识
 @param info 事件信息
 */
- (void)addEvent:(NSInteger)eventId moduleId:(NSNumber *)moduleId eventInfo:(NSDictionary *)info;
@end
```
## Example

```
 - (NSNumber *)moduleId
    {

        return @(11);
    }
- (NSDictionary *)eventData
    {

        return @{
                 @(1) : @"事件1",
                 @(2) : @"事件2",
                 @(3) : @"事件3"
                 };
    }


- (NSString *)moduleName
    {
        return @"测试模块2";
    }
    - (void)handleEvent:(NSInteger)event eventInfo:(NSDictionary *)info
    {

        if (event == 0) {
            NSLog(@"%@", info[@"EYLog_message"]);
        }
        else {

            NSString *eventDescription = self.eventData[@(event)];

            NSLog(@"%@,事件【%ld】-%@:%@", self.moduleName,event, eventDescription, info);
        }
    }
```



