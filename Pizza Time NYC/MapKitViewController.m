//
//  MapKitViewController.m
//  Pizza Time NYC
//
//  Created by Aditya Narayan on 12/23/15.
//  Copyright © 2015 TTT. All rights reserved.
//

#import "MapKitViewController.h"

@interface MapKitViewController ()

@end

@implementation MapKitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	[self createLocationManager];
	[self createMapView];
	
}

- (void)createMapView {
	self.mapView = [[MKMapView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
	[self.mapView setShowsUserLocation:YES];
	[self.mapView setDelegate:self];
	[self.view addSubview:self.mapView];
}

- (void)createLocationManager {
	self.locationManager = [[CLLocationManager alloc]init];
	[self.locationManager requestWhenInUseAuthorization];
	self.locationManager.delegate = self;
	[self.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - MKMapViewDelegate

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
	// set the inital map view location to user and use region of 0.1 x 0.1
	[self.mapView setRegion:MKCoordinateRegionMake(userLocation.coordinate, MKCoordinateSpanMake(0.1f, 0.1f)) animated:YES];
	
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
