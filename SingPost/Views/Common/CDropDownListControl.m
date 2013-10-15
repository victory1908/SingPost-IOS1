//
//  CDropDownListControl.m
//  SingPost
//
//  Created by Edward Soetiono on 29/9/13.
//  Copyright (c) 2013 Codigo. All rights reserved.
//

#import "CDropDownListControl.h"
#import "UIFont+SingPost.h"
#import "UIView+Position.h"

@interface CDropDownListControl () <UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate>

@end

@implementation CDropDownListControl
{
    UIPickerView *pickerView;
    UIButton *closePickerButton;
    UIView *pickerViewContainerView;
    UILabel *selectedValueLabel;
    
    NSUInteger selectedRowIndex;
    
    BOOL isAnimating;
}

#define PICKERVIEW_HEIGHT 215

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        [self setBackgroundColor:RGB(211, 210, 210)];
        
        selectedValueLabel = [[UILabel alloc] initWithFrame:CGRectInset(self.bounds, 10, 5)];
        [selectedValueLabel setWidth:selectedValueLabel.bounds.size.width - 12];
        [selectedValueLabel setFont:[UIFont SingPostLightFontOfSize:16.0f fontKey:kSingPostFontOpenSans]];
        [selectedValueLabel setBackgroundColor:[UIColor clearColor]];
        [self addSubview:selectedValueLabel];
        
        UIImageView *blackDropDownIndicatorImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"black_dropdown_indicator"]];
        [blackDropDownIndicatorImageView setFrame:CGRectMake(self.bounds.size.width - 20, self.bounds.size.height / 2.0f - 3, 10, 6)];
        [self addSubview:blackDropDownIndicatorImageView];
        
        //picker view
        pickerViewContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.frame) + 5, 320, PICKERVIEW_HEIGHT)];
        [pickerViewContainerView setTag:TAG_DROPDOWN_PICKERVIEW];
        [pickerViewContainerView setBackgroundColor:RGB(211, 210, 210)];
        [pickerViewContainerView setClipsToBounds:YES];
        
        pickerView = [[UIPickerView alloc] initWithFrame:pickerView.bounds];
        pickerView.showsSelectionIndicator = YES;
        [pickerView setDelegate:self];
        [pickerView setDataSource:self];
        [pickerViewContainerView addSubview:pickerView];
        
        closePickerButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [closePickerButton addTarget:self action:@selector(togglePickerVisibility) forControlEvents:UIControlEventTouchUpInside];
        [closePickerButton setBackgroundColor:[UIColor clearColor]];
        
        [self addTarget:self action:@selector(togglePickerVisibility) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

#define BOTTOM_MARGIN 6.0f
- (void)togglePickerVisibility
{
    if (!isAnimating) {
        isAnimating = YES;
        
        if (pickerViewContainerView.superview) {
            [_delegate repositionRelativeTo:self byVerticalHeight:-(PICKERVIEW_HEIGHT + BOTTOM_MARGIN)];
            
            [UIView animateWithDuration:0.3f animations:^{
                [pickerViewContainerView setHeight:0.0f];
            } completion:^(BOOL finished) {
                if ([self.delegate respondsToSelector:@selector(dropDownListIsDismissed:)])
                    [self.delegate dropDownListIsDismissed:self];
                
                [pickerViewContainerView removeFromSuperview];
                [closePickerButton removeFromSuperview];
                isAnimating = NO;
            }];
        }
        else {
            [_delegate repositionRelativeTo:self byVerticalHeight:PICKERVIEW_HEIGHT + BOTTOM_MARGIN];
            
            [closePickerButton setFrame:CGRectMake(0, 0, self.superview.bounds.size.width, self.superview.bounds.size.height + PICKERVIEW_HEIGHT)];
            [pickerViewContainerView setY:CGRectGetMaxY(self.frame) + 5 andHeight:0.0f];
            [self.superview addSubview:closePickerButton];
            [self.superview addSubview:pickerViewContainerView];
            
            [UIView animateWithDuration:0.3f animations:^{
                [pickerViewContainerView setHeight:PICKERVIEW_HEIGHT];
            } completion:^(BOOL finished) {
                isAnimating = NO;
            }];
        }
    }
}

- (void)selectRow:(NSInteger)row animated:(BOOL)shouldAnimate
{
    selectedRowIndex = row;
    [pickerView selectRow:row inComponent:0 animated:shouldAnimate];
    [self pickerView:pickerView didSelectRow:row inComponent:0];
    if ([self.delegate respondsToSelector:@selector(dropDownListIsDismissed:)])
        [self.delegate dropDownListIsDismissed:self];
}

- (BOOL)resignFirstResponder
{
    if (pickerViewContainerView.superview)
        [self togglePickerVisibility];
    
    return [super resignFirstResponder];
}

#pragma mark - Accessors

- (void)setValues:(NSArray *)inValues
{
    _values = inValues;
    [pickerView reloadAllComponents];
}

- (void)setPlistValueFile:(NSString *)inPlistValueFile
{
    _plistValueFile = inPlistValueFile;
    [self setValues:[NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:_plistValueFile ofType:@"plist"]]];
}

- (void)setPlaceholderText:(NSString *)placeholderText
{
    [selectedValueLabel setText:placeholderText];
}

- (NSString *)selectedText
{
    return _values[selectedRowIndex][@"value"];
}

- (NSString *)selectedValue
{
    return _values[selectedRowIndex][@"code"];
}

- (void)setFontSize:(CGFloat)fontSize
{
    [selectedValueLabel setFont:[UIFont SingPostLightFontOfSize:fontSize fontKey:kSingPostFontOpenSans]];
}

#pragma mark - UIPickerViewDelegates & DataSource

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    selectedRowIndex = row;
    [selectedValueLabel setText:_values[row][@"value"]];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;
{
    return _values.count;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    if (!view) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 250, 40)];
        label.font = [UIFont SingPostRegularFontOfSize:16.0f fontKey:kSingPostFontOpenSans];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = UITextAlignmentCenter;
        label.numberOfLines = 0;
        view = label;
    }
    
    ((UILabel *)view).text = _values[row][@"value"];

    return view;
}

@end
