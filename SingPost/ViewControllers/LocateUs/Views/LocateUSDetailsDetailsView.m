//
//  LocateUSDetailsDetailsView.m
//  SingPost
//
//  Created by Wei Guang on 7/1/14.
//  Copyright (c) 2014 Codigo. All rights reserved.
//

#import "LocateUSDetailsDetailsView.h"
#import "UIFont+SingPost.h"

@implementation LocateUSDetailsDetailsView

- (id)initWithLocation:(EntityLocation *)inLocation andFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        UILabel *contactNumber;
        
        if (inLocation.contactNumber != [NSNull class]) {
            if([inLocation.contactNumber length] > 0) {
                contactNumber = [[UILabel alloc] initWithFrame:CGRectMake(15,15,320,15)];
                [contactNumber setTextColor:RGB(58, 68, 81)];
                [contactNumber setBackgroundColor:[UIColor clearColor]];
                [contactNumber setFont:[UIFont SingPostRegularFontOfSize:14.0f fontKey:kSingPostFontOpenSans]];
                [contactNumber setText:[NSString stringWithFormat:@"Contact number : %@",inLocation.contactNumber]];
                [self addSubview:contactNumber];
            }
        }
        if (inLocation.postal_code != [NSNull class]) {
            if([inLocation.postal_code length] > 0) {
                UILabel *postalCode = [[UILabel alloc] initWithFrame:CGRectMake(15,35,320,15)];
                [postalCode setTextColor:RGB(58, 68, 81)];
                [postalCode setBackgroundColor:[UIColor clearColor]];
                [postalCode setFont:[UIFont SingPostRegularFontOfSize:14.0f fontKey:kSingPostFontOpenSans]];
                [postalCode setText:[NSString stringWithFormat:@"Postal code : %@",inLocation.postal_code]];
                [self addSubview:postalCode];
                if (contactNumber == nil)
                    postalCode.top = 15;
            }
        }
    }
    return self;
    
}

@end
