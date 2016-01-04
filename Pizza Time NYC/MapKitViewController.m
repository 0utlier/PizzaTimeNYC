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

BOOL userLocationShown;

@implementation MapKitViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	userLocationShown = NO;
	self.UserLocationProperty = [[MKUserLocation alloc] init];
	[self createLocationManager];
	[self createMapView];
	[self checkForLocationServicesEnabled]; // originally after "createLocationManager"
	// moved for ESB zoom
	
	[self createPizzaPlaces];
//	[self createToolBar];
//	[self createTabBar];
	[self createSearchBar];
	[self createLongPressGesture];
	//check for location
	//	[self currentLocationButtonPressed]; // this slows down the process of showing the user's location
	
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
// commented out for TabBar addition // delegate

//-(void)createToolBar {
//	[self.view addSubview:self.mapToolBar];
//	//uncomment following line for programmtic version of toolBar
//	
//	/*UIToolbar *toolbar = [[UIToolbar alloc] init];
//	 toolbar.frame = CGRectMake(0, 0, self.view.frame.size.width, 44);
//	 NSMutableArray *items = [[NSMutableArray alloc] init];
//	 [items addObject:[[[UIBarButtonItem alloc] initWith....]];
//	 [toolbar setItems:items animated:NO];
//	 [self.view addSubview:toolbar];*/
//	
//	// Add an action for each bar button ITEM
//	self.currentLocationButton.target = self;
//	self.currentLocationButton.action = @selector(currentLocationButtonPressed);
//	
//	self.searchAddressButton.target = self;
//	self.searchAddressButton.action = @selector(searchButtonPressed);
//	
//	/* //uncomment this if infoButton needs to do anything besides open page
//	 self.addPizzaPlaceButton.target = self;
//	 self.addPizzaPlaceButton.action = @selector(addPizzaPlaceButtonPressed);
//	 
//	 self.infoButton.target = self;
//	 self.infoButton.action = @selector(infoButtonPressed);
//	 */
//}
//
//-(void)createTabBar {
//	[self.view addSubview:self.mapTabBar];
//}

