//
//  APIManager.m
//  SingPost
//
//  Created by Wei Guang Heng on 07/07/2015.
//  Copyright (c) 2015 Codigo. All rights reserved.
//

#import "APIManager.h"
#import "ApiClient.h"
#import "AFNetworking.h"
#import "DatabaseManager.h"
#import "PushNotification.h"
#import "UserDefaultsManager.h"
#import "UIAlertView+Blocks.h"
#import "DeviceUtil.h"
#import "SAMKeychain.h"

static NSString * const POST_METHOD = @"POST";

static NSString * const SINGPOST_BASE_URL = @"https://prdesb1.singpost.com";
static NSString * const CMS_BASE_URL = @"http://mobile.singpost.com/singpost3/api/";

static NSString *const APP_ID = @"M00002";
static NSString *const OS = @"ios";

//End points
static NSString * const GetItemTrackingDetails = @"ma/GetItemTrackingDetails";

@interface APIManager()
@property (strong, nonatomic) AFHTTPSessionManager *manager;

@end

@implementation APIManager

@synthesize serverToken;
@synthesize fbToken;
@synthesize allTrackingItem;
@synthesize fbID;

@synthesize notificationProfileID = _notificationProfileID;

SINGLETON_MACRO

#pragma mark - Properties

- (BOOL)hasRegisteredProfileId
{
    return [[self notificationProfileID] length] > 0;
}

- (NSString *)notificationProfileID
{
    if (!_notificationProfileID) {
        _notificationProfileID = [SAMKeychain passwordForService:KEYCHAIN_SERVICENAME account:@"SETTINGS_PROFILEID"];
    }
    return _notificationProfileID;
}

- (void)setNotificationProfileID:(NSString *)inNotificationProfileID
{
    if (inNotificationProfileID.length > 0) {
        _notificationProfileID = inNotificationProfileID;
        [SAMKeychain setPassword:_notificationProfileID forService:KEYCHAIN_SERVICENAME account:@"SETTINGS_PROFILEID"];
    }
}

#pragma mark - Private methods
- (instancetype)init {
    self = [super init];
    if (self) {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        self.manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:configuration];
        
        AFSecurityPolicy *policy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        policy.allowInvalidCertificates = YES;
        policy.validatesDomainName = NO;
        
        self.manager.securityPolicy = policy;
        
        [self.manager setDataTaskWillCacheResponseBlock:^NSCachedURLResponse *(NSURLSession *session, NSURLSessionDataTask *dataTask, NSCachedURLResponse *proposedResponse)
         {
             NSHTTPURLResponse *resp = (NSHTTPURLResponse*)proposedResponse.response;
             NSMutableDictionary *newHeaders = [[resp allHeaderFields] mutableCopy];
             if (newHeaders[@"Cache-Control"] == nil) {
                 newHeaders[@"Cache-Control"] = @"max-age=120, public";
             }
             
             //             NSHTTPURLResponse *response2 = [[NSHTTPURLResponse alloc] initWithURL:resp.URL statusCode:resp.statusCode HTTPVersion:@"1.1" headerFields:newHeaders];
             
             NSURLResponse *response2 = [[NSHTTPURLResponse alloc] initWithURL:resp.URL statusCode:resp.statusCode HTTPVersion:nil headerFields:newHeaders];
             NSCachedURLResponse *cachedResponse2 = [[NSCachedURLResponse alloc] initWithResponse:response2
                                                                                             data:[proposedResponse data]
                                                                                         userInfo:[proposedResponse userInfo]
                                                                                    storagePolicy:NSURLCacheStorageAllowed];
             return cachedResponse2;
         }];
        
    }
    return self;
}

- (void)sendXMLRequest:(NSMutableURLRequest *)request
               success:(void (^)(NSURLResponse *response, RXMLElement *responseObject))success
               failure:(void (^)(NSError *error))failure {
    
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [self.manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/xml"];
    
//    [request setTimeoutInterval:5];

    
    NSURLSessionDataTask *dataTask = [self.manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Api Manager Error URL: %@",request.URL.absoluteString);
            NSLog(@"API Manager Error: %@", error);
            failure(error);
        } else {
            RXMLElement *rootXml = [RXMLElement elementFromXMLData:responseObject];
            success(response, rootXml);
            NSLog(@"Api Manager Success URL: %@",request.URL.absoluteString);
            NSLog(@"Api Manager Success %@",rootXml);
            
        }
    }];
    [dataTask resume];
}


