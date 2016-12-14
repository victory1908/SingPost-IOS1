//
//  Constants.h
//  SingPost
//
//  Created by Edward Soetiono on 28/9/13.
//  Copyright (c) 2013 Codigo. All rights reserved.
//

#define FACEBOOK_UAT_KEY @"1459873204283423"

#define SINGPOST_ITUNES_STORE_URL @"https://itunes.apple.com/sg/app/singpost-mobile/id647986630"

#define SIDEBAR_WIDTH 275.0f

//#define ERROR_DOMAIN @"com.codigo.singpost.errordomain"

#define ERROR_DOMAIN @"com.codigo.singpost.errordomain"

#define KEYCHAIN_SERVICENAME @"KEYCHAIN_SINGPOST"

//SingPost Production
#define GAI_SINGPOST_ID @"UA-37021472-1"

//SingPost Pilot
#define GAI_PILOT_ID @"UA-49593258-1"

//Codigo
#define GAI_ID @"UA-46197062-1"

//Error messages
#define INCOMPLETE_FIELDS_ERROR             @"Please ensure that all fields are entered correctly."
//#define NO_INTERNET_ERROR_TITLE             @"Something has gone wrong!"
//#define NO_INTERNET_ERROR_TITLE             @"Something has gone wrong!"
#define NO_INTERNET_ERROR_TITLE             @"No internet connection detected "
//#define NO_INTERNET_ERROR                   @"Connection to the server failed. Please try again later."
#define NO_INTERNET_ERROR                   @"Application in Offline Mode"

//#define NO_INTERNET_ERRORDOMAIN_TITLE             @"Server cannot be reached"
//#define NO_INTERNET_ERRORDOMAIN_MESSAGE           @"A server with the specified hostname could not be found, check your internet connection"
#define NO_INTERNET_ERRORDOMAIN_TITLE             @" Connection Error"
#define NO_INTERNET_ERRORDOMAIN_MESSAGE           @" There seems to be a problem with your internet connection. Please check firewall settings (if any) or data limit settings (if any)"


#define NO_INTERNET_ERROR_LOST_TITLE             @"Network Connection lost"
#define NO_INTERNET_ERROR_LOST_MESSAGE             @"The network connection was lost"


#define NO_INTERNET_ERROR_MESSAGE2       @"The Internet connection appears to be offline"



#define NO_RESULTS_ERROR                    @"Sorry, there are no results found. Please try again."
#define NO_TRACKING_NUMBER_ERROR            @"Please enter tracking number."
#define INVALID_TRACKING_NUMBER_ERROR       @"Please enter a valid tracking number."
#define TRACKED_ITEM_NOT_FOUND_ERROR        @"Item number incorrect or tracking status for this item is not yet updated. Please try again later."
#define NEW_TRACKED_ITEM_NOT_FOUND_ERROR    @"Item number incorrect or tracking status for this item is not yet updated. Please try again later. This number will be stored for your easy reference later."
#define ERRORCODE1001_MESSAGE               @"We are now encountering very high traffic in our system, please try again later."
#define ITEM_NUMBER_NOT_FOUND               @"Item number not found. Please check the number."
#define AdMobUnitId                         @"ca-app-pub-6540469093687715/9212584780"

//#define AdBannerHeight = [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) ? 50 : 90

//#define adMobUnitHeight ( (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 90 : 50 )
#define adMobUnitHeight ( (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 0 : 0 )
