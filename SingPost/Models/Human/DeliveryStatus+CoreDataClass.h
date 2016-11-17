//
//  DeliveryStatus+CoreDataClass.h
//  
//
//  Created by Le Khanh Vinh on 16/11/16.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "RXMLElement.h"

@class TrackedItem;

NS_ASSUME_NONNULL_BEGIN

@interface DeliveryStatus : NSManagedObject

+ (DeliveryStatus *)createFromXMLElement:(RXMLElement *)el inContext:(NSManagedObjectContext *)context;
+ (DeliveryStatus *)createFromDicElement:(NSDictionary *)el inContext:(NSManagedObjectContext *)context;


@end

NS_ASSUME_NONNULL_END

#import "DeliveryStatus+CoreDataProperties.h"