//- (void)sendXMLRequest:(NSURLRequest *)request
//               success:(void (^)(NSHTTPURLResponse *response, RXMLElement *responseObject))success
//               failure:(void (^)(NSError *error))failure {
//    AFRaptureXMLRequestOperation *operation =
//    [AFRaptureXMLRequestOperation XMLParserRequestOperationWithRequest:request
//                                                               success:^(NSURLRequest *request, NSHTTPURLResponse *response, RXMLElement *XMLElement)
//     {
//         success(response, XMLElement);
//     } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, RXMLElement *XMLElement) {
//         DLog(@"%@", [response allHeaderFields]);
//         DLog(@"%@",[error description]);
//         failure(error);
//     }];
//    [self.httpManager.operationQueue addOperation:operation];
//}

//- (void)sendJSONRequest:(NSMutableURLRequest *)request
//                success:(void (^)(NSURLResponse *response, id responseObject))success
//                failure:(void (^)(NSError *error))failure {
//    
//    self.manager.responseSerializer.acceptableContentTypes = [AFHTTPResponseSerializer serializer].acceptableContentTypes;
//    
//    request.timeoutInterval=5;
//    
//    NSURLSessionDataTask *dataTask = [self.manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
//        if (error) {
//            NSLog(@"Error: %@", error);
//            failure(error);
//        } else {
//            NSDictionary *jsonDict  = (NSDictionary *) responseObject;
//            success(response,jsonDict);
//            NSLog(@"%@",jsonDict);
//        }
//    }];
//    [dataTask resume];
//
//}

//- (void)sendJSONRequest:(NSURLRequest *)request
//                success:(void (^)(NSHTTPURLResponse *response, id responseObject))success
//                failure:(void (^)(NSError *error))failure {
//    AFHTTPRequestOperation *operation =
//    [self.httpManager HTTPRequestOperationWithRequest:request
//                                              success:^(AFHTTPRequestOperation *operation, id responseObject)
//     {
//         success(operation.response, responseObject);
//     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//         DLog(@"%@", [operation.response allHeaderFields]);
//         DLog(@"%@", [error description]);
//         failure(error);
//     }];
//    [self.httpManager.operationQueue addOperation:operation];
//}

#pragma mark - Tracking number
- (void)getTrackingNumberDetails:(NSString *)trackingNumber
                       completed:(void (^)(Parcel *parcel, NSError *error))completed {
    NSString *xml = [NSString stringWithFormat: @"<ItemTrackingDetailsRequest xmlns=\"http://singpost.com/paw/ns\">"
                     "<ItemTrackingNumbers>"
                     "<TrackingNumber>%@</TrackingNumber>"
                     "</ItemTrackingNumbers>"
                     "</ItemTrackingDetailsRequest>", [trackingNumber uppercaseString]];
    
    NSString *urlString = [NSString stringWithFormat:@"%@/ma/GetItemTrackingDetails",SINGPOST_BASE_URL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    [request addValue:@"application/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%ld", (  long)[xml length]] forHTTPHeaderField:@"Content-Length"];
    request.HTTPBody = [xml dataUsingEncoding:NSUTF8StringEncoding];
    request.HTTPMethod = POST_METHOD;
    
    [self sendXMLRequest:request success:^(NSURLResponse *response, RXMLElement *responseObject) {
        //Subscribe to notification if enabled
        if ([[UserDefaultsManager sharedInstance] getNotificationStatus]) {
            [PushNotificationManager API_subscribeNotificationForTrackingNumber:trackingNumber
                                                                   onCompletion:^(BOOL success, NSError *error){}];
        }
        //Save XML to database
        RXMLElement *itemsTrackingDetailList = [responseObject child:@"ItemsTrackingDetailList"];
        RXMLElement *itemTrackingDetail = [[itemsTrackingDetailList children:@"ItemTrackingDetail"] firstObject];
        
        if (itemTrackingDetail != nil)
            completed([DatabaseManager createOrUpdateParcel:itemTrackingDetail],nil);
        else {
//            [UIAlertView showWithTitle:NO_INTERNET_ERROR_TITLE
//                               message:TRACKED_ITEM_NOT_FOUND_ERROR
//                     cancelButtonTitle:@"OK" otherButtonTitles:nil tapBlock:nil];
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:NO_INTERNET_ERROR_TITLE message:TRACKED_ITEM_NOT_FOUND_ERROR preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [alert addAction:ok];
            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
            
            completed(nil,nil);
        }
    } failure:^(NSError *error) {
        [[ApiClient sharedInstance]reportAPIIssueURL:[request.URL absoluteString] payload:xml message:[error description]];
        completed(nil,error);
    }];
}

