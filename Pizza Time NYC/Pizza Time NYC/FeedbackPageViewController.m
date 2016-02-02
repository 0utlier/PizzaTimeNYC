//
//  FeedbackPageViewController.m
//  Pizza Time NYC
//
//  Created by Aditya Narayan on 2/2/16.
//  Copyright © 2016 TTT. All rights reserved.
//

#import "FeedbackPageViewController.h"
#import <AudioToolbox/AudioServices.h>

@interface FeedbackPageViewController ()

@end

@implementation FeedbackPageViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view.
	self.feedbackTextField.delegate = self;
	self.AppVersion.text = [self buildNumberInfo];
	[self.submitButton addTarget:self
						  action:@selector(submitButtonPressed:)
				forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

-(NSString *)buildNumberInfo {
	NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
	NSString *appVersion = [infoDict objectForKey:@"CFBundleShortVersionString"]; // example: 1.0.0
	return [NSString stringWithFormat:@"Build %@",appVersion];
}

-(void)submitButtonPressed:(UIButton *)submitButton {
	NSString *feedbackInfo = self.feedbackTextField.text;
	// create a PFObject and parse it!
	NSLog(@"Submit pressed with:\n %@\n %@", feedbackInfo,[self buildNumberInfo]);
	
	UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Thank You!"
														  message:@"We will look at your feedback!"
														 delegate:nil
												cancelButtonTitle:@"OK"
												otherButtonTitles: nil];
	
	[myAlertView show];
	[self dismissViewControllerAnimated:YES completion:nil];

}

#pragma mark - TextField Methods

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView {
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
	// remove placeHolder text if that's what's there
	if ([self.feedbackTextField.text isEqualToString:@"Send constructive and productive feedback!"]) {
		self.feedbackTextField.text = @"";
	}
	return YES;
}

-(BOOL)textViewShouldEndEditing:(UITextView *)textView {
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
	// remove placeHolder text if that's what's there
	if ([self.feedbackTextField.text isEqualToString:@""]) {
		self.feedbackTextField.text = @"Send constructive and productive feedback!";
	}
	[self.view endEditing:YES];
	return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
	
	if([text isEqualToString:@"\n"]) {
		[textView resignFirstResponder];
		return NO;
	}
	else if ([text isEqualToString:@"p"]) {
		NSLog(@"P was pressed");
		//Retrieve audio file
		NSString *path  = [[NSBundle mainBundle] pathForResource:@"annoyedRick" ofType:@"mp3"];
		NSURL *pathURL = [NSURL fileURLWithPath : path];
		
		SystemSoundID audioEffect;
		AudioServicesCreateSystemSoundID((__bridge CFURLRef) pathURL, &audioEffect);
		AudioServicesPlaySystemSound(audioEffect);
		
		// call the following function when the sound is no longer used
		// (must be done AFTER the sound is done playing)
		// Using GCD, we can use a block to dispose of the audio effect without using a NSTimer or something else to figure out when it'll be finished playing.
		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(30 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
			AudioServicesDisposeSystemSoundID(audioEffect);
		});
	}
	
	return YES;
}
- (void)keyboardDidShow:(NSNotification *)notification
{
	// Assign new frame to your view
	CGRect keyboardRect = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
	keyboardRect = [self.view convertRect:keyboardRect fromView:nil]; //this is it!
	[self.view setFrame:CGRectMake(0,0 - keyboardRect.size.height,self.view.bounds.size.width,self.view.bounds.size.height)]; //here taken -20 for example i.e. your view will be scrolled to -20. change its value according to your requirement.
	
}

-(void)keyboardDidHide:(NSNotification *)notification
{
	[self.view setFrame:CGRectMake(0,0,self.view.bounds.size.width,self.view.bounds.size.height)];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
