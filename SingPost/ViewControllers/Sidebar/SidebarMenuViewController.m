//
//  SidebarMenuViewController.m
//  SingPost
//
//  Created by Edward Soetiono on 24/9/13.
//  Copyright (c) 2013 Codigo. All rights reserved.
//

#import "SidebarMenuViewController.h"
#import "UIFont+SingPost.h"
#import "UIColor+SingPost.h"
#import "SidebarMenuTableViewCell.h"

@interface SidebarTrackingNumberTextField : UITextField

@end

@implementation SidebarTrackingNumberTextField

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        self.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
        self.autocorrectionType = UITextAutocorrectionTypeNo;
        self.backgroundColor = [UIColor clearColor];
        self.textColor = [UIColor SingPostBlueColor];
        self.font = [UIFont SingPostRegularFontOfSize:14.0f fontKey:kSingPostFontOpenSans];
    }
    
    return self;
}

- (void)drawPlaceholderInRect:(CGRect)rect {
    [RGB(163, 163, 163) setFill];
    [[self placeholder] drawInRect:CGRectInset(rect, 0, 5)  withFont:[UIFont SingPostLightItalicFontOfSize:9.0f fontKey:kSingPostFontOpenSans]];
}

- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, 0, 6);
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, 0, 6);
}

@end

@interface SidebarMenuViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@end

@implementation SidebarMenuViewController
{
    SidebarTrackingNumberTextField *trackingNumberTextField;
    UITableView *menuTableView;
}

- (void)loadView
{
    UIView *contentView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    [contentView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [contentView setBackgroundColor:[UIColor whiteColor]];
    
    CGFloat offsetY = 10.0f;
    UIImageView *singPostLogoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo_singaporepost_colored"]];
    [singPostLogoImageView setFrame:CGRectMake(10, offsetY, 120, 44)];
    [contentView addSubview:singPostLogoImageView];
    
    offsetY += 55.0f;
    
    menuTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, offsetY, contentView.bounds.size.width, contentView.bounds.size.height - offsetY) style:UITableViewStylePlain];
    [menuTableView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [menuTableView setDelegate:self];
    [menuTableView setDataSource:self];
    [menuTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [menuTableView setSeparatorColor:[UIColor clearColor]];
    [menuTableView setBackgroundView:nil];
    
    [contentView addSubview:menuTableView];
    
    self.view = contentView;
}

#pragma mark - IBActions

- (IBAction)findTrackingNumberButtonClicked:(id)sender
{
    NSLog(@"find tracking number clicked");
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - UITableView DataSource & Delegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 40)];
    [headerView setBackgroundColor:RGB(238, 238, 238)];
    
    UIView *separatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, headerView.bounds.size.width, 1)];
    [separatorView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [separatorView setBackgroundColor:RGB(196, 197, 200)];
    [headerView addSubview:separatorView];
    
    UILabel *trackLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 14, 80, 14)];
    [trackLabel setFont:[UIFont SingPostLightFontOfSize:14.0f fontKey:kSingPostFontOpenSans]];
    [trackLabel setText:@"Track"];
    [trackLabel setTextColor:RGB(58, 68, 81)];
    [trackLabel setBackgroundColor:[UIColor clearColor]];
    [headerView addSubview:trackLabel];
    
    UIImageView *starImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"star"]];
    [starImageView setFrame:CGRectMake(162, 13, 20, 20)];
    [headerView addSubview:starImageView];
    
    UIImageView *trackingTextBoxBackgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"trackingTextBox"]];
    [trackingTextBoxBackgroundImageView setFrame:CGRectMake(15, 35, 166, 30)];
    [headerView addSubview:trackingTextBoxBackgroundImageView];
    
    trackingNumberTextField = [[SidebarTrackingNumberTextField alloc] initWithFrame:CGRectMake(22, 35, 130, 30)];
    [trackingNumberTextField setBackgroundColor:[UIColor clearColor]];
    [trackingNumberTextField setDelegate:self];
    [trackingNumberTextField setPlaceholder:@"Last tracking number entered"];
    [headerView addSubview:trackingNumberTextField];
    
    UIButton *findTrackingNumberButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [findTrackingNumberButton setImage:[UIImage imageNamed:@"tracking_button"] forState:UIControlStateNormal];
    [findTrackingNumberButton setFrame:CGRectMake(155, 39, 25, 25)];
    [findTrackingNumberButton addTarget:self action:@selector(findTrackingNumberButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:findTrackingNumberButton];
	
	return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 80.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return SIDEBARMENU_TOTAL;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *const cellIdentifier = @"SidebarMenuTableViewCell";

    SidebarMenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
		cell = [[SidebarMenuTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
	}
    
    [cell setSidebarMenu:(tSidebarMenus)indexPath.row];

    return cell;
}

@end
