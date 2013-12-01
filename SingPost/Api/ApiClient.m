//
//  ApiClient.m
//  SingPost
//
//  Created by Edward Soetiono on 8/10/13.
//  Copyright (c) 2013 Codigo. All rights reserved.
//

#import "ApiClient.h"
#import "EntityLocation.h"
#import "ItemTracking.h"
#import <SSKeychain.h>

@implementation ApiClient

@synthesize notificationProfileID = _notificationProfileID;
@synthesize failedNotificationTrackingNumbers = _failedNotificationTrackingNumbers;

static NSString *const BASE_URL = @"https://uatesb1.singpost.com";
static NSString *const LOCATIONS_BASE_URL = @"http://mobile.singpost.com/";

static NSString *const APP_ID = @"M00001";
static NSString *const OS = @"ios";

#pragma mark - Shared singleton instance

+ (ApiClient *)sharedInstance {
    static ApiClient *sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        sharedInstance = [[self alloc] initWithBaseURL:[NSURL URLWithString:BASE_URL]];
    });
    
    return sharedInstance;
}

- (id)initWithBaseURL:(NSURL *)url
{
    if ((self = [super initWithBaseURL:url])) {
        [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
    }
    
    return self;
}

#pragma mark - Properties

- (BOOL)hasRegisteredProfileId
{
    return [[self notificationProfileID] length] > 0;
}

- (NSString *)notificationProfileID
{
    if (!_notificationProfileID) {
        _notificationProfileID = [SSKeychain passwordForService:KEYCHAIN_SERVICENAME account:@"SETTINGS_PROFILEID"];
    }
    return _notificationProfileID;
}

- (void)setNotificationProfileID:(NSString *)inNotificationProfileID
{
    if (inNotificationProfileID.length > 0) {
        _notificationProfileID = inNotificationProfileID;
        [SSKeychain setPassword:_notificationProfileID forService:KEYCHAIN_SERVICENAME account:@"SETTINGS_PROFILEID"];
    }
}

- (NSMutableSet *)failedNotificationTrackingNumbers
{
    if (!_failedNotificationTrackingNumbers) {
        _failedNotificationTrackingNumbers = [NSMutableSet setWithArray:[[[NSUserDefaults standardUserDefaults] valueForKey:@"SETTINGS_FAILEDNOTIFICATIONNUMBERS"] componentsSeparatedByString:@"^"]];
    }
    
    if (_failedNotificationTrackingNumbers.count == 0)
        _failedNotificationTrackingNumbers = [NSMutableSet set];
    
    return _failedNotificationTrackingNumbers;
}

- (void)setFailedNotificationTrackingNumbers:(NSMutableSet *)inFailedNotificationTrackingNumbers
{
    _failedNotificationTrackingNumbers = inFailedNotificationTrackingNumbers;
    [[NSUserDefaults standardUserDefaults] setValue:[_failedNotificationTrackingNumbers.allObjects componentsJoinedByString:@"^"] forKey:@"SETTINGS_FAILEDNOTIFICATIONNUMBERS"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - API calls

- (void)getSingpostServicesArticlesOnSuccess:(ApiClientSuccess)success onFailure:(ApiClientFailure)failure
{
    [self getPath:@"singpost-services.php"
       parameters:nil
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              if (success)
                  success(responseObject);
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              if (failure)
                  failure(error);
          }];
}

#pragma mark - Calculate Postage

- (void)calculateSingaporePostageForFromPostalCode:(NSString *)fromPostalCode andToPostalCode:(NSString *)toPostalCode andWeight:(NSString *)weightInGrams onSuccess:(ApiClientSuccess)success onFailure:(ApiClientFailure)failure
{
    NSString *xml = [NSString stringWithFormat:@"<SingaporePostalInfoDetailsRequest xmlns=\"http://singpost.com/paw/ns\">"
                     "<ToPostalCode>%@</ToPostalCode>"
                     "<FromPostalCode>%@</FromPostalCode>"
                     "<Weight>%@</Weight>"
                     "<DeliveryServiceName></DeliveryServiceName>"
                     "</SingaporePostalInfoDetailsRequest>", toPostalCode, fromPostalCode, weightInGrams];
    
    NSMutableURLRequest *request = [self requestWithMethod:@"POST" path:@"ma/FilterSingaporePostalInfo" parameters:nil];
    [request addValue:@"application/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%d", [xml length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:[xml dataUsingEncoding:NSUTF8StringEncoding]];
    
    AFRaptureXMLRequestOperation *operation = [AFRaptureXMLRequestOperation XMLParserRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, RXMLElement *XMLElement) {
        if (success)
            success(XMLElement);
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, RXMLElement *XMLElement) {
        if (failure)
            failure(error);
    }];
    
    [self enqueueHTTPRequestOperation:operation];
}

- (void)calculateOverseasPostageForCountryCode:(NSString *)countryCode andWeight:(NSString *)weightInGrams andItemTypeCode:(NSString *)itemTypeCode andDeliveryCode:(NSString *)deliveryCode onSuccess:(ApiClientSuccess)success onFailure:(ApiClientFailure)failure
{
    NSString *xml = [NSString stringWithFormat:@"<OverseasPostalInfoDetailsRequest xmlns=\"http://singpost.com/paw/ns\">"
         "<Country>%@</Country>"
         "<Weight>%@</Weight>"
         "<DeliveryServiceName></DeliveryServiceName>"
         "<ItemType>%@</ItemType>"
         "<PriceRange>999</PriceRange>"
         "<DeliveryTimeRange>%@</DeliveryTimeRange>"
         "</OverseasPostalInfoDetailsRequest>", countryCode, weightInGrams, itemTypeCode, deliveryCode];
    
    NSMutableURLRequest *request = [self requestWithMethod:@"POST" path:@"ma/FilterOverseasPostalInfo" parameters:nil];
    [request addValue:@"application/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%d", [xml length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:[xml dataUsingEncoding:NSUTF8StringEncoding]];
    
    AFRaptureXMLRequestOperation *operation = [AFRaptureXMLRequestOperation XMLParserRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, RXMLElement *XMLElement) {
        if (success)
            success(XMLElement);
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, RXMLElement *XMLElement) {
        if (failure)
            failure(error);
    }];
    
    [self enqueueHTTPRequestOperation:operation];
}

#pragma mark - Postal Code

- (void)findPostalCodeForBuildingNo:(NSString *)buildingNo andStreetName:(NSString *)streetName onSuccess:(ApiClientSuccess)success onFailure:(ApiClientFailure)failure
{
    NSString *xml = [NSString stringWithFormat:@"<PostalCodeByStreetDetailsRequest xmlns=\"http://singpost.com/paw/ns\">"
                     "<BuildingNo>%@</BuildingNo>"
                     "<StreetName>%@</StreetName>"
                     "</PostalCodeByStreetDetailsRequest>", buildingNo, streetName];
    
    NSMutableURLRequest *request = [self requestWithMethod:@"POST" path:@"ma/PostalCodebyStreet" parameters:nil];
    [request addValue:@"application/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%d", [xml length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:[xml dataUsingEncoding:NSUTF8StringEncoding]];
    
    AFRaptureXMLRequestOperation *operation = [AFRaptureXMLRequestOperation XMLParserRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, RXMLElement *XMLElement) {
        if (success)
            success(XMLElement);
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, RXMLElement *XMLElement) {
        if (failure)
            failure(error);
    }];
    
    [self enqueueHTTPRequestOperation:operation];
}

- (void)findPostalCodeForLandmark:(NSString *)landmark onSuccess:(ApiClientSuccess)success onFailure:(ApiClientFailure)failure
{
    NSString *xml = [NSString stringWithFormat:@"<PostalAddressByLandMarkDetailsRequest  xmlns=\"http://singpost.com/paw/ns\"><BuildingName>%@</BuildingName></PostalAddressByLandMarkDetailsRequest>", landmark];
    
    NSMutableURLRequest *request = [self requestWithMethod:@"POST" path:@"ma/PostalAddressbyLandMark" parameters:nil];
    [request addValue:@"application/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%d", [xml length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:[xml dataUsingEncoding:NSUTF8StringEncoding]];
    
    AFRaptureXMLRequestOperation *operation = [AFRaptureXMLRequestOperation XMLParserRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, RXMLElement *XMLElement) {
        if (success)
            success(XMLElement);
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, RXMLElement *XMLElement) {
        if (failure)
            failure(error);
    }];
    
    [self enqueueHTTPRequestOperation:operation];
}

- (void)findPostalCodeForWindowsDeliveryNo:(NSString *)windowsDeliveryNo andType:(NSString *)type andPostOffice:(NSString *)postOffice onSuccess:(ApiClientSuccess)success onFailure:(ApiClientFailure)failure
{
    NSString *xml = [NSString stringWithFormat:@"<PostalCodeByPOBoxDetailsRequest xmlns=\"http://singpost.com/paw/ns\"><WindowDeliveryNo>%@</WindowDeliveryNo><Type>%@</Type><PostOffice>%@</PostOffice></PostalCodeByPOBoxDetailsRequest>", windowsDeliveryNo, type, postOffice];
    
    NSMutableURLRequest *request = [self requestWithMethod:@"POST" path:@"ma/PostalCodebyPOBox" parameters:nil];
    [request addValue:@"application/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%d", [xml length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:[xml dataUsingEncoding:NSUTF8StringEncoding]];
    
    AFRaptureXMLRequestOperation *operation = [AFRaptureXMLRequestOperation XMLParserRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, RXMLElement *XMLElement) {
        if (success)
            success(XMLElement);
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, RXMLElement *XMLElement) {
        if (failure)
            failure(error);
    }];
    
    [self enqueueHTTPRequestOperation:operation];
}

#pragma mark - Locations

- (void)getPostingBoxLocationsOnSuccess:(ApiClientSuccess)success onFailure:(ApiClientFailure)failure
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"postingbox.php" relativeToURL:[NSURL URLWithString:LOCATIONS_BASE_URL]]];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        if (success)
            success(JSON);
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        if (failure)
            failure(error);
    }];
    
    [self enqueueHTTPRequestOperation:operation];
}

