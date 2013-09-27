//
//  UIFont+SingPost.m
//  SingPost
//
//  Created by Edward Soetiono on 27/9/13.
//  Copyright (c) 2013 Codigo. All rights reserved.
//

#import "UIFont+SingPost.h"

@implementation UIFont (SingPost)

NSString *const kSingPostFontOpenSans = @"Open Sans";

NSString *const kFontRegularKey = @"Regular";
NSString *const kFontItalicKey = @"Italic";
NSString *const kFontBoldKey = @"Bold";
NSString *const kFontBoldItalicKey = @"BoldItalic";
NSString *const kFontLightKey = @"Light";
NSString *const kFontLightItalicKey = @"LightItalic";

+ (NSDictionary *)fontMapForFontKey:(NSString *)key {
    static NSDictionary *fontDictionary = nil;
    static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		fontDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:
                          @{kFontRegularKey: @"OpenSans", kFontLightKey: @"OpenSans-Light", kFontLightItalicKey: @"OpenSansLight-Italic"}, kSingPostFontOpenSans,
                          nil];
	});
    
	return [fontDictionary objectForKey:key];
}

+ (NSString *)fontNameForFontKey:(NSString *)key style:(NSString *)style {
	return [[self fontMapForFontKey:key] objectForKey:style];
}

#pragma mark - Fonts

+ (UIFont *)SingPostRegularFontOfSize:(CGFloat)fontSize fontKey:(NSString *)key
{
    NSString *fontName = [self fontNameForFontKey:key style:kFontRegularKey];
	return [self fontWithName:fontName size:fontSize];
}

+ (UIFont *)SingPostLightFontOfSize:(CGFloat)fontSize fontKey:(NSString *)key
{
    NSString *fontName = [self fontNameForFontKey:key style:kFontLightKey];
	return [self fontWithName:fontName size:fontSize];
}

+ (UIFont *)SingPostLightItalicFontOfSize:(CGFloat)fontSize fontKey:(NSString *)key
{
    NSString *fontName = [self fontNameForFontKey:key style:kFontLightItalicKey];
	return [self fontWithName:fontName size:fontSize];
}


@end