#pragma mark - Calculate Postage

- (void)calculateSingaporePostageForFromPostalCode:(NSString *)fromPostalCode
                                   andToPostalCode:(NSString *)toPostalCode
                                         andWeight:(NSString *)weightInGrams
                                         onSuccess:(ApiClientSuccess)success
                                         onFailure:(ApiClientFailure)failure {
    NSString *xml = [NSString stringWithFormat:@"<SingaporePostalInfoDetailsRequest xmlns=\"http://singpost.com/paw/ns\">"
                     "<ToPostalCode>%@</ToPostalCode>"
                     "<FromPostalCode>%@</FromPostalCode>"
                     "<Weight>%@</Weight>"
                     "<DeliveryServiceName></DeliveryServiceName>"
                     "</SingaporePostalInfoDetailsRequest>", toPostalCode, fromPostalCode, weightInGrams];
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL: [NSURL URLWithString:@"/ma/FilterSingaporePostalInfo" relativeToURL:[NSURL URLWithString: SINGPOST_BASE_URL]]];
    
    [request addValue:@"application/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%ld", (unsigned long)[xml length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:[xml dataUsingEncoding:NSUTF8StringEncoding]];
    request.HTTPMethod = POST_METHOD;
    
    
    [self sendXMLRequest:request success:^(NSURLResponse *response, RXMLElement *responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        failure(error);
//        [self reportAPIIssueURL:[request.URL absoluteString] payload:xml message:[error description]];
    }];
    
}

