//
//  CTextView.h
//  SingPost
//
//  Created by Edward Soetiono on 7/10/13.
//  Copyright (c) 2013 Codigo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CTextView : UITextView

@property (nonatomic) NSString *placeholder;
@property (nonatomic) UIColor *placeholderColor;
@property (nonatomic, assign) CGFloat fontSize;
@property (nonatomic, assign) CGFloat placeholderFontSize;

@end
