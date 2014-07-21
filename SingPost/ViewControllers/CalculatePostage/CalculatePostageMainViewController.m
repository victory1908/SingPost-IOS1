//
//  CalculatePostageMainViewController.m
//  SingPost
//
//  Created by Edward Soetiono on 28/9/13.
//  Copyright (c) 2013 Codigo. All rights reserved.
//

#import "CalculatePostageMainViewController.h"
#import "NavigationBarView.h"
#import "UIFont+SingPost.h"
#import "CalculatePostageOverseasViewController.h"
#import "CalculatePostageSingaporeViewController.h"
#import "SectionToggleButton.h"
#import "UIView+Position.h"
#import "ApiClient.h"
#import "TTTAttributedLabel.h"
#import "UIAlertView+Blocks.h"

@interface CalculatePostageMainViewController ()
<
TTTAttributedLabelDelegate
>
@end

typedef enum  {
    CALCULATEPOSTAGE_SECTION_OVERSEAS,
    CALCULATEPOSTAGE_SECTION_SINGAPORE
} tCalculatePostageSections;

@implementation CalculatePostageMainViewController
{
    tCalculatePostageSections currentSection;
    SectionToggleButton *overseasSectionButton, *singaporeSectionButton;
    UIScrollView *sectionContentScrollView;
    UIButton *selectedSectionIndicatorButton;
    
    CalculatePostageOverseasViewController *overseasViewController;
    CalculatePostageSingaporeViewController *singaporeViewController;
}

- (void)loadView
{
    UIView *contentView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [contentView setBackgroundColor:RGB(240, 240, 240)];
    
    NavigationBarView *navigationBarView = [[NavigationBarView alloc] initWithFrame:NAVIGATIONBAR_FRAME];
    [navigationBarView setTitle:@"Calculate Postage"];
    if (_showNavBarBackButton)
        [navigationBarView setShowBackButton:YES];
    else
        [navigationBarView setShowSidebarToggleButton:YES];
    [contentView addSubview:navigationBarView];
    
    TTTAttributedLabel *instructionsLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectMake(15, 52, contentView.bounds.size.width - 30, 80)];
    [instructionsLabel setNumberOfLines:0];
    [instructionsLabel setFont:[UIFont SingPostRegularFontOfSize:14.0f fontKey:kSingPostFontOpenSans]];
    [instructionsLabel setBackgroundColor:[UIColor clearColor]];
    instructionsLabel.delegate = self;
    
    [instructionsLabel setText:@"Use this tool to find out charges for sending mails or parcels. Singapore Post covers all addresses within Singapore and 220 countries worldwide" afterInheritingLabelAttributesAndConfiguringWithBlock:nil];
     /*
    [instructionsLabel setText:@"Use this tool to find out charges for sending letter or parcel.\nThis is just to show you what 80 letter characters looks like, this is singpost" afterInheritingLabelAttributesAndConfiguringWithBlock:nil];
    NSRange singpost = [instructionsLabel.text rangeOfString:@"singpost"];
    [instructionsLabel addLinkToURL:[NSURL URLWithString:@"action://SingPost"] withRange:singpost];
    */
    [contentView addSubview:instructionsLabel];
    
    sectionContentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 190, contentView.bounds.size.width, contentView.bounds.size.height - 190)];
    [sectionContentScrollView setBackgroundColor:[UIColor clearColor]];
    [sectionContentScrollView setDelaysContentTouches:NO];
    [sectionContentScrollView setPagingEnabled:YES];
    [sectionContentScrollView setScrollEnabled:NO];
    [contentView addSubview:sectionContentScrollView];
    
    overseasViewController = [[CalculatePostageOverseasViewController alloc] initWithNibName:nil bundle:nil];
    [self addChildViewController:overseasViewController];
    [overseasViewController.view setFrame:CGRectMake(contentView.bounds.size.width * CALCULATEPOSTAGE_SECTION_OVERSEAS, 0, sectionContentScrollView.bounds.size.width, sectionContentScrollView.bounds.size.height)];
    [sectionContentScrollView addSubview:overseasViewController.view];
    [overseasViewController didMoveToParentViewController:self];
    
    singaporeViewController = [[CalculatePostageSingaporeViewController alloc] initWithNibName:nil bundle:nil];
    [self addChildViewController:singaporeViewController];
    [singaporeViewController.view setFrame:CGRectMake(contentView.bounds.size.width * CALCULATEPOSTAGE_SECTION_SINGAPORE, 0, sectionContentScrollView.bounds.size.width, sectionContentScrollView.bounds.size.height)];
    [sectionContentScrollView addSubview:singaporeViewController.view];
    [singaporeViewController didMoveToParentViewController:self];
    
    UIView *topSeparatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 139, contentView.bounds.size.width, 0.5f)];
    [topSeparatorView setBackgroundColor:RGB(196, 197, 200)];
    [contentView addSubview:topSeparatorView];
    
    UIView *bottomSeparatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 189.5, contentView.bounds.size.width, 0.5f)];
    [bottomSeparatorView setBackgroundColor:RGB(196, 197, 200)];
    [contentView addSubview:bottomSeparatorView];
    
    overseasSectionButton = [[SectionToggleButton alloc] initWithFrame:CGRectMake(0, 139.5, contentView.bounds.size.width / 2.0f + 0.5f, 50)];
    [overseasSectionButton setTag:CALCULATEPOSTAGE_SECTION_OVERSEAS];
    [overseasSectionButton addTarget:self action:@selector(sectionButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [overseasSectionButton setTitle:@"Overseas" forState:UIControlStateNormal];
    [overseasSectionButton setSelected:NO];
    [contentView addSubview:overseasSectionButton];
    
    singaporeSectionButton = [[SectionToggleButton alloc] initWithFrame:CGRectMake(contentView.bounds.size.width / 2.0f, 139.5, contentView.bounds.size.width / 2.0f, 50)];
    [singaporeSectionButton setTag:CALCULATEPOSTAGE_SECTION_SINGAPORE];
    [singaporeSectionButton addTarget:self action:@selector(sectionButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [singaporeSectionButton setTitle:@"Singapore" forState:UIControlStateNormal];
    [singaporeSectionButton setSelected:NO];
    [contentView addSubview:singaporeSectionButton];
    
    selectedSectionIndicatorButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [selectedSectionIndicatorButton setBackgroundColor:RGB(36, 84, 157)];
    [selectedSectionIndicatorButton.titleLabel setFont:[UIFont SingPostBoldFontOfSize:14.0f fontKey:kSingPostFontOpenSans]];
    [selectedSectionIndicatorButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [selectedSectionIndicatorButton setFrame:overseasSectionButton.frame];
    [contentView addSubview:selectedSectionIndicatorButton];
    
    UIImageView *selectedIndicatorImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"selected_indicator"]];
    [selectedIndicatorImageView setFrame:CGRectMake((int)(selectedSectionIndicatorButton.bounds.size.width / 2) - 8, selectedSectionIndicatorButton.bounds.size.height, 17, 8)];
    [selectedSectionIndicatorButton addSubview:selectedIndicatorImageView];
    
    UIPanGestureRecognizer *sectionSelectionPanGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleSectionSelectionPanGesture:)];
    [selectedSectionIndicatorButton addGestureRecognizer:sectionSelectionPanGestureRecognizer];
    
    self.view = contentView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self goToSection:CALCULATEPOSTAGE_SECTION_OVERSEAS];
}

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url {
    if ([[url scheme]hasPrefix:@"action"]) {
        if ([[url host]hasPrefix:@"SingPost"]) {
            [UIAlertView showWithTitle:nil message:@"Open link in Safari?"
                     cancelButtonTitle:@"Cancel" otherButtonTitles:@[@"OK"]
                              tapBlock:^(UIAlertView *alert, NSInteger buttonIndex) {
                                  if (buttonIndex == 1) {
                                      [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"http://www.singpost.com"]];
                                  }
                              }];
        }
    }
}

