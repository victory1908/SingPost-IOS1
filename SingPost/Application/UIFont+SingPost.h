//
//  UIFont+SingPost.h
//  SingPost
//
//  Created by Edward Soetiono on 27/9/13.
//  Copyright (c) 2013 Codigo. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const kSingPostFontOpenSans;

extern NSString *const kFontRegularKey;
extern NSString *const kFontItalicKey;
extern NSString *const kFontBoldKey;
extern NSString *const kFontBoldItalicKey;
extern NSString *const kFontLightItalicKey;
extern NSString *const kFontLightKey;

@interface UIFont (SingPost)

+ (NSDictionary *)fontMapForFontKey:(NSString *)key;
+ (NSString *)fontNameForFontKey:(NSString *)key style:(NSString *)style;

+ (UIFont *)SingPostRegularFontOfSize:(CGFloat)fontSize fontKey:(NSString *)key;
+ (UIFont *)SingPostLightItalicFontOfSize:(CGFloat)fontSize fontKey:(NSString *)key;

@end

