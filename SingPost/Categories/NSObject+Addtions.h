//
//  NSObject+Addtions.h
//  GNC
//
//  Created by Wei Guang on 24/2/14.
//  Copyright (c) 2014 Codigo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Addtions)

- (id)ifKindOfClass:(Class)c;

@property (nonatomic, strong) id associatedObject;

@end
