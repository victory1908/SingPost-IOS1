//
//  DeliveryStatus+CoreDataClass.m
//  
//
//  Created by Le Khanh Vinh on 16/11/16.
//
//

#import "DeliveryStatus+CoreDataClass.h"
#import "TrackedItem+CoreDataClass.h"
@implementation DeliveryStatus

+ (DeliveryStatus *)createFromXMLElement:(RXMLElement *)el inContext:(NSManagedObjectContext *)context
{
    DeliveryStatus *deliveryStatus = [DeliveryStatus MR_createEntityInContext:context];
    //    DeliveryStatus *deliveryStatus = [DeliveryStatus MR_createInContext:context];
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

+ (DeliveryStatus *)createFromDicElement:(NSDictionary *)el inContext:(NSManagedObjectContext *)context
{
    DeliveryStatus *deliveryStatus = [DeliveryStatus MR_createEntityInContext:context];
    //    DeliveryStatus *deliveryStatus = [DeliveryStatus MR_createInContext:context];
    [deliveryStatus setStatusDescription:[el objectForKey:@"StatusDescription"]];
    [deliveryStatus setLocation:[el objectForKey:@"Location"]];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssz"];
    NSDate *date = [dateFormatter dateFromString:[el objectForKey:@"Date"]];
    
    if (!date) {
        //date formatting failed, try again formatting with milliseconds
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSz"];
        date = [dateFormatter dateFromString:[el objectForKey:@"Date"]];
    }
    
    if (!date) {
        //date formatting failed again, try again formatting with just HH:mm:ss
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
        date = [dateFormatter dateFromString:[el objectForKey:@"Date"]];
    }
    
    [deliveryStatus setDate:date];
    
    return deliveryStatus;
}

@end
