//
// SensorsAnalyticsSDK+SAAutoTrack.m
// SensorsAnalyticsSDK
//
// Created by wenquan on 2021/4/2.
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

#import "SendataAnalyticsSDK+SAAutoTrack.h"
#import "SendataAnalyticsSDK+Private.h"
#import "SAAutoTrackUtils.h"
#import "UIView+AutoTrack.h"
#import "SAAutoTrackManager.h"
#import "SAModuleManager.h"
#import "SAWeakPropertyContainer.h"
#include <objc/runtime.h>

@implementation UIImage (SendataAnalytics)

- (NSString *)sendataAnalyticsImageName {
    return objc_getAssociatedObject(self, @"sendataAnalyticsImageName");
}

- (void)setSendataAnalyticsImageName:(NSString *)sendataAnalyticsImageName {
    objc_setAssociatedObject(self, @"sendataAnalyticsImageName", sendataAnalyticsImageName, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@end

@implementation UIView (SendataAnalytics)

- (UIViewController *)sendataAnalyticsViewController {
    return self.sendata_viewController;
}

//viewID
- (NSString *)sendataAnalyticsViewID {
    return objc_getAssociatedObject(self, @"sendataAnalyticsViewID");
}

- (void)setSendataAnalyticsViewID:(NSString *)sendataAnalyticsViewID {
    objc_setAssociatedObject(self, @"sendataAnalyticsViewID", sendataAnalyticsViewID, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

//ignoreView
- (BOOL)sendataAnalyticsIgnoreView {
    return [objc_getAssociatedObject(self, @"sendataAnalyticsIgnoreView") boolValue];
}

- (void)setSendataAnalyticsIgnoreView:(BOOL)sendataAnalyticsIgnoreView {
    objc_setAssociatedObject(self, @"sendataAnalyticsIgnoreView", [NSNumber numberWithBool:sendataAnalyticsIgnoreView], OBJC_ASSOCIATION_ASSIGN);
}

//afterSendAction
- (BOOL)sendataAnalyticsAutoTrackAfterSendAction {
    return [objc_getAssociatedObject(self, @"sendataAnalyticsAutoTrackAfterSendAction") boolValue];
}

- (void)setSendataAnalyticsAutoTrackAfterSendAction:(BOOL)sendataAnalyticsAutoTrackAfterSendAction {
    objc_setAssociatedObject(self, @"sendataAnalyticsAutoTrackAfterSendAction", [NSNumber numberWithBool:sendataAnalyticsAutoTrackAfterSendAction], OBJC_ASSOCIATION_ASSIGN);
}

//viewProperty
- (NSDictionary *)sendataAnalyticsViewProperties {
    return objc_getAssociatedObject(self, @"sendataAnalyticsViewProperties");
}

- (void)setSendataAnalyticsViewProperties:(NSDictionary *)sendataAnalyticsViewProperties {
    objc_setAssociatedObject(self, @"sendataAnalyticsViewProperties", sendataAnalyticsViewProperties, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id<SAUIViewAutoTrackDelegate>)sendataAnalyticsDelegate {
    SAWeakPropertyContainer *container = objc_getAssociatedObject(self, @"sendataAnalyticsDelegate");
    return container.weakProperty;
}

- (void)setSendataAnalyticsDelegate:(id<SAUIViewAutoTrackDelegate>)sendataAnalyticsDelegate {
    SAWeakPropertyContainer *container = [SAWeakPropertyContainer containerWithWeakProperty:sendataAnalyticsDelegate];
    objc_setAssociatedObject(self, @"sendataAnalyticsDelegate", container, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

#pragma mark -

@implementation SendataAnalyticsSDK (SAAutoTrack)

- (UIViewController *)currentViewController {
    return [SAAutoTrackUtils currentViewController];
}

- (BOOL)isAutoTrackEnabled {
    return [SAAutoTrackManager.sharedInstance isAutoTrackEnabled];
}

#pragma mark - Ignore

- (BOOL)isAutoTrackEventTypeIgnored:(SendataAnalyticsAutoTrackEventType)eventType {
    return [SAAutoTrackManager.sharedInstance isAutoTrackEventTypeIgnored:eventType];
}

- (void)ignoreViewType:(Class)aClass {
    [SAAutoTrackManager.sharedInstance.appClickTracker ignoreViewType:aClass];
}

- (BOOL)isViewTypeIgnored:(Class)aClass {
    return [SAAutoTrackManager.sharedInstance.appClickTracker isViewTypeIgnored:aClass];
}

- (void)ignoreAutoTrackViewControllers:(NSArray<NSString *> *)controllers {
    [SAAutoTrackManager.sharedInstance.appClickTracker ignoreAutoTrackViewControllers:controllers];
    [SAAutoTrackManager.sharedInstance.appViewScreenTracker ignoreAutoTrackViewControllers:controllers];
}

- (BOOL)isViewControllerIgnored:(UIViewController *)viewController {
    BOOL isIgnoreAppClick = [SAAutoTrackManager.sharedInstance.appClickTracker isViewControllerIgnored:viewController];
    BOOL isIgnoreAppViewScreen = [SAAutoTrackManager.sharedInstance.appViewScreenTracker isViewControllerIgnored:viewController];

    return isIgnoreAppClick || isIgnoreAppViewScreen;
}

#pragma mark - Track

- (void)trackViewAppClick:(UIView *)view {
    [self trackViewAppClick:view withProperties:nil];
}

- (void)trackViewAppClick:(UIView *)view withProperties:(NSDictionary *)p {
    [SAAutoTrackManager.sharedInstance.appClickTracker trackEventWithView:view properties:p];
}

- (void)trackViewScreen:(UIViewController *)controller {
    [self trackViewScreen:controller properties:nil];
}

- (void)trackViewScreen:(UIViewController *)controller properties:(nullable NSDictionary<NSString *, id> *)properties {
    [SAAutoTrackManager.sharedInstance.appViewScreenTracker trackEventWithViewController:controller properties:properties];
}

#pragma mark - Deprecated

- (void)enableAutoTrack {
    [self enableAutoTrack:  SendataAnalyticsEventTypeAppStart |   SendataAnalyticsEventTypeAppEnd |   SendataAnalyticsEventTypeAppViewScreen];
}

- (void)enableAutoTrack:(SendataAnalyticsAutoTrackEventType)eventType {
    if (self.configOptions.autoTrackEventType != eventType) {
        self.configOptions.autoTrackEventType = eventType;

        [SAModuleManager.sharedInstance setEnable:YES forModuleType:SAModuleTypeAutoTrack];
        
        [SAAutoTrackManager.sharedInstance updateAutoTrackEventType];
    }
}

- (void)ignoreAutoTrackEventType:(SendataAnalyticsAutoTrackEventType)eventType {
    if (!(self.configOptions.autoTrackEventType & eventType)) {
        return;
    }

    self.configOptions.autoTrackEventType = self.configOptions.autoTrackEventType ^ eventType;

    [SAAutoTrackManager.sharedInstance updateAutoTrackEventType];
}

- (BOOL)isViewControllerStringIgnored:(NSString *)viewControllerClassName {
    BOOL isIgnoreAppClick = [SAAutoTrackManager.sharedInstance.appClickTracker isViewControllerStringIgnored:viewControllerClassName];
    BOOL isIgnoreAppViewScreen = [SAAutoTrackManager.sharedInstance.appViewScreenTracker isViewControllerStringIgnored:viewControllerClassName];

    return isIgnoreAppClick || isIgnoreAppViewScreen;
}

- (void)trackViewScreen:(NSString *)url withProperties:(NSDictionary *)properties {
    [SAAutoTrackManager.sharedInstance.appViewScreenTracker trackEventWithURL:url properties:properties];
}

@end
