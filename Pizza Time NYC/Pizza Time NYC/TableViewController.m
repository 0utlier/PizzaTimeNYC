//
//  TableViewController.m
//  Pizza Time NYC
//
//  Created by Aditya Narayan on 1/4/16.
//  Copyright © 2016 TTT. All rights reserved.
//

#import "TableViewController.h"
#import "MapKitViewController.h"

@interface TableViewController ()
@property (nonatomic, retain) MapKitViewController *mapKit;

@end

BOOL isRefreshIconsOverlap;
BOOL isRefreshAnimating;


@implementation TableViewController

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (void)viewDidLoad {
	[super viewDidLoad];
	//	NSLog(@"Table View Controller loaded!");
//	UIColor *orangeMCQ = [[UIColor alloc]initWithRed:255.0/255.0 green:206.0/255.0 blue:98.0/255.0 alpha:1.0];
//	self.view.backgroundColor = orangeMCQ; // this changes the bar where the buttons are

	// instantiate tableView
	self.tableView.delegate=self;
	self.tableView.dataSource=self;
//	self.tableView.backgroundColor = [[UIColor alloc]initWithRed:55.0/255.0 green:193.0/255.0 blue:0.0/255.0 alpha:1.0];
	
	self.methodManager = [MethodManager sharedManager];
	self.methodManager.statusBarSize = [[UIApplication sharedApplication] statusBarFrame].size;
	self.dao = [DAO sharedDAO];
	
	[self createPizzaCells];
	[self createSearchBar];
	// Uncomment the following line to preserve selection between presentations.
	//		self.clearsSelectionOnViewWillAppear = NO;
	// Uncomment the following line to display an Edit button in the navigation bar for this view controller.
	//		self.navigationItem.rightBarButtonItem = self.editButtonItem;
	if (self.methodManager.firstTimeLoaded) {
		self.mapKit = self.tabBarController.viewControllers[MAPPAGE];
		[self.mapKit sortByDistanceForClosest];
	}
	[self createRefreshControl];
//	[self.tableView reloadData]; // removed 2.12.16 unecessary?
}

-(void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self.navigationController setNavigationBarHidden:YES];
	[self.tableView reloadData];
	//	NSLog(@"realign bools here");
	self.methodManager.mapPageBool = NO;
	[self.view setNeedsDisplay];	// i am unsure of why i need this 1.19.16, and still on 1.29
	[self assignLabels];
}



#pragma mark - CREATE PAGE

-(void)createPizzaCells {
	for (PizzaPlace *pizzaPlace in self.dao.pizzaPlaceArray) {
		pizzaPlace.image = @"TwoBrosPizzaLogo.jpg";
		pizzaPlace.url = @"http://www.2brospizza.com/";
		//		[self createAnnotation:pizzaPlace];
	}
	//	NSLog(@"PizzaPlaceArray:%@", self.pizzaPlaceArray);
	
}

-(void)createSearchBar {
	self.searchBar.delegate = self;
	self.searchBar.placeholder = @"Search Address";

	self.searchBar.backgroundColor = [UIColor redColor]; // color of cancel and cursor
	self.searchBar.barTintColor = [[UIColor alloc]initWithRed:0.0/255.0 green:188.0/255.0 blue:204.0/255.0 alpha:1.0]; // color of the bar
//	self.searchBar.tintColor = [UIColor purpleColor]; // color of 'cancel'
	
	UIImageView *searchIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"walkAlpha30.png"]];
	searchIcon.frame = CGRectMake(10, 10, 24, 24);
	[self.searchBar addSubview:searchIcon];
	[[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setBackgroundColor:[[UIColor alloc]initWithRed:255.0/255.0 green:206.0/255.0 blue:98.0/255.0 alpha:1.0]]; // for ALL searchBars, do this. Effects every bar after called
	
	[self.view addSubview:self.searchBar];
	self.searchBar.hidden = YES;
}

