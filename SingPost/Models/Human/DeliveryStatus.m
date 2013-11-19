#import "DeliveryStatus.h"
#import <RXMLElement.h>

@interface DeliveryStatus ()

// Private interface goes here.

@end


@implementation DeliveryStatus

+ (DeliveryStatus *)createFromXMLElement:(RXMLElement *)el inContext:(NSManagedObjectContext *)context
{
    DeliveryStatus *deliveryStatus = [DeliveryStatus MR_createInContext:context];
    [deliveryStatus setStatusDescription:[el child:@"StatusDescription"].text];
    [deliveryStatus setLocation:[el child:@"Location"].text];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssz"];
    NSDate *date = [dateFormatter dateFromString:[el child:@"Date"].text];
    
    if (!date) {
        //date formatting failed, try again formatting with milliseconds
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSz"];
        date = [dateFormatter dateFromString:[el child:@"Date"].text];
    }
    
    if (!date) {
        //date formatting failed again, try again formatting with just HH:mm:ss
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
        date = [dateFormatter dateFromString:[el child:@"Date"].text];
    }
    
    [deliveryStatus setDate:date];

    return deliveryStatus;
}

@end
