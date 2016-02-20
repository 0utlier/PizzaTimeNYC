//
//  DAO.m
//  Pizza Time NYC
//
//  Created by JD Leonard on 1/4/16.
//  Copyright © 2016 TTT. All rights reserved.
//

#import "DAO.h"

@implementation DAO

+ (instancetype)sharedDAO
{
	static DAO *sharedDAO = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		sharedDAO = [[DAO alloc] init];
		// Do any other initialisation stuff here
	});
	return sharedDAO;
}

- (NSMutableArray *) pizzaPlaceArray { // every time that pizzaPlaceArray GETS assigned, this gets called
	if (!_pizzaPlaceArray) {
		_pizzaPlaceArray = [NSMutableArray new];
	}
	return _pizzaPlaceArray;
}

#pragma mark - Connection

-(void)alertTheUser {
	
	PFQuery *queryAlert = [PFQuery queryWithClassName:@"Alerts"];
	[queryAlert whereKey:@"user" equalTo:[PFUser currentUser]];
	[queryAlert getFirstObjectInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
		if (object) {
			self.alertObject = object;
			UIAlertView *userAlertView = [[UIAlertView alloc] initWithTitle:nil
															  message:object[@"alert"]
																   delegate:self
														  cancelButtonTitle:@"Remind Me"
														  otherButtonTitles: @"Understood",nil];
			
			[userAlertView show];
		}
		else {
			NSLog(@"no message found for the user");
		}
	}];
}

-(MBProgressHUD *)progresshud:(NSString *)label withColor:(UIColor *)color {// withSize:(CGRect)size{
	// Load images
	NSArray *imageNames = @[@"KenPizzaMan1.png", @"KenPizzaMan3.png", @"KenPizzaMan5.png", @"KenPizzaMan9.png", @"KenPizzaMan11.png", @"KenPizzaMan13.png", @"KenPizzaMan15.png", @"KenPizzaMan19.png"];
	
	NSMutableArray *images = [[NSMutableArray alloc] init];
	for (int i = 0; i < imageNames.count; i++) {
		[images addObject:[UIImage imageNamed:[imageNames objectAtIndex:i]]];
	}
	
	// Normal Animation
	UIImageView *animationImageView = [[UIImageView alloc] init];//WithFrame:CGRectMake(200, 200, 100, 100)];
	animationImageView.animationImages = images;
	animationImageView.animationDuration = 0.8;
	[animationImageView startAnimating];
	
	UIWindow *window = [[[UIApplication sharedApplication] windows] lastObject];
	MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:window.rootViewController.view animated:YES];
	hud.mode = MBProgressHUDModeCustomView;
	hud.customView = [[UIImageView alloc]init];
	hud.opaque = NO; // didnt see a difference
	hud.customView = animationImageView;
	hud.label.text = label;// from parameter
	UIColor *blueMCQ = [[UIColor alloc]initWithRed:0.0/255.0 green:188.0/255.0 blue:204.0/255.0 alpha:1.0];
	hud.contentColor = blueMCQ; // color for TEXT
	//	hud.label.backgroundColor = [UIColor colorWithRed:0 green:150 blue:0 alpha:0.0f]; // color for label background
	hud.frame = CGRectMake(window.bounds.origin.x, window.center.y, window.bounds.size.width, window.center.y);// for full
	hud.bezelView.backgroundColor = color;
	hud.backgroundColor = color; // color for full background
	
	//	hud.bezelView.color = orangeMCQ;// [[UIColor whiteColor] colorWithAlphaComponent:0.0];
	//	hud.bezelView.opaque = NO;
	//	hud.bezelView.alpha = 0.1;
	//	hud.backgroundView.color = orangeMCQ;//[[UIColor whiteColor] colorWithAlphaComponent:0.0];
	//	hud.customView.backgroundColor = orangeMCQ;
	[hud showAnimated:YES];
	return hud;
}
-(MBProgressHUD *)textOnlyHud:(NSString *)label {
	UIWindow *window = [[[UIApplication sharedApplication] windows] lastObject];
	MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:window.rootViewController.view animated:YES];
	hud.mode = MBProgressHUDModeText;
	hud.label.text = label;
	UIColor *blueMCQ = [[UIColor alloc]initWithRed:0.0/255.0 green:188.0/255.0 blue:204.0/255.0 alpha:1.0];
	UIColor *orangeMCQ = [[UIColor alloc]initWithRed:255.0/255.0 green:206.0/255.0 blue:98.0/255.0 alpha:1.0];
	hud.contentColor = orangeMCQ;
	hud.bezelView.backgroundColor = blueMCQ;
	// Move to center.
	hud.offset = CGPointMake(0.f, 0.f);
	[hud hideAnimated:YES afterDelay:3.f];
	return hud;
}

