//
//  LandingPageViewController.m
//  SingPost
//
//  Created by Edward Soetiono on 24/9/13.
//  Copyright (c) 2013 Codigo. All rights reserved.
//

#import "LandingPageViewController.h"
#import "AppDelegate.h"
#import "UIFont+SingPost.h"
#import "UIView+Position.h"
#import "CTextField.h"
#import "OffersMoreMenuView.h"
#import "RegexKitLite.h"
#import "TrackingMainViewController.h"
#import "TrackingDetailsViewController.h"
#import "CalculatePostageMainViewController.h"
#import "FindPostalCodesMainViewController.h"
#import "LocateUsMainViewController.h"
#import "SendReceiveMainViewController.h"
#import "PaymentMainViewController.h"
#import "ShopMainViewController.h"
#import "MoreServicesMainViewController.h"
#import "FeedbackViewController.h"
#import "TermsOfUseViewController.h"
#import "StampCollectiblesMainViewController.h"
#import "AboutThisAppViewController.h"
#import "OffersMainViewController.h"
#import "MoreAppsViewController.h"
#import "FAQViewController.h"
#import "MaintanancePageViewController.h"
#import "ApiClient.h"
#import "NSDictionary+Additions.h"
#import "AnnouncementViewController.h"
#import "ShopViewController.h"
#import "BarScannerViewController.h"
#import "ScanTutorialViewController.h"
#import "UserDefaultsManager.h"

#import "TrackedItem.h"
#import <SVProgressHUD.h>

typedef enum {
    LANDINGPAGEBUTTON_START = 100,
    
    LANDINGPAGEBUTTON_CALCULATEPOSTAGE,
    LANDINGPAGEBUTTON_POSTALCODES,
    LANDINGPAGEBUTTON_LOCATEUS,
    LANDINGPAGEBUTTON_SENDRECEIVE,
    LANDINGPAGEBUTTON_PAY,
    LANDINGPAGEBUTTON_SHOP,
    LANDINGPAGEBUTTON_MORESERVICES,
    LANDINGPAGEBUTTON_STAMPCOLLECTIBLES,
    LANDINGPAGEBUTTON_MOREAPPS,
    LANDINGPAGEBUTTON_TRACKING_LIST,
    LANDINGPAGEBUTTON_TRACKING_FIND,
    
    LANDINGPAGEBUTTON_END
} tLandingPageButtons;

@interface LandingPageButton : UIButton

@property (nonatomic, assign) BOOL shouldDim;

@end

@implementation LandingPageButton
- (void)setShouldDim:(BOOL)inShouldDim {
    _shouldDim = inShouldDim;
    [self setAlpha:_shouldDim ? 0.5f : 1.0f];
}
@end

@interface LandingPageViewController ()
<
UITextFieldDelegate,
OffersMenuDelegate
>
@end

@implementation LandingPageViewController {
    CTextField *trackingNumberTextField;
    OffersMoreMenuView *offersMoreMenuView;
    
    UILabel * newLabel;
    UIImageView * badge;
    UIButton *announcementBtn;
}

#pragma mark - View lifecycle

- (void)setBadgeView:(BOOL)hasNew{
    if(hasNew) {
        [newLabel setHidden:NO];
        [badge setHidden:NO];
        [announcementBtn setImage:[UIImage imageNamed:@"NewAnnouncement"] forState:UIControlStateNormal];
    } else {
        [newLabel setHidden:YES];
        [badge setHidden:YES];
        [announcementBtn setImage:[UIImage imageNamed:@"Announcement"] forState:UIControlStateNormal];
    }
    
}

-(NSString *)getUTCFormateDate:(NSDate *)localDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [dateFormatter setTimeZone:timeZone];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:localDate];
    return dateString;
}

