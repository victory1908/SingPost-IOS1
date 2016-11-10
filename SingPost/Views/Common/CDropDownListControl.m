//
//  CDropDownListControl.m
//  SingPost
//
//  Created by Edward Soetiono on 29/9/13.
//  Copyright (c) 2013 Codigo. All rights reserved.
//

//#import "CDropDownListControl.h"
//#import "UIFont+SingPost.h"
//#import "UIView+Position.h"
//#import "UIImage+Extensions.h"
//#import "CUIActionSheet.h"
//
////@interface CDropDownListControl () <UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, UIPopoverControllerDelegate>
//
//@interface CDropDownListControl () <UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate>
//
//@end
//
//@implementation CDropDownListControl
//{
//    UIPickerView *pickerView;
////    UIPopoverController *pickerPopover;
//    UIViewController *pickerPopover;
////    UIActionSheet *pickerViewActionSheet;
//    CUIActionSheet *pickerViewActionSheet;
//    UILabel *selectedValueLabel;
//}
//
//#define PICKERVIEW_HEIGHT 215
//
//- (id)initWithFrame:(CGRect)frame
//{
//    if ((self = [super initWithFrame:frame])) {
//        _selectedRowIndex = NSNotFound;
//        [self setBackgroundColor:RGB(211, 210, 210)];
//        
//        selectedValueLabel = [[UILabel alloc] initWithFrame:CGRectInset(self.bounds, 10, 5)];
//        [selectedValueLabel setWidth:selectedValueLabel.bounds.size.width - 12];
//        [selectedValueLabel setFont:[UIFont SingPostLightFontOfSize:16.0f fontKey:kSingPostFontOpenSans]];
//        [selectedValueLabel setBackgroundColor:[UIColor clearColor]];
//        [self addSubview:selectedValueLabel];
//        
//        UIImageView *blackDropDownIndicatorImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"black_dropdown_indicator"]];
//        [blackDropDownIndicatorImageView setFrame:CGRectMake(self.bounds.size.width - 20, self.bounds.size.height / 2.0f - 3, 10, 6)];
//        [self addSubview:blackDropDownIndicatorImageView];
//        
//        pickerView = [[UIPickerView alloc] initWithFrame:SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0") ? CGRectMake(0, 42, 320, 230) : CGRectMake(0, 44, 320, 215)];
//        pickerView.showsSelectionIndicator = YES;
//        [pickerView setDelegate:self];
//        [pickerView setDataSource:self];
//
//        [self addTarget:self action:@selector(showActionSheet) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return self;
//}
//
//- (void)showActionSheet
//{
//    if (!INTERFACE_IS_IPAD) {
//        
//        pickerViewActionSheet = [[CUIActionSheet alloc] init];
//
//        UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
//        UIBarButtonItem *fixed1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
////        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(dismissActionSheet)];
//        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(dismissActionSheet)];
//        
//        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
//            UIImage *toolbarBackgroundImage = [[UIImage imageWithColor:RGB(200, 200, 200)] stretchableImageWithLeftCapWidth:0 topCapHeight:0];
//            [toolbar setBackgroundImage:toolbarBackgroundImage forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
//            [doneButton setTitleTextAttributes:@{
//                                                 NSFontAttributeName: [UIFont SingPostRegularFontOfSize:15.0f fontKey:kSingPostFontOpenSans],
//                                                 NSForegroundColorAttributeName: [UIColor blackColor]
//                                                 } forState:UIControlStateNormal];
////                                                   UITextAttributeFont: [UIFont SingPostRegularFontOfSize:15.0f fontKey:kSingPostFontOpenSans],
////                                                   UITextAttributeTextColor: [UIColor blackColor]
////                                                   } forState:UIControlStateNormal];
//        }
//        else {
//            [toolbar setBarStyle:UIBarStyleBlackOpaque];
//        }
//        
//        [toolbar setItems:@[fixed1, doneButton]];
//        
//        [pickerViewActionSheet addSubview:pickerView];
//        [pickerViewActionSheet addSubview:toolbar];
//        [pickerViewActionSheet setBounds:SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0") ? CGRectMake(0, 0, 320, 430) : CGRectMake(0, 0, 320, 420)];
//        [pickerViewActionSheet showInView:self];
//    }
//    else
//    {
//        if (pickerPopover) {
////            [pickerPopover dismissPopoverAnimated:YES];
//            [pickerPopover dismissViewControllerAnimated:YES completion:nil];
//        }
//        UIColor *navbarColor = [UIColor colorWithRed:(235.0/255.0) green:(235.0/255.0) blue:(235.0/255.0) alpha:1.0];
//        UIViewController * popoverContent = [[UIViewController alloc] init];
//        UIView* popoverView = [[UIView alloc] init];
//        popoverView.backgroundColor = [UIColor whiteColor];
//        UIView *headerView=[[UIView alloc]init];
//        [headerView setBackgroundColor:navbarColor];
//        UIButton *done_btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//        [done_btn setTitle:@"Done" forState:UIControlStateNormal];
//        [done_btn addTarget:self action:@selector(dismissActionSheet) forControlEvents:UIControlEventTouchUpInside];
//        [headerView addSubview:done_btn];
//        [popoverView addSubview:headerView];
//        [popoverView addSubview:pickerView];
//        popoverContent.view = popoverView;
//        popoverView.frame = CGRectMake(0, 0, 320, 344);
//        headerView.frame = CGRectMake(0, 0, 320, 45);
//        [done_btn setFrame:CGRectMake(260, 8, 50,30)];
//        popoverContent.preferredContentSize = CGSizeMake(320, 244);
////        popoverContent.contentSizeForViewInPopover = CGSizeMake(320, 244);
////        pickerPopover = [[UIPopoverController alloc] initWithContentViewController:popoverContent];
//        pickerPopover.modalPresentationStyle = UIModalPresentationPopover;
//        [pickerPopover presentViewController:pickerPopover animated:YES completion:nil];
//        
//        // Popover presentation controller was created when presenting; now  configure it.
//        UIPopoverPresentationController *presentationController = [pickerPopover popoverPresentationController];
//        presentationController.permittedArrowDirections = UIPopoverArrowDirectionUp;
//        presentationController.sourceView = self;
//        // arrow points out of the rect specified here
//        presentationController.sourceRect = self.bounds;
//        
////        [pickerPopover presentPopoverFromRect:self.bounds inView:self
////                     permittedArrowDirections:UIPopoverArrowDirectionUp
////                                     animated:YES];
////        pickerPopover.delegate = self;
//
//    }
//}
//
//- (void)dismissActionSheet
//{
//    [self selectRow:[pickerView selectedRowInComponent:0] animated:NO];
//    if ([_delegate respondsToSelector:@selector(CDropDownListControlDismissed:)]) {
//        [_delegate CDropDownListControlDismissed:self];
//    }
////    if(!INTERFACE_IS_IPAD)[pickerViewActionSheet dismissWithClickedButtonIndex:0 animated:YES];
//    if(!INTERFACE_IS_IPAD)[pickerViewActionSheet dismissView];
////    else [pickerPopover dismissPopoverAnimated:YES];
//    else [pickerPopover dismissViewControllerAnimated:YES completion:nil];
//}
//
//- (void)selectRow:(NSInteger)row animated:(BOOL)shouldAnimate
//{
//    _selectedRowIndex = row;
//    [pickerView selectRow:row inComponent:0 animated:shouldAnimate];
//    [self pickerView:pickerView didSelectRow:row inComponent:0];
//}
//
//#pragma mark - Accessors
//
//- (void)setValues:(NSArray *)inValues
//{
//    _values = inValues;
//    [pickerView reloadAllComponents];
//}
//
//- (void)setPlistValueFile:(NSString *)inPlistValueFile
//{
//    _plistValueFile = inPlistValueFile;
//    [self setValues:[NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:_plistValueFile ofType:@"plist"]]];
//}
//
//- (void)setPlaceholderText:(NSString *)placeholderText
//{
//    [selectedValueLabel setText:placeholderText];
//}
//
//- (NSString *)selectedText
//{
//    if (_selectedRowIndex == NSNotFound)
//        return nil;
//    return _values[_selectedRowIndex][@"value"];
//}
//
//- (NSString *)selectedValue
//{
//    if (_selectedRowIndex == NSNotFound)
//        return nil;
//    return _values[_selectedRowIndex][@"code"];
//}
//
//- (void)setFontSize:(CGFloat)fontSize
//{
//    [selectedValueLabel setFont:[UIFont SingPostLightFontOfSize:fontSize fontKey:kSingPostFontOpenSans]];
//}
//
//#pragma mark - UIPickerViewDelegates & DataSource
//
//- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
//    _selectedRowIndex = row;
//    [selectedValueLabel setText:_values[row][@"value"]];
//}
//
//- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;
//{
//    return 1;
//}
//
//- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;
//{
//    return _values.count;
//}
//
//- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
//{
//    if (!view) {
//        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 250, 40)];
//        label.font = [UIFont SingPostRegularFontOfSize:16.0f fontKey:kSingPostFontOpenSans];
//        label.backgroundColor = [UIColor clearColor];
//        label.textAlignment = NSTextAlignmentCenter;
//        label.numberOfLines = 0;
//        view = label;
//    }
//    
//    ((UILabel *)view).text = _values[row][@"value"];
//
//    return view;
//}
//
//@end