-(void)emptyAlert {
	UIAlertView *noInternet = [[UIAlertView alloc] initWithTitle:@"No connection to the internet found"
														 message:@"Pizza Places are not updated"
														delegate:self
											   cancelButtonTitle:@"OK"
											   otherButtonTitles: @"Try Again",nil];
	[noInternet show];
}


#pragma mark - PARSE Downloading

-(void) downloadParsePP {
	NSLog(@"download parse");
	// iterate through and create PP instance for place
	PFQuery *query = [PFQuery queryWithClassName:@"PizzaPlaceParse"];
	
	// Sorts the results in ascending order by the ZIP field
	[query orderByAscending:@"zip"];
	UIColor *orangeMCQ = [[UIColor alloc]initWithRed:255.0/255.0 green:206.0/255.0 blue:98.0/255.0 alpha:1.0];
	MBProgressHUD *hud;
	if (!self.hideProgressHud) {
		hud = [self progresshud:@"Makin' Pizza" withColor:orangeMCQ];
	}
	NSDate *myDate = (NSDate *)[[NSUserDefaults standardUserDefaults] objectForKey:@"myDateKey"];
	if (myDate) {
		[query whereKey:@"updatedAt" greaterThanOrEqualTo:myDate];
		// if no internet, hide animation
		TMReachability *reachability = [TMReachability reachabilityWithHostName:@"www.google.com"];
		NetworkStatus internetStatus = [reachability currentReachabilityStatus];
		if(internetStatus == NotReachable) {
			[hud hideAnimated:YES];
			return;
		}
	}
	else {// first time
		self.pizzaPlaceArray = [[NSMutableArray alloc]init]; // removed old one, and replace with new
	}
		[query findObjectsInBackgroundWithBlock:^(NSArray *parseArray, NSError *error) {
			if (!error) {
				// save current date and time to nsuser defaults
				NSDate *myDate = [NSDate date];
				[[NSUserDefaults standardUserDefaults] setObject:myDate forKey:@"myDateKey"];
				// The find succeeded.
				NSLog(@"Successfully retrieved %lu pizzaPlaces from PARSE DB", (unsigned long)parseArray.count);
				// Do something with the found objects
				PizzaPlace *pizzaPlace = nil;
				if (parseArray.count == 0) {
					[hud hideAnimated:YES]; // nothing to download, hide the hud
				}
				for (PFObject *pizzaPlaceParse in parseArray) {
					
					pizzaPlace = [[PizzaPlace alloc]init]; // allocate the new instance
					// assign its values from the objects
					pizzaPlace.name = pizzaPlaceParse[@"name"];
					pizzaPlace.address = pizzaPlaceParse[@"address"];
					pizzaPlace.street = pizzaPlaceParse[@"street"];
					pizzaPlace.city = pizzaPlaceParse[@"city"];
					pizzaPlace.zip = [pizzaPlaceParse[@"zip"]integerValue];
					pizzaPlace.latitude = [pizzaPlaceParse[@"latitude"]floatValue];
					pizzaPlace.longitude = [pizzaPlaceParse[@"longitude"]floatValue];
					
					BOOL last = ([[parseArray lastObject] isEqual:pizzaPlaceParse])? YES:NO;
					[self updateLikes:pizzaPlaceParse pizzaPlace:pizzaPlace withHud:hud isLast:last];
					[self.pizzaPlaceArray addObject:pizzaPlace];
					[pizzaPlaceParse pinInBackground]; // this is for local Storagex
				}
			}
			else {
				// Log details of the failure
				//				NSLog(@"Error: %@ %@", error, [error userInfo]);
				[self emptyAlert];
				[hud hideAnimated:YES]; //error, so hide the hud
			}
		}];
}

