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
    UIActionSheet *pickerViewActionSheet;
    UIPickerView *pickerView;
    UILabel *selectedValueLabel;
    NSArray *_values;
}

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        [self setBackgroundColor:RGB(211, 210, 210)];
        
        selectedValueLabel = [[UILabel alloc] initWithFrame:CGRectInset(self.bounds, 5, 5)];
        [selectedValueLabel setWidth:selectedValueLabel.bounds.size.width - 16];
        [selectedValueLabel setFont:[UIFont SingPostLightFontOfSize:16.0f fontKey:kSingPostFontOpenSans]];
        [selectedValueLabel setBackgroundColor:[UIColor clearColor]];
        [self addSubview:selectedValueLabel];
        
        UIImageView *blackDropDownIndicatorImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"black_dropdown_indicator"]];
        [blackDropDownIndicatorImageView setFrame:CGRectMake(self.bounds.size.width - 20, self.bounds.size.height / 2.0f - 3, 10, 6)];
        [self addSubview:blackDropDownIndicatorImageView];
        
        
        //picker view
        pickerViewActionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                            delegate:nil
                                                   cancelButtonTitle:nil
                                              destructiveButtonTitle:nil
                                                   otherButtonTitles:nil];
        
        [pickerViewActionSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
        
        pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 44, 320, 200)];
        pickerView.showsSelectionIndicator = YES;
        [pickerView setDelegate:self];
        [pickerView setDataSource:self];
        
        UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
        toolbar.barStyle = UIBarStyleBlackTranslucent;
        
        UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStyleBordered target:self action:@selector(dismissPickerViewActionSheet)];
        [closeButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys: [UIFont SingPostRegularFontOfSize:16.0f fontKey:kSingPostFontOpenSans], UITextAttributeFont,nil] forState:UIControlStateNormal];
        UIBarButtonItem *fixed1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        [toolbar setItems:@[fixed1, closeButton]];
        
        [pickerViewActionSheet addSubview:pickerView];
        [pickerViewActionSheet addSubview:toolbar];
        
        [self addTarget:self action:@selector(showPickerViewActionSheet) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)showPickerViewActionSheet
{
    [pickerViewActionSheet showInView:self];
    [pickerViewActionSheet setBounds:CGRectMake(0, 0, 320, 440)];
}

- (void)dismissPickerViewActionSheet
{
    [pickerViewActionSheet dismissWithClickedButtonIndex:0 animated:YES];
}

#pragma mark - Accessors

- (void)setPlistValueFile:(NSString *)inPlistValueFile
{
    _plistValueFile = inPlistValueFile;
    _values = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:_plistValueFile ofType:@"plist"]];
    [pickerView reloadAllComponents];
}

- (void)setPlaceholderText:(NSString *)placeholderText
{
    [selectedValueLabel setText:placeholderText];
}

#pragma mark - UIPickerViewDelegates & DataSource

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
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
        label.text = _values[row][@"value"];
        view = label;
    }

    return view;
}

@end
