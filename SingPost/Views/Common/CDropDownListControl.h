//
//  CDropDownListControl.h
//  SingPost
//
//  Created by Edward Soetiono on 29/9/13.
//  Copyright (c) 2013 Codigo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CDropDownListControl : UIControl

@property (nonatomic) NSArray *values;
@property (nonatomic) NSString *plistValueFile;
@property (nonatomic) NSString *placeholderText;
@property (nonatomic) CGFloat fontSize;

@property (nonatomic, readonly) NSString *selectedText;
@property (nonatomic, readonly) NSString *selectedValue;

- (void)selectRow:(NSInteger)row animated:(BOOL)shouldAnimate;

@end