-(void) fromLocalDataPP {
	[self downloadParsePP];
	PFQuery *query = [PFQuery queryWithClassName:@"PizzaPlaceParse"];
	[query fromLocalDatastore];
	[query findObjectsInBackgroundWithBlock:^(NSArray *parseArray, NSError *error) {
		if (!error) {
			// The find succeeded.
			NSLog(@"Successfully retrieved %lu pizzaPlaces from LOCAL", (unsigned long)parseArray.count);
			// Do something with the found objects
			PizzaPlace *pizzaPlace = nil;
			self.pizzaPlaceArray = [[NSMutableArray alloc]init]; // removed old one, and replace with new
			for (PFObject *pizzaPlaceParse in parseArray) {
				
				pizzaPlace = [[PizzaPlace alloc]init]; // allocate the new instance
				// assign its values from the objects
				pizzaPlace.name = pizzaPlaceParse[@"name"];
				pizzaPlace.address = pizzaPlaceParse[@"address"];
				pizzaPlace.street = pizzaPlaceParse[@"street"];
				pizzaPlace.city = pizzaPlaceParse[@"city"];
				pizzaPlace.zip = [pizzaPlaceParse[@"zip"]integerValue];
				pizzaPlace.latitude = [pizzaPlaceParse[@"latitude"]floatValue];
				pizzaPlace.longitude = [pizzaPlaceParse[@"longitude"]floatValue];
				BOOL last = ([[parseArray lastObject] isEqual:pizzaPlaceParse])? YES:NO;
				[self updateLikes:pizzaPlaceParse pizzaPlace:pizzaPlace withHud:nil isLast:last];
				PFQuery *queryLikes = [PFQuery queryWithClassName:@"Likes"];
				[queryLikes fromLocalDatastore];
				[queryLikes whereKey:@"pizzaPlace" equalTo:pizzaPlaceParse];
				[queryLikes whereKey:@"user" equalTo:[PFUser currentUser]];
				[queryLikes getFirstObjectInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
					pizzaPlace.rated = RATEDNOT;
					if (object) {
						if ([object[@"likeType"] isEqualToString:@"like"]) {
							pizzaPlace.rated = RATEDLIKE;
						}
						else if ([object[@"likeType"] isEqualToString:@"dislike"]) {
							pizzaPlace.rated = RATEDDISLIKE;
						}
					}
					
					[self.pizzaPlaceArray addObject:pizzaPlace];
					[pizzaPlaceParse pinInBackground]; // this is for local Storage
				}];
				
				//					NSLog(@"my array is = %@", self.pizzaPlaceArray);
			}
		}
		else {
			// Log details of the failure
			NSLog(@"Error: %@ %@", error, [error userInfo]);
		}
	}];
}


- (void) updateLikes:(PFObject *)pizzaPlaceParse pizzaPlace:(PizzaPlace *)pizzaPlace withHud:(MBProgressHUD *)hud isLast:(BOOL)isLast {// this takes a very long time to do
	PFQuery *queryLikes = [PFQuery queryWithClassName:@"Likes"];
	[queryLikes whereKey:@"pizzaPlace" equalTo:pizzaPlaceParse]; // using the object
	[queryLikes whereKey:@"likeType" equalTo:@"like"]; // using the object
	[queryLikes countObjectsInBackgroundWithBlock:^(int numberL, NSError * _Nullable error) {
		//		NSLog(@"likes updated");
		pizzaPlace.likes = numberL;
		
		PFQuery *queryDislikes = [PFQuery queryWithClassName:@"Likes"];
		[queryDislikes whereKey:@"pizzaPlace" equalTo:pizzaPlaceParse]; // using the object
		[queryDislikes whereKey:@"likeType" equalTo:@"dislike"]; // using the object
		[queryDislikes countObjectsInBackgroundWithBlock:^(int numberD, NSError * _Nullable error) {
			pizzaPlace.dislikes = numberD;
			//			NSLog(@"%d like and %d dislike", numberL, numberD);
			if (pizzaPlace.likes + pizzaPlace.dislikes == 0) {
				pizzaPlace.percentageLikes = 0;
				pizzaPlace.percentageDislikes = 0;
			}
			else {
				pizzaPlace.percentageLikes = (float)pizzaPlace.likes/(pizzaPlace.likes + pizzaPlace.dislikes)*100;
				pizzaPlace.percentageDislikes = (float)pizzaPlace.dislikes/(pizzaPlace.likes + pizzaPlace.dislikes)*100;
			}
			if (isLast) {
				// All instances of TestClass will be notified
				[[NSNotificationCenter defaultCenter]
				 postNotificationName:@"FinishedLoadingData"
				 object:self];
				[hud hideAnimated:YES];
			}
			//			NSLog(@"ratings = %f and %f for %@", pizzaPlace.percentageLikes, pizzaPlace.percentageDislikes, pizzaPlace.name);
		}];
	}];
	
}

