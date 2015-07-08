//
//  Parcel.m
//  SingPost
//
//  Created by Wei Guang Heng on 07/07/2015.
//  Copyright (c) 2015 Codigo. All rights reserved.
//

#import "Parcel.h"

@implementation Parcel

+ (Parcel *)getGlanceParcel {
    //There should be only one user selected Parcel
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"showInGlance == YES"];
    Parcel *parcel = [[Parcel objectsWithPredicate:predicate]firstObject];
    
    if (parcel != nil) {
        return parcel;
    }
    //If user did not select any Parcel show latest updated
    else {
        RLMResults *allParcels = [Parcel allObjects];
        RLMResults *results = [allParcels sortedResultsUsingProperty:@"lastUpdatedOn" ascending:NO];
        return [results firstObject];
    }
}

- (NSString *)getLabelText {
    if (![self.labelAlias isEqualToString:@""]) {
        return self.labelAlias;
    } else {
        return self.trackingNumber;
    }
}

@end