- (void)getPostOfficeLocationsOnSuccess:(ApiClientSuccess)success onFailure:(ApiClientFailure)failure
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"postoffice.php" relativeToURL:[NSURL URLWithString:LOCATIONS_BASE_URL]]];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        if (success)
            success(JSON);
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        if (failure)
            failure(error);
    }];
    
    [self enqueueHTTPRequestOperation:operation];
}

- (void)getSamLocationsOnSuccess:(ApiClientSuccess)success onFailure:(ApiClientFailure)failure
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"sam.php" relativeToURL:[NSURL URLWithString:LOCATIONS_BASE_URL]]];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        if (success)
            success(JSON);
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        if (failure)
            failure(error);
    }];
    
    [self enqueueHTTPRequestOperation:operation];
}

#pragma mark - Tracking

- (void)getItemTrackingDetailsForTrackingNumber:(NSString *)trackingNumber onSuccess:(ApiClientSuccess)success onFailure:(ApiClientFailure)failure
{
    NSString *xml = [NSString stringWithFormat: @"<ItemTrackingDetailsRequest xmlns=\"http://singpost.com/paw/ns\">"
                         "<ItemTrackingNumbers>"
                         "<TrackingNumber>%@</TrackingNumber>"
                         "</ItemTrackingNumbers>"
                         "</ItemTrackingDetailsRequest>", [trackingNumber uppercaseString]];
    
    NSMutableURLRequest *request = [self requestWithMethod:@"POST" path:@"ma/GetItemTrackingDetails" parameters:nil];
    [request addValue:@"application/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%d", [xml length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:[xml dataUsingEncoding:NSUTF8StringEncoding]];
    
    AFRaptureXMLRequestOperation *operation = [AFRaptureXMLRequestOperation XMLParserRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, RXMLElement *XMLElement) {
        if (success)
            success(XMLElement);
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, RXMLElement *XMLElement) {
        if (failure)
            failure(error);
    }];
    
    [self enqueueHTTPRequestOperation:operation];
}