- (void)downloadParseGifs {
	// iterate through and create PFFile instance for Gif
	PFQuery *query = [PFQuery queryWithClassName:@"GifParse"];
	
	// Sorts the results in ascending order by the updated field
	[query orderByAscending:@"updatedAt"];
	self.gifArray = [[NSMutableArray alloc]init]; // removed old one, and replace with new
	[query findObjectsInBackgroundWithBlock:^(NSArray *parseArray, NSError *error) {
		if (!error) {
			// The find succeeded.
			NSLog(@"Successfully retrieved %lu Gifs from PARSE DB", (unsigned long)parseArray.count);
			PFFile *gifImage = nil;
			for (PFObject *gifObject in parseArray) {
				gifImage = gifObject[@"GifFile"];
				[gifObject pinInBackground]; // this is for local Storage
				[gifImage getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
					if (!error) {
						[self.gifArray addObject:imageData];
					}
					else {
						NSLog(@"There was an error with DL PGifs, and it needs to be logged");
					}
				}];
			}
		}
		else {
			// Log details of the failure
			NSLog(@"Error: %@ %@", error, [error userInfo]);
		}
	}];
}

- (void)fromLocalDataGifs {
	PFQuery *query = [PFQuery queryWithClassName:@"GifParse"];
	[query fromLocalDatastore];
	self.gifArray = [[NSMutableArray alloc]init]; // removed old one, and replace with new
	[query findObjectsInBackgroundWithBlock:^(NSArray *parseArray, NSError *error) {
		if (!error) {
			// The find succeeded.
			NSLog(@"Successfully retrieved %lu Gifs from LOCAL", (unsigned long)parseArray.count);
			// Do something with the found objects
			PFFile *gifImage = nil;
			for (PFObject *gifObject in parseArray) {
				gifImage = gifObject[@"GifFile"];
				[gifImage getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
					if (!error) {
						[self.gifArray addObject:imageData];
					}
					else {
						NSLog(@"There was an error with LocalPargifs, and it needs to be logged");
					}
				}];
			}
		}
		else {
			// Log details of the failure
			NSLog(@"Error: %@ %@", error, [error userInfo]);
		}
		if (parseArray == nil || parseArray.count == 0) {
			[self downloadParseGifs];
		}
	}];
}
/* // commented out, but kept for help later 2.10.16
 -(void) saveParse {
	
	PFObject *testObjectPizza = [PFObject objectWithClassName:@"PizzaPlaceParse"];
	testObjectPizza[@"name"] = @"Two Bros 32 St. Marks";
	testObjectPizza[@"address"] = @"32 Saint Marks Place New York NY 10003";
	testObjectPizza[@"street"] = @"32 Saint Marks Place";
	testObjectPizza[@"city"] = @"New York NY";
	testObjectPizza[@"zip"] = @10003;
	testObjectPizza[@"latitude"] =	@40.728677;
	testObjectPizza[@"longitude"] =	@-73.988488;
	[testObjectPizza saveInBackground];
	
	NSString *kenPizzaMan = @"KenPizzaMan";
	NSString *gifFilePath = [[NSBundle mainBundle] pathForResource:kenPizzaMan ofType:@"gif"];
	NSData *gifData = [NSData dataWithContentsOfFile:gifFilePath];
	
	PFFile *file = [PFFile fileWithName:[NSString stringWithFormat:@"%@.gif",kenPizzaMan] data:gifData];
	PFObject *gifObject = [PFObject objectWithClassName:@"GifParse"];
	[gifObject setObject:file forKey:@"GifFile"];
	[gifObject saveInBackground];
	
	
 }
 */

#pragma mark - PARSE Uploading


- (void)likePizzaPlaceWithName:(NSString *)name {
	[self addLikeForPizzaPlace:name withType:@"like"];
}

- (void)dislikePizzaPlaceWithName:(NSString *)name {
	[self addLikeForPizzaPlace:name withType:@"dislike"];
}

