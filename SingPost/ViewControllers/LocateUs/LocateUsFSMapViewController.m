//
//  LocateUsFSMapViewController.m
//  SingPost
//
//  Created by Wei Guang on 23/1/14.
//  Copyright (c) 2014 Codigo. All rights reserved.
//

#import "LocateUsFSMapViewController.h"
#import "NavigationBarView.h"
#import <MapKit/MapKit.h>
#import <RegexKitLite.h>
#import "EntityLocationMapAnnotation.h"

@interface LocateUsFSMapViewController () <MKMapViewDelegate>

@end

@implementation LocateUsFSMapViewController {
    MKMapView *mapView;
}

- (void)loadView {
    UIView *contentView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [contentView setBackgroundColor:RGB(250, 250, 250)];
    
    mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0,0, contentView.bounds.size.width, contentView.bounds.size.height - 20)];
    mapView.showsUserLocation = YES;
    mapView.delegate = self;
    [contentView addSubview:mapView];
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeButton setImage:[UIImage imageNamed:@"button_close"] forState:UIControlStateNormal];
    [closeButton setFrame:CGRectMake(15, 15, 38, 38)];
    [closeButton addTarget:self action:@selector(closeMap:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:closeButton];
    
    self.view = contentView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    MKCoordinateRegion mapRegion;
    mapRegion.center = CLLocationCoordinate2DMake(_entityLocation.latitude.floatValue, _entityLocation.longitude.floatValue);
    mapRegion.span = MKCoordinateSpanMake(0.016, 0.016);
    [mapView setRegion:mapRegion animated:YES];
    mapView.delegate = self;
    
    EntityLocationMapAnnotation *locationAnnotation = [[EntityLocationMapAnnotation alloc] initWithEntityLocation:_entityLocation];
    [mapView addAnnotation:locationAnnotation];
    
    [[AppDelegate sharedAppDelegate] trackGoogleAnalyticsWithScreenName:[NSString stringWithFormat:@"Locations - %@ - Direction", _entityLocation.type]];
    
    //[self drawRouting];
    
}

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    [self drawRouting];
}

#pragma mark - Routing

- (void)drawRouting {
    NSArray *routes = [self calculateRoutesFrom:mapView.userLocation.coordinate to:_entityLocation.coordinate];
    
    if (routes.count > 0) {
        CLLocationCoordinate2D polypoints[routes.count];
        for (int i = 0; i < routes.count; i++) {
            CLLocation *loc = routes[i];
            polypoints[i].latitude = loc.coordinate.latitude;
            polypoints[i].longitude = loc.coordinate.longitude;
        }
        
        [mapView removeOverlays:mapView.overlays];
        
        MKPolyline *polyline = [MKPolyline polylineWithCoordinates:polypoints count:routes.count];
        [mapView addOverlay:polyline];
        [mapView setVisibleMapRect:polyline.boundingMapRect animated:YES];
    }
}

- (NSArray *)calculateRoutesFrom:(CLLocationCoordinate2D)f to:(CLLocationCoordinate2D)t {
	NSString *saddr = [NSString stringWithFormat:@"%f,%f", f.latitude, f.longitude];
	NSString *daddr = [NSString stringWithFormat:@"%f,%f", t.latitude, t.longitude];
	
	NSString *apiUrlStr = [NSString stringWithFormat:@"http://maps.google.com/maps?output=dragdir&saddr=%@&daddr=%@", saddr, daddr];
	NSURL *apiUrl = [NSURL URLWithString:apiUrlStr];
	NSString *apiResponse = [NSString stringWithContentsOfURL:apiUrl encoding:NSUTF8StringEncoding error:nil];
	NSString *encodedPoints = [apiResponse stringByMatching:@"points:\\\"([^\\\"]*)\\\"" capture:1L];
	
	return [self decodePolyLine:[encodedPoints mutableCopy]];
}

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

#pragma mark - MKMapViewDelegates

- (MKAnnotationView *)mapView:(MKMapView *)_mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    
    MKAnnotationView *annotationView;
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        static NSString *const selfAnnotationIdentifier = @"SelfLocationAnnotation";
        
        annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:selfAnnotationIdentifier];
        if (!annotationView) {
            annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:selfAnnotationIdentifier];
            annotationView.canShowCallout = YES;
            annotationView.image = [UIImage imageNamed:@"self_map_overlay"];
        }
    }
    else {
        static NSString *const annotationIdentifier = @"EntityLocationAnnotation";
        
        annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:annotationIdentifier];
        if (!annotationView) {
            annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:annotationIdentifier];
            annotationView.canShowCallout = YES;
            
            NSString *locationType = _entityLocation.type;
            if ([locationType isEqualToString:LOCATION_TYPE_POST_OFFICE])
                annotationView.image = [UIImage imageNamed:@"post_office_map_overlay"];
            else if ([locationType isEqualToString:LOCATION_TYPE_SAM])
                annotationView.image = [UIImage imageNamed:@"sam_map_overlay"];
            else if ([locationType isEqualToString:LOCATION_TYPE_POSTING_BOX])
                annotationView.image = [UIImage imageNamed:@"posting_box_map_overlay"];
            else if ([locationType isEqualToString:LOCATION_TYPE_SINGPOST_AGENT])
                annotationView.image = [UIImage imageNamed:@"agent_map_overlay"];
            else if ([locationType isEqualToString:LOCATION_TYPE_POSTAL_AGENT])
                annotationView.image = [UIImage imageNamed:@"agent_map_overlay"];
            else if ([locationType isEqualToString:LOCATION_TYPE_POPSTATION])
                annotationView.image = [UIImage imageNamed:@"popstation_map_overlay"];
        }
    }
    
    return annotationView;
}


- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    if ([overlay isKindOfClass:[MKPolygon class]])
    {
        MKPolygonRenderer *renderer = [[MKPolygonRenderer alloc] initWithPolygon:overlay];
        
        renderer.fillColor   = [[UIColor cyanColor] colorWithAlphaComponent:0.2];
        renderer.strokeColor = [[UIColor blueColor] colorWithAlphaComponent:0.7];
        renderer.lineWidth   = 3;
        
        return renderer;
    }
    
    if ([overlay isKindOfClass:[MKCircle class]])
    {
        MKCircleRenderer *renderer = [[MKCircleRenderer alloc] initWithCircle:overlay];
        
        renderer.fillColor   = [[UIColor cyanColor] colorWithAlphaComponent:0.2];
        renderer.strokeColor = [[UIColor blueColor] colorWithAlphaComponent:0.7];
        renderer.lineWidth   = 3;
        
        return renderer;
    }
    
    if ([overlay isKindOfClass:[MKPolyline class]])
    {
        MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithPolyline:overlay];
        
        renderer.strokeColor = [[UIColor blueColor] colorWithAlphaComponent:0.7];
        renderer.lineWidth   = 3;
        
        return renderer;
    }
    
    return nil;
}


//- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id)overlay {
//    MKPolylineView *plv = [[MKPolylineView alloc] initWithOverlay:overlay];
//    plv.strokeColor = RGB(36, 84, 157);
//    plv.lineWidth = 3.0;
//    return plv;
//}

#pragma mark - Actions

- (IBAction)closeMap:(id)sender {
    [[AppDelegate sharedAppDelegate].rootViewController cPopViewController];
}


@end
