//
//  PizzaPlaceDirectionsViewController.m
//  Pizza Time NYC
//
//  Created by Aditya Narayan on 1/6/16.
//  Copyright © 2016 TTT. All rights reserved.
//

#import "PizzaPlaceDirectionsViewController.h"

@interface PizzaPlaceDirectionsViewController ()

@end

BOOL userLocationShownDirections; // to stop from reloading user's Location
BOOL firstTimeLoadedDirections; // to stop refresh [of map] on initial load

@implementation PizzaPlaceDirectionsViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	NSLog(@"directions page loaded");
	self.UserLocationProperty = [[MKUserLocation alloc] init];
//	self.appDelegate = [AppDelegate sharedDelegate];
	self.methodManager = [MethodManager sharedManager];
	[self createLocationManager];
	[self createMapView];
	[self checkForLocationServicesEnabled]; // originally after "createLocationManager"
	[self setDirectionalValues:self.currentPizzaPlace];
	[self setEdgesForExtendedLayout:UIRectEdgeNone];
	[self setAutomaticallyAdjustsScrollViewInsets:NO];
	[self assignLabels];
	[self assignSounds];
}

-(void)viewWillAppear:(BOOL)animated {// find location every time the view appears
	[self.navigationController setNavigationBarHidden:YES];
	if(firstTimeLoadedDirections) {
		[self currentLocationButtonPressed];
	}
	else {
		NSLog(@"Map LOADED first time");
		firstTimeLoadedDirections = YES;
	}
}
- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
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
	[self.locationManager setDelegate:self];
	[self.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
}

- (void)createAnnotation:(PizzaPlace *)pizzaPlace
{
	CLLocationCoordinate2D centerCoordinate;
	centerCoordinate.latitude = pizzaPlace.latitude;
	centerCoordinate.longitude = pizzaPlace.longitude;
	MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
	[annotation setCoordinate:centerCoordinate];
	
	[annotation setTitle:pizzaPlace.name]; //You can set the subtitle too
	NSString *secondLineAddress = [pizzaPlace.city stringByAppendingString:[NSString stringWithFormat:@" %ld",(long)pizzaPlace.zip ]];
	NSString *allAddress = [pizzaPlace.street stringByAppendingString:[NSString stringWithFormat:@"\n%@", secondLineAddress]];
	//	NSLog(@"%@", allAddress);
	[annotation setSubtitle:allAddress];
	[self.mapView addAnnotation:annotation];
}

-(void)setPizzaPlaceProperty:(PizzaPlace *)pizzaPlace {
	self.currentPizzaPlace = pizzaPlace;
}

-(void)assignLabels {// and buttons
	UIButton *speakerButtonDirectPage = [[UIButton alloc]initWithFrame:CGRectMake(self.view.bounds.size.width -76, 16, 60, 60)];
	self.speakerButtonDirectPage = speakerButtonDirectPage;
	// Add an action in current code file (i.e. target)
	[self.speakerButtonDirectPage addTarget:self
								  action:@selector(speakerButtonPressed:)
						   forControlEvents:UIControlEventTouchUpInside];
	
	if (self.methodManager.sound == YES) {
		[self.speakerButtonDirectPage setBackgroundImage:[self.methodManager playMusic] forState:UIControlStateNormal];
	}
	else {
		[self.speakerButtonDirectPage setBackgroundImage:[self.methodManager stopMusic] forState:UIControlStateNormal];
	}
	[self.view addSubview:self.speakerButtonDirectPage];
	// divide by 2 for center and minus 30 for center of png
	UIButton *optionsButtonMapPage = [[UIButton alloc]initWithFrame:CGRectMake(self.view.bounds.size.width/2 - 30, 16, 60, 60)];
	// Add an action in current code file (i.e. target)
	[optionsButtonMapPage addTarget:self
							 action:@selector(optionsButtonPressed:)
				   forControlEvents:UIControlEventTouchUpInside];
	
	[optionsButtonMapPage setBackgroundImage:[UIImage imageNamed:@"menu.png"] forState:UIControlStateNormal];
	[self.view addSubview:optionsButtonMapPage];
}

