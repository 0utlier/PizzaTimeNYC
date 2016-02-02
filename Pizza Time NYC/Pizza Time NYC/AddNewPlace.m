//
//  AddNewPlace.m
//  Pizza Time NYC
//
//  Created by Aditya Narayan on 1/21/16.
//  Copyright © 2016 TTT. All rights reserved.
//

#import "AddNewPlace.h"
#import <AssetsLibrary/AssetsLibrary.h>
@interface AddNewPlace ()
// for use of the avAudioPlayer & Menu Button
@property (strong, nonatomic) MethodManager *methodManager;

@end

@implementation AddNewPlace

- (void)viewDidLoad {
	[super viewDidLoad];
	self.methodManager = [MethodManager sharedManager];
	self.addressTextField.delegate = self;
	self.nameTextField.delegate = self;
	
}

-(void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:YES];
	[self assignLabels];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}


-(void)assignLabels {// and buttons
	[self.view addSubview:[self.methodManager assignOptionsButton]];
	[self.view addSubview:[self.methodManager assignSpeakerButton]];
	
	UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(16, 16, 45, 45)];
	self.backButton = backButton;
	// Add an action in current code file (i.e. target)
	[self.backButton addTarget:self
						action:@selector(backButtonPressed:)
			  forControlEvents:UIControlEventTouchUpInside];
	
	[self.backButton setBackgroundImage:[UIImage imageNamed:@"MCQppiBACK.png"] forState:UIControlStateNormal];
	[self.view addSubview:self.backButton];
	
	[self.locationButton addTarget:self
							action:@selector(locationButtonPressed:)
				  forControlEvents:UIControlEventTouchUpInside];
	
	[self.cameraButton addTarget:self
						  action:@selector(cameraButtonPressed:)
				forControlEvents:UIControlEventTouchUpInside];
	
	[self.addButton addTarget:self
					   action:@selector(addButtonPressed:)
			 forControlEvents:UIControlEventTouchUpInside];
	
}

#pragma mark - ACTIONS

-(void)backButtonPressed:(UIButton *)backButton {
	NSLog(@"backButton was pressed");
	[self.tabBarController setSelectedIndex:MAPPAGE];
	
}

- (void)locationButtonPressed:(UIButton *)locationButton {
	//	[self.methodManager.locationManager startUpdatingLocation]; // unsure if I need this or not 2.1.16
	if (self.methodManager.locationManager.location.coordinate.latitude == 0.0 || self.methodManager.locationManager.location.coordinate.longitude == 0.0) {
		NSLog(@"Present an alert");
	}
	NSString *latLong = [NSString stringWithFormat:@"%f & %f",self.methodManager.locationManager.location.coordinate.latitude, self.methodManager.locationManager.location.coordinate.longitude];
	/*
	 // turn the latLong into an address
	 CLGeocoder *geocoder = [[CLGeocoder alloc] init];
	 [geocoder reverseGeocodeLocation:self.methodManager.locationManager.location completionHandler:^(NSArray *placemarks, NSError *error) {
		NSLog(@"Finding address");
		if (error) {
	 NSLog(@"Error %@", error.description);
		} else {
	 CLPlacemark *placemark = [placemarks lastObject];
	 self.addressTextField.text = [NSString stringWithFormat:@"%@", ABCreateStringWithAddressDictionary(placemark.addressDictionary, NO)];
		}
	 }];
	 */
	self.addressTextField.text = latLong;
}

-(void)cameraButtonPressed:(UIButton *)cameraButton {
	//	NSLog(@"camera button pressed, open camera or library");
	if (self.imageView.image == NULL) {
		
		UIActionSheet *photoChoice = [[UIActionSheet alloc]initWithTitle:nil
																delegate:self
													   cancelButtonTitle:@"Cancel"
												  destructiveButtonTitle:nil
													   otherButtonTitles: @"Take a new photo", @"Choose from existing", nil];
		[photoChoice showInView:self.view];
	}
	else { // picture exists
		UIActionSheet *photoChoice = [[UIActionSheet alloc]initWithTitle:nil
																delegate:self
													   cancelButtonTitle:@"Cancel"
												  destructiveButtonTitle:nil
													   otherButtonTitles: @"Take a new photo", @"Choose from existing", @"Remove Photo", nil];
		[photoChoice showInView:self.view];
	}
}