- (void)batchUpdateTrackedItems:(NSArray *)trackedItems onSuccess:(ApiClientSuccess)success onFailure:(ApiClientFailure)failure withProgressCompletion:(ApiClientProgressCompletion)progressCompletion
{
    NSMutableArray *updateOperations = [NSMutableArray array];
    
#define NUM_ITEMS_PER_API 10
    NSUInteger chunk = 0;
    NSArray *chunkedTrackedItems;
    do {
        chunkedTrackedItems = [trackedItems subarrayWithRange:NSMakeRange(chunk * NUM_ITEMS_PER_API, MIN(trackedItems.count - (chunk * NUM_ITEMS_PER_API), NUM_ITEMS_PER_API))];
        
        if (chunkedTrackedItems.count > 0) {
            NSMutableString *trackingNumbersXml = [NSMutableString string];
            for (ItemTracking *trackedItem in chunkedTrackedItems) {
                [trackingNumbersXml appendFormat:@"<TrackingNumber>%@</TrackingNumber>", [trackedItem.trackingNumber uppercaseString]];
            }
            
            NSString *xml = [NSString stringWithFormat: @"<ItemTrackingDetailsRequest xmlns=\"http://singpost.com/paw/ns\">"
                             "<ItemTrackingNumbers>"
                             "%@"
                             "</ItemTrackingNumbers>"
                             "</ItemTrackingDetailsRequest>", trackingNumbersXml];

            NSMutableURLRequest *request = [self requestWithMethod:@"POST" path:@"ma/GetItemTrackingDetails" parameters:nil];
            [request addValue:@"application/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
            [request addValue:[NSString stringWithFormat:@"%d", [xml length]] forHTTPHeaderField:@"Content-Length"];
            [request setHTTPBody:[xml dataUsingEncoding:NSUTF8StringEncoding]];
            
            AFRaptureXMLRequestOperation *operation = [AFRaptureXMLRequestOperation XMLParserRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, RXMLElement *XMLElement) {
                if (success)
                    success(XMLElement);
            } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, RXMLElement *XMLElement) {
                if (failure)
                    failure(error);
            }];
            
            [updateOperations addObject:operation];
        }
        
        chunk++;
    } while((chunk * NUM_ITEMS_PER_API) < trackedItems.count);

    [self enqueueBatchOfHTTPRequestOperations:updateOperations
                                progressBlock:^(NSUInteger numberOfFinishedOperations, NSUInteger totalNumberOfOperations) {
                                    if (progressCompletion)
                                        progressCompletion(numberOfFinishedOperations, totalNumberOfOperations);
                                } completionBlock:^(NSArray *operations) {
                                    //do nothing
                                }];
}