- (void)handleSectionSelectionPanGesture:(UIPanGestureRecognizer *)gestureRecognizer
{
    CGPoint translation = [gestureRecognizer translationInView:self.view];
    gestureRecognizer.view.center = CGPointMake(gestureRecognizer.view.center.x + translation.x, gestureRecognizer.view.center.y);
    [gestureRecognizer.view setX:MIN(MAX(0, gestureRecognizer.view.frame.origin.x), self.view.bounds.size.width - gestureRecognizer.view.bounds.size.width)];
    [gestureRecognizer setTranslation:CGPointZero inView:self.view];
    
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        [self resignAllResponders];
    }
    else if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        if (CGRectContainsPoint(overseasSectionButton.frame, gestureRecognizer.view.center))
            [self goToSection:CALCULATEPOSTAGE_SECTION_OVERSEAS];
        else if (CGRectContainsPoint(singaporeSectionButton.frame, gestureRecognizer.view.center))
            [self goToSection:CALCULATEPOSTAGE_SECTION_SINGAPORE];
    }
    else {
        if (CGRectContainsPoint(overseasSectionButton.frame, gestureRecognizer.view.center))
            [selectedSectionIndicatorButton setTitle:@"Overseas" forState:UIControlStateNormal];
        else if (CGRectContainsPoint(singaporeSectionButton.frame, gestureRecognizer.view.center))
            [selectedSectionIndicatorButton setTitle:@"Singapore" forState:UIControlStateNormal];
    }
}

- (void)goToSection:(tCalculatePostageSections)section
{
    currentSection = section;
    
    if (currentSection == CALCULATEPOSTAGE_SECTION_OVERSEAS)
        [selectedSectionIndicatorButton setTitle:@"Overseas" forState:UIControlStateNormal];
    else if (currentSection == CALCULATEPOSTAGE_SECTION_SINGAPORE)
        [selectedSectionIndicatorButton setTitle:@"Singapore" forState:UIControlStateNormal];
    
    [sectionContentScrollView setContentOffset:CGPointMake(currentSection * sectionContentScrollView.bounds.size.width, 0) animated:YES];
    
    [UIView animateWithDuration:0.3f animations:^{
        if (currentSection == CALCULATEPOSTAGE_SECTION_OVERSEAS)
            [selectedSectionIndicatorButton setFrame:overseasSectionButton.frame];
        else if (currentSection == CALCULATEPOSTAGE_SECTION_SINGAPORE)
            [selectedSectionIndicatorButton setFrame:singaporeSectionButton.frame];
    }];
}

#pragma mark - IBActions

- (IBAction)sectionButtonClicked:(id)sender
{
    [self resignAllResponders];
    if (sender == overseasSectionButton)
        [self goToSection:CALCULATEPOSTAGE_SECTION_OVERSEAS];
    else if (sender == singaporeSectionButton)
        [self goToSection:CALCULATEPOSTAGE_SECTION_SINGAPORE];
}

#pragma mark -

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self resignAllResponders];
}

- (void)resignAllResponders
{
    [sectionContentScrollView endEditing:YES];
    [overseasViewController.view endEditing:YES];
    [singaporeViewController.view endEditing:YES];
}

@end
