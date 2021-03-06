//
//  NSDictionary+Additions.m
//  CurrencyExchange
//
//  Created by Edward Soetiono on 23/11/13.
//  Copyright (c) 2013 edwardsoetiono. All rights reserved.
//

#import "NSDictionary+Additions.h"

@implementation NSDictionary (Additions)

- (id)objectForKeyOrNil:(id)key {
    id val = [self objectForKey:key];
    return (val == [NSNull null]) ? nil : val;
}

@end

@implementation NSMutableDictionary (Additions)

- (void)setValidObject:(id)object forKey:(id <NSCopying>)key {
    if (object == nil)
        return;
    [self setObject:object forKey:key];
}

@end