-(void)assignLabels {// and buttons
	
	// if the button already exists, remove it from the superView
	[self.methodManager removeBothButtons];
	if (self.searchButtonTableView) {
		[self.searchButtonTableView removeFromSuperview];
	}
	
	
	[self.view addSubview:[self.methodManager assignOptionsButton]];
	[self.view addSubview:[self.methodManager assignSpeakerButton]];
	
	UIButton *searchButtonTableView = [[UIButton alloc]initWithFrame:CGRectMake(16, 16, 45, 45)];
	self.searchButtonTableView = searchButtonTableView;
	// Add an action in current code file (i.e. target)
	[self.searchButtonTableView addTarget:self
								   action:@selector(searchButtonPressed:)
						 forControlEvents:UIControlEventTouchUpInside];
	
	[self.searchButtonTableView setBackgroundImage:[UIImage imageNamed:@"MCQMapSEARCH.png"] forState:UIControlStateNormal];
	[self.view addSubview:self.searchButtonTableView];
	
	UIButton *mapButtonListPage = [[UIButton alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height - 49, self.view.bounds.size.width/2, 49)];
	self.mapButtonListPage = mapButtonListPage;
	// Add an action in current code file (i.e. target)
	[self.mapButtonListPage addTarget:self
							   action:@selector(mapButtonPressed:)
					 forControlEvents:UIControlEventTouchUpInside];
	
	[self.mapButtonListPage setBackgroundImage:[UIImage imageNamed:@"MCQTabBarMAP.png"] forState:UIControlStateNormal];
	[self.view addSubview:self.mapButtonListPage];
	
	UIButton *listButtonListPage = [[UIButton alloc]initWithFrame:CGRectMake(self.view.bounds.size.width/2, self.view.bounds.size.height - 49, self.view.bounds.size.width/2, 49)];
	self.listButtonListPage = listButtonListPage;
	// Add an action in current code file (i.e. target)
	[self.listButtonListPage addTarget:self
								action:@selector(listButtonPressed:)
					  forControlEvents:UIControlEventTouchUpInside];
	
	[self.listButtonListPage setBackgroundImage:[UIImage imageNamed:@"MCQTabBarLIST.png"] forState:UIControlStateNormal];
	[self.view addSubview:self.listButtonListPage];
	
	
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	//#warning Incomplete implementation, return the number of sections
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	//#warning Incomplete implementation, return the number of rows
	return [self.dao.pizzaPlaceArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 90;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"Cell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	// Configure the cell...
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
	}
	// Display pizzaPlace in the table cell
	PizzaPlace *pizzaPlace = [self.dao.pizzaPlaceArray objectAtIndex:indexPath.row];
	//	UIImageView *recipeImageView = (UIImageView *)[cell viewWithTag:100];
	//	recipeImageView.image = [UIImage imageNamed:recipe.imageFile];
	
	UILabel *nameLabel = (UILabel *)[cell viewWithTag:100];
	nameLabel.text = [pizzaPlace.name uppercaseString];
	
	//seperate the address into two lines
	UILabel *addressLabelTop = (UILabel *)[cell viewWithTag:101];
	addressLabelTop.text = pizzaPlace.street;
	
	UILabel *addressLabelBottom = (UILabel *)[cell viewWithTag:102];
	NSString *secondLineAddress = [pizzaPlace.city stringByAppendingString:[NSString stringWithFormat:@" %ld",(long)pizzaPlace.zip ]];
	//	NSLog(@"%@", secondLineAddress);
	addressLabelBottom.text = secondLineAddress;
	
	UILabel *distanceLabel = (UILabel *)[cell viewWithTag:103];
	distanceLabel.text = [NSString stringWithFormat:@"%.2f mi", pizzaPlace.distance];

	UILabel *ratingUpLabel = (UILabel *)[cell viewWithTag:104];
	ratingUpLabel.text = [NSString stringWithFormat:@"%.0f%%", pizzaPlace.percentageLikes];
	
	UILabel *ratingDownLabel = (UILabel *)[cell viewWithTag:105];
	ratingDownLabel.text = [NSString stringWithFormat:@"%.0f%%", pizzaPlace.percentageDislikes];

	
	UIButton *rated = (UIButton *)[cell viewWithTag:106];
//	rated.contentMode = UIViewContentModeScaleToFill;
//	rated.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
//	rated.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
//rated.imageView.contentMode = UIViewContentModeScaleAspectFit;
	if (pizzaPlace.rated == RATEDLIKE) {
		[rated setBackgroundImage:[UIImage imageNamed:@"MCQHeart.png"] forState:UIControlStateNormal];
	}
	else if (pizzaPlace.rated == RATEDDISLIKE) {
		[rated setBackgroundImage:[UIImage imageNamed:@"MCQHeartBroken.png"] forState:UIControlStateNormal];
	}
	else { // (self.currentPizzaPlace.rated == RATEDNOT)
		[rated setBackgroundImage:nil forState:UIControlStateNormal];
	}

	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	for (PizzaPlace *pizzaPlace in self.dao.pizzaPlaceArray) {
		if ([pizzaPlace.name isEqualToString:[[self.dao.pizzaPlaceArray objectAtIndex:indexPath.row]name]]) {
			//			NSLog(@"User selected the PP = %@ and wanted %@", [[self.dao.pizzaPlaceArray objectAtIndex:indexPath.row]name], pizzaPlace.name);
			
			// Pass the selected object to the new view controller.
			// Push the view controller.

			PizzaPlaceInfoViewController *pizzaPlaceInfoViewController = self.tabBarController.viewControllers[PPINFOPAGE];
			[pizzaPlaceInfoViewController setLabelValues:pizzaPlace];
			[self.tabBarController setSelectedIndex:PPINFOPAGE];
		}
	}
	//[self.tabBarController showViewController:detailViewController sender:NULL];
	
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */


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
	[UIView animateWithDuration:0.66f
					 animations:^{
						 // where is the search bar going?
						 searchBar.frame = CGRectMake(-(self.view.bounds.size.width), self.methodManager.statusBarSize.height, self.view.bounds.size.width, 44);
						 
						 // unHide the search button
						 self.searchButtonTableView.alpha = 1.0;
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
	self.methodManager.searchSubmit = YES; //searching for address
//	NSLog(@"self.methodManager.searchSubmit = YES");
//	NSLog(@"self.methodManager.searchSubmit is %d", self.methodManager.searchSubmit );
	
	CLGeocoder *geocoder = [[CLGeocoder alloc] init];
	[geocoder geocodeAddressString:theSearchBar.text completionHandler:^(NSArray *placemarks, NSError *error) {		//Error checking
		
		
		CLPlacemark *placemark = [placemarks objectAtIndex:0];
		CLLocation *resultLocation = placemark.location;
//		NSLog(@"result's lat %f",resultLocation.coordinate.latitude);

		// set the distance of the PPs, then sort by
		[self.mapKit findDistance:resultLocation];
//		NSLog(@"self.methodManager.searchSubmit is %d", self.methodManager.searchSubmit );
		[self.mapKit sortByDistanceForClosest];
		self.methodManager.searchSubmit = NO; // no longer searching for address
//		NSLog(@"self.methodManager.searchSubmit = NO");

		dispatch_async(dispatch_get_main_queue(), ^{
			[self.tableView reloadData];
			NSLog(@"search finished and reloaded");
		});
	}];
}


#pragma mark - REFRESH CONTROL
- (void)createRefreshControl
{
	// Programmatically inserting a UIRefreshControl
	self.refreshControl = [[UIRefreshControl alloc] init];
	
	// Setup the loading view, which will hold the moving graphics
	self.refreshLoadingView = [[UIView alloc] initWithFrame:self.refreshControl.bounds];
	self.refreshLoadingView.backgroundColor = [UIColor clearColor];
	
	// Setup the color view, which will display the rainbowed background
	self.refreshColorView = [[UIView alloc] initWithFrame:self.refreshControl.bounds];
	self.refreshColorView.backgroundColor = [UIColor clearColor];
	self.refreshColorView.alpha = 0.80;
	
	// Create the graphic image views
	self.pizzaImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MCQPizzaLoad.png"]];
	self.dollarImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MCQDollarLoad1.png"]];
	
	// Add the graphics to the loading view
	[self.refreshLoadingView addSubview:self.dollarImage];
	[self.refreshLoadingView addSubview:self.pizzaImage];
	
	// Clip so the graphics don't stick out
	self.refreshLoadingView.clipsToBounds = YES;
	
	// Hide the original spinner icon
	self.refreshControl.tintColor = [UIColor clearColor];
	
	// Add the loading and colors views to our refresh control
	[self.refreshControl addSubview:self.refreshColorView];
	[self.refreshControl addSubview:self.refreshLoadingView];
	
	// Initalize flags
	isRefreshIconsOverlap = NO;
	isRefreshAnimating = NO;
	
	// When activated, invoke our refresh function
	[self.refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
	
	// not mentioned in the tutorial, but added by 0utlier
	[self.tableView addSubview:self.refreshControl];
}

- (void)refresh:(id)sender{ // ??? this needs refreshing haha
	NSLog(@"begin = %f", self.methodManager.locationManager.location.coordinate.latitude);
	// -- DO SOMETHING AWESOME (... or just wait 3 seconds) --
	[self.view setUserInteractionEnabled:NO];
	// This is where you'll make requests to an API, reload data, or process information
	[self.dao fromLocalDataPP]; // this should update the likes
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(parseDone:)
												 name:@"FinishedLoadingData"
											   object:nil];
	/*
	double delayInSeconds = 5.0;
	dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
	dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
		[self.mapKit sortByDistanceForClosest];
		NSLog(@"DONE");
		[self.tableView reloadData];
		
		// When done requesting/reloading/processing invoke endRefreshing, to close the control
		[self.refreshControl endRefreshing];
		NSLog(@"after = %f", self.methodManager.locationManager.location.coordinate.latitude);
	});
	// -- FINISHED SOMETHING AWESOME, WOO! --
	 */
}

- (void) parseDone:(NSNotification *) notification {
	self.mapKit = self.tabBarController.viewControllers[MAPPAGE];
	[self.mapKit sortByDistanceForClosest];
	[self createPizzaCells];
	[self.tableView reloadData];
	[self.refreshControl endRefreshing];
	[[NSNotificationCenter defaultCenter]removeObserver:self name:@"FinishedLoadingData" object:nil];
	[self.view setUserInteractionEnabled:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	// Get the current size of the refresh controller
	CGRect refreshBounds = self.refreshControl.bounds;
	
	// Distance the table has been pulled >= 0
	CGFloat pullDistance = MAX(0.0, -self.refreshControl.frame.origin.y);
	
	// Half the width of the table
	CGFloat midX = self.tableView.frame.size.width / 2.0;
	
	// Calculate the width and height of our graphics
	CGFloat compassHeight = self.pizzaImage.bounds.size.height;
	CGFloat compassHeightHalf = compassHeight / 2.0;
	
	CGFloat compassWidth = self.pizzaImage.bounds.size.width;
	CGFloat compassWidthHalf = compassWidth / 2.0;
	
	CGFloat spinnerHeight = self.dollarImage.bounds.size.height;
	CGFloat spinnerHeightHalf = spinnerHeight / 2.0;
	
	CGFloat spinnerWidth = self.dollarImage.bounds.size.width;
	CGFloat spinnerWidthHalf = spinnerWidth / 2.0;
	
	// Calculate the pull ratio, between 0.0-1.0
	CGFloat pullRatio = MIN( MAX(pullDistance, 0.0), 100.0) / 100.0;
	
	// Set the Y coord of the graphics, based on pull distance
	CGFloat compassY = pullDistance / 2.0 - compassHeightHalf;
	CGFloat spinnerY = pullDistance / 2.0 - spinnerHeightHalf;
	
	// Calculate the X coord of the graphics, adjust based on pull ratio
	CGFloat compassX = (midX + compassWidthHalf) - (compassWidth * pullRatio);
	CGFloat spinnerX = (midX - spinnerWidth - spinnerWidthHalf) + (spinnerWidth * pullRatio);
	
	// When the compass and spinner overlap, keep them together
	if (fabs(compassX - spinnerX) < 1.0) {
		isRefreshIconsOverlap = YES;
	}
	
	// If the graphics have overlapped or we are refreshing, keep them together
	if (isRefreshIconsOverlap || self.refreshControl.isRefreshing) {
		compassX = midX - compassWidthHalf;
		spinnerX = midX - spinnerWidthHalf;
	}
	
	// Set the graphic's frames
	CGRect pizzaFrame = self.pizzaImage.frame;
	pizzaFrame.origin.x = compassX;
	pizzaFrame.origin.y = compassY;
	
	CGRect dollarFrame = self.dollarImage.frame;
	dollarFrame.origin.x = spinnerX;
	dollarFrame.origin.y = spinnerY;
	
	self.pizzaImage.frame = pizzaFrame;
	self.dollarImage.frame = dollarFrame;
	
	// Set the encompassing view's frames
	refreshBounds.size.height = pullDistance;
	
	self.refreshColorView.frame = refreshBounds;
	self.refreshLoadingView.frame = refreshBounds;
	
	// If we're refreshing and the animation is not playing, then play the animation
	if (self.refreshControl.isRefreshing && !isRefreshAnimating) {
		[self animateRefreshView];
	}
	
	//	NSLog(@"pullDistance: %.1f, pullRatio: %.1f, midX: %.1f, isRefreshing: %i", pullDistance, pullRatio, midX, self.refreshControl.isRefreshing);
}

- (void)animateRefreshView
{
	// Background color to loop through for our color view
	NSArray *colorArray = @[[UIColor redColor],[UIColor blueColor],[UIColor purpleColor],[UIColor cyanColor],[UIColor orangeColor],[UIColor magentaColor]];
	static int colorIndex = 0;
	
	// Flag that we are animating
	isRefreshAnimating = YES;
	
	[UIView animateWithDuration:0.3
						  delay:0
						options:UIViewAnimationOptionCurveLinear
					 animations:^{
						 // Rotate the spinner by M_PI_2 = PI/2 = 90 degrees
						 [self.dollarImage setTransform:CGAffineTransformRotate(self.dollarImage.transform, M_PI)];
       
						 // Change the background color
						 self.refreshColorView.backgroundColor = [colorArray objectAtIndex:colorIndex];
						 colorIndex = (colorIndex + 1) % colorArray.count;
					 }
					 completion:^(BOOL finished) {
						 // If still refreshing, keep spinning, else reset
						 if (self.refreshControl.isRefreshing) {
							 [self animateRefreshView];
						 }else{
							 [self resetAnimation];
						 }
					 }];
}

- (void)resetAnimation
{
	// Reset our flags and background color
	isRefreshAnimating = NO;
	isRefreshIconsOverlap = NO;
	self.refreshColorView.backgroundColor = [UIColor clearColor];
}


#pragma mark - ACTIONS

// Main initial button press
-(void)searchButtonPressed:(UIButton *)searchButton {
	NSLog(@"searchButtonTable was pressed");
	// this should hide the buttons and present the search bar of Pizza Time
	self.methodManager.searching = YES;
	[self.methodManager searchBarPresent];
	[self.view bringSubviewToFront:self.searchBar];
	self.searchBar.frame = CGRectMake(-(self.view.bounds.size.width), self.methodManager.statusBarSize.height, self.view.bounds.size.width, 44);
	self.searchBar.hidden = NO;
	// set the search button alpha
	self.searchButtonTableView.alpha = 0.5;
	[UIView animateWithDuration:0.66
					 animations:^{
						 // where is the search bar going?
						 self.searchBar.frame = CGRectMake(0, self.methodManager.statusBarSize.height, self.view.bounds.size.width, 44);
						 self.searchButtonTableView.alpha = 0.0;
					 }];
	[self.searchBar becomeFirstResponder];
}

-(void)mapButtonPressed:(UIButton *)mapButton {
//	NSLog(@"open and present the mapView here");
	[self.tabBarController setSelectedIndex:MAPPAGE];
}

-(void)listButtonPressed:(UIButton *)listButton {
	NSLog(@"refresh the listView here");
	[self.tableView reloadData];
}

@end
