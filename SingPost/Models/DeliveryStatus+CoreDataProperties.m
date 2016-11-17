//
//  DeliveryStatus+CoreDataProperties.m
//  
//
//  Created by Le Khanh Vinh on 16/11/16.
//
//

#import "DeliveryStatus+CoreDataProperties.h"

@implementation DeliveryStatus (CoreDataProperties)

+ (NSFetchRequest<DeliveryStatus *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"DeliveryStatus"];
}

@dynamic date;
@dynamic location;
@dynamic statusDescription;
@dynamic trackItem;

@end
