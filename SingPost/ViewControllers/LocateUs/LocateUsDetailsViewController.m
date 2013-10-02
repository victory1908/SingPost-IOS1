//
//  LocateUsDetailsViewController.m
//  SingPost
//
//  Created by Edward Soetiono on 1/10/13.
//  Copyright (c) 2013 Codigo. All rights reserved.
//

#import "LocateUsDetailsViewController.h"
#import "NavigationBarView.h"
#import "EntityLocation.h"

#import <MapKit/MapKit.h>
#import <RegexKitLite.h>

#import "EntityLocationMapAnnotation.h"
#import "UIFont+SingPost.h"
#import "UIColor+SingPost.h"
#import "SectionToggleButton.h"
#import "UIView+Position.h"

#import "LocateUsDetailsOpeningHoursView.h"

@interface LocateUsDetailsViewController () <MKMapViewDelegate>

@end

typedef enum  {
    LOCATEUSDETAILS_SECTION_OPENINGHOURS,
    LOCATEUSDETAILS_SECTION_SERVICES,
    LOCATEUSDETAILS_SECTION_POSTINGBOX
} tLocateUsDetailsSections;

@implementation LocateUsDetailsViewController
{
    tLocateUsDetailsSections currentSection;
    EntityLocation *_entityLocation;
    MKMapView *locationMapView;
    UILabel *addressLabel;
    UIButton *selectedSectionIndicatorButton;
    UIImageView *isOpenedIndicatorImageView, *addressImageView;
    UIScrollView *sectionContentScrollView;
    SectionToggleButton *openingHoursSectionButton, *servicesSectionButton, *postingBoxSectionButton;
    
    LocateUsDetailsOpeningHoursView *openingHoursSectionView;
}

//designated initializer
- (id)initWithEntityLocation:(EntityLocation *)inEntityLocation
{
    NSParameterAssert(inEntityLocation);
    if ((self = [super initWithNibName:nil bundle:nil])) {
        _entityLocation = inEntityLocation;
    }
    
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    return [self initWithEntityLocation:nil];
}

