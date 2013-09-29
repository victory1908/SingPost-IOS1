//
//  SeparatorTableViewCell.m
//  SingPost
//
//  Created by Edward Soetiono on 30/9/13.
//  Copyright (c) 2013 Codigo. All rights reserved.
//

#import "SeparatorTableViewCell.h"

@implementation SeparatorTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        
        UIView *separatorView = [[UIView alloc] initWithFrame:CGRectMake(15, 0, self.contentView.bounds.size.width - 30, 1)];
        [separatorView setBackgroundColor:RGB(196, 197, 200)];
        [self.contentView addSubview:separatorView];
    }
    
    return self;
}

@end
