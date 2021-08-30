//
//  UIViewController+AutoTrack.m
//  SensorsAnalyticsSDK
//
//  Created by 王灼洲 on 2017/10/18.
//  Copyright © 2015-2020 Sensors Data Co., Ltd. All rights reserved.
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

#if ! __has_feature(objc_arc)
#error This file must be compiled with ARC. Either turn on ARC for the project or use -fobjc-arc flag on this file.
#endif


#import "UIViewController+AutoTrack.h"
#import "SendataAnalyticsSDK.h"
#import "SACommonUtility.h"
#import "SALog.h"
#import "UIView+AutoTrack.h"
#import "SAAutoTrackManager.h"
#import "SAWeakPropertyContainer.h"
#import <objc/runtime.h>

static void *const kSAPreviousViewController = (void *)&kSAPreviousViewController;

@implementation UIViewController (AutoTrack)

- (BOOL)sendata_isIgnored {
    return ![[SAAutoTrackManager sharedInstance].appClickTracker shouldTrackViewController:self];
}

- (NSString *)sendata_screenName {
    return NSStringFromClass([self class]);
}

- (NSString *)sendata_title {
    __block NSString *titleViewContent = nil;
    __block NSString *controllerTitle = nil;
    [SACommonUtility performBlockOnMainThread:^{
        titleViewContent = self.navigationItem.titleView.sendata_elementContent;
        controllerTitle = self.navigationItem.title;
    }];
    if (titleViewContent.length > 0) {
        return titleViewContent;
    }

    if (controllerTitle.length > 0) {
        return controllerTitle;
    }
    return nil;
}

- (void)sa_autotrack_viewDidAppear:(BOOL)animated {
    // 防止 tabbar 切换，可能漏采 $AppViewScreen 全埋点
    if ([self isKindOfClass:UINavigationController.class]) {
        UINavigationController *nav = (UINavigationController *)self;
        nav.sendata_previousViewController = nil;
    }

    SAAppViewScreenTracker *appViewScreenTracker = SAAutoTrackManager.sharedInstance.appViewScreenTracker;

    // parentViewController 判断，防止开启子页面采集时候的侧滑多采集父页面 $AppViewScreen 事件
    if (self.navigationController && self.parentViewController == self.navigationController) {
        // 全埋点中，忽略由于侧滑部分返回原页面，重复触发 $AppViewScreen 事件
        if (self.navigationController.sendata_previousViewController == self) {
            return [self sa_autotrack_viewDidAppear:animated];
        }
    }

    if (SAAutoTrackManager.sharedInstance.configOptions.enableAutoTrackChildViewScreen ||
        !self.parentViewController ||
        [self.parentViewController isKindOfClass:[UITabBarController class]] ||
        [self.parentViewController isKindOfClass:[UINavigationController class]] ||
        [self.parentViewController isKindOfClass:[UIPageViewController class]] ||
        [self.parentViewController isKindOfClass:[UISplitViewController class]]) {
        [appViewScreenTracker autoTrackEventWithViewController:self];
    }

    // 标记 previousViewController
    if (self.navigationController && self.parentViewController == self.navigationController) {
        self.navigationController.sendata_previousViewController = self;
    }

    [self sa_autotrack_viewDidAppear:animated];
}

@end

@implementation UINavigationController (AutoTrack)

- (void)setSendata_previousViewController:(UIViewController *)sendata_previousViewController {
    SAWeakPropertyContainer *container = [SAWeakPropertyContainer containerWithWeakProperty:sendata_previousViewController];
    objc_setAssociatedObject(self, kSAPreviousViewController, container, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIViewController *)sendata_previousViewController {
    SAWeakPropertyContainer *container = objc_getAssociatedObject(self, kSAPreviousViewController);
    return container.weakProperty;
}

@end
