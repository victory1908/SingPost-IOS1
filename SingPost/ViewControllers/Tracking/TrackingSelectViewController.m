//
//  TrackingSelectViewController.m
//  SingPost
//
//  Created by Li Le on 24/9/14.
//  Copyright (c) 2014 Codigo. All rights reserved.
//

#import "TrackingSelectViewController.h"
#import "TrackingSelectTableViewCell.h"

@interface TrackingSelectViewController ()

@end

@implementation TrackingSelectViewController
@synthesize trackItems;
@synthesize trackItems2Delete;
@synthesize delegate;

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
    trackItems2Delete = [NSMutableArray array];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [trackItems count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"TrackingSelectTableViewCell";
    
    TrackingSelectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"TrackingSelectTableViewCell" owner:self options:nil];
        
        cell = [topLevelObjects objectAtIndex:0];
        cell.item = [trackItems objectAtIndex:indexPath.row];
        cell.delegate = self;
        [cell initConetent];
    }
    
    return cell;
}

#pragma mark Sync 
-(void) add2DeleteItem : (TrackedItem *)item {
    [trackItems2Delete addObject:item];
}

-(void) removeFromDeleteItem : (TrackedItem *)item {
    [trackItems2Delete removeObject:item];
}

- (IBAction)onOKClicked:(id)sender {
    [delegate updateSelectItem:trackItems2Delete];
}


@end
