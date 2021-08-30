//
// SANotificationUtil.m
// SensorsAnalyticsSDK
//
// Created by 陈玉国 on 2021/1/18.
// Copyright © 2021 Sensors Data Co., Ltd. All rights reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

#if ! __has_feature(objc_arc)
#error This file must be compiled with ARC. Either turn on ARC for the project or use -fobjc-arc flag on this file.
#endif

#import "SANotificationUtil.h"
#import "SAAppPushConstants.h"
#import "SAJSONUtil.h"
#import "SALog.h"

@implementation SANotificationUtil

+ (NSDictionary *)propertiesFromUserInfo:(NSDictionary *)userInfo {
    
    NSMutableDictionary *properties = [[NSMutableDictionary alloc] init];
    
    if (userInfo[kSAPushServiceKeyJPUSH]) {
        properties[kSAEventPropertyNotificationServiceName] = kSAEventPropertyNotificationServiceNameJPUSH;
    }
    
    if (userInfo[kSAPushServiceKeyGeTui]) {
        properties[kSAEventPropertyNotificationServiceName] = kSAEventPropertyNotificationServiceNameGeTui;
    }
    
    //SF related properties
    NSString *sfDataString = userInfo[kSAPushServiceKeySF];
    
    if ([sfDataString isKindOfClass:[NSString class]]) {

        NSDictionary *sfProperties = [SAJSONUtil JSONObjectWithString:sfDataString];
        if ([sfProperties isKindOfClass:[NSDictionary class]]) {
            [properties addEntriesFromDictionary:[self propertiesFromSFData:sfProperties]];
        }
    }
    
    return [properties copy];
}

+ (NSDictionary *)propertiesFromSFData:(NSDictionary *)sfData {
    NSMutableDictionary *properties = [[NSMutableDictionary alloc] init];
    properties[kSFPlanStrategyID] = sfData[kSFPlanStrategyID.sendata_sfPushKey];
    properties[kSFChannelCategory] = sfData[kSFChannelCategory.sendata_sfPushKey];
    properties[kSFAudienceID] = sfData[kSFAudienceID.sendata_sfPushKey];
    properties[kSFChannelID] = sfData[kSFChannelID.sendata_sfPushKey];
    properties[kSFLinkUrl] = sfData[kSFLinkUrl.sendata_sfPushKey];
    properties[kSFPlanType] = sfData[kSFPlanType.sendata_sfPushKey];
    properties[kSFChannelServiceName] = sfData[kSFChannelServiceName.sendata_sfPushKey];
    properties[kSFMessageID] = sfData[kSFMessageID.sendata_sfPushKey];
    properties[kSFPlanID] = sfData[kSFPlanID.sendata_sfPushKey];
    properties[kSFStrategyUnitID] = sfData[kSFStrategyUnitID.sendata_sfPushKey];
    properties[kSFEnterPlanTime] = sfData[kSFEnterPlanTime.sendata_sfPushKey];
    return [properties copy];
}

@end

@implementation NSString (SFPushKey)

- (NSString *)sendata_sfPushKey {
    NSString *prefix = @"$";
    if ([self hasPrefix:prefix]) {
        return [self substringFromIndex:[prefix length]];
    }
    return self;
}

@end
