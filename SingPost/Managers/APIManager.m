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

static BOOL isProduction = YES;

static NSString * const GET_METHOD = @"GET";
static NSString * const POST_METHOD = @"POST";

#define SINGPOST_BASE_URL   (isProduction ? SINGPOST_PRODUCTION_BASE_URL:SINGPOST_UAT_BASE_URL)

//Development
static NSString * const SINGPOST_UAT_BASE_URL = @"https://uatesb1.singpost.com";

//Production
static NSString * const SINGPOST_PRODUCTION_BASE_URL = @"https://prdesb1.singpost.com";

//End points
static NSString * const GetItemTrackingDetails = @"ma/GetItemTrackingDetails";
static NSString * const SubscribeTrackingNumber = @"ma/notify/subscription/add";
static NSString * const UnsubscribeTrackingNumber = @"ma/notify/subscription/remove";

@interface APIManager()
@property (strong, nonatomic) AFHTTPClient *httpManager;
@end

@implementation APIManager

SINGLETON_MACRO

#pragma mark - Private methods
- (instancetype)init {
    self = [super init];
    
    if (self) {
        self.httpManager = [[AFHTTPClient alloc]initWithBaseURL:[NSURL URLWithString:SINGPOST_BASE_URL]];
    }
    return self;
}

- (void)sendXMLRequest:(NSURLRequest *)request
               success:(void (^)(NSHTTPURLResponse *response, RXMLElement *responseObject))success
               failure:(void (^)(NSError *error))failure {
    AFRaptureXMLRequestOperation *operation =
    [AFRaptureXMLRequestOperation XMLParserRequestOperationWithRequest:request
                                                               success:^(NSURLRequest *request, NSHTTPURLResponse *response, RXMLElement *XMLElement)
     {
         success(response, XMLElement);
     } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, RXMLElement *XMLElement) {
         DLog(@"%@", [response allHeaderFields]);
         DLog(@"%@",[error description]);
         failure(error);
     }];
    [self.httpManager.operationQueue addOperation:operation];
}

- (void)sendJSONRequest:(NSURLRequest *)request
                success:(void (^)(NSHTTPURLResponse *response, id responseObject))success
                failure:(void (^)(NSError *error))failure {
    AFHTTPRequestOperation *operation =
    [self.httpManager HTTPRequestOperationWithRequest:request
                                              success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         success(operation.response, responseObject);
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         DLog(@"%@", [operation.response allHeaderFields]);
         DLog(@"%@", [error description]);
         failure(error);
     }];
    [self.httpManager.operationQueue addOperation:operation];
}

#pragma mark - Public methods
- (void)getTrackingNumberDetails:(NSString *)trackingNumber
                       completed:(void (^)(Parcel *parcel, NSError *error))completed {
    NSString *xml = [NSString stringWithFormat: @"<ItemTrackingDetailsRequest xmlns=\"http://singpost.com/paw/ns\">"
                     "<ItemTrackingNumbers>"
                     "<TrackingNumber>%@</TrackingNumber>"
                     "</ItemTrackingNumbers>"
                     "</ItemTrackingDetailsRequest>", [trackingNumber uppercaseString]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:GetItemTrackingDetails
                                                                              relativeToURL:[NSURL URLWithString:SINGPOST_BASE_URL]]];
    [request addValue:@"application/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%ld", [xml length]] forHTTPHeaderField:@"Content-Length"];
    request.HTTPBody = [xml dataUsingEncoding:NSUTF8StringEncoding];
    request.HTTPMethod = POST_METHOD;
    
    [self sendXMLRequest:request success:^(NSHTTPURLResponse *response, RXMLElement *responseObject) {
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
            [UIAlertView showWithTitle:NO_INTERNET_ERROR_TITLE
                               message:TRACKED_ITEM_NOT_FOUND_ERROR
                     cancelButtonTitle:@"OK" otherButtonTitles:nil tapBlock:nil];
            completed(nil,nil);
        }
    } failure:^(NSError *error) {
        [[ApiClient sharedInstance]reportAPIIssueURL:[request.URL absoluteString] payload:xml message:[error description]];
        completed(nil,error);
    }];
}

- (void)subscribeTrackingNumberNotification:(NSString *)trackingNumber
                                  completed:(void (^)(NSError *error))completed {
    if ([[ApiClient sharedInstance] hasRegisteredProfileId]) {
        NSString *xml = [NSString stringWithFormat: @"<SubscribeRequest>"
                         "<ProfileID>%@</ProfileID>"
                         "<ItemNumberList><ItemNumber>%@</ItemNumber></ItemNumberList>"
                         "</SubscribeRequest>", [[ApiClient sharedInstance] notificationProfileID],trackingNumber];
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:SubscribeTrackingNumber
                                                                                  relativeToURL:[NSURL URLWithString:SINGPOST_BASE_URL]]];
        [request addValue:@"application/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        [request addValue:[NSString stringWithFormat:@"%ld", [xml length]] forHTTPHeaderField:@"Content-Length"];
        request.HTTPBody = [xml dataUsingEncoding:NSUTF8StringEncoding];
        request.HTTPMethod = POST_METHOD;
        
        [self sendXMLRequest:request success:^(NSHTTPURLResponse *response, RXMLElement *responseObject) {
            completed(nil);
        } failure:^(NSError *error) {
            [[ApiClient sharedInstance]reportAPIIssueURL:[request.URL absoluteString] payload:xml message:[error description]];
            completed(error);
        }];
    }
    else {
        completed([NSError errorWithDomain:ERROR_DOMAIN
                                      code:1
                                  userInfo:@{NSLocalizedDescriptionKey:@"Profile ID not found"}]);
    }
}

- (void)unsubscribeTrackingNumberNotification:(NSString *)trackingNumber
                                    completed:(void (^)(NSError *error))completed {
    if ([[ApiClient sharedInstance] hasRegisteredProfileId]) {
        NSString *xml = [NSString stringWithFormat: @"<UnsubscribeRequest>"
                         "<ProfileID>%@</ProfileID>"
                         "<ItemNumberList><ItemNumber>%@</ItemNumber></ItemNumberList>"
                         "</UnsubscribeRequest>", [[ApiClient sharedInstance] notificationProfileID], trackingNumber];
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:UnsubscribeTrackingNumber
                                                                                  relativeToURL:[NSURL URLWithString:SINGPOST_BASE_URL]]];
        [request addValue:@"application/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        [request addValue:[NSString stringWithFormat:@"%ld", [xml length]] forHTTPHeaderField:@"Content-Length"];
        request.HTTPBody = [xml dataUsingEncoding:NSUTF8StringEncoding];
        request.HTTPMethod = POST_METHOD;
        
        [self sendXMLRequest:request success:^(NSHTTPURLResponse *response, RXMLElement *responseObject) {
            completed(nil);
        } failure:^(NSError *error) {
            [[ApiClient sharedInstance]reportAPIIssueURL:[request.URL absoluteString] payload:xml message:[error description]];
            completed(error);
        }];
    }
    else {
        completed([NSError errorWithDomain:ERROR_DOMAIN
                                      code:1
                                  userInfo:@{NSLocalizedDescriptionKey:@"Profile ID not found"}]);
    }
}

@end