- (void)loadView
{
    UIView *contentView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [contentView setBackgroundColor:RGB(250, 250, 250)];
    
    NavigationBarView *navigationBarView = [[NavigationBarView alloc] initWithFrame:NAVIGATIONBAR_FRAME];
    [navigationBarView setTitle:_entityLocation.name];
    [navigationBarView setShowBackButton:YES];
    [contentView addSubview:navigationBarView];
    
    UIScrollView *contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 44, contentView.bounds.size.width, contentView.bounds.size.height - navigationBarView.bounds.size.height - [UIApplication sharedApplication].statusBarFrame.size.height)];
    [contentScrollView setBackgroundColor:[UIColor clearColor]];
    [contentScrollView setContentSize:CGSizeMake(contentScrollView.bounds.size.width, 504)];
    [contentView addSubview:contentScrollView];
    
    locationMapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, contentView.bounds.size.width, 200)];
    locationMapView.showsUserLocation = YES;
    locationMapView.delegate = self;
    [contentScrollView addSubview:locationMapView];
    
    addressImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 217, 35, 35)];
    [addressImageView setContentMode:UIViewContentModeCenter];
    [contentScrollView addSubview:addressImageView];
    
    addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 211, 190, 44)];
    [addressLabel setFont:[UIFont SingPostRegularFontOfSize:14.0f fontKey:kSingPostFontOpenSans]];
    [addressLabel setTextColor:RGB(51, 51, 51)];
    [addressLabel setNumberOfLines:2];
    [addressLabel setAdjustsFontSizeToFitWidth:YES];
    [addressLabel setBackgroundColor:[UIColor clearColor]];
    [contentScrollView addSubview:addressLabel];
    
    isOpenedIndicatorImageView = [[UIImageView alloc] initWithFrame:CGRectMake(255, 230, 10, 10)];
    [contentScrollView addSubview:isOpenedIndicatorImageView];
    
    UIButton *showMapRouteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [showMapRouteButton setImage:[UIImage imageNamed:@"search_map_button"] forState:UIControlStateNormal];
    [showMapRouteButton setFrame:CGRectMake(270, 212, 44, 44)];
    [showMapRouteButton addTarget:self action:@selector(showMapRouteButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [contentScrollView addSubview:showMapRouteButton];
    
    UIView *topSeparatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 266, contentView.bounds.size.width, 1)];
    [topSeparatorView setBackgroundColor:RGB(196, 197, 200)];
    [contentScrollView addSubview:topSeparatorView];
    
    UIView *bottomSeparatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 317, contentView.bounds.size.width, 1)];
    [bottomSeparatorView setBackgroundColor:RGB(196, 197, 200)];
    [contentScrollView addSubview:bottomSeparatorView];
    
    openingHoursSectionButton = [[SectionToggleButton alloc] initWithFrame:CGRectMake(0, 267, 107, 50)];
    [openingHoursSectionButton setTag:LOCATEUSDETAILS_SECTION_OPENINGHOURS];
    [openingHoursSectionButton.titleLabel setFont:[UIFont SingPostBoldFontOfSize:12.0f fontKey:kSingPostFontOpenSans]];
    [openingHoursSectionButton addTarget:self action:@selector(sectionButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [openingHoursSectionButton setTitle:@"Opening hours" forState:UIControlStateNormal];
    [contentScrollView addSubview:openingHoursSectionButton];
    
    servicesSectionButton = [[SectionToggleButton alloc] initWithFrame:CGRectMake(107, 267, 107, 50)];
    [servicesSectionButton setTag:LOCATEUSDETAILS_SECTION_SERVICES];
    [servicesSectionButton.titleLabel setFont:[UIFont SingPostBoldFontOfSize:12.0f fontKey:kSingPostFontOpenSans]];
    [servicesSectionButton addTarget:self action:@selector(sectionButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [servicesSectionButton setTitle:@"Services" forState:UIControlStateNormal];
    [contentScrollView addSubview:servicesSectionButton];
    
    postingBoxSectionButton = [[SectionToggleButton alloc] initWithFrame:CGRectMake(214, 267, 108, 50)];
    [postingBoxSectionButton setTag:LOCATEUSDETAILS_SECTION_POSTINGBOX];
    [postingBoxSectionButton.titleLabel setFont:[UIFont SingPostBoldFontOfSize:12.0f fontKey:kSingPostFontOpenSans]];
    [postingBoxSectionButton addTarget:self action:@selector(sectionButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [postingBoxSectionButton setTitle:@"Posting Box" forState:UIControlStateNormal];
    [contentScrollView addSubview:postingBoxSectionButton];
    
    selectedSectionIndicatorButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [selectedSectionIndicatorButton setBackgroundColor:RGB(36, 84, 157)];
    [selectedSectionIndicatorButton.titleLabel setFont:[UIFont SingPostBoldFontOfSize:12.0f fontKey:kSingPostFontOpenSans]];
    [selectedSectionIndicatorButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [selectedSectionIndicatorButton setFrame:openingHoursSectionButton.frame];
    [contentScrollView addSubview:selectedSectionIndicatorButton];
    
    UIImageView *selectedIndicatorImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"selected_indicator"]];
    [selectedIndicatorImageView setFrame:CGRectMake((int)(selectedSectionIndicatorButton.bounds.size.width / 2) - 8, selectedSectionIndicatorButton.bounds.size.height, 17, 8)];
    [selectedSectionIndicatorButton addSubview:selectedIndicatorImageView];
    
    sectionContentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 318, contentScrollView.bounds.size.width, contentScrollView.contentSize.height - 318)];
    [sectionContentScrollView setBackgroundColor:[UIColor clearColor]];
    [sectionContentScrollView setDelaysContentTouches:NO];
    [sectionContentScrollView setPagingEnabled:YES];
    [sectionContentScrollView setScrollEnabled:NO];
    [contentScrollView addSubview:sectionContentScrollView];
    
    openingHoursSectionView = [[LocateUsDetailsOpeningHoursView alloc] initWithLocation:_entityLocation andFrame:CGRectMake(sectionContentScrollView.bounds.size.width * LOCATEUSDETAILS_SECTION_OPENINGHOURS, 0, sectionContentScrollView.bounds.size.width, sectionContentScrollView.bounds.size.height)];
    [sectionContentScrollView addSubview:openingHoursSectionView];
    
    UIPanGestureRecognizer *sectionSelectionPanGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleSectionSelectionPanGesture:)];
    [selectedSectionIndicatorButton addGestureRecognizer:sectionSelectionPanGestureRecognizer];
    
    self.view = contentView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //map
    MKCoordinateRegion mapRegion;
    mapRegion.center = CLLocationCoordinate2DMake(_entityLocation.latitude.floatValue, _entityLocation.longitude.floatValue);
    mapRegion.span = MKCoordinateSpanMake(0.016, 0.016);
    [locationMapView setRegion:mapRegion animated:YES];
    
    EntityLocationMapAnnotation *locationAnnotation = [[EntityLocationMapAnnotation alloc] initWithEntityLocation:_entityLocation];
    [locationMapView addAnnotation:locationAnnotation];
    
    //fields
    [addressLabel setText:_entityLocation.address];
    [isOpenedIndicatorImageView setImage:[UIImage imageNamed:_entityLocation.isOpened ? @"green_circle" : @"red_circle"]];
    
    if ([_entityLocation.type isEqualToString:LOCATION_TYPE_POST_OFFICE])
        [addressImageView setImage:[UIImage imageNamed:@"postoffice_icon"]];
    else if ([_entityLocation.type isEqualToString:LOCATION_TYPE_POSTING_BOX])
        [addressImageView setImage:[UIImage imageNamed:@"postingbox_icon"]];
    else if ([_entityLocation.type isEqualToString:LOCATION_TYPE_SAM])
        [addressImageView setImage:[UIImage imageNamed:@"SAM"]];
    
    [self goToSection:LOCATEUSDETAILS_SECTION_OPENINGHOURS];
}