-(void)addButtonPressed:(UIButton *)addButton {
	NSString *submission = [NSString stringWithFormat:@"User has found %@, which is located: %@", self.nameTextField.text, self.addressTextField.text];
	NSLog(@"addButton was pressed - submit info to developer \n%@", submission);
	// create a PFObject and parse it!
	UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Thank You!"
														  message:@"We will look into your Submission!"
														 delegate:nil
												cancelButtonTitle:@"OK"
												otherButtonTitles: nil];
	
	[myAlertView show];
	[self.tabBarController setSelectedIndex:OPTIONSPAGE];
	
}

#pragma mark - Text Field Delegate

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
	return YES;
}


- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
	[self.view endEditing:YES];
	return YES;
}

- (void)keyboardDidShow:(NSNotification *)notification
{
	
}

-(void)keyboardDidHide:(NSNotification *)notification
{
	
}

-(BOOL)textFieldShouldReturn:(UITextField*)textField
{
	NSInteger nextTag = textField.tag + 1;
	// Try to find next responder
	UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
	if (nextResponder) {
		// Found next responder, so set it.
		[nextResponder becomeFirstResponder];
	} else {
		// Not found, so remove keyboard.
		[textField resignFirstResponder];
	}
	return NO; // We do not want UITextField to insert line-breaks.
}


#pragma mark - Camera Selection

- (BOOL)checkForCamera {
	if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
		
		UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
															  message:@"Device has no camera"
															 delegate:nil
													cancelButtonTitle:@"OK"
													otherButtonTitles: nil];
		
		[myAlertView show];
		return NO;
	}
	return YES;
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	
	int i = (int) buttonIndex;
	
	switch(i) {
			
		case 0:
		{
			//Code for camera
			if ([self checkForCamera]) {
				UIImagePickerController *picker = [[UIImagePickerController alloc] init];
				picker.delegate = self;
				picker.allowsEditing = YES;
				picker.sourceType = UIImagePickerControllerSourceTypeCamera;
				
				[self presentViewController:picker animated:YES completion:NULL];
			}
		}
			break;
		case 1:
		{
			UIImagePickerController *picker = [[UIImagePickerController alloc] init];
			picker.delegate = self;
			picker.allowsEditing = YES;
			picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
			
			[self presentViewController:picker animated:YES completion:NULL];
		}
			break;
		case 2:
		{
			self.imageView.image = nil;
		}
			
		default:
			// Do Nothing.........
			break;
			
	}
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
	
	NSLog(@"Picker returned successfully.");
	
	UIImage *selectedImage;
	
	NSURL *mediaUrl;
	
	mediaUrl = (NSURL *)[info valueForKey:UIImagePickerControllerMediaURL];
	
	if (mediaUrl == nil) {
		
		selectedImage = (UIImage *) [info valueForKey:UIImagePickerControllerEditedImage];
		if (selectedImage == nil) {
			
			selectedImage = (UIImage *) [info valueForKey:UIImagePickerControllerOriginalImage];
			NSLog(@"Original image picked.");
			
		}
		else {
			
			NSLog(@"Edited image picked.");
			
		}
		
	}
	[self imageCoordinate:info];
	[self dismissViewControllerAnimated:YES completion:nil];
	
	
	self.imageView.image = selectedImage;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
	
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imageCoordinate:(NSDictionary *)info {
	NSURL *photoUrl = [info objectForKey:@"UIImagePickerControllerReferenceURL"];
	ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc]init];
	[assetsLibrary assetForURL:photoUrl resultBlock:^(ALAsset *photoAsset) {
	 CLLocation *location = [photoAsset valueForProperty:ALAssetPropertyLocation];
		if (location.coordinate.latitude == 0.0 || location.coordinate.longitude == 0.0) {
			NSLog(@"Present an alert");
		}
		NSString *latLong = [NSString stringWithFormat:@"%f & %f",location.coordinate.latitude, location.coordinate.longitude];
		self.addressTextField.text = latLong;
/* // not sure what this would do, if not setting the location to the image
	 NSMutableDictionary *exifDataDict = [[NSMutableDictionary alloc]init];
	 if (location!=nil) {
		 [exifDataDict setObject:[NSNumber numberWithDouble:location.coordinate.latitude] forKey:@"latitude"];
		 [exifDataDict setObject:[NSNumber numberWithDouble:location.coordinate.longitude] forKey:@"longitude"];
	 }
		*/
	} failureBlock:nil];
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
