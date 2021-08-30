//
// NSObject+SACellClick.m
// SensorsAnalyticsSDK
//
// Created by yuqiang on 2020/11/5.
// Copyright © 2020 Sensors Data Co., Ltd. All rights reserved.
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

#import "NSObject+DelegateProxy.h"
#import <objc/runtime.h>

static void *const kSANSObjectDelegateProxyParasiteKey = (void *)&kSANSObjectDelegateProxyParasiteKey;
static void *const kSANSObjectDelegateProxySuperClassKey = (void *)&kSANSObjectDelegateProxySuperClassKey;
static void *const kSANSObjectDelegateProxyDelegateClassKey = (void *)&kSANSObjectDelegateProxyDelegateClassKey;
static void *const kSANSObjectDelegateSelectorsKey = (void *)&kSANSObjectDelegateSelectorsKey;
static void *const kSANSObjectDelegateOptionalSelectorsKey = (void *)&kSANSObjectDelegateOptionalSelectorsKey;
static void *const kSANSObjectDelegateProxyKey = (void *)&kSANSObjectDelegateProxyKey;

static void *const kSANSProxyDelegateProxyParasiteKey = (void *)&kSANSProxyDelegateProxyParasiteKey;
static void *const kSANSProxyDelegateProxySuperClassKey = (void *)&kSANSProxyDelegateProxySuperClassKey;
static void *const kSANSProxyDelegateProxyDelegateClassKey = (void *)&kSANSProxyDelegateProxyDelegateClassKey;
static void *const kSANSProxyDelegateSelectorsKey = (void *)&kSANSProxyDelegateSelectorsKey;
static void *const kSANSProxyDelegateOptionalSelectorsKey = (void *)&kSANSProxyDelegateOptionalSelectorsKey;
static void *const kSANSProxyDelegateProxyKey = (void *)&kSANSProxyDelegateProxyKey;

@implementation SADelegateProxyParasite

- (void)dealloc {
    !self.deallocBlock ?: self.deallocBlock();
}

@end

@implementation NSObject (DelegateProxy)

- (SADelegateProxyParasite *)sendata_parasite {
    return objc_getAssociatedObject(self, kSANSObjectDelegateProxyParasiteKey);
}

