#import "_DeliveryStatus.h"
@class RXMLElement;

@interface DeliveryStatus : _DeliveryStatus {}

+ (DeliveryStatus *)createFromXMLElement:(RXMLElement *)el inContext:(NSManagedObjectContext *)context;
+ (DeliveryStatus *)createFromDicElement:(NSDictionary *)el inContext:(NSManagedObjectContext *)context;

@end
