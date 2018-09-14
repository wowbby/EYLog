//
//  EYStatistics.h
//  EYLog
//
//  Created by 振兴郑 on 2018/9/14.
//

#import <Foundation/Foundation.h>


@protocol EYStatisticsObserver <NSObject>

/**
 添加统计事件回调，对事件的打印，统计、分析、记录由 EYStatisticsObserver的具体实现

 @param event 事件ID
 @param info 事件信息
 */
-(void)handleEvent:(NSInteger)event eventInfo:(NSDictionary *)info;
@end

@interface EYStatistics : NSObject

/**
 单例

 @return EYStatistics instance
 */
+(instancetype)shareStatistics;

/**
 普通日志打印，事件ID内部实现默认为0

 @param format 日志信息
 */
-(void)addLog:(NSString *)format,...;

/**
 添加事件监听回调

 @param observer 监听者
 */
-(void)addEventObserver:(id<EYStatisticsObserver>)observer;

/**
 移除事件监听回调

 @param observer 监听者
 */
-(void)removeEventObserver:(id<EYStatisticsObserver>)observer;

/**
 添加事件

 @param event 事件ID------请将普通日志输出定义枚举的时候保留【0】值，0值作为普通日志输入的标识
 @param info 事件信息
 */
-(void)addEvent:(NSInteger)event eventInfo:(NSDictionary *)info;
@end
