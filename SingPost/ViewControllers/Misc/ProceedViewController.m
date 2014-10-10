//
//  ProceedViewController.m
//  SingPost
//
//  Created by Li Le on 18/9/14.
//  Copyright (c) 2014 Codigo. All rights reserved.
//

#import "ProceedViewController.h"
#import "NavigationBarView.h"
#import "UIFont+SingPost.h"
#import "Article.h"
#import <SVProgressHUD.h>
#import "FlatBlueButton.h"
#import "LandingPageViewController.h"
#import "UIView+Position.h"
#import "UIAlertView+Blocks.h"
#import "ApiClient.h"

@interface ProceedViewController () {
    UIButton * btn1;
    UIButton * sendBtn;
    __weak IBOutlet UIButton *doneBtn;
}

@end

@implementation ProceedViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UIView *contentView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [contentView setBackgroundColor:RGB(250, 250, 250)];
    
    NavigationBarView *navigationBarView = [[NavigationBarView alloc] initWithFrame:NAVIGATIONBAR_FRAME];
    [navigationBarView setTitle:@"Before we proceed..."];
    [navigationBarView setShowSidebarToggleButton:YES];
    [contentView addSubview:navigationBarView];
    
    btn1 = [[UIButton alloc] initWithFrame:CGRectMake(20, 70, contentView.bounds.size.width/16, contentView.bounds.size.width/16)];
    [btn1 setImage:[UIImage imageNamed:@"checkbox-0"] forState:UIControlStateNormal];
    [btn1 setImage:[UIImage imageNamed:@"checkbox-1"] forState:UIControlStateSelected];
    [btn1 addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:btn1];
    
    UILabel * pp = [[UILabel alloc] initWithFrame:CGRectMake(20+btn1.frame.size.width + 20, 65, contentView.bounds.size.width * 12 / 16, contentView.bounds.size.width * 2 / 16)];
    [pp setNumberOfLines:0];
    [pp setText:@"I acknowledge and accept the Privacy Policy SingPost Group"];
    [pp setTextColor:[UIColor blackColor]];
    [pp setFont:[UIFont SingPostLightFontOfSize:(14.0f * contentView.bounds.size.width /320) fontKey:kSingPostFontOpenSans]];
    [pp sizeToFit];
    [contentView addSubview:pp];
    
    UIButton * btn2 = [[UIButton alloc] initWithFrame:CGRectMake(20, pp.frame.origin.y + pp.frame.size.height + (20 * contentView.bounds.size.width /320) , contentView.bounds.size.width/16, contentView.bounds.size.width/16)];
    [btn2 setImage:[UIImage imageNamed:@"checkbox-0"] forState:UIControlStateNormal];
    [btn2 setImage:[UIImage imageNamed:@"checkbox-1"] forState:UIControlStateSelected];
    [btn2 addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:btn2];
    
    UILabel * pd = [[UILabel alloc] initWithFrame:CGRectMake(20+btn2.frame.size.width + 20, btn2.frame.origin.y - 5, contentView.bounds.size.width * 12 / 16, contentView.bounds.size.width * 5 / 16)];
    [pd setNumberOfLines:0];
    [pd setText:@"I consent to the use of my personal data by SingPost for the purposes of serving targeted advertisement banners to me through SingPost Mobile App"];
    [pd setTextColor:[UIColor blackColor]];
    [pd setFont:[UIFont SingPostLightFontOfSize:(14.0f * contentView.bounds.size.width /320) fontKey:kSingPostFontOpenSans]];
    [pd sizeToFit];
    [contentView addSubview:pd];
    
    sendBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, pd.frame.origin.y + pd.frame.size.height + (20 * contentView.bounds.size.width /320), contentView.bounds.size.width - 40, contentView.bounds.size.width * 2 /16)];
    [sendBtn setBackgroundImage:[UIImage imageNamed:@"blue_bg_pressed_button"] forState:UIControlStateNormal];
    [sendBtn addTarget:self action:@selector(sendClicked) forControlEvents:UIControlEventTouchUpInside];
    [sendBtn setTitle:@"DONE" forState:UIControlStateNormal];
    [sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [contentView addSubview:sendBtn];
    [sendBtn setEnabled:false];
    
    [doneBtn.titleLabel setFont:[UIFont SingPostRegularFontOfSize:16.0f fontKey:kSingPostFontOpenSans]];
    
    self.view = contentView;
    
}

- (IBAction)buttonClicked:(UIButton *)sender {
    sender.selected = !sender.selected;
    
    if(sender == btn1 && sender.isSelected == false) {
        [sendBtn setEnabled:false];
    } else if (sender == btn1 && sender.isSelected == true) {
        [sendBtn setEnabled:true];
    }
}

- (void)sendClicked {
    
    if (FBSession.activeSession.state == FBSessionStateOpen
        || FBSession.activeSession.state == FBSessionStateOpenTokenExtended) {
        
        // Close the session and remove the access token from the cache
        // The session state handler (in the app delegate) will be called automatically
        
        
        [FBSession.activeSession closeAndClearTokenInformation];
        [FBSession.activeSession close];
        //[FBSession setActiveSession:nil];
        
        [self fbDidLogout];
        
        [ApiClient sharedInstance].serverToken = @"";
        
        // If the session state is not any of the two "open" states when the button is clicked
    } else {
        // Open a session showing the user the login UI
        // You must ALWAYS ask for public_profile permissions when opening a session
        /*[FBSession openActiveSessionWithReadPermissions:@[@"public_profile",@"email",@"user_about_me",@"user_birthday",@"user_location"]
                                           allowLoginUI:YES
                                      completionHandler:
         ^(FBSession *session, FBSessionState state, NSError *error) {
         
             // Retrieve the app delegate
             AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
             
             appDelegate.isLoginFromSideBar = YES;
             // Call the app delegate's sessionStateChanged:state:error method to handle session state changes
             [appDelegate sessionStateChanged:session state:state error:error];
         }];*/
        
        [[AppDelegate sharedAppDelegate] LoginFacebook];
    }
    
    //[[AppDelegate sharedAppDelegate].rootViewController cPopViewController];
}



-(void) fbDidLogout
{
    NSLog(@"Logged out of facebook");
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies])
    {
        NSString* domainName = [cookie domain];
        NSRange domainRange = [domainName rangeOfString:@"facebook"];
        if(domainRange.length > 0)
        {
            [storage deleteCookie:cookie];
        }
    }
}//

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
