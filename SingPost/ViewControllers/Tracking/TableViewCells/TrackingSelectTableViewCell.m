//
//  TrackingSelectTableViewCell.m
//  SingPost
//
//  Created by Li Le on 24/9/14.
//  Copyright (c) 2014 Codigo. All rights reserved.
//

#import "TrackingSelectTableViewCell.h"
#import "UIFont+SingPost.h"
#import "TrackedItem.h"
#import "PersistentBackgroundView.h"
#import "UILabel+VerticalAlign.h"

@implementation TrackingSelectTableViewCell
@synthesize checkBox;
@synthesize item;
@synthesize delegate;

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        _trackingLabel.text = item.trackingNumber;
    }
    
    return self;
}

- (void) initConetent {
    _trackingLabel.text = item.trackingNumber;
    [_trackingLabel setFont:[UIFont SingPostRegularFontOfSize:14.0f fontKey:kSingPostFontOpenSans]];
    
}

- (IBAction)onClicked:(UIButton *)sender {
    if(sender.isSelected) {
        sender.selected = false;
        [delegate add2DeleteItem:item];
    }
    else {
        sender.selected = true;
        [delegate removeFromDeleteItem:item];
    }
}


@end
