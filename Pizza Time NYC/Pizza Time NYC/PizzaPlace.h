//
//  PizzaPlace.h
//  Pizza Time NYC
//
//  Created by SUGAR^2 on 12/25/15.
//  Copyright © 2015 TTT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PizzaPlace : NSObject

typedef NS_ENUM(NSInteger, RatingOptions) { //0,1,2//
	RATEDNOT,
	RATEDLIKE,
	RATEDDISLIKE
};

//information on PizzaPlace
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *url;
@property (nonatomic, retain) NSString *image;

//location of PizzaPlace
@property (nonatomic, retain) NSString *address;
@property (nonatomic, retain) NSString *street;
@property (nonatomic, retain) NSString *city;
@property (nonatomic) NSInteger zip;
@property float latitude;
@property float longitude;
@property float distance;

@property (nonatomic) int likes;
@property (nonatomic) int dislikes;
@property (nonatomic) RatingOptions rated;
@property float percentageLikes;
@property float percentageDislikes;


@end
