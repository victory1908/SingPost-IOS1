//
//  DatabaseManager.h
//  SingPost
//
//  Created by Wei Guang Heng on 07/07/2015.
//  Copyright (c) 2015 Codigo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RXMLElement.h"
#import "Parcel.h"

@interface DatabaseManager : NSObject

+ (void)setupRealm;

+ (Parcel *)createOrUpdateParcel:(RXMLElement *)element;
+ (void)removeParcel:(Parcel *)parcel;
+ (void)setShowInGlance:(Parcel *)newParcel;

@end