- (void)calculateOverseasPostageForCountryCode:(NSString *)countryCode
                                     andWeight:(NSString *)weightInGrams
                               andItemTypeCode:(NSString *)itemTypeCode
                               andDeliveryCode:(NSString *)deliveryCode
                                     onSuccess:(ApiClientSuccess)success
                                     onFailure:(ApiClientFailure)failure {
    if (deliveryCode == nil || [deliveryCode length] <= 0)
        deliveryCode = @"999";
    
    NSString *xml = [NSString stringWithFormat:@"<OverseasPostalInfoDetailsRequest xmlns=\"http://singpost.com/paw/ns\">"
                     "<Country>%@</Country>"
                     "<Weight>%@</Weight>"
                     "<DeliveryServiceName></DeliveryServiceName>"
                     "<ItemType>%@</ItemType>"
                     "<PriceRange>999</PriceRange>"
                     "<DeliveryTimeRange>%@</DeliveryTimeRange>"
                     "</OverseasPostalInfoDetailsRequest>", countryCode, weightInGrams, itemTypeCode, deliveryCode];
    
    NSString *urlString = [NSString stringWithFormat:@"%@/ma/FilterOverseasPostalInfo",SINGPOST_BASE_URL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    [request addValue:@"application/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%ld", (unsigned long)[xml length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:[xml dataUsingEncoding:NSUTF8StringEncoding]];
    request.HTTPMethod = POST_METHOD;
    
    [self sendXMLRequest:request success:^(NSURLResponse *response, RXMLElement *responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        failure(error);
//        [self reportAPIIssueURL:[request.URL absoluteString] payload:xml message:[error description]];
    }];
}


#pragma mark - Postal Code

- (void)findPostalCodeForBuildingNo:(NSString *)buildingNo
                      andStreetName:(NSString *)streetName
                          onSuccess:(ApiClientSuccess)success
                          onFailure:(ApiClientFailure)failure {
    NSString *xml = [NSString stringWithFormat:@"<PostalCodeByStreetDetailsRequest xmlns=\"http://singpost.com/paw/ns\">"
                     "<BuildingNo>%@</BuildingNo>"
                     "<StreetName>%@</StreetName>"
                     "</PostalCodeByStreetDetailsRequest>", buildingNo, streetName];
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL: [NSURL URLWithString:@"ma/PostalCodebyStreet" relativeToURL:[NSURL URLWithString: SINGPOST_BASE_URL]]];
    
    [request addValue:@"application/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%ld", (unsigned long)[xml length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:[xml dataUsingEncoding:NSUTF8StringEncoding]];
    request.HTTPMethod = POST_METHOD;
    
    [self sendXMLRequest:request success:^(NSURLResponse *response, RXMLElement *responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        failure(error);
        [self reportAPIIssueURL:[request.URL absoluteString] payload:xml message:[error description]];
    }];
}

- (void)findPostalCodeForLandmark:(NSString *)landmark
                        onSuccess:(ApiClientSuccess)success
                        onFailure:(ApiClientFailure)failure {
    NSString *xml = [NSString stringWithFormat:@"<PostalAddressByLandMarkDetailsRequest  xmlns=\"http://singpost.com/paw/ns\"><BuildingName>%@</BuildingName></PostalAddressByLandMarkDetailsRequest>", landmark];
    
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL: [NSURL URLWithString:@"ma/PostalAddressbyLandMark" relativeToURL:[NSURL URLWithString: SINGPOST_BASE_URL]]];
    [request addValue:@"application/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%ld", (unsigned long)[xml length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:[xml dataUsingEncoding:NSUTF8StringEncoding]];
    request.HTTPMethod = POST_METHOD;
    
    [self sendXMLRequest:request success:^(NSURLResponse *response, RXMLElement *responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        failure(error);
        [self reportAPIIssueURL:[request.URL absoluteString] payload:xml message:[error description]];
    }];
}

- (void)findPostalCodeForWindowsDeliveryNo:(NSString *)windowsDeliveryNo andType:(NSString *)type andPostOffice:(NSString *)postOffice onSuccess:(ApiClientSuccess)success onFailure:(ApiClientFailure)failure
{
    NSString *xml = [NSString stringWithFormat:@"<PostalCodeByPOBoxDetailsRequest xmlns=\"http://singpost.com/paw/ns\"><WindowDeliveryNo>%@</WindowDeliveryNo><Type>%@</Type><PostOffice>%@</PostOffice></PostalCodeByPOBoxDetailsRequest>", windowsDeliveryNo, type, postOffice];
    
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL: [NSURL URLWithString:@"ma/PostalCodebyPOBox" relativeToURL:[NSURL URLWithString: SINGPOST_BASE_URL]]];
    [request addValue:@"application/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%ld", (unsigned long)[xml length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:[xml dataUsingEncoding:NSUTF8StringEncoding]];
    request.HTTPMethod = POST_METHOD;
    
    [self sendXMLRequest:request success:^(NSURLResponse *response, RXMLElement *responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        failure(error);
        [self reportAPIIssueURL:[request.URL absoluteString] payload:xml message:[error description]];
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
    
    NSString *urlString = [NSString stringWithFormat:@"%@/ma/notify/registration/add",SINGPOST_BASE_URL];
    
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL: [NSURL URLWithString:urlString]];
    
    [request addValue:@"application/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%ld", (unsigned long)[xml length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:[xml dataUsingEncoding:NSUTF8StringEncoding]];
    request.HTTPMethod = POST_METHOD;
    
    [self sendXMLRequest:request success:^(NSURLResponse *response, RXMLElement *responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        failure(error);
        double delayInSeconds = 30;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^{
            [self registerAPNSToken:apnsToken onSuccess:^(id responseObject){} onFailure:^(NSError *error){}];
        });
        [self reportAPIIssueURL:[request.URL absoluteString] payload:xml message:[error description]];
    }];
    
    
}

- (void)subscribeNotificationForTrackingNumber:(NSString *)trackingNumber onSuccess:(ApiClientSuccess)success onFailure:(ApiClientFailure)failure
{
    NSString *xml = [NSString stringWithFormat: @"<SubscribeRequest>"
                     "<ProfileID>%@</ProfileID>"
                     "<ItemNumberList><ItemNumber>%@</ItemNumber></ItemNumberList>"
                     "</SubscribeRequest>", [self notificationProfileID], trackingNumber];
    NSString *urlString = [NSString stringWithFormat:@"%@/ma/notify/subscription/add",SINGPOST_BASE_URL];
    
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL: [NSURL URLWithString:urlString]];
    
    [request addValue:@"application/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%ld", (unsigned long)[xml length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:[xml dataUsingEncoding:NSUTF8StringEncoding]];
    request.HTTPMethod = POST_METHOD;
    
    [self sendXMLRequest:request success:^(NSURLResponse *response, RXMLElement *responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        failure(error);
        [self reportAPIIssueURL:[request.URL absoluteString] payload:xml message:[error description]];
    }];
    
}

- (void)subscribeNotificationForTrackingNumberArray:(NSArray *)trackingNumberArray
                                          onSuccess:(ApiClientSuccess)success onFailure:(ApiClientFailure)failure {
    NSString *xml = [NSString stringWithFormat: @"<SubscribeRequest>"
                     "<ProfileID>%@</ProfileID>"
                     "<ItemNumberList>", [self notificationProfileID]];
    
    for(NSString * itemNumber in trackingNumberArray) {
        xml = [xml stringByAppendingString:[NSString stringWithFormat:@"<ItemNumber>%@</ItemNumber>",itemNumber]];
    }
    xml = [xml stringByAppendingString:@"</ItemNumberList>""</SubscribeRequest>"];
    
    NSString *urlString = [NSString stringWithFormat:@"%@/ma/notify/subscription/add",SINGPOST_BASE_URL];
    
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL: [NSURL URLWithString:urlString]];
    
    [request addValue:@"application/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%ld", (unsigned long)[xml length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:[xml dataUsingEncoding:NSUTF8StringEncoding]];
    request.HTTPMethod = POST_METHOD;
    
    [self sendXMLRequest:request success:^(NSURLResponse *response, RXMLElement *responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        failure(error);
        [self reportAPIIssueURL:[request.URL absoluteString] payload:xml message:[error description]];
    }];
}

- (void)unsubscribeNotificationForTrackingNumber:(NSString *)trackingNumber onSuccess:(ApiClientSuccess)success onFailure:(ApiClientFailure)failure
{
    NSString *xml = [NSString stringWithFormat: @"<UnsubscribeRequest>"
                     "<ProfileID>%@</ProfileID>"
                     "<ItemNumberList><ItemNumber>%@</ItemNumber></ItemNumberList>"
                     "</UnsubscribeRequest>", [self notificationProfileID], trackingNumber];
    
    NSString *urlString = [NSString stringWithFormat:@"%@/ma/notify/subscription/remove",SINGPOST_BASE_URL];
    
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL: [NSURL URLWithString:urlString]];
    
    [request addValue:@"application/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%ld", (unsigned long)[xml length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:[xml dataUsingEncoding:NSUTF8StringEncoding]];
    request.HTTPMethod = POST_METHOD;
    
    [self sendXMLRequest:request success:^(NSURLResponse *response, RXMLElement *responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        failure(error);
        [self reportAPIIssueURL:[request.URL absoluteString] payload:xml message:[error description]];
    }];
}

- (void)unsubscribeNotificationForTrackingNumberArray:(NSArray *)trackingNumberArray onSuccess:(ApiClientSuccess)success onFailure:(ApiClientFailure)failure
{
    NSString *xml = [NSString stringWithFormat: @"<UnsubscribeRequest>"
                     "<ProfileID>%@</ProfileID>"
                     "<ItemNumberList>", [self notificationProfileID]];
    
    for(NSString * itemNumber in trackingNumberArray) {
        xml = [xml stringByAppendingString:[NSString stringWithFormat:@"<ItemNumber>%@</ItemNumber>",itemNumber]];
    }
    xml = [xml stringByAppendingString:@"</ItemNumberList>""</UnsubscribeRequest>"];
    
    NSString *urlString = [NSString stringWithFormat:@"%@/ma/notify/subscription/remove",SINGPOST_BASE_URL];
    
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL: [NSURL URLWithString:urlString]];
    
    [request addValue:@"application/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%ld", (unsigned long)[xml length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:[xml dataUsingEncoding:NSUTF8StringEncoding]];
    request.HTTPMethod = POST_METHOD;
    
    [self sendXMLRequest:request success:^(NSURLResponse *response, RXMLElement *responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        failure(error);
        [self reportAPIIssueURL:[request.URL absoluteString] payload:xml message:[error description]];
    }];
    
}





@end
