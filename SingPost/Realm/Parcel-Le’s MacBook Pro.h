//
//  Parcel.h
//  SingPost
//
//  Created by Wei Guang Heng on 07/07/2015.
//  Copyright (c) 2015 Codigo. All rights reserved.
//

#import "ParcelStatus.h"
#import <Realm/Realm.h>
#import "TrackedItem+CoreDataClass.h"

@interface Parcel : RLMObject
@property NSDate *addedOn;
@property NSString *destinationCountry;
@property NSString *isActive;
@property BOOL isFound;
@property BOOL isRead;
@property BOOL showInGlance;
@property NSDate *lastUpdatedOn;
@property NSString *originalCountry;
@property NSString *trackingNumber;
@property NSString *labelAlias;
@property RLMArray<ParcelStatus> *deliveryStatus;

+ (Parcel *)getGlanceParcel;
- (NSString *)getLabelText;
- (NSString *)latestStatus;

+ (RLMResults *)getAllParcels;
+ (RLMResults *)getActiveParcels;
+ (RLMResults *)getUnsortedParcels;
+ (RLMResults *)getCompletedParcels;

@end

