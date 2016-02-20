//
//  MapKitViewController.m
//  Pizza Time NYC
//
//  Created by JD Leonard on 12/23/15.
//  Copyright © 2015 TTT. All rights reserved.
//

#import "MapKitViewController.h"

@interface MapKitViewController ()

@property (strong, nonatomic) MethodManager *methodManager;
@property (strong, nonatomic) DAO *dao;
@property (strong, nonatomic) MBProgressHUD *hud;
@property CLLocationCoordinate2D newAddress; // used for handleLongPress, // maybe use for search, annotation clicking, etc. , which means move to method manager

@end

int countMapKit;// set the user's [current location] image to 3 separate items
BOOL userLocationShown; // to stop from reloading user's Location (NO = 0 = not showing location)
/*
 countMapKit 1.20.16
 created in MapKit
 MK VWA +=1
 MK viewForAnnotation SWITCH statement
 
 userLocationShown 1.20.16
 created in MapKit
 MK VDL set NO
 MK updUsr if YES, return: else, assign YES
 MK findDistance if not found, NO
 please check if necessary - MK currentLocPre set YES (maybe because called in other pages)
 */

@implementation MapKitViewController
/*
 + (id)sharedManager {
	static MapKitViewController *sharedMyManager = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
 sharedMyManager = [[self alloc] init];
	});
	return sharedMyManager;
 }
 */
- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (void)viewDidLoad {
	[super viewDidLoad];
	NSLog(@"Map Page called VDL");
	userLocationShown = NO;
	
	self.methodManager = [MethodManager sharedManager];
	self.dao = [DAO sharedDAO];
	//	NSLog(@"my array is full = %@", self.dao.pizzaPlaceArray);
	
	[self createMapView];
	//	[self checkForLocationServicesEnabled]; // this should have the bool used to assign bool
	
	[self createPizzaPins];
	[self createSearchBar];
	[self createLongPressGesture];
	
}

-(void)viewWillAppear:(BOOL)animated {// find location every time the view appears
	[super viewWillAppear:animated];
	//	NSLog(@"locMan = %f", self.locationManager.location.coordinate.latitude);
	countMapKit+=1; // changes the annotation for self
	self.methodManager.mapPageBool = YES;
	if (self.currentPizzaPlace == NULL) {self.currentPizzaPlace = [[PizzaPlace alloc]init];}
	
	//	NSLog(@"show VWA directions is = %d", self.methodManager.directionsShow);
	[self sortByDistanceForClosest]; // if closest is hit and directionsShown is YES
	[self setDirectionalValues];
	[self currentLocationButtonPressed];
	
	if(self.methodManager.firstTimeLoaded) {
		NSLog(@"Map Page LOADED first time (called first and only once)");
		// not needed as of 1.29.16, but kept in case
		self.methodManager.firstTimeLoaded = NO;
	}
	else { //not the first time here
		// removed because locMan is being found during viewController 1.29.16
		//	[self currentLocationButtonPressed]; // only call currLoc after first time
	}
	
	[self assignButtons];
	if (!self.methodManager.directionsShow) {
		MKCircle *circle = [MKCircle circleWithCenterCoordinate:self.methodManager.locationManager.location.coordinate radius:500];
		[self.mapView addOverlay:circle];
	}
}

-(void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:YES];
	// set directions to NO
	self.methodManager.directionsShow = NO;
	self.dao.hideProgressHud = NO;
	NSArray *pointsArray = [self.mapView overlays];
	[self.mapView removeOverlays:pointsArray];
}


#pragma mark - CREATE PAGE

- (void)createMapView {
	self.mapView = [[MKMapView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 49)]; // -49 for the tabBar buttons
	[self.mapView setShowsUserLocation:YES];
	[self.mapView setDelegate:self];
	//disable rotation for compass being hidden // unsure if this is ok
	//	self.mapView.rotateEnabled = NO;
	
	if ([self.mapView respondsToSelector:@selector(showsCompass)]) {
		//		NSLog(@"User is on ios 9");
		self.mapView.showsCompass = NO;
	}
	else {
		NSLog(@"User is NOT on ios 9");
	}
	[self.view addSubview:self.mapView];
}

-(void)createLongPressGesture {
	UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGesture:)];
	[self.mapView addGestureRecognizer:longPressGesture];
}

-(void)createSearchBar {
	self.searchBar.delegate = self;
	self.searchBar.placeholder = @"Search Address";
	
	self.searchBar.backgroundColor = [UIColor redColor]; // color of cancel and cursor
	self.searchBar.barTintColor = [[UIColor alloc]initWithRed:0.0/255.0 green:188.0/255.0 blue:204.0/255.0 alpha:1.0]; // color of the bar
	
	UIImageView *searchIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"walkAlpha30.png"]];
	searchIcon.frame = CGRectMake(10, 10, 24, 24);
	[self.searchBar addSubview:searchIcon];
	[[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setBackgroundColor:[[UIColor alloc]initWithRed:255.0/255.0 green:206.0/255.0 blue:98.0/255.0 alpha:1.0]]; // for ALL searchBars, do this. Effects every bar after called
	
	[self.view addSubview:self.searchBar];
	self.searchBar.hidden = YES;
}