-(void)assignSounds {
	if (self.methodManager.audioPlayer.rate == 0.0) {
		NSString *backgroundMusicPath = [[NSBundle mainBundle]pathForResource:@"pizzaMusic" ofType:@"mp3"];
		if (!self.methodManager.audioPlayer) {
			self.methodManager.audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:[NSURL fileURLWithPath:backgroundMusicPath] error:NULL];
		}
		self.methodManager.audioPlayer.numberOfLoops = -1; // -1 is infinite loops
	}
	else {
//		NSLog(@"You've already created the player!");
	}
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark - MKMapViewDelegate

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
	self.UserLocationProperty = userLocation;
	if(userLocationShownDirections) return;
	// set the inital map view location to user and use region of 0.01 x 0.01
	//	[self.mapView setRegion:MKCoordinateRegionMake(userLocation.coordinate, MKCoordinateSpanMake(0.02f, 0.02f)) animated:YES];
	[self.mapView setRegion:[self regionForAnnotations] animated:YES];
	userLocationShownDirections = YES;
	//	[self findDistance];
	
}

- (MKCoordinateRegion)regionForAnnotations {//:(MKUserLocation *)annotation { //pizzaPlace:(PizzaPlace*)pizzaPlace {
	
	CLLocationDegrees minLat = self.currentPizzaPlace.latitude;
	CLLocationDegrees minLon = self.currentPizzaPlace.longitude;
	CLLocationDegrees maxLat = self.UserLocationProperty.coordinate.latitude;
	CLLocationDegrees maxLon = self.UserLocationProperty.coordinate.longitude;
	
	if (self.UserLocationProperty.coordinate.latitude < minLat) {
		minLat = self.UserLocationProperty.coordinate.latitude;
		maxLat = self.currentPizzaPlace.latitude;
	}
	if (self.UserLocationProperty.coordinate.longitude < minLon) {
		minLon = self.UserLocationProperty.coordinate.longitude;
		maxLon = self.currentPizzaPlace.longitude;
	}
	//	MKCoordinateSpan span = MKCoordinateSpanMake(fabs(maxLat - minLat),fabs(maxLon - minLon));//absolute values
	MKCoordinateSpan span = MKCoordinateSpanMake((maxLat - minLat)*1.3,(maxLon - minLon)*1.3);
	//	NSLog(@"lat = %f\nLong = %f", span.latitudeDelta, span.longitudeDelta);
	
	CLLocationCoordinate2D center = CLLocationCoordinate2DMake((maxLat - span.latitudeDelta / 2), maxLon - span.longitudeDelta / 2);
	
	return MKCoordinateRegionMake(center, span);
}

-(void)setDirectionalValues:(PizzaPlace *)pizzaPlace {
	[self createAnnotation:pizzaPlace];
	//	NSLog(@"I need to find directions for %@", pizzaPlace.name);
	MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:CLLocationCoordinate2DMake(pizzaPlace.latitude, pizzaPlace.longitude) addressDictionary:nil];
	// create a MKMapItem with coordinates of pizza place
	MKMapItem *pizzaPlaceLocation = [[MKMapItem alloc]initWithPlacemark:placemark];
	MKDirectionsRequest *request = [[MKDirectionsRequest alloc] init];
	[request setSource:[MKMapItem mapItemForCurrentLocation]];
	[request setDestination:pizzaPlaceLocation];
	[request setTransportType:MKDirectionsTransportTypeWalking]; // This can be limited to automobile and walking directions.
	[request setRequestsAlternateRoutes:YES]; // Gives you several route options.
	MKDirections *directions = [[MKDirections alloc] initWithRequest:request];
	[directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
		if (!error) {
			for (MKRoute *route in [response routes]) {
				[self.mapView addOverlay:[route polyline] level:MKOverlayLevelAboveRoads]; // Draws the route above roads, but below labels.
				NSLog(@"STEPS : %@", [route.steps objectAtIndex:0]);
				//				MKRoute *route = [[response routes] objectAtIndex:0];
				//				NSLog(@"distance = %f miles",route.distance/1609.344); //in meters (converted to miles)
				NSLog(@"ETA = %f Min",route.expectedTravelTime/60);// in seconds (converted to minutes)
				// You can also get turn-by-turn steps, distance, advisory notices, ETA, etc by accessing various route properties.
			}
		}
	}];
}

