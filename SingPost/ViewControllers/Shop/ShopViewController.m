//
//  ShopViewController.m
//  SingPost
//
//  Created by Wei Guang on 17/7/14.
//  Copyright (c) 2014 Codigo. All rights reserved.
//

#import "ShopViewController.h"
#import "NavigationBarView.h"
#import "ApiClient.h"
#import "SVProgressHUD.h"
#import "UIAlertView+Blocks.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
#import "NSDictionary+Additions.h"
#import "Article.h"
#import "UILabel+VerticalAlign.h"
#import "UIFont+SingPost.h"
#import "NSObject+Addtions.h"
#import "ShopContentViewController.h"
#import "UIColor-Expanded.h"

@interface ShopViewController ()
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *subTitleLabel;
@property (strong, nonatomic) UIImageView *background;
@end

@implementation ShopViewController

- (void)loadView {
    UIView *contentView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [contentView setBackgroundColor:RGB(250, 250, 250)];
    
    self.background = [[UIImageView alloc]initWithFrame:contentView.frame];
    self.background.contentMode = UIViewContentModeScaleAspectFill;
    [contentView addSubview:self.background];
    
    NavigationBarView *navigationBarView = [[NavigationBarView alloc] initWithFrame:NAVIGATIONBAR_FRAME];
    [navigationBarView setTitle:@"Shop"];
    [navigationBarView setShowSidebarToggleButton:YES];
    [contentView addSubview:navigationBarView];
    
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, navigationBarView.bottom, contentView.width, contentView.height - navigationBarView.height - 20)];
    [contentView addSubview:self.scrollView];
    
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 15, contentView.width - 30, 35)];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.font = [UIFont SingPostBoldFontOfSize:25.0f fontKey:kSingPostFontOpenSans];
    [self.scrollView addSubview:self.titleLabel];
    
    self.subTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, self.titleLabel.bottom + 8, contentView.width - 30, 35)];
    self.subTitleLabel.textAlignment = NSTextAlignmentCenter;
    self.subTitleLabel.numberOfLines = 0;
    self.subTitleLabel.font = [UIFont SingPostLightFontOfSize:15.0f fontKey:kSingPostFontOpenSans];
    [self.scrollView addSubview:self.subTitleLabel];
    
    self.view = contentView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // load data from userdefault
    NSData *data = [[NSUserDefaults standardUserDefaults]objectForKey:@"Offer"];
    NSDictionary *root = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    self.titleLabel.text = [root objectForKeyOrNil:@"BackgroundText"];
    self.subTitleLabel.text = [root objectForKeyOrNil:@"BackgroundSubText"];
    
    if ([UIColor colorWithHexString:[root objectForKeyOrNil:@"BackgroundTextColor"]] != nil) {
        self.titleLabel.textColor = [UIColor colorWithHexString:[root objectForKeyOrNil:@"BackgroundTextColor"]];
    }
    else {
        self.titleLabel.textColor = [UIColor whiteColor];
    }
    
    if ([UIColor colorWithHexString:[root objectForKeyOrNil:@"BackgroundSubTextColor"]] != nil) {
        self.subTitleLabel.textColor = [UIColor colorWithHexString:[root objectForKeyOrNil:@"BackgroundSubTextColor"]];
    }
    else {
        self.subTitleLabel.textColor = [UIColor whiteColor];
    }
    
    [self relayoutSubviews:root];
    
    NSString *backgroundImage = [root objectForKeyOrNil:@"BackgroundImage"];
    [self.background setImageWithURL:[NSURL URLWithString:backgroundImage]
         usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    
    
    if ([[AppDelegate sharedAppDelegate] hasInternetConnectionWarnIfNoConnection:YES]) {
        [SVProgressHUD showWithStatus:@"Please wait.."];
        [Article API_getShopItemsOnCompletion:^(NSArray *items, NSDictionary *root) {
            
            self.titleLabel.text = [root objectForKeyOrNil:@"BackgroundText"];
            self.subTitleLabel.text = [root objectForKeyOrNil:@"BackgroundSubText"];
            
            if ([UIColor colorWithHexString:[root objectForKeyOrNil:@"BackgroundTextColor"]] != nil) {
                self.titleLabel.textColor = [UIColor colorWithHexString:[root objectForKeyOrNil:@"BackgroundTextColor"]];
            }
            else {
                self.titleLabel.textColor = [UIColor whiteColor];
            }
            
            if ([UIColor colorWithHexString:[root objectForKeyOrNil:@"BackgroundSubTextColor"]] != nil) {
                self.subTitleLabel.textColor = [UIColor colorWithHexString:[root objectForKeyOrNil:@"BackgroundSubTextColor"]];
            }
            else {
                self.subTitleLabel.textColor = [UIColor whiteColor];
            }
            
            [self relayoutSubviews:root];
            
            NSString *backgroundImage = [root objectForKeyOrNil:@"BackgroundImage"];
            [self.background setImageWithURL:[NSURL URLWithString:backgroundImage]
                 usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            [SVProgressHUD dismiss];
        }];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[AppDelegate sharedAppDelegate] trackGoogleAnalyticsWithScreenName:@"Shop"];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [SVProgressHUD dismiss];
}

- (void)relayoutSubviews:(NSDictionary *)dictionary {
    [self.titleLabel sizeToFitKeepWidth];
    [self.subTitleLabel sizeToFitKeepWidth];
    
    self.subTitleLabel.top = self.titleLabel.bottom + 15;
    
    NSInteger index = 0;
    NSArray *keysArray = [dictionary objectForKeyOrNil:@"keys"];
    for (NSString *key in keysArray) {
        NSDictionary *item = [[dictionary objectForKeyOrNil:key]firstObject];
        if (item != nil) {
            [self createShopBtnIndex:index item:item name:key];
            index++;
        }
    }
    [self.scrollView autoAdjustScrollViewContentSizeBottomInset:15];
}

- (void)createShopBtnIndex:(NSInteger)index item:(NSDictionary *)item name:(NSString *)name {
    NSInteger padding = (index/2) * 15;
    NSInteger y = self.subTitleLabel.bottom + 15;
    NSInteger viewWidth = (self.scrollView.width - 45)/2;
    NSInteger viewHeight = viewWidth/3*2 + 40;
    
    UIView *view = [[UIView alloc]init];
    view.userInteractionEnabled = YES;
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight - 40)];
    [imageView setImageWithURL:[NSURL URLWithString:[item objectForKeyOrNil:@"Thumbnail"]]
   usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [view addSubview:imageView];
    
    UIView *background = [[UIView alloc]initWithFrame:CGRectMake(0, imageView.bottom, imageView.width, 40)];
    background.backgroundColor = RGB(42, 98, 173);
    background.alpha = 0.8;
    [view addSubview:background];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, background.width - 10, background.height)];
    label.text = name;
    label.numberOfLines = 2;
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont SingPostLightFontOfSize:14.0f fontKey:kSingPostFontOpenSans];
    label.textAlignment = NSTextAlignmentCenter;
    [background addSubview:label];
    
    view.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:view];
    
    if (index % 2 == 0)
        view.frame = CGRectMake(15, (index/2 * viewHeight) + y + padding, viewWidth,viewHeight);
    else
        view.frame = CGRectMake(self.scrollView.width/2 + 7.5, (index/2 * viewHeight) + y + padding, viewWidth,viewHeight);
    
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onItemSelect:)];
    [recognizer setAssociatedObject:item];
    [view addGestureRecognizer:recognizer];
}

- (void)onItemSelect:(UITapGestureRecognizer *)sender {
    ShopContentViewController *vc = [[ShopContentViewController alloc]init];
    vc.item = [sender associatedObject];
    [[AppDelegate sharedAppDelegate].rootViewController cPushViewController:vc];
    [[AppDelegate sharedAppDelegate] trackGoogleAnalyticsWithScreenName:[NSString stringWithFormat:@"Shop - %@", [[sender associatedObject]objectForKeyOrNil:@"Category"]]];
}


@end
