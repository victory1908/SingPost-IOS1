//
//  NSString+Extensions.m
//  SingPost
//
//  Created by Edward Soetiono on 13/12/13.
//  Copyright (c) 2013 Codigo. All rights reserved.
//

#import "NSString+Extensions.h"

@implementation NSString(Extensions)

- (NSString *)trimWhiteSpaces
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

@end
