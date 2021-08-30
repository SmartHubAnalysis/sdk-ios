//
// UIView+SAVisualProperties.m
// SensorsAnalyticsSDK
//
// Created by 储强盛 on 2021/1/6.
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

#import "UIView+SAVisualProperties.h"
#import "SAVisualizedManager.h"
#import <objc/runtime.h>

static void *const kSAViewNodePropertyName = (void *)&kSAViewNodePropertyName;

@implementation UIView (SAVisualProperties)

- (void)sendata_visualize_didMoveToSuperview {
    [self sendata_visualize_didMoveToSuperview];

    [SAVisualizedManager.sharedInstance.visualPropertiesTracker didMoveToSuperviewWithView:self];
}

- (void)sendata_visualize_didMoveToWindow {
    [self sendata_visualize_didMoveToWindow];

    [SAVisualizedManager.sharedInstance.visualPropertiesTracker didMoveToWindowWithView:self];
}

- (void)sendata_visualize_didAddSubview:(UIView *)subview {
    [self sendata_visualize_didAddSubview:subview];

    [SAVisualizedManager.sharedInstance.visualPropertiesTracker didAddSubview:subview];
}

- (void)sendata_visualize_bringSubviewToFront:(UIView *)view {
    [self sendata_visualize_bringSubviewToFront:view];
    if (view.sendata_viewNode) {
        // 移动节点
        [self.sendata_viewNode.subNodes removeObject:view.sendata_viewNode];
        [self.sendata_viewNode.subNodes addObject:view.sendata_viewNode];
        
        // 兄弟节点刷新 Index
        [view.sendata_viewNode refreshBrotherNodeIndex];
    }
}

- (void)sendata_visualize_sendSubviewToBack:(UIView *)view {
    [self sendata_visualize_sendSubviewToBack:view];
    if (view.sendata_viewNode) {
        // 移动节点
        [self.sendata_viewNode.subNodes removeObject:view.sendata_viewNode];
        [self.sendata_viewNode.subNodes insertObject:view.sendata_viewNode atIndex:0];
        
        // 兄弟节点刷新 Index
        [view.sendata_viewNode refreshBrotherNodeIndex];
    }
}

- (void)setSendata_viewNode:(SAViewNode *)sendata_viewNode {
    objc_setAssociatedObject(self, kSAViewNodePropertyName, sendata_viewNode, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (SAViewNode *)sendata_viewNode {
    return objc_getAssociatedObject(self, kSAViewNodePropertyName);
}

/// 刷新节点位置信息
- (void)sendata_refreshIndex {
    if (self.sendata_viewNode) {
        [self.sendata_viewNode refreshIndex];
    }
}

@end

@implementation UITableViewCell(SAVisualProperties)

- (void)sendata_visualize_prepareForReuse {
    [self sendata_visualize_prepareForReuse];

    // 重用后更新 indexPath
    [self sendata_refreshIndex];
}

@end

@implementation UICollectionViewCell(SAVisualProperties)

- (void)sendata_visualize_prepareForReuse {
    [self sendata_visualize_prepareForReuse];

    // 重用后更新 indexPath
    [self sendata_refreshIndex];
}

@end


@implementation UITableViewHeaderFooterView(SAVisualProperties)

- (void)sendata_visualize_prepareForReuse {
    [self sendata_visualize_prepareForReuse];

    // 重用后更新 index
    [self sendata_refreshIndex];
}

@end

@implementation UIWindow(SAVisualProperties)
- (void)sendata_visualize_becomeKeyWindow {
    [self sendata_visualize_becomeKeyWindow];

    [SAVisualizedManager.sharedInstance.visualPropertiesTracker becomeKeyWindow:self];
}

@end


@implementation UITabBar(SAVisualProperties)
- (void)sendata_visualize_setSelectedItem:(UITabBarItem *)selectedItem {
    BOOL isSwitchTab = self.selectedItem == selectedItem;
    [self sendata_visualize_setSelectedItem:selectedItem];

    // 当前已经是选中状态，即未切换 tab 修改页面，不需更新
    if (!isSwitchTab) {
        return;
    }
    if (!SAVisualizedManager.sharedInstance.visualPropertiesTracker) {
        return;
    }

    SAViewNode *tabBarNode = self.sendata_viewNode;
    NSString *itemIndex = [NSString stringWithFormat:@"%lu", (unsigned long)[self.items indexOfObject:selectedItem]];
    for (SAViewNode *node in tabBarNode.subNodes) {
        // 只需更新切换 item 对应 node 页面名称即可
        if ([node isKindOfClass:SATabBarButtonNode.class] && [node.elementPosition isEqualToString:itemIndex]) {
            // 共用自定义属性查询队列，从而保证更新页面信息后，再进行属性元素遍历
            dispatch_async(SAVisualizedManager.sharedInstance.visualPropertiesTracker.serialQueue, ^{
                [node refreshSubNodeScreenName];
            });
        }
    }
}

@end