#import "CDropDownListControl.h"
#import "UIFont+SingPost.h"
#import "UIView+Position.h"
#import "UIImage+Extensions.h"
#import "CUIActionSheet.h"

@interface CDropDownListControl () <UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, UIPopoverControllerDelegate>

@end

@implementation CDropDownListControl
{
    UIPickerView *pickerView;
    UIPopoverController *pickerPopover;
    //    UIActionSheet *pickerViewActionSheet;
    CUIActionSheet *pickerViewActionSheet;
    UILabel *selectedValueLabel;
}

#define PICKERVIEW_HEIGHT 215

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        _selectedRowIndex = NSNotFound;
        [self setBackgroundColor:RGB(211, 210, 210)];
        
        selectedValueLabel = [[UILabel alloc] initWithFrame:CGRectInset(self.bounds, 10, 5)];
        [selectedValueLabel setWidth:selectedValueLabel.bounds.size.width - 12];
        [selectedValueLabel setFont:[UIFont SingPostLightFontOfSize:16.0f fontKey:kSingPostFontOpenSans]];
        [selectedValueLabel setBackgroundColor:[UIColor clearColor]];
        [self addSubview:selectedValueLabel];
        
        UIImageView *blackDropDownIndicatorImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"black_dropdown_indicator"]];
        [blackDropDownIndicatorImageView setFrame:CGRectMake(self.bounds.size.width - 20, self.bounds.size.height / 2.0f - 3, 10, 6)];
        [self addSubview:blackDropDownIndicatorImageView];
        
        pickerView = [[UIPickerView alloc] initWithFrame:SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0") ? CGRectMake(0, 42, 320, 230) : CGRectMake(0, 44, 320, 215)];
        pickerView.showsSelectionIndicator = YES;
        [pickerView setDelegate:self];
        [pickerView setDataSource:self];
        
        [self addTarget:self action:@selector(showActionSheet) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)showActionSheet
{
    if (!INTERFACE_IS_IPAD) {
        
        pickerViewActionSheet = [[CUIActionSheet alloc] init];
        
        UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
        UIBarButtonItem *fixed1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(dismissActionSheet)];
//        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(dismissActionSheet)];
        
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
            UIImage *toolbarBackgroundImage = [[UIImage imageWithColor:RGB(200, 200, 200)] stretchableImageWithLeftCapWidth:0 topCapHeight:0];
            [toolbar setBackgroundImage:toolbarBackgroundImage forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
            
            NSDictionary *attributes = @{
                                         NSForegroundColorAttributeName: [UIColor blackColor],
                                         NSFontAttributeName: [UIFont fontWithName:kSingPostFontOpenSans size:15.0f]
                                         };
            
            [doneButton setTitleTextAttributes:attributes forState:UIControlStateNormal];
            
//            [doneButton setTitleTextAttributes:@{
//                                                 UITextAttributeFont: [UIFont SingPostRegularFontOfSize:15.0f fontKey:kSingPostFontOpenSans],
//                                                 UITextAttributeTextColor: [UIColor blackColor]
//                                                 } forState:UIControlStateNormal];
        }
        else {
            [toolbar setBarStyle:UIBarStyleBlackOpaque];
        }
        
        [toolbar setItems:@[fixed1, doneButton]];
        
        [pickerViewActionSheet addSubview:pickerView];
        [pickerViewActionSheet addSubview:toolbar];
        [pickerViewActionSheet setBounds:SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0") ? CGRectMake(0, 0, 320, 430) : CGRectMake(0, 0, 320, 420)];
        [pickerViewActionSheet showInView:self];
    }
    else
    {
        if (pickerPopover) {
            [pickerPopover dismissPopoverAnimated:YES];
        }
        UIColor *navbarColor = [UIColor colorWithRed:(235.0/255.0) green:(235.0/255.0) blue:(235.0/255.0) alpha:1.0];
        UIViewController * popoverContent = [[UIViewController alloc] init];
        UIView* popoverView = [[UIView alloc] init];
        popoverView.backgroundColor = [UIColor whiteColor];
        UIView *headerView=[[UIView alloc]init];
        [headerView setBackgroundColor:navbarColor];
        UIButton *done_btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [done_btn setTitle:@"Done" forState:UIControlStateNormal];
        [done_btn addTarget:self action:@selector(dismissActionSheet) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:done_btn];
        [popoverView addSubview:headerView];
        [popoverView addSubview:pickerView];
        popoverContent.view = popoverView;
        popoverView.frame = CGRectMake(0, 0, 320, 344);
        headerView.frame = CGRectMake(0, 0, 320, 45);
        [done_btn setFrame:CGRectMake(260, 8, 50,30)];
        popoverContent.preferredContentSize = CGSizeMake(320, 244);
//        popoverContent.contentSizeForViewInPopover = CGSizeMake(320, 244);
        pickerPopover = [[UIPopoverController alloc] initWithContentViewController:popoverContent];
        [pickerPopover presentPopoverFromRect:self.bounds inView:self
                     permittedArrowDirections:UIPopoverArrowDirectionUp
                                     animated:YES];
        pickerPopover.delegate = self;
        
    }
}

- (void)dismissActionSheet
{
    [self selectRow:[pickerView selectedRowInComponent:0] animated:NO];
    if ([_delegate respondsToSelector:@selector(CDropDownListControlDismissed:)]) {
        [_delegate CDropDownListControlDismissed:self];
    }
    //    if(!INTERFACE_IS_IPAD)[pickerViewActionSheet dismissWithClickedButtonIndex:0 animated:YES];
    if(!INTERFACE_IS_IPAD)[pickerViewActionSheet dismissView];
    else [pickerPopover dismissPopoverAnimated:YES];
}

- (void)selectRow:(NSInteger)row animated:(BOOL)shouldAnimate
{
    _selectedRowIndex = row;
    [pickerView selectRow:row inComponent:0 animated:shouldAnimate];
    [self pickerView:pickerView didSelectRow:row inComponent:0];
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
    if (_selectedRowIndex == NSNotFound)
        return nil;
    return _values[_selectedRowIndex][@"value"];
}

- (NSString *)selectedValue
{
    if (_selectedRowIndex == NSNotFound)
        return nil;
    return _values[_selectedRowIndex][@"code"];
}

- (void)setFontSize:(CGFloat)fontSize
{
    [selectedValueLabel setFont:[UIFont SingPostLightFontOfSize:fontSize fontKey:kSingPostFontOpenSans]];
}

#pragma mark - UIPickerViewDelegates & DataSource

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    _selectedRowIndex = row;
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
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 0;
        view = label;
    }
    
    ((UILabel *)view).text = _values[row][@"value"];
    
    return view;
}

@end



