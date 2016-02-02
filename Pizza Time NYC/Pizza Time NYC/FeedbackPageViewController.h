//
//  FeedbackPageViewController.h
//  Pizza Time NYC
//
//  Created by Aditya Narayan on 2/2/16.
//  Copyright © 2016 TTT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeedbackPageViewController : UIViewController <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *AppVersion;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (weak, nonatomic) IBOutlet UITextView *feedbackTextField;

@end
