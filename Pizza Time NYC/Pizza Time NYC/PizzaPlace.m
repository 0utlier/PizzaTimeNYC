//
//  PizzaPlace.m
//  Pizza Time NYC
//
//  Created by SUGAR^2 on 12/25/15.
//  Copyright © 2015 TTT. All rights reserved.
//

#import "PizzaPlace.h"

@implementation PizzaPlace

//setter
- (void)setLikes:(int)likes {
	_likes = likes;
	if (!(_likes + _dislikes) == 0) {
		self.percentageLikes = (float)_likes/(_likes + _dislikes)*100;
		self.percentageDislikes = (float)_dislikes/(_likes + _dislikes)*100;
	}
	else {
		self.percentageLikes = 0;
		self.percentageDislikes = 0;
	}
}

- (void)setDislikes:(int)dislikes {
	_dislikes = dislikes;
	if (!(_likes + _dislikes) == 0) {
		self.percentageLikes = (float)_likes/(_likes + _dislikes)*100;
		self.percentageDislikes = (float)_dislikes/(_likes + _dislikes)*100;
	}
	else {
		self.percentageLikes = 0;
		self.percentageDislikes = 0;
	}
}

@end
