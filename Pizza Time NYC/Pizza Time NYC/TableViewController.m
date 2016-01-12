//
//  TableViewController.m
//  Pizza Time NYC
//
//  Created by Aditya Narayan on 1/4/16.
//  Copyright © 2016 TTT. All rights reserved.
//

#import "TableViewController.h"

@interface TableViewController ()

@end

@implementation TableViewController

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (void)viewDidLoad {
	[super viewDidLoad];
	//	NSLog(@"Table View Controller loaded!");
	// instantiate tableView
	self.tableView.delegate=self;//unsure if necessary
	self.tableView.dataSource=self;
	self.methodManager = [MethodManager sharedManager];
//	self.appDelegate = [AppDelegate sharedDelegate];
	self.dao = [DAO sharedDAO];
	[self.dao createPizzaPlaces];
	[self createPizzaCells];
	[self createSearchBar];
	// Uncomment the following line to preserve selection between presentations.
	// self.clearsSelectionOnViewWillAppear = NO;
	[self assignLabels];
	// Uncomment the following line to display an Edit button in the navigation bar for this view controller.
	// self.navigationItem.rightBarButtonItem = self.editButtonItem;
	[self sortByDistance];
	//	self.navigationController.hidesBarsOnTap = YES;
	[self.tableView reloadData];
}

-(void)viewWillAppear:(BOOL)animated {
	[self.navigationController setNavigationBarHidden:YES];
	[self.tableView reloadData];
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
	[self.view addSubview:self.searchBar];
	self.searchBar.hidden = YES;
}

-(void)assignLabels {// and buttons
	
	[self.view addSubview:[self.methodManager assignOptionsButton]];
	[self.view addSubview:[self.methodManager assignSpeakerButton]];
//	NSLog(@"view has width of %f", self.view.bounds.size.width);
	UIButton *searchButtonMapPage = [[UIButton alloc]initWithFrame:CGRectMake(16, 16, 60, 60)];
	// Add an action in current code file (i.e. target)
	[searchButtonMapPage addTarget:self
							 action:@selector(searchButtonPressed:)
				   forControlEvents:UIControlEventTouchUpInside];
	
	[searchButtonMapPage setBackgroundImage:[UIImage imageNamed:@"search60.png"] forState:UIControlStateNormal];
	[self.view addSubview:searchButtonMapPage];

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
	nameLabel.text = pizzaPlace.name;
	
	//seperate the address into two lines
	UILabel *addressLabelTop = (UILabel *)[cell viewWithTag:101];
	addressLabelTop.text = pizzaPlace.street;
	
	UILabel *addressLabelBottom = (UILabel *)[cell viewWithTag:102];
	NSString *secondLineAddress = [pizzaPlace.city stringByAppendingString:[NSString stringWithFormat:@" %ld",(long)pizzaPlace.zip ]];
	//	NSLog(@"%@", secondLineAddress);
	addressLabelBottom.text = secondLineAddress;
	
	UILabel *distanceLabel = (UILabel *)[cell viewWithTag:103];
	distanceLabel.text = [NSString stringWithFormat:@"%.2f mi", pizzaPlace.distance];
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	//	PizzaPlaceInfoViewController *detailViewController = (PizzaPlaceInfoViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"PizzaPlaceInfoViewController"];
	for (PizzaPlace *pizzaPlace in self.dao.pizzaPlaceArray) {
		if ([pizzaPlace.name isEqualToString:[[self.dao.pizzaPlaceArray objectAtIndex:indexPath.row]name]]) {
			//			NSLog(@"User selected the PP = %@ and wanted %@", [[self.dao.pizzaPlaceArray objectAtIndex:indexPath.row]name], pizzaPlace.name);
			
			// Pass the selected object to the new view controller.
			// Push the view controller.
			
			UITabBarController *tabBarController = [self.storyboard instantiateViewControllerWithIdentifier:@"TabBarController"];//TabBarController
			//tabBarController.viewControllers = @[detailViewController];
			PizzaPlaceInfoViewController *pizzaPlaceInfoViewController = tabBarController.viewControllers[0];
						PizzaPlaceDirectionsViewController *pizzaPlaceDirectionsViewController = tabBarController.viewControllers[1];
			[pizzaPlaceInfoViewController setLabelValues:pizzaPlace];
						[pizzaPlaceDirectionsViewController setPizzaPlaceProperty:pizzaPlace];
			
			[self.navigationController pushViewController:tabBarController animated:YES];
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

-(void)sortByDistance {
	NSSortDescriptor *mySorter = [[NSSortDescriptor alloc] initWithKey:@"distance" ascending:YES];
	[self.dao.pizzaPlaceArray sortUsingDescriptors:[NSArray arrayWithObject:mySorter]];
}

#pragma mark - SearchBar Delegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
	searchBar.showsCancelButton = YES;
	return YES;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
	searchBar.showsCancelButton = NO;
	return YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar {
//	[searchBar resignFirstResponder];
//	[searchBar setShowsCancelButton:NO animated:YES];
//		self.searchBar.hidden = YES;
	// show the buttons again
//	[self.view bringSubviewToFront:self.searchBar];
//	self.searchBar.frame = CGRectMake(0, 0, 320, 480);
	[UIView animateWithDuration:0.66
					 animations:^{
						 self.searchBar.frame = CGRectMake(-320, 16, 320, 44);
					 }];
//	self.searchBar.hidden = YES;
//	[self assignLabels];
}

#pragma mark - ACTIONS

// Main initial button press
-(void)searchButtonPressed:(UIButton *)searchButton {
	NSLog(@"searchButton was pressed");
	// this should hide the buttons and present the search bar of Pizza Time
//	self.searchBar.hidden = NO;
//	optionsButton.hidden = YES;
	searchButton.hidden = YES;
	[self.view bringSubviewToFront:self.searchBar];
	self.searchBar.frame = CGRectMake(-320, 0, 320, 480);
	self.searchBar.hidden = NO;
	[UIView animateWithDuration:0.66
					 animations:^{
						 self.searchBar.frame = CGRectMake(0, 0, 320, 480);
					 }];
	[self.searchBar becomeFirstResponder];

}
@end