#pragma mark - Notifications

- (void)registerAPNSToken:(NSString *)apnsToken onSuccess:(ApiClientSuccess)success onFailure:(ApiClientFailure)failure
{
    NSString *xml = [NSString stringWithFormat: @"<RegisterRequest>"
                     "<PushID>%@</PushID>"
                     "<AppID>%@</AppID>"
                     "<OS>%@</OS>"
                     "</RegisterRequest>", apnsToken, APP_ID, OS];
    
    NSMutableURLRequest *request = [self requestWithMethod:@"POST" path:@"ma/notify/registration/add" parameters:nil];
    [request addValue:@"application/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%d", [xml length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:[xml dataUsingEncoding:NSUTF8StringEncoding]];
    
    AFRaptureXMLRequestOperation *operation = [AFRaptureXMLRequestOperation XMLParserRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, RXMLElement *XMLElement) {
        if (success)
            success(XMLElement);
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, RXMLElement *XMLElement) {
        if (failure)
            failure(error);
    }];
    
    [self enqueueHTTPRequestOperation:operation];
}

- (void)subscribeNotificationForTrackingNumber:(NSString *)trackingNumber onSuccess:(ApiClientSuccess)success onFailure:(ApiClientFailure)failure
{
    NSString *xml = [NSString stringWithFormat: @"<SubscribeRequest>"
                     "<ProfileID>%@</ProfileID>"
                     "<ItemNumberList><ItemNumber>%@</ItemNumber></ItemNumberList>"
                     "</SubscribeRequest>", [self notificationProfileID], trackingNumber];
    
    NSMutableURLRequest *request = [self requestWithMethod:@"POST" path:@"ma/notify/subscription/add" parameters:nil];
    [request addValue:@"application/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%d", [xml length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:[xml dataUsingEncoding:NSUTF8StringEncoding]];
    
    AFRaptureXMLRequestOperation *operation = [AFRaptureXMLRequestOperation XMLParserRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, RXMLElement *XMLElement) {
        if (success)
            success(XMLElement);
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, RXMLElement *XMLElement) {
        if (failure)
            failure(error);
    }];
    
    [self enqueueHTTPRequestOperation:operation];
}

@end