- (void)setSendata_parasite:(SADelegateProxyParasite *)sendata_parasite {
    objc_setAssociatedObject(self, kSANSObjectDelegateProxyParasiteKey, sendata_parasite, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (Class)sendata_superClass {
    return objc_getAssociatedObject(self, kSANSObjectDelegateProxySuperClassKey);
}

- (void)setSendata_superClass:(Class)sendata_superClass {
    objc_setAssociatedObject(self, kSANSObjectDelegateProxySuperClassKey, sendata_superClass, OBJC_ASSOCIATION_RETAIN);
}

- (Class)sendata_delegateClass {
    return objc_getAssociatedObject(self, kSANSObjectDelegateProxyDelegateClassKey);
}

- (void)setSendata_delegateClass:(Class)sendata_delegateClass {
    objc_setAssociatedObject(self, kSANSObjectDelegateProxyDelegateClassKey, sendata_delegateClass, OBJC_ASSOCIATION_RETAIN);
}

- (NSSet<NSString *> *)sendata_selectors {
    return objc_getAssociatedObject(self, kSANSObjectDelegateSelectorsKey);
}

- (void)setSendata_selectors:(NSSet<NSString *> *)sendata_selectors {
    objc_setAssociatedObject(self, kSANSObjectDelegateSelectorsKey, sendata_selectors, OBJC_ASSOCIATION_COPY);
}

- (NSSet<NSString *> *)sendata_optionalSelectors {
    return objc_getAssociatedObject(self, kSANSObjectDelegateOptionalSelectorsKey);
}

- (void)setSendata_optionalSelectors:(NSSet<NSString *> *)sendata_optionalSelectors {
    objc_setAssociatedObject(self, kSANSObjectDelegateOptionalSelectorsKey, sendata_optionalSelectors, OBJC_ASSOCIATION_COPY);
}

- (id)sendata_delegateProxy {
    return objc_getAssociatedObject(self, kSANSObjectDelegateProxyKey);
}

- (void)setSendata_delegateProxy:(id)sendata_delegateProxy {
    objc_setAssociatedObject(self, kSANSObjectDelegateProxyKey, sendata_delegateProxy, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)sendata_registerDeallocBlock:(void (^)(void))deallocBlock {
    if (!self.sendata_parasite) {
        self.sendata_parasite = [[SADelegateProxyParasite alloc] init];
        self.sendata_parasite.deallocBlock = deallocBlock;
    }
}

- (BOOL)sendata_respondsToSelector:(SEL)aSelector {
    if ([self sendata_respondsToSelector:aSelector]) {
        return YES;
    }
    if ([self.sendata_optionalSelectors containsObject:NSStringFromSelector(aSelector)]) {
        return YES;
    }
    return NO;
}

@end


@implementation NSProxy (DelegateProxy)

- (SADelegateProxyParasite *)sendata_parasite {
    return objc_getAssociatedObject(self, kSANSProxyDelegateProxyParasiteKey);
}

- (void)setSendata_parasite:(SADelegateProxyParasite *)sendata_parasite {
    objc_setAssociatedObject(self, kSANSProxyDelegateProxyParasiteKey, sendata_parasite, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (Class)sendata_superClass {
    return objc_getAssociatedObject(self, kSANSProxyDelegateProxySuperClassKey);
}

- (void)setSendata_superClass:(Class)sendata_superClass {
    objc_setAssociatedObject(self, kSANSProxyDelegateProxySuperClassKey, sendata_superClass, OBJC_ASSOCIATION_RETAIN);
}

- (Class)sendata_delegateClass {
    return objc_getAssociatedObject(self, kSANSProxyDelegateProxyDelegateClassKey);
}

- (void)setSendata_delegateClass:(Class)sendata_delegateClass {
    objc_setAssociatedObject(self, kSANSProxyDelegateProxyDelegateClassKey, sendata_delegateClass, OBJC_ASSOCIATION_RETAIN);
}

- (NSSet<NSString *> *)sendata_selectors {
    return objc_getAssociatedObject(self, kSANSProxyDelegateSelectorsKey);
}

- (void)setSendata_selectors:(NSSet<NSString *> *)sendata_selectors {
    objc_setAssociatedObject(self, kSANSProxyDelegateSelectorsKey, sendata_selectors, OBJC_ASSOCIATION_COPY);
}

- (NSSet<NSString *> *)sendata_optionalSelectors {
    return objc_getAssociatedObject(self, kSANSProxyDelegateOptionalSelectorsKey);
}

- (void)setSendata_optionalSelectors:(NSSet<NSString *> *)sendata_optionalSelectors {
    objc_setAssociatedObject(self, kSANSProxyDelegateOptionalSelectorsKey, sendata_optionalSelectors, OBJC_ASSOCIATION_COPY);
}

- (id)sendata_delegateProxy {
    return objc_getAssociatedObject(self, kSANSProxyDelegateProxyKey);
}

- (void)setSendata_delegateProxy:(id)sendata_delegateProxy {
    objc_setAssociatedObject(self, kSANSProxyDelegateProxyKey, sendata_delegateProxy, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)sendata_registerDeallocBlock:(void (^)(void))deallocBlock {
    if (!self.sendata_parasite) {
        self.sendata_parasite = [[SADelegateProxyParasite alloc] init];
        self.sendata_parasite.deallocBlock = deallocBlock;
    }
}

- (BOOL)sendata_respondsToSelector:(SEL)aSelector {
    if ([self sendata_respondsToSelector:aSelector]) {
        return YES;
    }
    if ([self.sendata_optionalSelectors containsObject:NSStringFromSelector(aSelector)]) {
        return YES;
    }
    return NO;
}

@end
