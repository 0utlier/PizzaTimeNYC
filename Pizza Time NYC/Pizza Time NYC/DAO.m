//
//  DAO.m
//  Pizza Time NYC
//
//  Created by Aditya Narayan on 1/4/16.
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


#pragma mark - PARSE

-(void) downloadParsePP {
	// iterate through and create PP instance for place
	PFQuery *query = [PFQuery queryWithClassName:@"PizzaPlaceParse"];
	
	// Sorts the results in ascending order by the ZIP field
	[query orderByAscending:@"zip"];
	[query findObjectsInBackgroundWithBlock:^(NSArray *parseArray, NSError *error) {
		if (!error) {
			// The find succeeded.
			NSLog(@"Successfully retrieved %lu pizzaPlaces from PARSE DB", (unsigned long)parseArray.count);
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
				
				PFQuery *queryLikes = [PFQuery queryWithClassName:@"Likes"];
				[queryLikes whereKey:@"pizzaPlace" equalTo:pizzaPlaceParse]; // using the object
				[queryLikes whereKey:@"likeType" equalTo:@"like"]; // using the object
				[queryLikes countObjectsInBackgroundWithBlock:^(int number, NSError * _Nullable error) {
					pizzaPlace.likes = number;
					
					PFQuery *queryDislikes = [PFQuery queryWithClassName:@"Likes"];
					[queryDislikes whereKey:@"pizzaPlace" equalTo:pizzaPlaceParse]; // using the object
					[queryDislikes whereKey:@"likeType" equalTo:@"dislike"]; // using the object
					[queryDislikes countObjectsInBackgroundWithBlock:^(int number, NSError * _Nullable error) {
						pizzaPlace.dislikes = number;
						if (pizzaPlace.likes + pizzaPlace.dislikes == 0) {
							pizzaPlace.percentageLikes = 0;
						}
						else {
							pizzaPlace.percentageLikes = (float)pizzaPlace.likes/(pizzaPlace.likes + pizzaPlace.dislikes)*100;
						}
						NSLog(@"ratings = %f for %@", pizzaPlace.percentageLikes, pizzaPlace.name);
						[self.pizzaPlaceArray addObject:pizzaPlace];
						[pizzaPlaceParse pinInBackground]; // this is for local Storage
					}];
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

-(void) fromLocalDataPP {
	PFQuery *query = [PFQuery queryWithClassName:@"PizzaPlaceParse"];
	[query fromLocalDatastore];
	[query findObjectsInBackgroundWithBlock:^(NSArray *parseArray, NSError *error) {
		if (parseArray == nil || parseArray.count == 0) {
			[self downloadParsePP];
		} else {
			if (!error) {
				// The find succeeded.
				NSLog(@"Successfully retrieved %lu pizzaPlaces from LOCAL", (unsigned long)parseArray.count);
				// Do something with the found objects
				PizzaPlace *pizzaPlace = nil;
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
					}];
					
					//					NSLog(@"my array is = %@", self.pizzaPlaceArray);
				}
			}
			else {
				// Log details of the failure
				NSLog(@"Error: %@ %@", error, [error userInfo]);
			}
		}
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
						NSLog(@"There was an error, and it needs to be logged");
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
						NSLog(@"There was an error, and it needs to be logged");
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

@end