-(void)assignButtons {// and buttons
	
	//	NSLog(@"Views Count %lu", (unsigned long)[self.view.subviews count]);
	
	// if the button already exists, remove it from the superView
	[self.methodManager removeBothButtons];
	if (self.searchButtonMapPage) {
		[self.searchButtonMapPage removeFromSuperview];
	}
	
	[self.view addSubview:[self.methodManager assignOptionsButton]];
	[self.view addSubview:[self.methodManager assignSpeakerButton]];
	
	UIButton *searchButtonMapPage = [[UIButton alloc]initWithFrame:CGRectMake(16, 16, 45, 45)];
	self.searchButtonMapPage = searchButtonMapPage;
	// Add an action in current code file (i.e. target)
	[self.searchButtonMapPage addTarget:self
								 action:@selector(searchButtonPressed:)
					   forControlEvents:UIControlEventTouchUpInside];
	
	[self.searchButtonMapPage setBackgroundImage:[UIImage imageNamed:@"MCQMapSEARCH.png"] forState:UIControlStateNormal];
	[self.view addSubview:self.searchButtonMapPage];
	
	
	UIButton *mapButtonMapPage = [[UIButton alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height - 49, self.view.bounds.size.width/2, 49)];
	self.mapButtonMapPage = mapButtonMapPage;
	// Add an action in current code file (i.e. target)
	[self.mapButtonMapPage addTarget:self
								 action:@selector(mapButtonPressed:)
					forControlEvents:UIControlEventTouchUpInside];
	
	[self.mapButtonMapPage setBackgroundImage:[UIImage imageNamed:@"MCQTabBarMAP.png"] forState:UIControlStateNormal];
	[self.view addSubview:self.mapButtonMapPage];
	
	UIButton *listButtonMapPage = [[UIButton alloc]initWithFrame:CGRectMake(self.view.bounds.size.width/2, self.view.bounds.size.height - 49, self.view.bounds.size.width/2, 49)];
	self.listButtonMapPage = listButtonMapPage;
	// Add an action in current code file (i.e. target)
	[self.listButtonMapPage addTarget:self
							   action:@selector(listButtonPressed:)
					 forControlEvents:UIControlEventTouchUpInside];
	
	[self.listButtonMapPage setBackgroundImage:[UIImage imageNamed:@"MCQTabBarLIST.png"] forState:UIControlStateNormal];
	[self.view addSubview:self.listButtonMapPage];
	
	UIButton *currentLocation = [[UIButton alloc]initWithFrame:CGRectMake(8, self.view.bounds.size.height - 49 - 46, 30, 30)];
	self.currentLocationButtonMapPage = currentLocation;
	// Add an action in current code file (i.e. target)
	[self.currentLocationButtonMapPage addTarget:self
										  action:@selector(currentLocationButtonPressed)
								forControlEvents:UIControlEventTouchUpInside];
	
	[self.currentLocationButtonMapPage setBackgroundImage:[UIImage imageNamed:@"MCQMapLOCATION.png"] forState:UIControlStateNormal];
	[self.view addSubview:self.currentLocationButtonMapPage];
	
}

#pragma mark - MKMapViewDelegate

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation { // if location is off, this does not get called // otherwise, it gets called every update \\ as per 1.29.16, this is not true
	//	NSLog(@"userLoc Lat = %f", userLocation.location.coordinate.latitude);
	//	NSLog(@"locMan Lat = %f",self.methodManager.locationManager.location.coordinate.latitude);
	if(userLocationShown) return;
	//	NSLog(@"show UL directions is = %d", self.methodManager.directionsShow);
	
	if (self.methodManager.locationManager.location.coordinate.latitude != 0.0 || self.methodManager.locationManager.location.coordinate.longitude != 0.0) {
		if (self.methodManager.directionsShow) {
			[self.mapView setRegion:[self regionForAnnotations] animated:NO];
			self.methodManager.directionsShow = NO;
		}
		else {
			// set the inital map view location to user and use region of 0.05 x 0.05
			[self.mapView setRegion:MKCoordinateRegionMake(userLocation.coordinate, MKCoordinateSpanMake(0.05f, 0.05f)) animated:YES];
		}
		userLocationShown = YES; // we have found and assigned the location
	}
	else {
		NSLog(@"Could not find location didUpdateUser");
	}
	[self findDistance:userLocation.location];
}

// this is being called way often, unsure if good idea to be calling a method so much
- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
	//	NSLog(@"region did change");
	[self removeCompass];
}

// what calls this?
-(MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
	if (self.methodManager.directionsShow) { // show lines directions
		MKPolylineRenderer  *routeLineRenderer = [[MKPolylineRenderer alloc] initWithPolyline:overlay];
		routeLineRenderer.strokeColor = [UIColor redColor];
		routeLineRenderer.lineWidth = 4;
		return routeLineRenderer;
		
	}
	else { // show radius for user
		MKCircleRenderer *circleView = [[MKCircleRenderer alloc] initWithCircle:overlay];
		UIColor* clr = [[UIColor alloc]initWithRed:255.0/255.0 green:201.0/255.0 blue:153.0/255.0 alpha:1.0];
		//		circleView.strokeColor = [[UIColor brownColor] colorWithAlphaComponent:0.4];
		circleView.strokeColor = clr;
		circleView.fillColor = [[UIColor redColor] colorWithAlphaComponent:0.35];
		return circleView;
		
	}
}

-(void)removeCompass {
	// Gets array of subviews from the map view (MKMapView)
	NSArray *mapSubViews = self.mapView.subviews;
	
	for (UIView *view in mapSubViews) {
		// Checks if the view is of class MKCompassView
		if ([view isKindOfClass:NSClassFromString(@"MKCompassView")]) {
			// Removes view from mapView
			[view removeFromSuperview];
		}
	}
	
}

// is this getting called?
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	NSLog(@"there was an error: %@", error);
}

#pragma mark - Distance & Directions