- (void)handleSectionSelectionPanGesture:(UIPanGestureRecognizer *)gestureRecognizer
{
    CGPoint translation = [gestureRecognizer translationInView:self.view];
    gestureRecognizer.view.center = CGPointMake(gestureRecognizer.view.center.x + translation.x, gestureRecognizer.view.center.y);
    [gestureRecognizer.view setX:MIN(MAX(0, gestureRecognizer.view.frame.origin.x), self.view.bounds.size.width - gestureRecognizer.view.bounds.size.width)];
    [gestureRecognizer setTranslation:CGPointZero inView:self.view];
    
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        [self resignAllResponders];;
    }
    else if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        if (CGRectContainsPoint(openingHoursSectionButton.frame, gestureRecognizer.view.center))
            [self goToSection:LOCATEUSDETAILS_SECTION_OPENINGHOURS];
        else if (CGRectContainsPoint(servicesSectionButton.frame, gestureRecognizer.view.center))
            [self goToSection:LOCATEUSDETAILS_SECTION_SERVICES];
        else if (CGRectContainsPoint(postingBoxSectionButton.frame, gestureRecognizer.view.center))
            [self goToSection:LOCATEUSDETAILS_SECTION_POSTINGBOX];
    }
    else {
        if (CGRectContainsPoint(openingHoursSectionButton.frame, gestureRecognizer.view.center))
            [selectedSectionIndicatorButton setTitle:@"Opening hours" forState:UIControlStateNormal];
        else if (CGRectContainsPoint(servicesSectionButton.frame, gestureRecognizer.view.center))
            [selectedSectionIndicatorButton setTitle:@"Services" forState:UIControlStateNormal];
        else if (CGRectContainsPoint(postingBoxSectionButton.frame, gestureRecognizer.view.center))
            [selectedSectionIndicatorButton setTitle:@"Posting Box" forState:UIControlStateNormal];
    }
}

- (void)goToSection:(tLocateUsDetailsSections)section
{
    currentSection = section;
    
    if (currentSection == LOCATEUSDETAILS_SECTION_OPENINGHOURS)
        [selectedSectionIndicatorButton setTitle:@"Opening hours" forState:UIControlStateNormal];
    else if (currentSection == LOCATEUSDETAILS_SECTION_SERVICES)
        [selectedSectionIndicatorButton setTitle:@"Services" forState:UIControlStateNormal];
    else if (currentSection == LOCATEUSDETAILS_SECTION_POSTINGBOX)
        [selectedSectionIndicatorButton setTitle:@"Posting Box" forState:UIControlStateNormal];
    
    [sectionContentScrollView setContentOffset:CGPointMake(currentSection * sectionContentScrollView.bounds.size.width, 0) animated:YES];
    
    [UIView animateWithDuration:0.3f animations:^{
        if (currentSection == LOCATEUSDETAILS_SECTION_OPENINGHOURS)
            [selectedSectionIndicatorButton setFrame:openingHoursSectionButton.frame];
        else if (currentSection == LOCATEUSDETAILS_SECTION_SERVICES)
            [selectedSectionIndicatorButton setFrame:servicesSectionButton.frame];
        else if (currentSection == LOCATEUSDETAILS_SECTION_POSTINGBOX)
            [selectedSectionIndicatorButton setFrame:postingBoxSectionButton.frame];
    }];
}

- (void)resignAllResponders
{
    [sectionContentScrollView endEditing:YES];
}

#pragma mark - IBActions

