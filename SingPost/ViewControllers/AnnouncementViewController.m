//
//  AnnouncementViewController.m
//  SingPost
//
//  Created by Wei Guang on 7/7/14.
//  Copyright (c) 2014 Codigo. All rights reserved.
//

#import "AnnouncementViewController.h"
#import "NavigationBarView.h"
#import "AnnouncementTableViewCell.h"
#import "ApiClient.h"
#import "AnnouncementDetailViewController.h"
#import "NSDictionary+Additions.h"
#import "SVProgressHUD.h"

@interface AnnouncementViewController ()
<
UITableViewDelegate,
UITableViewDataSource
>
@property (strong, nonatomic) NSArray *dataArray;
@property (strong, nonatomic) UITableView *tableView;
@end

@implementation AnnouncementViewController

- (void)loadView {
    UIView *contentView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [contentView setBackgroundColor:RGB(250, 250, 250)];
    
    NavigationBarView *navigationBarView = [[NavigationBarView alloc] initWithFrame:NAVIGATIONBAR_FRAME];
    [navigationBarView setTitle:@"Announcements"];
    [navigationBarView setShowSidebarToggleButton:YES];
    [contentView addSubview:navigationBarView];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, navigationBarView.bottom, contentView.bounds.size.width, contentView.bounds.size.height - navigationBarView.height - [UIApplication sharedApplication].statusBarFrame.size.height) style:UITableViewStylePlain];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableView setSeparatorColor:[UIColor clearColor]];
    [self.tableView setBackgroundView:nil];
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    [self.tableView setBackgroundColor:[UIColor whiteColor]];
    [contentView addSubview:self.tableView];
    
    self.view = contentView;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"announcements"];
    _dataArray = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    [SVProgressHUD showWithStatus:@"Please wait..."];
    [[ApiClient sharedInstance]getSingpostAnnouncementSuccess:^(id responseObject)
     {
         NSArray * arr = [[responseObject objectForKeyOrNil:@"root"] objectForKeyOrNil:@"announcements"];
         
         
         if(arr == nil) {
            arr = [responseObject objectForKeyOrNil:@"root"];
         }
         self.dataArray = arr;
         [self.tableView reloadData];
         
         NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
         
         NSString * rand = [[responseObject objectForKeyOrNil:@"root"] objectForKeyOrNil:@"rand"];
         
         if(rand!= nil) {
             [defaults setObject:rand forKey:@"LAST_RAND"];
             
             NSData *data = [NSKeyedArchiver archivedDataWithRootObject:arr];
             [defaults setObject:data forKey:@"announcements"];
             
             [defaults synchronize];
         }
         [SVProgressHUD dismiss];
         
     } failure:^(NSError *error)
     {[SVProgressHUD dismiss];}];
    
    [[AppDelegate sharedAppDelegate] trackGoogleAnalyticsWithScreenName:@"Announcements List"];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[self getUTCFormateDate:[NSDate date]] forKey:@"ANNOUNCEMENT_LAST_DATE"];
    [defaults synchronize];
    [AppDelegate sharedAppDelegate].isPrevAnnouncementNew = NO;
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AnnouncementTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AnnouncementTableViewCell class])];
    if (!cell)
        cell = [[AnnouncementTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([AnnouncementTableViewCell class])];
    [cell configureCellWithData:[self.dataArray objectAtIndex:indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    AnnouncementDetailViewController *vc = [[AnnouncementDetailViewController alloc]init];
    vc.info = [self.dataArray objectAtIndex:indexPath.row];
    [[AppDelegate sharedAppDelegate].rootViewController cPushViewController:vc];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
