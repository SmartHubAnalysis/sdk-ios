//
// UIView+SAVisualPropertiey.h
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

#import <UIKit/UIKit.h>
#import "SAViewNode.h"

@interface UIView (SAVisualProperties)

- (void)sendata_visualize_didMoveToSuperview;

- (void)sendata_visualize_didMoveToWindow;

- (void)sendata_visualize_didAddSubview:(UIView *)subview;

- (void)sendata_visualize_bringSubviewToFront:(UIView *)view;

- (void)sendata_visualize_sendSubviewToBack:(UIView *)view;

/// 视图对应的节点
@property (nonatomic, strong) SAViewNode *sendata_viewNode;

@end

@interface UITableViewCell(SAVisualProperties)

- (void)sendata_visualize_prepareForReuse;

@end

@interface UICollectionViewCell(SAVisualProperties)

- (void)sendata_visualize_prepareForReuse;

@end

@interface UITableViewHeaderFooterView(SAVisualProperties)

- (void)sendata_visualize_prepareForReuse;

@end

@interface UIWindow (SAVisualProperties)

- (void)sendata_visualize_becomeKeyWindow;

@end


@interface UITabBar (SAVisualProperties)
- (void)sendata_visualize_setSelectedItem:(UITabBarItem *)selectedItem;
@end