-(void)findDistance:(CLLocation *)userLocation {
	if (self.methodManager == NULL || self.dao.pizzaPlaceArray == NULL) {
		self.methodManager = [MethodManager sharedManager];
		self.dao = [DAO sharedDAO];
	}
	for (PizzaPlace *pizzaPlace in self.dao.pizzaPlaceArray) {
		// assign pizzaPlace's location
		double pizzaPlaceLat = (double)pizzaPlace.latitude;
		double pizzaPlaceLong = (double)pizzaPlace.longitude;
		
		// NSLog(@"findDistance lat = %f", userLocation.coordinate.latitude);
		// assign user's location
		double userLocationLat = (double)userLocation.coordinate.latitude;
		double userLocationLong = (double)userLocation.coordinate.longitude;
		
		if (userLocation.coordinate.latitude == 0.0 || userLocation.coordinate.longitude == 0.0) {
			// NSLog(@"No idea where user is!");
			userLocationShown = NO;
			userLocationLat = self.methodManager.empireStateBuilding.coordinate.latitude;
			userLocationLong = self.methodManager.empireStateBuilding.coordinate.longitude;
		}
		CLLocation *pizzaPlaceLocation = [[CLLocation alloc] initWithLatitude:pizzaPlaceLat
																	longitude:pizzaPlaceLong];
		
		CLLocation *userLocationForDistance = [[CLLocation alloc] initWithLatitude:userLocationLat
																		 longitude:userLocationLong];
		CLLocationDistance distanceL = [pizzaPlaceLocation distanceFromLocation:userLocationForDistance];
		//		NSLog(@"%f AND %f", userLocationLat, userLocationLong);
		NSString *distanceFromUser = [NSString stringWithFormat:@"%.1fmi",(distanceL/1609.344)];
		//		NSLog(@"distance in miles: %@ for %@", distanceFromUser, pizzaPlace.name);
		
		//convert to float and then assign to pizzaPlaceDistance
		float distanceFloat = [distanceFromUser floatValue];
		pizzaPlace.distance = distanceFloat;
		//				NSLog(@"The distance saved as %f for %@", pizzaPlace.distance, pizzaPlace.name);
	}
}

-(void)sortByDistanceForClosest {
	// find top of the array[0] and set it as currentPizzaPlace and then set bool for directions to YES
	if (self.methodManager == NULL || self.dao.pizzaPlaceArray == NULL) {
		self.methodManager = [MethodManager sharedManager];
		self.dao = [DAO sharedDAO];
	}
	NSLog(@"location manager in sortByDistance = %f", 	self.methodManager.locationManager.location.coordinate.latitude);
	if (!self.methodManager.searchSubmit) { // not submitting search
		[self findDistance:self.methodManager.locationManager.location];
	}
	NSSortDescriptor *distanceSorter = [[NSSortDescriptor alloc] initWithKey:@"distance" ascending:YES];
	[self.dao.pizzaPlaceArray sortUsingDescriptors:[NSArray arrayWithObject:distanceSorter]];
	//		NSLog(@"array ORDERED = %@", self.dao.pizzaPlaceArray);
	
	// if finding directions, set current Pizza to closest
	if (self.methodManager.directionsShow) {
		if(!self.methodManager.closestPP)return;
		//		NSLog(@"%@", [[self.dao.pizzaPlaceArray objectAtIndex:0]name]);
		self.currentPizzaPlace = [self.dao.pizzaPlaceArray objectAtIndex:0];
		self.methodManager.closestPP = NO;
	}
	
}

- (MKCoordinateRegion)regionForAnnotations { // being called for directions
	// closest pizza place
	if (self.currentPizzaPlace.latitude == 0.0 || self.currentPizzaPlace.longitude == 0.0) {
		[self sortByDistanceForClosest];
	}
	CLLocationDegrees minLat = self.currentPizzaPlace.latitude;
	CLLocationDegrees minLon = self.currentPizzaPlace.longitude;
	CLLocationDegrees maxLat = self.methodManager.locationManager.location.coordinate.latitude;
	CLLocationDegrees maxLon = self.methodManager.locationManager.location.coordinate.longitude;
	CLLocationDegrees tempForSwap;
	
	if (maxLat == 0.0 || maxLon == 0.0) {
		maxLat = self.methodManager.empireStateBuilding.coordinate.latitude;
		maxLon = self.methodManager.empireStateBuilding.coordinate.longitude;
	}
	if (maxLat < minLat) {
		tempForSwap = minLat;
		minLat = maxLat;
		maxLat = tempForSwap;
		//		minLat = self.UserLocationProperty.coordinate.latitude;
		//		maxLat = self.currentPizzaPlace.latitude;
	}
	if (maxLon < minLon) {
		tempForSwap = minLon;
		minLon = maxLon;
		maxLon = tempForSwap;
		//		minLon = self.UserLocationProperty.coordinate.longitude;
		//		maxLon = self.currentPizzaPlace.longitude;
	}
	MKCoordinateSpan span = MKCoordinateSpanMake((maxLat - minLat)*1.3,(maxLon - minLon)*1.3);
	//	NSLog(@"lat = %f\nLong = %f", span.latitudeDelta, span.longitudeDelta);
	
	CLLocationCoordinate2D center = CLLocationCoordinate2DMake((maxLat - span.latitudeDelta / 2), maxLon - span.longitudeDelta / 2);
	
	return MKCoordinateRegionMake(center, span);
}

