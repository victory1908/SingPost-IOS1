//
//  CDropDownListControl.h
//  SingPost
//
//  Created by Edward Soetiono on 29/9/13.
//  Copyright (c) 2013 Codigo. All rights reserved.
//

#import <UIKit/UIKit.h>

#define TAG_DROPDOWN_PICKERVIEW 888

@protocol CDropDownListControlDelegate;

@interface CDropDownListControl : UIControl

@property (nonatomic) NSString *plistValueFile;
@property (nonatomic) NSString *placeholderText;
@property (nonatomic, weak) id<CDropDownListControlDelegate> delegate;

@property (nonatomic, readonly) NSString *selectedText;
@property (nonatomic, readonly) NSString *selectedValue;

- (void)selectRow:(NSInteger)row animated:(BOOL)shouldAnimate;

@end

@protocol CDropDownListControlDelegate <NSObject>

- (void)repositionRelativeTo:(CDropDownListControl *)control byVerticalHeight:(CGFloat)offsetHeight;

@end