-(void)createSearchBar {
	self.searchBar.delegate = self;
	[self.view addSubview:self.searchBar];
	self.searchBar.hidden = YES;
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
	searchBar.showsCancelButton = YES;
	return YES;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
	searchBar.showsCancelButton = NO;
	return YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar {
	[searchBar resignFirstResponder];
	[searchBar setShowsCancelButton:NO animated:YES];
	self.searchBar.hidden = YES;
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

#pragma mark - custom Annotations

-(void)createPizzaPlaces
{
	//TwoBros PizzaPlaces //as of 12.26.15 we have 7 TB
	// name, address, image, url, Lat / Long
	PizzaPlace *tb32_stMarks = [[PizzaPlace alloc]init];
	PizzaPlace *tb542_9thAve = [[PizzaPlace alloc]init];
	PizzaPlace *tb601_6thAve = [[PizzaPlace alloc]init];
	PizzaPlace *tb557_8thAve = [[PizzaPlace alloc]init];
	PizzaPlace *tb31_46thSt = [[PizzaPlace alloc]init];
	PizzaPlace *tb755_6thAve = [[PizzaPlace alloc]init];
	PizzaPlace *tb319_6thAve = [[PizzaPlace alloc]init];
	
	tb32_stMarks.pizzaPlaceName = @"Two Bros 32 St. Marks";
	tb542_9thAve.pizzaPlaceName = @"Two Bros 542 9th Ave";
	tb601_6thAve.pizzaPlaceName = @"Two Bros 601 6th Ave";
	tb557_8thAve.pizzaPlaceName = @"Two Bros 557 8th Ave";
	tb31_46thSt.pizzaPlaceName = @"Two Bros 31 46th St";
	tb755_6thAve.pizzaPlaceName = @"Two Bros 755 6th Ave";
	tb319_6thAve.pizzaPlaceName = @"Two Bros 319 6th Ave";
	
	tb32_stMarks.pizzaPlaceAddress = @"32 Saint Marks Place New York NY 10003";
	tb32_stMarks.pizzaPlaceLatitude = 40.728677;
	tb32_stMarks.pizzaPlaceLongitude = -73.988488;
	
	tb542_9thAve.pizzaPlaceAddress = @"542 9th Ave New York NY 10018";
	tb542_9thAve.pizzaPlaceLatitude = 40.756921;
	tb542_9thAve.pizzaPlaceLongitude = -73.993333;
	
	tb601_6thAve.pizzaPlaceAddress = @"601 6th Ave New York NY 10011";
	tb601_6thAve.pizzaPlaceLatitude = 40.739602;
	tb601_6thAve.pizzaPlaceLongitude = -73.995534;
	
	tb557_8thAve.pizzaPlaceAddress = @"557 8th Ave New York NY 10018";
	tb557_8thAve.pizzaPlaceLatitude = 40.754742;
	tb557_8thAve.pizzaPlaceLongitude = -73.992015;
	
	tb31_46thSt.pizzaPlaceAddress = @"31 West 46th St New York NY 10036";
	tb31_46thSt.pizzaPlaceLatitude = 40.756775;
	tb31_46thSt.pizzaPlaceLongitude = -73.980227;
	
	tb755_6thAve.pizzaPlaceAddress = @"755 6th Ave New York NY 10010";
	tb755_6thAve.pizzaPlaceLatitude = 40.744382;
	tb755_6thAve.pizzaPlaceLongitude = -73.992049;
	
	tb319_6thAve.pizzaPlaceAddress = @"319 6th Avenue New York NY 10014";
	tb319_6thAve.pizzaPlaceLatitude = 40.731076;
	tb319_6thAve.pizzaPlaceLongitude = -74.001708;
	
	self.pizzaPlaceArray = [[NSMutableArray alloc]initWithArray:@[tb32_stMarks, tb542_9thAve, tb601_6thAve, tb557_8thAve, tb31_46thSt, tb755_6thAve, tb319_6thAve]];
	
	for (PizzaPlace *pizzaPlace in self.pizzaPlaceArray) {
		pizzaPlace.pizzaPlaceImage = @"TwoBrosPizzaLogo.jpg";
		pizzaPlace.pizzaPlaceURL = @"http://www.2brospizza.com/";
		[self createAnnotation:pizzaPlace];
	}
	//	NSLog(@"PizzaPlaceArry:%@", self.pizzaPlaceArray);
}

- (void)createAnnotation:(PizzaPlace *)PizzaPlace
{
	CLLocationCoordinate2D centerCoordinate;
	centerCoordinate.latitude = PizzaPlace.pizzaPlaceLatitude;
	centerCoordinate.longitude = PizzaPlace.pizzaPlaceLongitude;
	MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
	[annotation setCoordinate:centerCoordinate];
	[annotation setTitle:PizzaPlace.pizzaPlaceName]; //You can set the subtitle too
	[annotation setSubtitle:PizzaPlace.pizzaPlaceAddress];
	[self.mapView addAnnotation:annotation];
	
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
	 UIImage *image = [UIImage imageNamed:pizzaPlace.pizzaPlaceImage];
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
			customPinView.image = [UIImage imageNamed:@"animatedBike29.jpg"];
		}
		else{
			customPinView.image = [UIImage imageNamed:@"Icon-Small.png"];
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
	MKAnnotationView *aV;
	
	for (aV in views) {
		
		// Don't pin drop if annotation is user location
		//		if ([aV.annotation isKindOfClass:[MKUserLocation class]]) {
		//			continue;
		//		}
		
		// Check if current annotation is inside visible map rect, else go to next one
		MKMapPoint point =  MKMapPointForCoordinate(aV.annotation.coordinate);
		if (!MKMapRectContainsPoint(self.mapView.visibleMapRect, point)) {
			continue;
		}
		
		CGRect endFrame = aV.frame;
		
		// Move annotation out of view
		aV.frame = CGRectMake(aV.frame.origin.x, aV.frame.origin.y - self.view.frame.size.height, aV.frame.size.width, aV.frame.size.height);
		
		// Animate drop
		[UIView animateWithDuration:2.5 delay:0.4*[views indexOfObject:aV] options: UIViewAnimationOptionCurveLinear animations:^{
			
			aV.frame = endFrame;
			
			// Animate squash
		}completion:^(BOOL finished){
			if (finished) {
				[UIView animateWithDuration:2.95 animations:^{
					aV.transform = CGAffineTransformMakeScale(1.0, 0.8);
					
				}completion:^(BOOL finished){
					if (finished) {
						[UIView animateWithDuration:0.1 animations:^{
							aV.transform = CGAffineTransformIdentity;
						}];
					}
				}];
			}
		}];
	}
}

-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
	WebViewController *detailViewController = (WebViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"WebViewController"];
	for (PizzaPlace *pizzaPlace in self.pizzaPlaceArray) {
		if ([pizzaPlace.pizzaPlaceName isEqualToString:view.annotation.title]) {
			NSLog(@"my annotation %@ and my location %@",view.annotation.title, pizzaPlace.pizzaPlaceName);
			detailViewController.url = pizzaPlace.pizzaPlaceURL;
			// Pass the selected object to the new view controller.
			// Push the view controller.
		}
	}
	[self.navigationController pushViewController:detailViewController animated:YES];
}


//-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
//{
//	NSLog(@"Location: %f, %f",
//		  userLocation.location.coordinate.latitude,
//		  userLocation.location.coordinate.longitude);
//	MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.location.coordinate, 250, 250);
////	[self.mapView setRegion:region animated:YES];
//}


#pragma mark - MKMapViewDelegate

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
	self.UserLocationProperty = userLocation;
	if(userLocationShown) return;
	// set the inital map view location to user and use region of 0.01 x 0.01
	[self.mapView setRegion:MKCoordinateRegionMake(userLocation.coordinate, MKCoordinateSpanMake(0.05f, 0.05f)) animated:YES];
	userLocationShown = YES;
	
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark - ACTIONS

// Main initial button press
-(void)infoButtonPressed { //currently commented out, because StoryBoard is showing the current display correctly
	NSLog(@"info button was pressed");
	// this should open the Info Page of Pizza Time
}

// Main initial button press
-(void)currentLocationButtonPressed {
	NSLog(@"Current Location button was pressed");
	// this should zoom in on current location again
	
	[self checkForLocationServicesEnabled];
	if([CLLocationManager authorizationStatus]!=kCLAuthorizationStatusDenied)
	{
		
		[self.mapView setRegion:MKCoordinateRegionMake(self.UserLocationProperty.coordinate, MKCoordinateSpanMake(0.05f, 0.05f)) animated:YES];
		
		self.locationManager.delegate = self;
		self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
		userLocationShown = NO;
		
		[self.locationManager startUpdatingLocation];
	}
}

// bring user to settings of Pizza Time (stock settings)
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	//	NSLog(@"%ld", (long)buttonIndex);
	if (buttonIndex == 1) {
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
	}
	else {
		NSLog(@"User does not want to share location");
		// enter audio BUMMMMMMMERRRRR
	}
}

