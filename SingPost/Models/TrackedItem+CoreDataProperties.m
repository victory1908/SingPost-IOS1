//
//  TrackedItem+CoreDataProperties.m
//  
//
//  Created by Le Khanh Vinh on 16/11/16.
//
//  This file was automatically generated and should not be edited.
//

#import "TrackedItem+CoreDataProperties.h"

@implementation TrackedItem (CoreDataProperties)

+ (NSFetchRequest<TrackedItem *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"TrackedItem"];
}

@dynamic addedOn;
@dynamic destinationCountry;
@dynamic isActive;
@dynamic isFound;
@dynamic isRead;
@dynamic lastUpdatedOn;
@dynamic originalCountry;
@dynamic trackingNumber;
@dynamic deliveryStatuses;

@end
