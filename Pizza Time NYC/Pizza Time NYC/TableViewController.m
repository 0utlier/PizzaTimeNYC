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

- (void)viewDidLoad {
    [super viewDidLoad];
//	NSLog(@"Table View Controller loaded!");
	// instantiate tableView
	self.tableView.delegate=self;//unsure if necessary
	self.tableView.dataSource=self;
	
	self.dao = [DAO sharedDAO];
	[self.dao createPizzaPlaces];
	[self createPizzaCells];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
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
	nameLabel.text = pizzaPlace.pizzaPlaceName;
	
	UILabel *addressLabel = (UILabel *)[cell viewWithTag:101];
	addressLabel.text = pizzaPlace.pizzaPlaceAddress;

	UILabel *distanceLabel = (UILabel *)[cell viewWithTag:102];
	distanceLabel.text = [NSString stringWithFormat:@"%f", pizzaPlace.pizzaPlaceDistance];

	return cell;
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

-(void)createPizzaCells {
	for (PizzaPlace *pizzaPlace in self.dao.pizzaPlaceArray) {
		pizzaPlace.pizzaPlaceImage = @"TwoBrosPizzaLogo.jpg";
		pizzaPlace.pizzaPlaceURL = @"http://www.2brospizza.com/";
//		[self createAnnotation:pizzaPlace];
	}
	//	NSLog(@"PizzaPlaceArry:%@", self.pizzaPlaceArray);
	
}




@end