-(void)checkForLocationServicesEnabled {
	//check for authorization here
	if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusDenied)
	{
		// set Empire State Building as a location and set pin
		CLLocationCoordinate2D centerCoordinate;
		centerCoordinate.latitude = 40.7484;
		centerCoordinate.longitude = -73.9857;
		NSLog(@"lat = %f, long = %f", centerCoordinate.latitude, centerCoordinate.longitude);
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

// Main initial button press
-(void)searchButtonPressed {
	NSLog(@"Search button was pressed");
	// this should unhide the search bar
	if (self.searchBar.hidden == YES) {
		self.searchBar.hidden = NO;
		[self.searchBar becomeFirstResponder];
	}
	else {
		self.searchBar.hidden = YES;
	}
	
}

// Main initial button press
-(void)addPizzaPlaceButtonPressed{//currently commented out, because StoryBoard is showing the current display correctly
	NSLog(@"addPizzaPlace button was pressed");
	// this should open the addPizzaPlace view of Pizza Time
}

-(void)createLongPressGesture {
	UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGesture:)];
	[self.mapView addGestureRecognizer:longPressGesture];
}

-(void)handleLongPressGesture:(UIGestureRecognizer*)sender {
	// This is important if you only want to receive one tap and hold event
	if (sender.state == UIGestureRecognizerStateEnded)
	{
		[self.mapView removeGestureRecognizer:sender];
	}
	else
	{
		// Here we get the CGPoint for the touch and convert it to latitude and longitude coordinates to display on the map
		CGPoint point = [sender locationInView:self.mapView];
		CLLocationCoordinate2D locCoord = [self.mapView convertPoint:point toCoordinateFromView:self.mapView];
		// Then all you have to do is create the annotation and add it to the map
		//		MKAnnotation *dropPin = [[MKAnnotation	alloc] init];
		//		dropPin.latitude = [NSNumber numberWithDouble:locCoord.latitude];
		//		dropPin.longitude = [NSNumber numberWithDouble:locCoord.longitude];
		//		[self.mapView addAnnotation:dropPin];
		
		CLLocationCoordinate2D centerCoordinate;
		centerCoordinate.latitude = (CLLocationDegrees)locCoord.latitude;
		centerCoordinate.longitude = (CLLocationDegrees)locCoord.longitude;
		MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
		[annotation setCoordinate:centerCoordinate];
		[annotation setTitle:@"You Found Me"]; //You can set the subtitle too
		[annotation setSubtitle:@"Are you my mother?"];
		[self.mapView addAnnotation:annotation];
		//If we keep this, add the values to an array of places, so that it will not only reload next time, it can be added to the dataBase
		
	}
}

@end