-(void)setDirectionalValues {
	//	NSLog(@"show DV directions is = %d", self.methodManager.directionsShow);
	if (!self.methodManager.directionsShow) {
		//		NSLog(@"not looking for directions");
	}
	
	else { // show directions
		//		NSLog(@"WE ARE looking for directionsor %@", self.currentPizzaPlace.name);
		MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:CLLocationCoordinate2DMake(self.currentPizzaPlace.latitude, self.currentPizzaPlace.longitude) addressDictionary:nil];
		// create a MKMapItem with coordinates of pizza place
		MKMapItem *pizzaPlaceLocation = [[MKMapItem alloc]initWithPlacemark:placemark];
		MKDirectionsRequest *request = [[MKDirectionsRequest alloc] init];
		
		NSLog(@"user location lat = %f", self.methodManager.locationManager.location.coordinate.latitude);
		NSLog(@"user location long = %f", self.methodManager.locationManager.location.coordinate.longitude);
		
		if (self.methodManager.locationManager.location.coordinate.latitude != 0.0 || self.methodManager.locationManager.location.coordinate.longitude != 0.0) {
			MKPlacemark *userPlaceMark = [[MKPlacemark alloc]initWithCoordinate:CLLocationCoordinate2DMake(self.methodManager.locationManager.location.coordinate.latitude, self.methodManager.locationManager.location.coordinate.longitude) addressDictionary:nil];
			[request setSource:[[MKMapItem alloc] initWithPlacemark:userPlaceMark]];
			
		}
		else {
			// no user location found = set Empire State Building as current location
			MKPlacemark *empirePlacemark = [[MKPlacemark alloc] initWithCoordinate:CLLocationCoordinate2DMake(self.methodManager.empireStateBuilding.coordinate.latitude, self.methodManager.empireStateBuilding.coordinate.longitude) addressDictionary:nil];
			MKMapItem *empireLocation = [[MKMapItem alloc]initWithPlacemark:empirePlacemark];
			
			[request setSource:empireLocation];
		}
		
		[request setDestination:pizzaPlaceLocation];
		[request setTransportType:MKDirectionsTransportTypeWalking]; // This can be limited to automobile and walking directions.
		[request setRequestsAlternateRoutes:YES]; // Gives you several route options.
		self.directions = [[MKDirections alloc] initWithRequest:request];
		[self calculateDirectionsWithRequest:request numberOfRetries:0];
		//		[self.directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
		//			if (!error) {
		//				for (MKRoute *route in [response routes]) {
		//					[self.mapView addOverlay:[route polyline] level:MKOverlayLevelAboveRoads]; // Draws the route above roads, but below labels.
		//					NSLog(@"STEPS : %@", [route.steps objectAtIndex:0]);
		//				MKRoute *route = [[response routes] objectAtIndex:0];
		//				NSLog(@"distance = %f miles",route.distance/1609.344); //in meters (converted to miles)
		//					NSLog(@"ETA = %f Min",route.expectedTravelTime/60);// in seconds (converted to minutes)
		// You can also get turn-by-turn steps, distance, advisory notices, ETA, etc by accessing various route properties.
		//				}
		//			}
		//			else if (error && ![self.directions isCalculating]){				// most likely call upon reachability
		//
		/* // loggin the errors, but not with much info [at least when internet is off]
		 NSLog(@"%@", error.userInfo[NSLocalizedDescriptionKey]);
		 NSLog(@"Domain: %@", error.domain);
		 NSLog(@"Error Code: %ld", error.code);
		 NSLog(@"Description: %@", [error localizedDescription]);
		 NSLog(@"Reason: %@", [error localizedFailureReason]);
		 NSLog(@"%@",[error localizedRecoverySuggestion]);
		 */
		//				NSLog(@"error, but probably internet conneciton = %@", error);
		//				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Cannot Connect To Internet"
		//																message:@"Are you using an iPod Touch?"
		//															   delegate:self
		//													  cancelButtonTitle:@"It's OK"
		//													  otherButtonTitles:@"Settings", nil];
		//				[alert show];
		//			}
		//			else if ([self.directions isCalculating]) {
		//				// try to call again
		//				self.directions = [[MKDirections alloc] initWithRequest:request];
		//			}
		//		}];
		//		[self setEdgesForExtendedLayout:UIRectEdgeNone];
		//		[self setAutomaticallyAdjustsScrollViewInsets:NO];
		
	}
}

- (void)calculateDirectionsWithRequest:(MKDirectionsRequest *)request numberOfRetries:(int)numberOfRetries {
	
	if (numberOfRetries > 4) {
		return;
	}
	else {
		numberOfRetries++;
	}
	
	self.directions = [[MKDirections alloc] initWithRequest:request];
	[self.directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
		if (!error) {
			for (MKRoute *route in [response routes]) {
				[self.mapView addOverlay:[route polyline] level:MKOverlayLevelAboveRoads]; // Draws the route above roads, but below labels.
				//					NSLog(@"STEPS : %@", [route.steps objectAtIndex:0]);
				//				MKRoute *route = [[response routes] objectAtIndex:0];
				//				NSLog(@"distance = %f miles",route.distance/1609.344); //in meters (converted to miles)
				//					NSLog(@"ETA = %f Min",route.expectedTravelTime/60);// in seconds (converted to minutes)
				// You can also get turn-by-turn steps, distance, advisory notices, ETA, etc by accessing various route properties.
			}
		}
		else if (error && ![self.directions isCalculating] && error.code != 1){				// most likely call upon reachability
			
			/* // loggin the errors, but not with much info [at least when internet is off]
			 NSLog(@"%@", error.userInfo[NSLocalizedDescriptionKey]);
			 NSLog(@"Domain: %@", error.domain);
			 NSLog(@"Error Code: %ld", error.code);
			 NSLog(@"Description: %@", [error localizedDescription]);
			 NSLog(@"Reason: %@", [error localizedFailureReason]);
			 NSLog(@"%@",[error localizedRecoverySuggestion]);
			 */
			NSLog(@"error, but probably internet conneciton = %@", error);
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Cannot Connect To Internet"
															message:@"Are you using an iPod Touch?"
														   delegate:self
												  cancelButtonTitle:@"It's OK"
												  otherButtonTitles:@"Settings", nil];
			[alert show];
		}
		else {
			// try to call again
			MapKitViewController *mapKit = self;
			dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 10 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
				[mapKit calculateDirectionsWithRequest:request numberOfRetries:numberOfRetries];
			});
			//			[self calculateDirectionsWithRequest:request numberOfRetries:numberOfRetries];
		}
	}];
	
}

#pragma mark - Location Services & AlertView

