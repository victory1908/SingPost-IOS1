//
//  NSObject+Addtions.m
//  GNC
//
//  Created by Wei Guang on 24/2/14.
//  Copyright (c) 2014 Codigo. All rights reserved.
//

#import "NSObject+Addtions.h"
#import <objc/runtime.h>

@implementation NSObject (Addtions)
@dynamic associatedObject;

- (void)setAssociatedObject:(id)object {
    objc_setAssociatedObject(self, @selector(associatedObject), object, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id)associatedObject {
    return objc_getAssociatedObject(self, @selector(associatedObject));
}

- (id)ifKindOfClass:(Class)c {
    return [self isKindOfClass:c] ? self : nil;
}

@end
