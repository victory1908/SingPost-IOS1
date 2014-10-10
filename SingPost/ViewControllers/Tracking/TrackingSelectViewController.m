//
//  TrackingSelectViewController.m
//  SingPost
//
//  Created by Li Le on 24/9/14.
//  Copyright (c) 2014 Codigo. All rights reserved.
//

#import "TrackingSelectViewController.h"
#import "TrackingSelectTableViewCell.h"

@interface TrackingSelectViewController () {
    //NSMutableArray * selectedArray;
    __weak IBOutlet UIButton *checkBox;
}

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
    [self addAll2Delete];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    
}

- (void)addAll2Delete {
    for(TrackedItem * item in trackItems) {
        [trackItems2Delete addObject:item];
    }
}

- (void)removeAll2Delete {
    [trackItems2Delete removeAllObjects];
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
        
        
    }
    
    cell.item = [trackItems objectAtIndex:indexPath.row];
    cell.delegate = self;
    [cell initConetent];
    return cell;
}

#pragma mark Sync 
-(void) add2DeleteItem : (TrackedItem *)item {
    [checkBox setSelected:NO];
    
    if([trackItems2Delete containsObject:item])
        return;
    
    [trackItems2Delete addObject:item];
}

-(void) removeFromDeleteItem : (TrackedItem *)item {
    [trackItems2Delete removeObject:item];
    
    if([trackItems2Delete count] == 0)
        [checkBox setSelected:YES];
}

- (IBAction)onOKClicked:(id)sender {
    if(![self checkAllUnselected])
        [delegate updateSelectItem:trackItems2Delete];
}

- (IBAction)onCancelClicked:(id)sender {
    [sender setSelected:NO];
    [self unSelectAll];
    [delegate updateSelectItem:trackItems2Delete];
    
}


- (IBAction)onSelectAll:(UIButton *)sender {
    if(sender.isSelected) {
        [sender setSelected:NO];
        
        [self unSelectAll];
    } else {
        [sender setSelected:YES];
        
        [self selectAll];
    }
}

- (BOOL) checkAllUnselected {
    
    BOOL value = true;
    
    NSMutableArray *cells = [[NSMutableArray alloc] init];
    for (NSInteger j = 0; j < [self.tableView numberOfSections]; ++j)
    {
        for (NSInteger i = 0; i < [self.tableView numberOfRowsInSection:j]; ++i)
        {
            id cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:j]];
            if(cell)
                [cells addObject:cell];
        }
    }
    
    for (id cell in cells)
    {
        if([cell isKindOfClass:[TrackingSelectTableViewCell class]]) {
            if([[cell checkBox] isSelected]) {
                value = false;
            }
            
        }
    }
    
    return value;
}

- (NSDictionary *) selectAll {
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    
    /*NSMutableArray *cells = [[NSMutableArray alloc] init];
    for (NSInteger j = 0; j < [self.tableView numberOfSections]; ++j)
    {
        for (NSInteger i = 0; i < [self.tableView numberOfRowsInSection:j]; ++i)
        {
            id cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:j]];
            if(cell)
                [cells addObject:cell];
            
        }
    }
    
    for (id cell in cells)
    {
        if([cell isKindOfClass:[TrackingSelectTableViewCell class]]) {
            [cell onSelected];
            
        }
    }*/
    
    [self removeAll2Delete];
    [self.tableView reloadData];
    
    return dic;
}

- (NSDictionary *) unSelectAll {
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    
    /*NSMutableArray *cells = [[NSMutableArray alloc] init];
    for (NSInteger j = 0; j < [self.tableView numberOfSections]; ++j)
    {
        for (NSInteger i = 0; i < [self.tableView numberOfRowsInSection:j]; ++i)
        {
            id cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:j]];
            if(cell)
                [cells addObject:cell];
        }
    }
    
    for (id cell in cells)
    {
        if([cell isKindOfClass:[TrackingSelectTableViewCell class]]) {
            [cell onUnSelected];
            
        }
    }*/
    
    [self addAll2Delete];
    [self.tableView reloadData];
    return dic;
}

@end