-(BOOL)checkForLocationServicesEnabled {	// authorized or NOT
	if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusDenied && self.methodManager.userLocAuth == NO)
	{// authorization not given
		// set Empire State Building as a location and set pin
		if (self.methodManager.directionsShow) {
			NSLog(@"showing directions, please do set region");
			[self.mapView setRegion:[self regionForAnnotations] animated:NO];
		}
		else {
			MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(self.methodManager.empireStateBuilding.coordinate, 1200, 1200);
			[self.mapView setRegion:region animated:YES];
		}
		NSLog(@"Location Services Disabled");
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Location Service Disabled"
														message:@"We have set your location as the Empire State Building, until you enable your location!"
													   delegate:self
											  cancelButtonTitle:@"Stay Hidden!"
											  otherButtonTitles:@"Settings", nil];
		[alert show];
		return FALSE;
	}
	else {
		// everything is good, continue
		return TRUE;
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

-(BOOL)checkForLocationServicesFound { // do not check on initial load, before allowed use the bool
	self.methodManager = [MethodManager sharedManager];
	if (!self.methodManager.userLocRemind) {
		NSLog(@"skip me please - do not remind about not found");
		// everything is good, continue
		return TRUE;
	}
	else {
		if (self.methodManager.locationManager.location.coordinate.latitude != 0.0 || self.methodManager.locationManager.location.coordinate.longitude != 0.0) {
			//		NSLog(@"we are finding the location...do nothing?");
			// everything is good, continue
			return TRUE;
		}
		else {
			NSLog(@"we are NOT finding the location... ESB");
			// no user location found = set Empire State Building as current location
			if (self.methodManager.directionsShow) {
				NSLog(@"showing directions, please do set region to them");
				[self.mapView setRegion:[self regionForAnnotations] animated:NO];
			}
			else {
				MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(self.methodManager.empireStateBuilding.coordinate, 1200, 1200);
				[self.mapView setRegion:region animated:YES];
			}
			NSLog(@"Location Services Not Working");
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Location Service Cannot Find You"
															message:@"We have set your location as the Empire State Building, until you enable your location!"
														   delegate:self
												  cancelButtonTitle:@"Cool"
												  otherButtonTitles:@"Remind Me", nil];
			[alert show];
			return FALSE;
		}
	}
}

/*
 - (void) createManhattan {
 NSArray *coordinateData = [NSArray alloc]initWithObjects:@(-74.0207291,40.6985354), (-73.9730072,40.70979200000001), (-73.9668274,40.7410143), (-73.9215088,40.7909394), (-73.7882996,40.8002962), (-73.8102722,40.8595252), (-73.9215088,40.8989819), (-74.0093994,40.7610408), (-74.0207291,40.6985354), nil];
 }
 
 int coordsLen = [coordinateData count];
 CLLocationCoordinate2D *coords = malloc(sizeof(CLLocationCoordinate2D) * coordsLen);
 for (int i=0; i < coordsLen; i++)
 {
	YourCustomObj *coordObj = (YourCustomObj *)[coordinateData objectAtIndex:i];
	coords[i] = CLLocationCoordinate2DMake(coordObj.latitude, coordObj.longitude);
 }
 MKPolygon *polygon = [MKPolygon polygonWithCoordinates:coords count:coordsLen];
 free(coords);
 [mapView addOverlay:polygon];
 */

#pragma mark - Custom Annotations

