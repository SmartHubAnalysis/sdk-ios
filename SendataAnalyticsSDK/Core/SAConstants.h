//
//  SAConstants.h
//  SendataAnalyticsSDK
//
//  Created by 向作为 on 2018/8/9.
//  Copyright © 2015-2020 Sendata Data Co., Ltd. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

#import <Foundation/Foundation.h>


#pragma mark - typedef
/**
 * @abstract
 * Debug 模式，用于检验数据导入是否正确。该模式下，事件会逐条实时发送到 SendataAnalytics，并根据返回值检查
 * 数据导入是否正确。
 *
 * @discussion
 * Debug 模式的具体使用方式，请参考:
 *  http://www.Sendatadata.cn/manual/debug_mode.html
 *
 * Debug模式有三种选项:
 *   SendataAnalyticsDebugOff - 关闭 DEBUG 模式
 *   SendataAnalyticsDebugOnly - 打开 DEBUG 模式，但该模式下发送的数据仅用于调试，不进行数据导入
 *   SendataAnalyticsDebugAndTrack - 打开 DEBUG 模式，并将数据导入到 SendataAnalytics 中
 */
typedef NS_ENUM(NSInteger, SendataAnalyticsDebugMode) {
      SendataAnalyticsDebugOff,
      SendataAnalyticsDebugOnly,
      SendataAnalyticsDebugAndTrack,
};

/**
 * @abstract
 * TrackTimer 接口的时间单位。调用该接口时，传入时间单位，可以设置 event_duration 属性的时间单位。
 *
 * @discuss
 * 时间单位有以下选项：
 *   SendataAnalyticsTimeUnitMilliseconds - 毫秒
 *   SendataAnalyticsTimeUnitSeconds - 秒
 *   SendataAnalyticsTimeUnitMinutes - 分钟
 *   SendataAnalyticsTimeUnitHours - 小时
 */
typedef NS_ENUM(NSInteger, SendataAnalyticsTimeUnit) {
      SendataAnalyticsTimeUnitMilliseconds,
      SendataAnalyticsTimeUnitSeconds,
      SendataAnalyticsTimeUnitMinutes,
      SendataAnalyticsTimeUnitHours
};


/**
 * @abstract
 * AutoTrack 中的事件类型
 *
 * @discussion
 *   SendataAnalyticsEventTypeAppStart - $AppStart
 *   SendataAnalyticsEventTypeAppEnd - $AppEnd
 *   SendataAnalyticsEventTypeAppClick - $AppClick
 *   SendataAnalyticsEventTypeAppViewScreen - $AppViewScreen
 */
typedef NS_OPTIONS(NSInteger, SendataAnalyticsAutoTrackEventType) {
      SendataAnalyticsEventTypeNone      = 0,
      SendataAnalyticsEventTypeAppStart      = 1 << 0,
      SendataAnalyticsEventTypeAppEnd        = 1 << 1,
      SendataAnalyticsEventTypeAppClick      = 1 << 2,
      SendataAnalyticsEventTypeAppViewScreen = 1 << 3,
};

/**
 * @abstract
 * 网络类型
 *
 * @discussion
 *   SendataAnalyticsNetworkTypeNONE - NULL
 *   SendataAnalyticsNetworkType2G - 2G
 *   SendataAnalyticsNetworkType3G - 3G
 *   SendataAnalyticsNetworkType4G - 4G
 *   SendataAnalyticsNetworkTypeWIFI - WIFI
 *   SendataAnalyticsNetworkTypeALL - ALL
 *   SendataAnalyticsNetworkType5G - 5G
 */
typedef NS_OPTIONS(NSInteger, SendataAnalyticsNetworkType) {
      SendataAnalyticsNetworkTypeNONE         = 0,
      SendataAnalyticsNetworkType2G API_UNAVAILABLE(macos)    = 1 << 0,
      SendataAnalyticsNetworkType3G API_UNAVAILABLE(macos)    = 1 << 1,
      SendataAnalyticsNetworkType4G API_UNAVAILABLE(macos)    = 1 << 2,
      SendataAnalyticsNetworkTypeWIFI     = 1 << 3,
      SendataAnalyticsNetworkTypeALL      = 0xFF,
#ifdef __IPHONE_14_1
      SendataAnalyticsNetworkType5G API_UNAVAILABLE(macos)   = 1 << 4
#endif
};