- (void)loadView {
    UIView *contentView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [contentView setBackgroundColor:[UIColor whiteColor]];
    
    UIImageView *envelopBackgroundImageView = [[UIImageView alloc] init];
    if (INTERFACE_IS_IPAD) {
        envelopBackgroundImageView.frame = CGRectMake(0, 0, 768, 552);
        envelopBackgroundImageView.image = [UIImage imageNamed:@"EnvelopeBackground"];
    }
    else {
        envelopBackgroundImageView.frame = (INTERFACE_IS_4INCHSCREEN ? CGRectMake(0, 0, 320, 276) : CGRectMake(0, 0, 320, 248));
        envelopBackgroundImageView.image = (INTERFACE_IS_4INCHSCREEN ? [UIImage imageNamed:@"EnvelopeBackground568"] : [UIImage imageNamed:@"EnvelopeBackground"]);
    }
    envelopBackgroundImageView.userInteractionEnabled = YES;
    [contentView addSubview:envelopBackgroundImageView];
    
    announcementBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [announcementBtn setImage:[UIImage imageNamed:@"Announcement"] forState:UIControlStateNormal];
    [announcementBtn addTarget:self action:@selector(onAnnouncementBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    
    if (INTERFACE_IS_IPAD)
        announcementBtn.frame = CGRectMake(contentView.right - 103, 15, 88, 88);
    else
        announcementBtn.frame = CGRectMake(contentView.right - 44, 0, 44, 44);
    [contentView addSubview:announcementBtn];
    
    //Badge start
    badge = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_badge"]];
    if (INTERFACE_IS_IPAD)
        badge.frame = CGRectMake(contentView.right - 60, 18,50, 26);
    else
        badge.frame = CGRectMake(contentView.right - 27, 2,24, 13);
    
    [badge setHidden:YES];
    
    if (INTERFACE_IS_IPAD) {
        newLabel = [[UILabel alloc] initWithFrame:CGRectMake(contentView.right - 52, 18,44, 25)];
        [newLabel setFont:[UIFont SingPostRegularFontOfSize:15.0f fontKey:kSingPostFontOpenSans]];
    }
    else {
        newLabel = [[UILabel alloc] initWithFrame:CGRectMake(contentView.right - 25, 4,22, 11)];
        [newLabel setFont:[UIFont SingPostRegularFontOfSize:9.0f fontKey:kSingPostFontOpenSans]];
    }
    [newLabel setNumberOfLines:1];
    [newLabel setTextColor:RGB(255, 255, 255)];
    [newLabel setText:@"NEW"];
    
    
    [newLabel setHidden:YES];
    
    [contentView addSubview:badge];
    [contentView addSubview:newLabel];
    
    [self setBadgeView:[AppDelegate sharedAppDelegate].isPrevAnnouncementNew];
    
    [[ApiClient sharedInstance]getSingpostAnnouncementSuccess:^(id responseObject)
     {
         NSArray * arr = nil;
         NSObject * obj = [responseObject objectForKeyOrNil:@"root"];
         if([obj isKindOfClass:[NSArray class]]) {
             arr = (NSArray *)obj;
         } else {
             NSString * rand = [[responseObject objectForKeyOrNil:@"root"] objectForKeyOrNil:@"rand"];
             
             if(rand == nil) {
                 return;
             }
             
             NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
             NSString * lastRand = [defaults stringForKey:@"LAST_RAND"];
             
             if(lastRand == nil) {
                 NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                 [defaults setObject:rand forKey:@"LAST_RAND"];
                 [defaults synchronize];
                 return;
             }
             
             if([lastRand isEqualToString:rand]) {
                 [self setBadgeView:NO];
                 [AppDelegate sharedAppDelegate].isPrevAnnouncementNew = NO;
             } else {
                 [self setBadgeView:YES];
                 [AppDelegate sharedAppDelegate].isPrevAnnouncementNew = YES;
             }
             
             /*arr = [[responseObject objectForKeyOrNil:@"root"] objectForKey:@"announcements"];
              
              NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
              NSString * dateStr = [defaults stringForKey:@"ANNOUNCEMENT_LAST_DATE"];
              if(dateStr == nil) {
              [self setBadgeView:NO];
              [AppDelegate sharedAppDelegate].isPrevAnnouncementNew = NO;
              NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
              [defaults setObject:[self getUTCFormateDate:[NSDate date]] forKey:@"ANNOUNCEMENT_LAST_DATE"];
              [defaults synchronize];
              }
              else {
              NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
              [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
              
              NSDate * localDate = [formatter dateFromString:dateStr];
              NSDate * remoteDate = [formatter dateFromString:[[responseObject objectForKeyOrNil:@"root"] objectForKey:@"last_modified"]];
              
              if ([localDate compare:remoteDate] == NSOrderedDescending) {
              [self setBadgeView:NO];
              [AppDelegate sharedAppDelegate].isPrevAnnouncementNew = NO;
              } else {
              [self setBadgeView:YES];
              [AppDelegate sharedAppDelegate].isPrevAnnouncementNew = YES;
              }
              }*/
         }
         
         
     } failure:^(NSError *error)
     {}];
    
    //Badge end
    
    int whySoManyDifferentBuilds = 0;
    if(![ApiClient isScanner]) {
        whySoManyDifferentBuilds = 53;
    }
    
    if (INTERFACE_IS_IPAD) {
        trackingNumberTextField = [[CTextField alloc] initWithFrame:CGRectMake(50, 240, 668 - 57 + whySoManyDifferentBuilds, 50)];
        trackingNumberTextField.fontSize = 15.0f;
        trackingNumberTextField.placeholderFontSize = 16.0f;
        trackingNumberTextField.insetBoundsSize = CGSizeMake(50, 7);
    }
    else {
        trackingNumberTextField = [[CTextField alloc] initWithFrame:INTERFACE_IS_4INCHSCREEN ? CGRectMake(20, 80, contentView.width - 40 - 53 +whySoManyDifferentBuilds , 47) : CGRectMake(20, 70, contentView.width - 40 - 53 + whySoManyDifferentBuilds, 30)];
        trackingNumberTextField.fontSize = INTERFACE_IS_4INCHSCREEN ? 14.0f : 14.0f;
        trackingNumberTextField.placeholderFontSize = INTERFACE_IS_4INCHSCREEN ? 12.0f : 12.0f;
        trackingNumberTextField.insetBoundsSize = SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0") ? (INTERFACE_IS_4INCHSCREEN ? CGSizeMake(50, 8) : CGSizeMake(40, 3)) : (INTERFACE_IS_4INCHSCREEN ? CGSizeMake(50, 6) : CGSizeMake(40, 5));
    }
    trackingNumberTextField.background = [UIImage imageNamed:@"trackingTextBox"];
    trackingNumberTextField.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
    trackingNumberTextField.placeholder = @"Enter tracking number";
    trackingNumberTextField.returnKeyType = UIReturnKeySend;
    trackingNumberTextField.delegate = self;
    [contentView addSubview:trackingNumberTextField];
    
    CGFloat findTrackingBtnX;
    
    
    //Add Scan Button
    
    if([ApiClient isScanner]) {
        UIButton * scanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        if (INTERFACE_IS_IPAD) {
            findTrackingBtnX = contentView.width - 90;
            scanBtn.frame = CGRectMake(findTrackingBtnX, 240, 50, 50);
        }
        else {
            findTrackingBtnX = contentView.width - 65;
            scanBtn.frame = INTERFACE_IS_4INCHSCREEN ? CGRectMake(findTrackingBtnX, 80, 47, 47) : CGRectMake(findTrackingBtnX, 70, 30, 30);
        }
        [scanBtn setImage:[UIImage imageNamed:@"scanBtn"] forState:UIControlStateNormal];
        [scanBtn addTarget:self action:@selector(OnGoToScan) forControlEvents:UIControlEventTouchUpInside];
        [contentView addSubview:scanBtn];
    }
    
    LandingPageButton *trackingListButton = [LandingPageButton buttonWithType:UIButtonTypeCustom];
    [trackingListButton setImage:[UIImage imageNamed:@"tracking_list_icon"] forState:UIControlStateNormal];
    [trackingListButton addTarget:self action:@selector(trackingListButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    if (INTERFACE_IS_IPAD)
        trackingListButton.frame = CGRectMake(58, 240, 40, 48);
    else
        trackingListButton.frame = INTERFACE_IS_4INCHSCREEN ? CGRectMake(28, 80, 40, 48) : CGRectMake(28, 70, 26, 31);
    trackingListButton.tag = LANDINGPAGEBUTTON_TRACKING_LIST;
    [contentView addSubview:trackingListButton];
    
    LandingPageButton *findTrackingNumberButton = [LandingPageButton buttonWithType:UIButtonTypeCustom];
    //CGFloat findTrackingBtnX;
    if (INTERFACE_IS_IPAD) {
        findTrackingBtnX = trackingNumberTextField.right - 40;
        findTrackingNumberButton.frame = CGRectMake(findTrackingBtnX, trackingNumberTextField.center.y - 35/2, 35, 35);
    }
    else {
        findTrackingBtnX = trackingNumberTextField.width - 15;
        findTrackingNumberButton.frame = INTERFACE_IS_4INCHSCREEN ? CGRectMake(findTrackingBtnX, 87, 35, 35) : CGRectMake(findTrackingBtnX, 71, 29, 29);
    }
    [findTrackingNumberButton setImage:[UIImage imageNamed:@"tracking_button"] forState:UIControlStateNormal];
    [findTrackingNumberButton addTarget:self action:@selector(findTrackingNumberButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    findTrackingNumberButton.tag = LANDINGPAGEBUTTON_TRACKING_FIND;
    [contentView addSubview:findTrackingNumberButton];
    
    UIImageView *singPostLogoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo_singaporepost"]];
    if (INTERFACE_IS_IPAD)
        singPostLogoImageView.frame = CGRectMake((contentView.width - 272)/2, 80, 272, 92);
    else
        singPostLogoImageView.frame = CGRectMake((contentView.width - 155)/2, 8, 155, 55);
    [contentView addSubview:singPostLogoImageView];
    
    UIButton *toggleSidebarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    if (INTERFACE_IS_IPAD)
        toggleSidebarButton.frame = CGRectMake(15, 15, 88, 88);
    else
        toggleSidebarButton.frame = CGRectMake(0, 0, 44, 44);
    [toggleSidebarButton setImage:[UIImage imageNamed:@"sidebar_button"] forState:UIControlStateNormal];
    [toggleSidebarButton addTarget:self action:@selector(toggleSidebarButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:toggleSidebarButton];
    
    //landing page buttons
    NSInteger ICON_WIDTH;
    NSInteger ICON_HEIGHT;
    NSInteger ICON_SPACING_VERTICAL;
    NSInteger STARTING_OFFSET_X;
    NSInteger STARTING_OFFSET_Y;
    
    if (INTERFACE_IS_IPAD) {
        ICON_WIDTH = 150;
        ICON_HEIGHT = 150;
        ICON_SPACING_VERTICAL = 20;
        STARTING_OFFSET_X = 159;
        STARTING_OFFSET_Y = 480;
    }
    else {
        ICON_WIDTH = (INTERFACE_IS_4INCHSCREEN ? 90 : 80);
        ICON_HEIGHT = (INTERFACE_IS_4INCHSCREEN ? 90 : 80);
        ICON_SPACING_VERTICAL = (INTERFACE_IS_4INCHSCREEN ? 10 : 5);
        STARTING_OFFSET_X = (INTERFACE_IS_4INCHSCREEN ? 30 : 40);
        STARTING_OFFSET_Y = (INTERFACE_IS_4INCHSCREEN ? 230 : 185);
    }
    CGFloat offsetX, offsetY;
    
    offsetY = STARTING_OFFSET_Y;
    offsetX = STARTING_OFFSET_X;
    LandingPageButton *menuCalculatePostageButton = [LandingPageButton buttonWithType:UIButtonTypeCustom];
    [menuCalculatePostageButton setFrame:CGRectMake(offsetX, offsetY, ICON_WIDTH, ICON_HEIGHT)];
    [menuCalculatePostageButton setImage:[UIImage imageNamed:@"landing_calculatePostage"] forState:UIControlStateNormal];
    [menuCalculatePostageButton setTag:LANDINGPAGEBUTTON_CALCULATEPOSTAGE];
    [menuCalculatePostageButton addTarget:self action:@selector(menuButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:menuCalculatePostageButton];
    
    offsetX += ICON_WIDTH;
    LandingPageButton *menuPostalCodesButton = [LandingPageButton buttonWithType:UIButtonTypeCustom];
    [menuPostalCodesButton setFrame:CGRectMake(offsetX, offsetY, ICON_WIDTH, ICON_HEIGHT)];
    [menuPostalCodesButton setImage:[UIImage imageNamed:@"landing_postalCodes"] forState:UIControlStateNormal];
    [menuPostalCodesButton setTag:LANDINGPAGEBUTTON_POSTALCODES];
    [menuPostalCodesButton addTarget:self action:@selector(menuButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:menuPostalCodesButton];
    
    offsetX += ICON_WIDTH;
    LandingPageButton *menuPageLocateUsButton = [LandingPageButton buttonWithType:UIButtonTypeCustom];
    [menuPageLocateUsButton setFrame:CGRectMake(offsetX, offsetY, ICON_WIDTH, ICON_HEIGHT)];
    [menuPageLocateUsButton setImage:[UIImage imageNamed:@"landing_locateUs"] forState:UIControlStateNormal];
    [menuPageLocateUsButton setTag:LANDINGPAGEBUTTON_LOCATEUS];
    [menuPageLocateUsButton addTarget:self action:@selector(menuButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:menuPageLocateUsButton];
    
    offsetX = STARTING_OFFSET_X;
    offsetY += ICON_HEIGHT + ICON_SPACING_VERTICAL;
    LandingPageButton *menuSendReceiveButton = [LandingPageButton buttonWithType:UIButtonTypeCustom];
    [menuSendReceiveButton setFrame:CGRectMake(offsetX, offsetY, ICON_WIDTH, ICON_HEIGHT)];
    [menuSendReceiveButton setTag:LANDINGPAGEBUTTON_SENDRECEIVE];
    [menuSendReceiveButton setImage:[UIImage imageNamed:@"landing_sendReceive"] forState:UIControlStateNormal];
    [menuSendReceiveButton addTarget:self action:@selector(menuButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:menuSendReceiveButton];
    
    offsetX += ICON_WIDTH;
    LandingPageButton *menuPayButton = [LandingPageButton buttonWithType:UIButtonTypeCustom];
    [menuPayButton setFrame:CGRectMake(offsetX, offsetY, ICON_WIDTH, ICON_HEIGHT)];
    [menuPayButton setTag:LANDINGPAGEBUTTON_PAY];
    [menuPayButton setImage:[UIImage imageNamed:@"landing_pay"] forState:UIControlStateNormal];
    [menuPayButton addTarget:self action:@selector(menuButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:menuPayButton];
    
    offsetX += ICON_WIDTH;
    LandingPageButton *menuShopButton = [LandingPageButton buttonWithType:UIButtonTypeCustom];
    [menuShopButton setFrame:CGRectMake(offsetX, offsetY, ICON_WIDTH, ICON_HEIGHT)];
    [menuShopButton setTag:LANDINGPAGEBUTTON_SHOP];
    [menuShopButton setImage:[UIImage imageNamed:@"landing_shop"] forState:UIControlStateNormal];
    [menuShopButton addTarget:self action:@selector(menuButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:menuShopButton];
    
    offsetX = STARTING_OFFSET_X;
    offsetY += ICON_HEIGHT + ICON_SPACING_VERTICAL;
    LandingPageButton *menuMoreServicesButton = [LandingPageButton buttonWithType:UIButtonTypeCustom];
    [menuMoreServicesButton setFrame:CGRectMake(offsetX, offsetY, ICON_WIDTH, ICON_HEIGHT)];
    [menuMoreServicesButton setTag:LANDINGPAGEBUTTON_MORESERVICES];
    [menuMoreServicesButton setImage:[UIImage imageNamed:@"landing_moreServices"] forState:UIControlStateNormal];
    [menuMoreServicesButton addTarget:self action:@selector(menuButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:menuMoreServicesButton];
    
    offsetX += ICON_WIDTH;
    LandingPageButton *menuStampCollectiblesButton = [LandingPageButton buttonWithType:UIButtonTypeCustom];
    [menuStampCollectiblesButton setFrame:CGRectMake(offsetX, offsetY, ICON_WIDTH, ICON_HEIGHT)];
    [menuStampCollectiblesButton setTag:LANDINGPAGEBUTTON_STAMPCOLLECTIBLES];
    [menuStampCollectiblesButton addTarget:self action:@selector(menuButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [menuStampCollectiblesButton setImage:[UIImage imageNamed:@"landing_stampCollectibles"] forState:UIControlStateNormal];
    [contentView addSubview:menuStampCollectiblesButton];
    
    offsetX += ICON_WIDTH;
    LandingPageButton *menuMoreAppsButton = [LandingPageButton buttonWithType:UIButtonTypeCustom];
    [menuMoreAppsButton setFrame:CGRectMake(offsetX, offsetY, ICON_WIDTH, ICON_HEIGHT)];
    [menuMoreAppsButton setImage:[UIImage imageNamed:@"landing_moreApps"] forState:UIControlStateNormal];
    [menuMoreAppsButton setTag:LANDINGPAGEBUTTON_MOREAPPS];
    [menuMoreAppsButton addTarget:self action:@selector(menuButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:menuMoreAppsButton];
    
    offersMoreMenuView = [[OffersMoreMenuView alloc] initWithFrame:CGRectMake(0, contentView.bounds.size.height - 52, contentView.bounds.size.width, 500)];
    [offersMoreMenuView setDelegate:self];
    [contentView addSubview:offersMoreMenuView];
    
    self.view = contentView;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[AppDelegate sharedAppDelegate]updateMaintananceStatuses];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[AppDelegate sharedAppDelegate] trackGoogleAnalyticsWithScreenName:@"Home"];
    
    //[self OnGoToScan];
    
    bool b = [[NSUserDefaults standardUserDefaults] boolForKey:@"12121"];
    if(b == false)
        [self performSelector:@selector(showTutorial) withObject:nil afterDelay:1.0f];
}

- (void) showTutorial {
    if(![ApiClient isScanner]) {
        return;
    }
    vc = [[ScanTutorialViewController alloc] initWithNibName:@"ScanTutorialViewController" bundle:nil];
    [self.view addSubview:vc.view];
    [vc.nextBtn addTarget:self action:@selector(onNextClicked:) forControlEvents:UIControlEventTouchUpInside];
    [vc.PrevBtn addTarget:self action:@selector(onPrevClicked:) forControlEvents:UIControlEventTouchUpInside];
    [vc.closeBtn addTarget:self action:@selector(onCloseClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    
}

- (IBAction)onCloseClicked:(id)sender {
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"12121"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    [vc.view removeFromSuperview];
}

- (IBAction)onNextClicked:(id)sender {
    [vc.nextBtn setHidden:YES];
    [vc.PrevBtn setHidden:NO];
    
    [vc.imageView setAlpha:0.5f];
    [UIView animateWithDuration:0.1
                     animations:^{
                         vc.imageView.alpha = 0.5f;
                     } completion:^(BOOL finished) {
                         [vc.imageView setImage:[UIImage imageNamed:@"tutorial02.png"]];
                         
                         [UIView animateWithDuration:0.5
                                          animations:^{
                                              vc.imageView.alpha = 1.0f;
                                          } completion:^(BOOL finished) {
                                              
                                          }];
                     }];
    
    
}


- (IBAction)onPrevClicked:(id)sender {
    [vc.nextBtn setHidden:NO];
    [vc.PrevBtn setHidden:YES];
    
    
    [vc.imageView setAlpha:0.5f];
    [UIView animateWithDuration:0.1
                     animations:^{
                         vc.imageView.alpha = 0.5f;
                     } completion:^(BOOL finished) {
                         [vc.imageView setImage:[UIImage imageNamed:@"tutorial01.png"]];
                         
                         [UIView animateWithDuration:0.5
                                          animations:^{
                                              vc.imageView.alpha = 1.0f;
                                          } completion:^(BOOL finished) {
                                              
                                          }];
                     }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [trackingNumberTextField setText:[[UserDefaultsManager sharedInstance] getLastTrackingNumber]];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [trackingNumberTextField resignFirstResponder];
}

- (void)updateMaintananceStatusUIs
{
    NSDictionary *maintananceStatuses = [[AppDelegate sharedAppDelegate] maintenanceStatuses];
    for (tLandingPageButtons tag = LANDINGPAGEBUTTON_START + 1; tag < LANDINGPAGEBUTTON_END; tag++) {
        LandingPageButton *button = (LandingPageButton *)[self.view viewWithTag:tag];
        switch (tag) {
            case LANDINGPAGEBUTTON_CALCULATEPOSTAGE:
            {
                [button setShouldDim:[maintananceStatuses[@"CalculatePostage"] isEqualToString:@"on"]];
                break;
            }
            case LANDINGPAGEBUTTON_POSTALCODES:
            {
                [button setShouldDim:[maintananceStatuses[@"FindPostalCodes"] isEqualToString:@"on"]];
                break;
            }
            case LANDINGPAGEBUTTON_LOCATEUS:
            {
                [button setShouldDim:[maintananceStatuses[@"LocateUs"] isEqualToString:@"on"]];
                break;
            }
            case LANDINGPAGEBUTTON_SENDRECEIVE:
            {
                [button setShouldDim:[maintananceStatuses[@"SendNReceive"] isEqualToString:@"on"]];
                break;
            }
            case LANDINGPAGEBUTTON_PAY:
            {
                [button setShouldDim:[maintananceStatuses[@"Pay"] isEqualToString:@"on"]];
                break;
            }
            case LANDINGPAGEBUTTON_SHOP:
            {
                [button setShouldDim:[maintananceStatuses[@"Shop"] isEqualToString:@"on"]];
                break;
            }
            case LANDINGPAGEBUTTON_MORESERVICES:
            {
                [button setShouldDim:[maintananceStatuses[@"MoreServices"] isEqualToString:@"on"]];
                break;
            }
            case LANDINGPAGEBUTTON_STAMPCOLLECTIBLES:
            {
                [button setShouldDim:[maintananceStatuses[@"StampCollectibles"] isEqualToString:@"on"]];
                break;
            }
            case LANDINGPAGEBUTTON_MOREAPPS:
            {
                [button setShouldDim:[maintananceStatuses[@"MoreApps"] isEqualToString:@"on"]];
                break;
            }
            case LANDINGPAGEBUTTON_TRACKING_LIST: {
                [button setShouldDim:[maintananceStatuses[@"TrackFeature"] isEqualToString:@"on"]];
            }
            case LANDINGPAGEBUTTON_TRACKING_FIND: {
                [button setShouldDim:[maintananceStatuses[@"TrackFeature"] isEqualToString:@"on"]];
            }
            default:
                NSLog(@"not yet implemented %@",button);
                break;
        }
    }
    if ([maintananceStatuses[@"TrackFeature"] isEqualToString:@"on"])
        trackingNumberTextField.alpha = 0.5;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField == trackingNumberTextField) {
        NSDictionary *maintananceStatuses = [[AppDelegate sharedAppDelegate] maintenanceStatuses];
        if ([maintananceStatuses[@"TrackFeature"] isEqualToString:@"on"]) {
            MaintanancePageViewController *viewController = [[MaintanancePageViewController alloc] initWithModuleName:@"Tracking"
                                                                                                           andMessage:maintananceStatuses[@"Comment"]];
            [self presentViewController:viewController animated:YES completion:nil];
            return NO;
        }
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == trackingNumberTextField)
        [self findTrackingNumberButtonClicked];
    return YES;
}

#pragma mark - OffersMenuDelegate

- (void)toggleShowOffersMoreMenu
{
    offersMoreMenuView.isShown = !offersMoreMenuView.isShown;
    
    if (offersMoreMenuView.isShown) {
#define TAG_CLOSEOFFERSMENUBUTTON 333
        UIButton *closeOffersMenuButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [closeOffersMenuButton setTag:TAG_CLOSEOFFERSMENUBUTTON];
        [closeOffersMenuButton setBackgroundColor:[UIColor colorWithWhite:0.3f alpha:0.5f]];
        [closeOffersMenuButton setFrame:self.view.bounds];
        [closeOffersMenuButton setAlpha:0.0f];
        [closeOffersMenuButton addTarget:self action:@selector(toggleShowOffersMoreMenu) forControlEvents:UIControlEventTouchUpInside];
        [self.view insertSubview:closeOffersMenuButton belowSubview:offersMoreMenuView];
    }
    
    [UIView animateWithDuration:0.3f animations:^{
        if (offersMoreMenuView.isShown) {
            [offersMoreMenuView setY:self.view.bounds.size.height - 236];
            [[self.view viewWithTag:TAG_CLOSEOFFERSMENUBUTTON] setAlpha:1.0f];
        }
        else {
            [offersMoreMenuView setY:self.view.bounds.size.height - 52];
            [[self.view viewWithTag:TAG_CLOSEOFFERSMENUBUTTON] removeFromSuperview];
        }
        
    }];
}

#pragma mark - IBActions

- (IBAction)menuButtonClicked:(UIButton *)sender
{
    NSDictionary *maintananceStatuses = [[AppDelegate sharedAppDelegate] maintenanceStatuses];
    tLandingPageButtons landingPageButton = (tLandingPageButtons)((UIButton *)sender).tag;
    
    switch (landingPageButton) {
        case LANDINGPAGEBUTTON_CALCULATEPOSTAGE:
        {
            if ([maintananceStatuses[@"CalculatePostage"] isEqualToString:@"on"]) {
                MaintanancePageViewController *viewController = [[MaintanancePageViewController alloc] initWithModuleName:@"Calculate Postage" andMessage:maintananceStatuses[@"Comment"]];
                [self presentViewController:viewController animated:YES completion:nil];
            }
            else {
                CalculatePostageMainViewController *viewController = [[CalculatePostageMainViewController alloc] initWithNibName:nil bundle:nil];
                [[AppDelegate sharedAppDelegate].rootViewController cPushViewController:viewController];
            }
            break;
        }
        case LANDINGPAGEBUTTON_POSTALCODES:
        {
            if ([maintananceStatuses[@"FindPostalCodes"] isEqualToString:@"on"]) {
                MaintanancePageViewController *viewController = [[MaintanancePageViewController alloc] initWithModuleName:@"Find Postal Codes" andMessage:maintananceStatuses[@"Comment"]];
                [self presentViewController:viewController animated:YES completion:nil];
            }
            else {
                FindPostalCodesMainViewController *viewController = [[FindPostalCodesMainViewController alloc] initWithNibName:nil bundle:nil];
                [[AppDelegate sharedAppDelegate].rootViewController cPushViewController:viewController];
            }
            break;
        }
        case LANDINGPAGEBUTTON_LOCATEUS:
        {
            if ([maintananceStatuses[@"LocateUs"] isEqualToString:@"on"]) {
                MaintanancePageViewController *viewController = [[MaintanancePageViewController alloc] initWithModuleName:@"Locate Us" andMessage:maintananceStatuses[@"Comment"]];
                [self presentViewController:viewController animated:YES completion:nil];
            }
            else {
                LocateUsMainViewController *viewController = [[LocateUsMainViewController alloc] initWithNibName:nil bundle:nil];
                [[AppDelegate sharedAppDelegate].rootViewController cPushViewController:viewController];
            }
            break;
        }
        case LANDINGPAGEBUTTON_SENDRECEIVE:
        {
            if ([maintananceStatuses[@"SendNReceive"] isEqualToString:@"on"]) {
                MaintanancePageViewController *viewController = [[MaintanancePageViewController alloc] initWithModuleName:@"Send & Receive" andMessage:maintananceStatuses[@"Comment"]];
                [self presentViewController:viewController animated:YES completion:nil];
            }
            else {
                SendReceiveMainViewController *viewController = [[SendReceiveMainViewController alloc] initWithNibName:nil bundle:nil];
                [[AppDelegate sharedAppDelegate].rootViewController cPushViewController:viewController];
            }
            break;
        }
        case LANDINGPAGEBUTTON_PAY:
        {
            if ([maintananceStatuses[@"Pay"] isEqualToString:@"on"]) {
                MaintanancePageViewController *viewController = [[MaintanancePageViewController alloc] initWithModuleName:@"Pay" andMessage:maintananceStatuses[@"Comment"]];
                [self presentViewController:viewController animated:YES completion:nil];
            }
            else {
                PaymentMainViewController *viewController = [[PaymentMainViewController alloc] initWithNibName:nil bundle:nil];
                [[AppDelegate sharedAppDelegate].rootViewController cPushViewController:viewController];
            }
            break;
        }
        case LANDINGPAGEBUTTON_SHOP:
        {
            if ([maintananceStatuses[@"Shop"] isEqualToString:@"on"]) {
                MaintanancePageViewController *viewController = [[MaintanancePageViewController alloc] initWithModuleName:@"Shop" andMessage:maintananceStatuses[@"Comment"]];
                [self presentViewController:viewController animated:YES completion:nil];
            }
            else {
                ShopViewController *viewController = [[ShopViewController alloc] initWithNibName:nil bundle:nil];
                [[AppDelegate sharedAppDelegate].rootViewController cPushViewController:viewController];
            }
            break;
        }
        case LANDINGPAGEBUTTON_MORESERVICES:
        {
            if ([maintananceStatuses[@"MoreServices"] isEqualToString:@"on"]) {
                MaintanancePageViewController *viewController = [[MaintanancePageViewController alloc] initWithModuleName:@"More Services" andMessage:maintananceStatuses[@"Comment"]];
                [self presentViewController:viewController animated:YES completion:nil];
            }
            else {
                MoreServicesMainViewController *viewController = [[MoreServicesMainViewController alloc] initWithNibName:nil bundle:nil];
                [[AppDelegate sharedAppDelegate].rootViewController cPushViewController:viewController];
            }
            break;
        }
        case LANDINGPAGEBUTTON_STAMPCOLLECTIBLES:
        {
            if ([maintananceStatuses[@"StampCollectibles"] isEqualToString:@"on"]) {
                MaintanancePageViewController *viewController = [[MaintanancePageViewController alloc] initWithModuleName:@"Stamp Collectibles" andMessage:maintananceStatuses[@"Comment"]];
                [self presentViewController:viewController animated:YES completion:nil];
            }
            else {
                StampCollectiblesMainViewController *viewController = [[StampCollectiblesMainViewController alloc] initWithNibName:nil bundle:nil];
                [[AppDelegate sharedAppDelegate].rootViewController cPushViewController:viewController];
            }
            break;
        }
        case LANDINGPAGEBUTTON_MOREAPPS:
        {
            if ([maintananceStatuses[@"MoreApps"] isEqualToString:@"on"]) {
                MaintanancePageViewController *viewController = [[MaintanancePageViewController alloc] initWithModuleName:@"More Apps" andMessage:maintananceStatuses[@"Comment"]];
                [self presentViewController:viewController animated:YES completion:nil];
            }
            else {
                MoreAppsViewController *viewController = [[MoreAppsViewController alloc] initWithNibName:nil bundle:nil];
                [[AppDelegate sharedAppDelegate].rootViewController cPushViewController:viewController];
            }
            break;
        }
        default:
            NSLog(@"not yet implemented");
            break;
    }
}

- (void)offersMenuButtonClicked:(tOffersMenuButtons)button
{
    [self toggleShowOffersMoreMenu];
    switch (button) {
        case OFFERSMENUBUTTON_OFFERS:
        {
            OffersMainViewController *viewController = [[OffersMainViewController alloc] initWithNibName:nil bundle:nil];
            [[AppDelegate sharedAppDelegate].rootViewController cPushViewController:viewController];
            break;
        }
        case OFFERSMENUBUTTON_FEEDBACK:
        {
            FeedbackViewController *viewController = [[FeedbackViewController alloc] initWithNibName:nil bundle:nil];
            [[AppDelegate sharedAppDelegate].rootViewController cPushViewController:viewController];
            break;
        }
        case OFFERSMENUBUTTON_TERMSOFUSE:
        {
            TermsOfUseViewController *viewController = [[TermsOfUseViewController alloc] initWithNibName:nil bundle:nil];
            viewController.isFirstLaunch = NO;
            [[AppDelegate sharedAppDelegate].rootViewController cPushViewController:viewController];
            break;
        }
        case OFFERSMENUBUTTON_ABOUTTHISAPP:
        {
            AboutThisAppViewController *viewController = [[AboutThisAppViewController alloc] initWithNibName:nil bundle:nil];
            [[AppDelegate sharedAppDelegate].rootViewController cPushViewController:viewController];
            break;
        }
        case OFFERSMENUBUTTON_FAQS:
        {
            FAQViewController *viewController = [[FAQViewController alloc] initWithNibName:nil bundle:nil];
            [[AppDelegate sharedAppDelegate].rootViewController cPushViewController:viewController];
            break;
        }
        case OFFERSMENUBUTTON_RATEOURAPP:
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:SINGPOST_ITUNES_STORE_URL]];
            break;
        }
        default:
            NSLog(@"not implemented yet");
            break;
    }
}

- (IBAction)trackingListButtonClicked:(id)sender
{
    NSDictionary *maintananceStatuses = [[AppDelegate sharedAppDelegate] maintenanceStatuses];
    if ([maintananceStatuses[@"TrackFeature"] isEqualToString:@"on"]) {
        MaintanancePageViewController *viewController = [[MaintanancePageViewController alloc] initWithModuleName:@"Tracking"
                                                                                                       andMessage:maintananceStatuses[@"Comment"]];
        [self presentViewController:viewController animated:YES completion:nil];
        return;
    }
    
    TrackingMainViewController *trackingMainViewController = [[TrackingMainViewController alloc] initWithNibName:nil bundle:nil];
    [[AppDelegate sharedAppDelegate].rootViewController cPushViewController:trackingMainViewController];
}

- (void)findTrackingNumberButtonClicked
{
    NSDictionary *maintananceStatuses = [[AppDelegate sharedAppDelegate] maintenanceStatuses];
    if ([maintananceStatuses[@"TrackFeature"] isEqualToString:@"on"]) {
        MaintanancePageViewController *viewController = [[MaintanancePageViewController alloc] initWithModuleName:@"Tracking"
                                                                                                       andMessage:maintananceStatuses[@"Comment"]];
        [self presentViewController:viewController animated:YES completion:nil];
        return;
    }
    
    if ([trackingNumberTextField.text isMatchedByRegex:@"[^a-zA-Z0-9]"]) {
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:INVALID_TRACKING_NUMBER_ERROR delegate:nil
//                                             cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        [alert show];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:INVALID_TRACKING_NUMBER_ERROR preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
        
        return;
    }
    
    if (!(trackingNumberTextField.text.length > 0)) {
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:NO_TRACKING_NUMBER_ERROR delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
//        [alertView show];
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:NO_TRACKING_NUMBER_ERROR preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
        
        return;
    }
    
    [self.view endEditing:YES];
    TrackingMainViewController *trackingMainViewController = [[TrackingMainViewController alloc] initWithNibName:nil bundle:nil];
    trackingMainViewController.isPushNotification = NO;
    [[AppDelegate sharedAppDelegate].rootViewController switchToViewController:trackingMainViewController];
    
    double delayInSeconds = 0.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [trackingMainViewController addTrackingNumber:trackingNumberTextField.text];
    });
}

- (IBAction)toggleSidebarButtonClicked:(id)sender
{
    [[AppDelegate sharedAppDelegate].rootViewController toggleSideBarVisiblity];
}

- (void)onAnnouncementBtn:(id)sender {
//    AnnouncementViewController *vc = [[AnnouncementViewController alloc]init];
//    [[AppDelegate sharedAppDelegate].rootViewController cPushViewController:vc];
    AnnouncementViewController *annoucementvc = [[AnnouncementViewController alloc] init];
    [[AppDelegate sharedAppDelegate].rootViewController cPushViewController:annoucementvc];
}

- (void)OnGoToScan {
    BarScannerViewController * barCodeVC = [[BarScannerViewController alloc] init];
    LandingPageViewController *landingPageViewController = [[LandingPageViewController alloc] initWithNibName:nil bundle:nil];
    barCodeVC.landingVC = landingPageViewController;
//    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:barCodeVC animated:YES completion:nil];
    [self.view.window.rootViewController.navigationController pushViewController:barCodeVC animated:YES];
//    [[AppDelegate sharedAppDelegate].rootViewController switchToViewController:barCodeVC];

    
//    BarScannerViewController * barScannervc = [[BarScannerViewController alloc] init];
//    barScannervc.landingVC = self;
//    [[AppDelegate sharedAppDelegate].rootViewController switchToViewController:vc];
    
//    BarScannerViewController * vc = [[BarScannerViewController alloc] init];
//    vc.landingVC = self;
//    [[AppDelegate sharedAppDelegate].rootViewController switchToViewController:vc];
}

@end