- (void)addLikeForPizzaPlace:(NSString *)name withType:(NSString *)type {
	PFQuery *query = [PFQuery queryWithClassName:@"PizzaPlaceParse"];
	[query fromLocalDatastore];
	[query whereKey:@"name" equalTo:name];
	PFObject *pizzaPlaceParse = [query getFirstObject];
	
	PFQuery *queryLikes = [PFQuery queryWithClassName:@"Likes"];
	[queryLikes whereKey:@"pizzaPlace" equalTo:pizzaPlaceParse]; // using the object
	[queryLikes whereKey:@"user" equalTo:[PFUser currentUser]]; // using the object
	[queryLikes getFirstObjectInBackgroundWithBlock:^(PFObject * _Nullable likeParse, NSError * _Nullable error) {
		//likes or NO likes
		if (!likeParse) {
			// create like
			PFObject *objectNew = [[PFObject alloc]initWithClassName:@"Likes"];
			objectNew[@"likeType"] = type;
			objectNew[@"pizzaPlace"] = pizzaPlaceParse;
			objectNew[@"user"] = [PFUser currentUser];
			[objectNew saveEventually];
			[objectNew pinInBackground];
		}
		else {
			if(![likeParse[@"likeType"] isEqualToString:type]) {
				//update like
				likeParse[@"likeType"] = type;
				[likeParse saveEventually];
			}
			else {//[likeParse[@"likeType"] isEqualToString:type]
				[likeParse deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
					if (succeeded && !error) {
						NSLog(@"like deleted from parse");
					} else {
						NSLog(@"error: %@", error);
					}
				}];
			}
		}
	}];
}

-(void)addNewPizzaPlace:(NSString *)name address:(NSString *)address location:(CLLocation *)location imageData:(NSData *)imageData block:(PFBooleanResultBlock)block {
	PFObject *addRequest = [PFObject objectWithClassName:@"AddRequest"];
	addRequest[@"name"] = name;
	addRequest[@"address"] = address;
	addRequest[@"latitude"] = [NSString stringWithFormat:@"%f", location.coordinate.latitude];
	addRequest[@"longitude"] = [NSString stringWithFormat:@"%f", location.coordinate.longitude];
	addRequest[@"user"] = [PFUser currentUser];
	
	
	PFFile *imageFile = [PFFile fileWithName:[NSString stringWithFormat:@"%@.png", name] data:imageData];
	addRequest[@"image"] = imageFile;
	
	[addRequest saveInBackgroundWithBlock:block];
	
	
}

-(void)feedbackSubmission:(NSString *)feedback build:(NSString *)build email:(NSString *)email type:(NSString *)type {
	PFObject *feedbackParse = [PFObject objectWithClassName:@"FeedbackParse"];
	feedbackParse[@"feedbackString"] = feedback;
	feedbackParse[@"build"] = build;
	feedbackParse[@"userEmail"] = email;
	feedbackParse[@"typeFeedback"] = type;
	feedbackParse[@"user"] = [PFUser currentUser];
	
	[feedbackParse saveEventually];
}

-(void)closedSubmission:(PizzaPlace *)pizzaPlace {
	PFObject *feedbackParse = [PFObject objectWithClassName:@"FeedbackParse"];
	feedbackParse[@"feedbackString"] = pizzaPlace.name;
	feedbackParse[@"userEmail"] = pizzaPlace.address;
	feedbackParse[@"typeFeedback"] = @"CLOSED";
	feedbackParse[@"user"] = [PFUser currentUser];
	
	[feedbackParse saveEventually];
}

#pragma mark - UIAlertView

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
#pragma mark 1 - No Internet (PP)
	// 1 // no connection found
	if ([alertView.title isEqualToString:@"No connection to the internet found"]) {
		if (buttonIndex == 1) {
			[self downloadParsePP];
		}
		else {
			NSLog(@"user does not care about updating, hide the hud");
		}
	}
#pragma mark 2 - No Internet (Gifs)
	//not being used
	// 1 // no connection found
	else if ([alertView.title isEqualToString:@"No connection to internet found"]) {
		if (buttonIndex == 1) {
			[self downloadParseGifs];
		}
		else {
			NSLog(@"user does not care about updating");
		}
	}
#pragma mark 3 - Message to the User
	else  {
		if (buttonIndex == 1) {
			NSLog(@"delete the parse message");
			[self.alertObject deleteEventually];
		}
		else {
			NSLog(@"User wants to be reminded");
		}
	}
}
@end