- (IBAction)sectionButtonClicked:(id)sender
{
    if (sender == openingHoursSectionButton)
        [self goToSection:LOCATEUSDETAILS_SECTION_OPENINGHOURS];
    else if (sender == servicesSectionButton)
        [self goToSection:LOCATEUSDETAILS_SECTION_SERVICES];
    else if (sender == postingBoxSectionButton)
        [self goToSection:LOCATEUSDETAILS_SECTION_POSTINGBOX];
}

- (IBAction)showMapRouteButtonClicked:(id)sender
{
    [self showMapRouteDirections];
}

#pragma mark - MKMapViewDelegates

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    NSLog(@"annotation class: %@", NSStringFromClass([annotation class]));
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil; //use default
    
    static NSString *const annotationIdentifier = @"EntityLocationAnnotation";
    
    MKAnnotationView *annotationView = [locationMapView dequeueReusableAnnotationViewWithIdentifier:annotationIdentifier];
    if (!annotationView) {
        annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:annotationIdentifier];
        annotationView.canShowCallout = YES;
        annotationView.image = [UIImage imageNamed:@"map_overlay"];
    }
    
    return annotationView;
}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id)overlay {
    MKPolylineView *plv = [[MKPolylineView alloc] initWithOverlay:overlay];
    plv.strokeColor = [UIColor SingPostBlueColor];
    plv.lineWidth = 3.0;
    return plv;
}

#pragma mark - Routing

- (NSMutableArray *)decodePolyLine:(NSMutableString *)encoded {
	[encoded replaceOccurrencesOfString:@"\\\\" withString:@"\\"
								options:NSLiteralSearch
								  range:NSMakeRange(0, [encoded length])];
	NSInteger len = [encoded length];
	NSInteger index = 0;
	NSMutableArray *array = [NSMutableArray array];
	NSInteger lat=0;
	NSInteger lng=0;
	while (index < len) {
		NSInteger b;
		NSInteger shift = 0;
		NSInteger result = 0;
		do {
			b = [encoded characterAtIndex:index++] - 63;
			result |= (b & 0x1f) << shift;
			shift += 5;
		} while (b >= 0x20);
		NSInteger dlat = ((result & 1) ? ~(result >> 1) : (result >> 1));
		lat += dlat;
		shift = 0;
		result = 0;
		do {
			b = [encoded characterAtIndex:index++] - 63;
			result |= (b & 0x1f) << shift;
			shift += 5;
		} while (b >= 0x20);
		NSInteger dlng = ((result & 1) ? ~(result >> 1) : (result >> 1));
		lng += dlng;
		NSNumber *latitude = [[NSNumber alloc] initWithFloat:lat * 1e-5];
		NSNumber *longitude = [[NSNumber alloc] initWithFloat:lng * 1e-5];
		CLLocation *loc = [[CLLocation alloc] initWithLatitude:[latitude floatValue] longitude:[longitude floatValue]];
		[array addObject:loc];
	}
	
	return array;
}

- (NSArray *)calculateRoutesFrom:(CLLocationCoordinate2D)f to:(CLLocationCoordinate2D)t {
	NSString* saddr = [NSString stringWithFormat:@"%f,%f", f.latitude, f.longitude];
	NSString* daddr = [NSString stringWithFormat:@"%f,%f", t.latitude, t.longitude];
	
	NSString* apiUrlStr = [NSString stringWithFormat:@"http://maps.google.com/maps?output=dragdir&saddr=%@&daddr=%@", saddr, daddr];
	NSURL* apiUrl = [NSURL URLWithString:apiUrlStr];
	NSString *apiResponse = [NSString stringWithContentsOfURL:apiUrl encoding:NSUTF8StringEncoding error:nil];
	NSString* encodedPoints = [apiResponse stringByMatching:@"points:\\\"([^\\\"]*)\\\"" capture:1L];
	
	return [self decodePolyLine:[encodedPoints mutableCopy]];
}

- (void)showMapRouteDirections
{
	NSArray *routes = [self calculateRoutesFrom:locationMapView.userLocation.coordinate to:_entityLocation.coordinate];
    
    if (routes.count > 0) {
        CLLocationCoordinate2D polypoints[routes.count];
        for (int i = 0; i < routes.count; i++) {
            CLLocation *loc = routes[i];
            polypoints[i].latitude = loc.coordinate.latitude;
            polypoints[i].longitude = loc.coordinate.longitude;
        }
        
        MKPolyline *polyline = [MKPolyline polylineWithCoordinates:polypoints count:routes.count];
        [locationMapView addOverlay:polyline];
        [locationMapView setVisibleMapRect:polyline.boundingMapRect animated:YES];
    }
}

@end