-(void)createPizzaPins {
	for (PizzaPlace *pizzaPlace in self.dao.pizzaPlaceArray) {
		pizzaPlace.image = @"TwoBrosPizzaLogo.jpg";
		pizzaPlace.url = @"http://www.2brospizza.com/";
		[self createAnnotation:pizzaPlace];
	}
	//	NSLog(@"PizzaPlaceArray:%@", self.dao.pizzaPlaceArray);
	
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
	[self.view setUserInteractionEnabled:YES];
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{ //use the below if drops are necessary
	/*
	 if([annotation isKindOfClass:[MKUserLocation class]]);
		return nil;
	 
	 static NSString *AnnotationIdentifier=@"AnnotationIdentifier";
	 MKPinAnnotationView *pinView=[[MKPinAnnotationView alloc ]initWithAnnotation:annotation reuseIdentifier:AnnotationIdentifier];
	 
	 pinView.animatesDrop=YES;
	 pinView.canShowCallout=YES;
	 pinView.pinColor=MKPinAnnotationColorRed;
	 pinView.leftCalloutAccessoryView = [[UIView alloc] initWithFrame:CGRectMake(0,0,80,60)];
	 
	 UIImageView *IconView = [[UIImageView alloc] initWithFrame:pinView.leftCalloutAccessoryView.frame];
	 for (PizzaPlace *pizzaPlace in self.pizzaPlaceArray) {
		if ([pizzaPlace.pizzaPlaceName isEqualToString:annotation.title]) {
	 //			NSLog(@"my annotation %@ and my location %@",annotation.title, pizzaPlace.pizzaPlaceName);
	 UIImage *image = [UIImage imageNamed:pizzaPlace.image];
	 IconView.image = image;
		}
	 }
	 pinView.leftCalloutAccessoryView = IconView;
	 
	 UIButton *rbutton=[UIButton buttonWithType:UIButtonTypeDetailDisclosure];
	 [rbutton setTitle:annotation.title forState:UIControlStateNormal];
	 //	[rbutton addTarget:self action:@selector(showDetailViewController:sender:) forControlEvents:UIControlEventTouchUpInside];
	 pinView.rightCalloutAccessoryView=rbutton;
	 
	 
	 return pinView;
	 */
	static NSString *AnnotationIdentifier=@"AnnotationIdentifier";
	MKAnnotationView *pinView = (MKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationIdentifier];
	if (!pinView) {
		
		MKAnnotationView *customPinView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationIdentifier];
		if (annotation == mapView.userLocation){
			switch (countMapKit%3) {
				case 0:
					//					NSLog(@"count is 0 - set bike");
					//					customPinView.image = [UIImage imageNamed:@"animatedBike29.jpg"];
					customPinView.image = [UIImage imageNamed:@"skateBoardAlpha30.png"];
					customPinView.centerOffset = CGPointMake(0,-customPinView.frame.size.height*0.5);
					countMapKit +=1;
					break;
				case 1:
					//					NSLog(@"Count is 1 - set board");
					customPinView.image = [UIImage imageNamed:@"MCQMapBIKE29.png"];
					countMapKit +=1;
					break;
				case 2:
					//					NSLog(@"Count is 2 - set walker");
					customPinView.image = [UIImage imageNamed:@"walkAlpha30.png"];
					countMapKit +=1;
					break;
				default:
					NSLog(@"Count is DEFAULT - decide what to do");
					customPinView.image = [UIImage imageNamed:@"animatedBike29.jpg"];
					countMapKit +=1;
					break;
			}
			customPinView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
		}
		else{
			customPinView.image = [UIImage imageNamed:@"MCQMapSLICE.png"];
			customPinView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
		}
		//			customPinView.animatesDrop = NO;
		customPinView.canShowCallout = YES;
		return customPinView;
		
	} else {
		
		pinView.annotation = annotation;
	}
	
	return pinView;
	
}

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views {
	MKAnnotationView *annotationView;
	
	for (annotationView in views) {
		
		// Don't pin drop if annotation is user location
		//		if ([annotationView.annotation isKindOfClass:[MKUserLocation class]]) {
		//			continue;
		//		}
		
		// Check if current annotation is inside visible map rect, else go to next one
		MKMapPoint point =  MKMapPointForCoordinate(annotationView.annotation.coordinate);
		if (!MKMapRectContainsPoint(self.mapView.visibleMapRect, point)) {
			continue;
		}
		
		CGRect endFrame = annotationView.frame;
		
		// Move annotation out of view
		annotationView.frame = CGRectMake(annotationView.frame.origin.x, annotationView.frame.origin.y - self.view.frame.size.height, annotationView.frame.size.width, annotationView.frame.size.height);
		
		// Animate drop
		[UIView animateWithDuration:1.75 delay:0.4*[views indexOfObject:annotationView] options: UIViewAnimationOptionCurveLinear animations:^{
			
			annotationView.frame = endFrame;
			
			// Animate squash
		}completion:^(BOOL finished){
			if (finished) {
				[UIView animateWithDuration:2.95 animations:^{
					annotationView.transform = CGAffineTransformMakeScale(1.0, 0.8);
					
				}completion:^(BOOL finished){
					if (finished) {
						[UIView animateWithDuration:0.1 animations:^{
							annotationView.transform = CGAffineTransformIdentity;
						}];
					}
				}];
			}
		}];
	}
}

-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
	for (PizzaPlace *pizzaPlace in self.dao.pizzaPlaceArray) {
		if ([pizzaPlace.name isEqualToString:view.annotation.title]) {
			//			NSLog(@"my annotation %@ and my location %@",view.annotation.title, pizzaPlace.name);
			PizzaPlaceInfoViewController *pizzaPlaceInfoViewController = self.tabBarController.viewControllers[PPINFOPAGE];
			[pizzaPlaceInfoViewController setLabelValues:pizzaPlace];
			
			self.currentPizzaPlace = pizzaPlace;
			NSLog(@"pizza is %@, and self.pizza is %@", pizzaPlace.name, self.currentPizzaPlace.name);
			self.methodManager.directionsShow = NO;
			[self.tabBarController setSelectedIndex:PPINFOPAGE];
		}
		else if ([view.annotation.title isEqualToString:@"You Found Me"])
		{
			// maybe set values for ADDPAGE
			self.newAddress = view.annotation.coordinate;
			[self.tabBarController setSelectedIndex:ADDPAGE];
		}
		else if ([view.annotation.title isEqualToString:@"Current Location"])
		{
			NSLog(@"user clicked on self, show two options");
			self.newAddress = self.methodManager.locationManager.location.coordinate;
			//maybe link to personal/profile page & add PP in current location
			UIAlertView *alert = [[UIAlertView alloc]
								  initWithTitle:@"ADD A NEW PLACE"
								  message:@"Did you find a new Dollar Pizza?"
								  delegate:self
								  cancelButtonTitle:@"Cancel"
								  otherButtonTitles:@"ADD NEW", @"PROFILE", nil];
			[alert show];
			return;
		}
		
	}
}



#pragma mark - SearchBar Delegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
	searchBar.showsCancelButton = YES;
	return YES;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
	searchBar.showsCancelButton = NO;
	[self searchBarCancelButtonClicked:searchBar];
	return YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar {
	[UIView animateWithDuration:0.66f animations:^{
		// where is the search bar going?
		searchBar.frame = CGRectMake(-(self.view.bounds.size.width), self.methodManager.statusBarSize.height, self.view.bounds.size.width, 44);
		
		// unHide the search button
		self.searchButtonMapPage.alpha = 1.0;
		// unHide the speaker and options buttons
		self.methodManager.searching = NO;
		[self.methodManager searchBarPresent];
	}completion:^(BOOL finished) { //when finished, unHide the searchButton
		[self.view endEditing:YES];
		self.searchBar.hidden = YES;
	}];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)theSearchBar
{
	// keep the animation and actions of dismissing the search bar
	[self searchBarCancelButtonClicked:(UISearchBar *) self.searchBar];
	// add searchSubmit set to YES here (and NO at the bottom) if update to closest is necessary [for size of annotation on map]
	CLGeocoder *geocoder = [[CLGeocoder alloc] init];
	[geocoder geocodeAddressString:theSearchBar.text completionHandler:^(NSArray *placemarks, NSError *error) {
		//Error checking
		
		CLPlacemark *placemark = [placemarks objectAtIndex:0];
		MKCoordinateRegion region;
		region.center = [(CLCircularRegion *)placemark.region center];
		MKCoordinateSpan span;
		double radius = [(CLCircularRegion *)placemark.region radius]/1000;
		
		NSLog(@"[searchBarSearchButtonClicked] Radius is %f", radius);
		span.latitudeDelta = radius / 112.0;
		region.span = span;
		// add annotation pin for result? //ensure it goes away after the map is left
		[self.mapView setRegion:region animated:YES];
	}];
}
#pragma mark - UIAlertView

