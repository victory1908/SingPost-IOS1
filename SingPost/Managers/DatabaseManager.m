//
//  DatabaseManager.m
//  SingPost
//
//  Created by Wei Guang Heng on 07/07/2015.
//  Copyright (c) 2015 Codigo. All rights reserved.
//

#import "DatabaseManager.h"
#import "ParcelStatus.h"
#import <Realm/Realm.h>
#import "PushNotification.h"

#define APP_GROUP_ID @"group.sg.codigo.singpost"

@implementation DatabaseManager

#pragma mark - Public methods
+ (void)setupRealm {
    NSURL *containerURL = [[NSFileManager defaultManager]containerURLForSecurityApplicationGroupIdentifier:APP_GROUP_ID];
    NSURL *realmURL = [containerURL URLByAppendingPathComponent:@"SingPost.realm"];
    
    RLMRealmConfiguration *configuration = [RLMRealmConfiguration defaultConfiguration];
    configuration.fileURL = realmURL;
    [RLMRealmConfiguration setDefaultConfiguration:configuration];
    
    NSLog(@"Default Realm location: %@", realmURL);
    
    
//    NSURL *realmURL = [[NSFileManager defaultManager]containerURLForSecurityApplicationGroupIdentifier:APP_GROUP_ID];
//    NSString *realmPath = [realmURL.path stringByAppendingPathComponent:@"SingPost.realm"];
//    [RLMRealm setDefaultRealmPath:realmPath];
//    NSLog(@"Default Realm Path : %@",[RLMRealm defaultRealmPath]);
}

+ (Parcel *)createOrUpdateParcel:(RXMLElement *)element {
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    
    NSString *trackingNumber = [element child:@"TrackingNumber"].text;
    
    //Check if parcel exists
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"trackingNumber == %@",trackingNumber];
    Parcel *parcel = [[Parcel objectsWithPredicate:predicate]firstObject];
    
    if (parcel == nil) {
        //Create new parcel
        parcel = [[Parcel alloc]init];
        parcel.addedOn = [NSDate date];
        parcel.showInGlance = NO;
        parcel.labelAlias = @"";
    }
    parcel.trackingNumber = trackingNumber;
    parcel.originalCountry = [element child:@"OriginalCountry"].text;
    parcel.destinationCountry = [element child:@"DestinationCountry"].text;
    parcel.isActive = [element child:@"TrackingNumberActive"].text;
    parcel.isFound = [[element child:@"TrackingNumberFound"].text boolValue];
    parcel.lastUpdatedOn = [NSDate date];
    
    RLMArray *existingStatus = parcel.deliveryStatus;
    RLMArray *newStatus = [[RLMArray alloc]initWithObjectClassName:@"ParcelStatus"];
    
    RXMLElement *deliveryStatus = [element child:@"DeliveryStatusDetails"];
    for (RXMLElement *xmlStatus in [deliveryStatus children:@"DeliveryStatusDetail"]) {
        ParcelStatus *parcelStatus = [self createParcelStatus:xmlStatus];
        [newStatus addObject:parcelStatus];
    }
    //Remove old records
    [parcel.deliveryStatus removeAllObjects];
    //Replace with new records
    [parcel.deliveryStatus addObjects:newStatus];
    
    //Status have been changed
    if ([existingStatus count] != [parcel.deliveryStatus count]) {
        parcel.isRead = NO;
    } else {
        parcel.isRead = YES;
    }
    [realm addObject:parcel];
    [realm commitWriteTransaction];
    return parcel;
}

+ (void)removeParcel:(Parcel *)parcel {
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    [realm deleteObject:parcel];
    [realm commitWriteTransaction];
}

+ (void)setShowInGlance:(Parcel *)newParcel {
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    
    //Get previously set parcel
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"showInGlance == YES"];
    RLMResults *results = [Parcel objectsWithPredicate:predicate];
    for (Parcel *oldParcel in results) {
        oldParcel.showInGlance = NO;
    }
    newParcel.showInGlance = YES;
    [realm commitWriteTransaction];
}

#pragma mark - Private methods
+ (ParcelStatus *)createParcelStatus:(RXMLElement *)element {
    ParcelStatus *parcelStatus = [[ParcelStatus alloc]init];
    parcelStatus.location = [element child:@"Location"].text;
    parcelStatus.statusDescription = [element child:@"StatusDescription"].text;
    
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ssz";
    NSDate *date = [dateFormatter dateFromString:[element child:@"Date"].text];
    
    if (date == nil) {
        dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSSz";
        date = [dateFormatter dateFromString:[element child:@"Date"].text];
    }
    
    if (date == nil) {
        dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss";
        date = [dateFormatter dateFromString:[element child:@"Date"].text];
    }
    parcelStatus.date = date;
    return parcelStatus;
}

@end
