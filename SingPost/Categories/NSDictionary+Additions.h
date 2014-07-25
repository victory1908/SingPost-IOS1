//
//  NSDictionary+Additions.h
//  CurrencyExchange
//
//  Created by Edward Soetiono on 23/11/13.
//  Copyright (c) 2013 edwardsoetiono. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Additions)

- (id)objectForKeyOrNil:(id)key;

@end


@interface NSMutableDictionary (Additions)

- (void)setValidObject:(id)object forKey:(id <NSCopying>)key;

@end