-(MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
	
	MKPolylineRenderer  * routeLineRenderer = [[MKPolylineRenderer alloc] initWithPolyline:overlay];
	
	routeLineRenderer.strokeColor = [UIColor redColor];
	routeLineRenderer.lineWidth = 4;
	return routeLineRenderer;
}

-(void)checkForLocationServicesEnabled {
	//check for authorization here
	if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusDenied)
	{
		// set Empire State Building as a location and set pin
		CLLocationCoordinate2D centerCoordinate;
		centerCoordinate.latitude = 40.7484;
		centerCoordinate.longitude = -73.9857;
		self.UserLocationProperty.coordinate = centerCoordinate;
		//		NSLog(@"lat = %f, long = %f", centerCoordinate.latitude, centerCoordinate.longitude);
		// set region of map to focus on Empire State Building
		MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(centerCoordinate, 200, 200);
		[self.mapView setRegion:region animated:YES];
		
		NSLog(@"Location Services Disabled");
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Location Service Disabled"
														message:@"Is Shredder on your tail? We'll keep your location a secret!"
													   delegate:self
											  cancelButtonTitle:@"RUN"
											  otherButtonTitles:@"Settings", nil];
		[alert show];
	}
	// uncomment following for professional response, instead [to replace the above]
	
	/*UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Location Service Disabled"
	 message:@"To re-enable, please go to Settings and turn on Location Service for this app."
	 delegate:self
	 cancelButtonTitle:@"Cancel"
	 otherButtonTitles:@"Settings", nil];
	 [alert show];
	 */
}

#pragma mark - ACTIONS

// this should disable and enable the sound of the app
-(void)speakerButtonPressed:(UIButton *)speakerButton {
	if (self.methodManager.sound) {
		//		NSLog(@"sound disabled"); //disable sound
		[self.speakerButtonDirectPage setBackgroundImage:[self.methodManager stopMusic] forState:UIControlStateNormal];
		//		self.appDelegate.audioPlayer.rate = 0.0;
	}
	else {
		//		NSLog(@"sound enabled"); //enable sound
		[self.speakerButtonDirectPage setBackgroundImage:[self.methodManager playMusic] forState:UIControlStateNormal];
		//		self.appDelegate.audioPlayer.rate = 1.0;
	}
}

// this should show the menu page
-(void)optionsButtonPressed:(UIButton *)optionsButton {
	NSLog(@"optionsButton was pressed");
	// this should open the options page of Pizza Time
	UIViewController *detailViewController = (UIViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"OptionsPage"];
	[self.navigationController pushViewController:detailViewController animated:YES];
}


// Main initial button press
-(void)currentLocationButtonPressed {
	NSLog(@"Current Location button was pressed");
	// this should zoom in on current location again
	
	[self checkForLocationServicesEnabled];
	if([CLLocationManager authorizationStatus]!=kCLAuthorizationStatusDenied)
	{
		
		//		[self.mapView setRegion:MKCoordinateRegionMake(self.UserLocationProperty.coordinate, MKCoordinateSpanMake(0.05f, 0.05f)) animated:YES];
		[self.mapView setRegion:[self regionForAnnotations] animated:YES];
		userLocationShownDirections = YES;
		
		self.locationManager.delegate = self;
		self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
		userLocationShownDirections = NO;
		
		[self.locationManager startUpdatingLocation];
	}
}


@end