// bring user to settings of Pizza Time (stock settings)
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	
#pragma mark 1 - Location Not Found
	// 1 // location not found
	if ([alertView.title isEqualToString:@"Location Service Cannot Find You"]) {
		if (buttonIndex == 1) {
			[[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
			NSLog(@"user opened the settings");
		}
		else {
			NSLog(@"user does not care - set bool");
			self.methodManager.userLocRemind = NO;
		}
	}
#pragma mark 2 - Location Not Authorized
	// 2 // location not authorized
	else if ([alertView.title isEqualToString:@"Location Service Disabled"]) {
		//	NSLog(@"%ld", (long)buttonIndex);
		if (buttonIndex == 1) {
			[[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
		}
		else {
			NSLog(@"User does not want to share location - PLEASE set bool to not prompt again and again");
			// enter audio BUMMMMMMMERRRRR
			self.methodManager.userLocAuth = YES;
		}
	}
#pragma mark 3 - Cannot Connect Internet
	// 3 // internet troubles
	else if ([alertView.title isEqualToString:@"Cannot Connect To Internet"]) {
		//	NSLog(@"%ld", (long)buttonIndex);
		if (buttonIndex == 1) {
			[[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
		}
		else {
			NSLog(@"User does not want to use the internet - PLEASE set bool to not prompt again and again");
			// enter audio BUMMMMMMMERRRRR
		}
	}
#pragma mark 4 - Add New (HOLD Screen)
	// 4 // (hold gesture) add pizza OR set current
	else if ([alertView.title isEqualToString:@"ADD NEW PLACE"]) {
		if (buttonIndex == 1) {
			//			NSLog(@"Add new pizzaPlace to this location"); // add
			[self.tabBarController setSelectedIndex:ADDPAGE];
		}
		else if (buttonIndex == 2)		{
			NSLog(@"Set this location as current"); // current location
			MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(self.newAddress, 800, 800);
			// add annotation pin for result? //ensure it goes away after the map is left
			[self.mapView setRegion:region animated:YES];
			if (!self.methodManager.directionsShow) {
				MKCircle *circle = [MKCircle circleWithCenterCoordinate:self.newAddress radius:300];
				[self.mapView addOverlay:circle];
			}
			CLLocation *newLocation = [[CLLocation alloc]initWithLatitude:self.newAddress.latitude longitude:self.newAddress.longitude];
			self.methodManager.searchSubmit = YES; //setting new address
			[self findDistance:newLocation];
			[self sortByDistanceForClosest];
			self.methodManager.searchSubmit = NO; // no longer setting new address
		}
		else { //cancel
			NSLog(@"Selected cancel - remove the annotation just added");
			for (id annotation in self.mapView.annotations)
			{
				if ([[annotation title] isEqualToString:@"You Found Me"])
					[self.mapView removeAnnotation:annotation];
			}
		}
	}
#pragma mark 5 - Add New (Selected Current Location)
	// 5 // (current location tapped) add pizza OR open progile
	else if ([alertView.title isEqualToString:@"ADD A NEW PLACE"]) {
		if (buttonIndex == 1) {
			//			NSLog(@"Add new pizzaPlace to this location"); // add
			[self.tabBarController setSelectedIndex:ADDPAGE];
		}
		else if (buttonIndex == 2)		{
			//			NSLog(@"OPEN FEEDBACK PAGE"); // current location
			UIViewController *detailViewController = (UIViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"feedbackPage"];
			UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Profile Page Coming Soon"
																  message:@"Leave feedback in the mean time"
																 delegate:nil
														cancelButtonTitle:@"OK"
														otherButtonTitles: nil];
			
			[myAlertView show];
			self.methodManager.rotation = NO;
			[self presentViewController:detailViewController animated:YES completion:nil];
		}
		else { //cancel
			NSLog(@"Selected cancel");
		}
	}
	// 6 and any other //
	else {
		if (buttonIndex == 1) {
			NSLog(@"Please do something here - there is a problem with alertView response");
		}
		else {
			NSLog(@"Please do something here - there is a problem with alertView response");
		}
	}
}


#pragma mark - ACTIONS

// Main initial button press
-(void)searchButtonPressed:(UIButton *)searchButton {
	//	NSLog(@"searchButtonMapKit was pressed");
	// this should hide the buttons and present the search bar of Pizza Time
	self.methodManager.searching = YES;
	[self.methodManager searchBarPresent];
	[self.view bringSubviewToFront:self.searchBar];
	self.searchBar.frame = CGRectMake(-(self.view.bounds.size.width), self.methodManager.statusBarSize.height, self.view.bounds.size.width, 44);
	self.searchBar.hidden = NO;
	// set the search button alpha
	self.searchButtonMapPage.alpha = 0.5;
	[UIView animateWithDuration:0.66
					 animations:^{
						 // where is the search bar going?
						 self.searchBar.frame = CGRectMake(0, self.methodManager.statusBarSize.height, self.view.bounds.size.width, 44);
						 self.searchButtonMapPage.alpha = 0.0;
					 }];
	[self.searchBar becomeFirstResponder];
}

-(void)mapButtonPressed:(UIButton *)mapButton {
	NSLog(@"refresh the mapView here");
	// if no internet, do not attempt to reload
	TMReachability *reachability = [TMReachability reachabilityWithHostName:@"www.google.com"];
	NetworkStatus internetStatus = [reachability currentReachabilityStatus];
	if(internetStatus == NotReachable) {
		[self.dao textOnlyHud:@"No Internet"];
	}
	else {
		self.hud = [self.dao progresshud:@"Raining Pizzas"withColor:[UIColor clearColor]];
		//create a function that removes all annotations please
		[self removeAllAnnotations];
		self.dao.hideProgressHud = YES;
		[self.dao fromLocalDataPP];
		[self.view setUserInteractionEnabled:NO];
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(parseDone:)
													 name:@"FinishedLoadingData"
												   object:nil];
	}
}

- (void)removeAllAnnotations {
	id userLocation = [self.mapView userLocation];
	NSMutableArray *pins = [[NSMutableArray alloc] initWithArray:[self.mapView annotations]];
	if ( userLocation != nil ) {
		[pins removeObject:userLocation]; // avoid removing user location off the map
	}
	
	[self.mapView removeAnnotations:pins];
	pins = nil;
}

- (void)parseDone:(NSNotification *) notification {
	[self currentLocationButtonPressed];
	[self createPizzaPins];
	[[NSNotificationCenter defaultCenter]removeObserver:self
												   name:@"FinishedLoadingData"
												 object:nil];
	[self.hud hideAnimated:YES];
	//	[self.view setUserInteractionEnabled:YES];
}

- (void)listButtonPressed:(UIButton *)listButton {
	//	NSLog(@"open and present the listView here");
	[self.tabBarController setSelectedIndex:LISTPAGE];
}

// Main initial button press
- (void)currentLocationButtonPressed {
	//	[self.methodManager.locationManager startUpdatingLocation]; // added 2.11.16 unsure if necessary because testing on simulator
	NSLog(@"Current Location button was pressed \n(LAT = %f)",self.methodManager.locationManager.location.coordinate.latitude);
	NSArray *pointsArray = [self.mapView overlays];
	[self.mapView removeOverlays:pointsArray];
	for (id annotation in self.mapView.annotations)
	{
		if ([[annotation title] isEqualToString:@"You Found Me"])
			[self.mapView removeAnnotation:annotation];
	}
	// this should zoom in on current location again, if not found = ESB
	
	if (![self checkForLocationServicesEnabled]) return;
	if (![self checkForLocationServicesFound]) return;
	
	// we ARE authorized
	if (self.methodManager.locationManager.location.coordinate.latitude != 0.0 || self.methodManager.locationManager.location.coordinate.longitude != 0.0) { // location has value
		if (self.methodManager.directionsShow) {
			NSLog(@"showing directions, please set region to them");
			[self.mapView setRegion:[self regionForAnnotations] animated:NO];
		}
		else {// not directions, just show userLocation
			[self.mapView setRegion:MKCoordinateRegionMake(self.methodManager.locationManager.location.coordinate, MKCoordinateSpanMake(0.05f, 0.05f)) animated:YES];
			MKCircle *circle = [MKCircle circleWithCenterCoordinate:self.methodManager.locationManager.location.coordinate radius:500];
			[self.mapView addOverlay:circle];
		}
		// we have found the user
		userLocationShown = YES;
		[self findDistance:self.methodManager.locationManager.location];
	}
	else {
		userLocationShown = NO;
		[self findDistance:self.methodManager.empireStateBuilding];
		if (self.methodManager.directionsShow) {
			NSLog(@"showing directions, please set region with annotations");
			[self.mapView setRegion:[self regionForAnnotations] animated:NO];
		}
		else {
			// set region of map to focus on Empire State Building
			MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(self.methodManager.empireStateBuilding.coordinate, 1200, 1200);
			[self.mapView setRegion:region animated:YES];
		}
	}
}

-(void)handleLongPressGesture:(UIGestureRecognizer*)sender {
	// This is important if you only want to receive one tap and hold event
	if (sender.state == UIGestureRecognizerStateBegan)
	{
		//		NSLog(@"longPress state began");
		// removed 1.15.16 thinking this is why only 1
		//		[self.mapView removeGestureRecognizer:sender];
	}
	else if (sender.state == UIGestureRecognizerStateEnded){
		UIAlertView *alert = [[UIAlertView alloc]
							  initWithTitle:@"ADD NEW PLACE"
							  message:@"Did you find a new Dollar Pizza?"
							  delegate:self
							  cancelButtonTitle:@"Cancel"
							  otherButtonTitles:@"ADD NEW", @"Set as my Current Location", nil];
		[alert show];
		
		// Here we get the CGPoint for the touch and convert it to latitude and longitude coordinates to display on the map
		CGPoint point = [sender locationInView:self.mapView];
		self.newAddress = [self.mapView convertPoint:point toCoordinateFromView:self.mapView];
		// Then all you have to do is create the annotation and add it to the map
		//		MKAnnotation *dropPin = [[MKAnnotation	alloc] init];
		//		dropPin.latitude = [NSNumber numberWithDouble:newAddress.latitude];
		//		dropPin.longitude = [NSNumber numberWithDouble:newAddress.longitude];
		//		[self.mapView addAnnotation:dropPin];
		
		MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
		[annotation setCoordinate:self.newAddress];
		[annotation setTitle:@"You Found Me"]; //You can set the subtitle too
		[annotation setSubtitle:@"Are you my mother?"];
		[self.mapView addAnnotation:annotation];
		NSLog(@"%@", annotation);
		// this will be the two options ken wants
		NSLog(@"found new PP with lat = %f and long = %f", self.newAddress.latitude, self.newAddress.longitude);
		//If we keep this, add the values to an array of places, so that it will not only reload next time, it can be added to the dataBase
		/*
		 save the newAddress as a property
		 (newAddress  - to be used with search as well)
		 then in response to uilertview, use property to create place or set as current address
		 */
		
	}
}

@end
