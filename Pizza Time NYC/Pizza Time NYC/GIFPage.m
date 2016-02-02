//
//  GIFPage.m
//  Pizza Time NYC
//
//  Created by Aditya Narayan on 1/30/16.
//  Copyright © 2016 TTT. All rights reserved.
//

#import "GIFPage.h"
#import "MethodManager.h"

@interface GIFPage ()

@property CGAffineTransform transform;
@property (strong, nonatomic) MethodManager *methodManager;

@end

@implementation GIFPage

- (void)viewDidLoad {
	[super viewDidLoad];
	self.methodManager = [MethodManager sharedManager];
	/*
	 UIWebView *webViewBG;
	 NSString *filePath = [[NSBundle mainBundle] pathForResource:@"tmntBikePizza" ofType:@"gif"];
	 
	 NSData *gif = [NSData dataWithContentsOfFile:filePath];
	 
	 webViewBG = [[UIWebView alloc] initWithFrame:CGRectMake(0, (self.view.bounds.size.height - self.view.bounds.size.width)/2 , self.view.bounds.size.width, self.view.bounds.size.width)];
	 NSURL *nilURL = nil; // these are to remove a warning from putting nil in for string and URL
	 NSString *nilString = nil; // these are to remove a warning from putting nil in for string and URL
	 [webViewBG loadData:gif MIMEType:@"image/gif" textEncodingName:nilString baseURL:nilURL];
	 
	 webViewBG.userInteractionEnabled = NO;
	 
	 // set the rotation of the GIF
	 self.transform = CGAffineTransformMakeRotation(M_PI_2); // 90 degrees EAST
	 
	 //Obtaining the current device orientation
	 UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
	 
	 //	NSLog(@"orienation = %ld", (long)orientation);
	 if (orientation == UIDeviceOrientationLandscapeRight)
	 {
		// code for RIGHT orientation
		self.transform = CGAffineTransformMakeRotation(M_PI_2 *3); // 90 degrees WEST
		
	 }
	 
	 webViewBG.transform = self.transform;
	 [self.view addSubview:webViewBG];
	 */
	
	// Do any additional setup after loading the view.
	NSString *kenPizzaMan = [[NSBundle mainBundle] pathForResource:@"KenPizzaMan" ofType:@"gif"];
	NSString *tmntBikePizza = [[NSBundle mainBundle] pathForResource:@"tmntBikePizza" ofType:@"gif"];
	NSString *dripDropPizza = [[NSBundle mainBundle] pathForResource:@"dripDropPizza" ofType:@"gif"];
	NSString *druggedPizza = [[NSBundle mainBundle] pathForResource:@"druggedPizza" ofType:@"gif"];
	NSString *rocketPizza = [[NSBundle mainBundle] pathForResource:@"rocketPizza" ofType:@"gif"];
	NSString *spinningPizza = [[NSBundle mainBundle] pathForResource:@"spinningPizza" ofType:@"gif"];
	NSString *steamingPizza = [[NSBundle mainBundle] pathForResource:@"steamingPizza" ofType:@"gif"];
	NSString *krabsPizza = [[NSBundle mainBundle] pathForResource:@"krabsPizza" ofType:@"gif"];
	NSString *spongeBobBWPizza = [[NSBundle mainBundle] pathForResource:@"spongeBobBWPizza" ofType:@"gif"];
	NSString *krustyKrabSingPizza = [[NSBundle mainBundle] pathForResource:@"krustyKrabSingPizza" ofType:@"gif"];
	NSString *krustyKrabSingPizza2 = [[NSBundle mainBundle] pathForResource:@"krustyKrabSingPizza2" ofType:@"gif"];
	NSString *sneakyDogPizza = [[NSBundle mainBundle] pathForResource:@"sneakyDogPizza" ofType:@"gif"];
	NSString *pyrPizza = [[NSBundle mainBundle] pathForResource:@"pyrPizza" ofType:@"gif"];
	NSString *hungryPizza = [[NSBundle mainBundle] pathForResource:@"hungryPizza" ofType:@"gif"];
	NSString *cyclePizza = [[NSBundle mainBundle] pathForResource:@"cyclePizza" ofType:@"gif"];
	NSString *lsdPizza = [[NSBundle mainBundle] pathForResource:@"lsdPizza" ofType:@"gif"];
	NSString *scaryPizza = [[NSBundle mainBundle] pathForResource:@"scaryPizza" ofType:@"gif"];
	NSString *adventureTimePizza = [[NSBundle mainBundle] pathForResource:@"adventureTimePizza" ofType:@"gif"];
	NSString *bit8Pizza = [[NSBundle mainBundle] pathForResource:@"bit8Pizza" ofType:@"gif"];
	NSString *blinkPizza = [[NSBundle mainBundle] pathForResource:@"blinkPizza" ofType:@"gif"];
	NSString *catPizza = [[NSBundle mainBundle] pathForResource:@"catPizza" ofType:@"gif"];
	NSString *partyOnPizza = [[NSBundle mainBundle] pathForResource:@"partyOnPizza" ofType:@"gif"];
	NSString *handsUpPizza = [[NSBundle mainBundle] pathForResource:@"handsUpPizza" ofType:@"gif"];
	NSString *newYearPizza = [[NSBundle mainBundle] pathForResource:@"newYearPizza" ofType:@"gif"];
	NSString *starWarsPizza = [[NSBundle mainBundle] pathForResource:@"starWarsPizza" ofType:@"gif"];
	NSString *dancingPizza = [[NSBundle mainBundle] pathForResource:@"dancingPizza" ofType:@"gif"];
	NSString *videoGamePizza = [[NSBundle mainBundle] pathForResource:@"videoGamePizza" ofType:@"gif"];
	NSString *loadingPizza = [[NSBundle mainBundle] pathForResource:@"loadingPizza" ofType:@"gif"];
	NSString *furbyPizza = [[NSBundle mainBundle] pathForResource:@"furbyPizza" ofType:@"gif"];
	NSString *drippingPizza = [[NSBundle mainBundle] pathForResource:@"drippingPizza" ofType:@"gif"];
	NSString *planetPizza = [[NSBundle mainBundle] pathForResource:@"planetPizza" ofType:@"gif"];
	NSString *TMNTMikeyPizza = [[NSBundle mainBundle] pathForResource:@"TMNTMikeyPizza" ofType:@"gif"];
	NSString *skatePizza = [[NSBundle mainBundle] pathForResource:@"skatePizza" ofType:@"gif"];
	NSString *moneyPizza = [[NSBundle mainBundle] pathForResource:@"moneyPizza" ofType:@"gif"];
	NSString *flyingPizza = [[NSBundle mainBundle] pathForResource:@"flyingPizza" ofType:@"gif"];
	NSString *rock30Pizza = [[NSBundle mainBundle] pathForResource:@"30RockPizza" ofType:@"gif"];
	NSString *s90Pizza = [[NSBundle mainBundle] pathForResource:@"90sPizza" ofType:@"gif"];
	NSString *friendsPizza = [[NSBundle mainBundle] pathForResource:@"friendsPizza" ofType:@"gif"];
	NSString *lovePizza = [[NSBundle mainBundle] pathForResource:@"lovePizza" ofType:@"gif"];
	NSString *dripPizza = [[NSBundle mainBundle] pathForResource:@"dripPizza" ofType:@"gif"];
	NSString *feetPizza = [[NSBundle mainBundle] pathForResource:@"feetPizza" ofType:@"gif"];
	NSString *coolPizza = [[NSBundle mainBundle] pathForResource:@"coolPizza" ofType:@"gif"];
	NSString *sliceSlicePizza = [[NSBundle mainBundle] pathForResource:@"sliceSlicePizza" ofType:@"gif"];
	NSString *rotatePizza = [[NSBundle mainBundle] pathForResource:@"rotatePizza" ofType:@"gif"];
	NSString *trippyPizza = [[NSBundle mainBundle] pathForResource:@"trippyPizza" ofType:@"gif"];
	NSString *pyrCatPizza = [[NSBundle mainBundle] pathForResource:@"pyrCatPizza" ofType:@"gif"];
	NSMutableArray *gifArray = [[NSMutableArray alloc]initWithArray:@[kenPizzaMan,tmntBikePizza,dripDropPizza,druggedPizza, rocketPizza, spinningPizza, steamingPizza, krabsPizza, spongeBobBWPizza,krustyKrabSingPizza, krustyKrabSingPizza2, sneakyDogPizza, pyrPizza, hungryPizza, cyclePizza, lsdPizza, scaryPizza, adventureTimePizza, bit8Pizza, blinkPizza, catPizza, partyOnPizza, handsUpPizza, newYearPizza, starWarsPizza, dancingPizza, videoGamePizza, loadingPizza, furbyPizza, drippingPizza, planetPizza, TMNTMikeyPizza, skatePizza, moneyPizza, flyingPizza, rock30Pizza, s90Pizza, friendsPizza, lovePizza, dripPizza, feetPizza, coolPizza, sliceSlicePizza, rotatePizza, trippyPizza, pyrCatPizza]];
	
	//	NSData *gif = [NSData dataWithContentsOfFile:filePath];
	//	[self.webView loadData:gif MIMEType:@"image/gif" textEncodingName:@"UTF-8" baseURL:[NSURL URLWithString:@"http://"] ];
	//
	//	NSString *jsCommandW = [NSString stringWithFormat:@"document.getElementsByTagName('img')[0].style.width = '80px'"];
	//	[self.webView stringByEvaluatingJavaScriptFromString:jsCommandW];
	//	NSString *jsCommandH = [NSString stringWithFormat:@"document.getElementsByTagName('img')[0].style.height = '80px'"];
	//	[self.webView stringByEvaluatingJavaScriptFromString:jsCommandH];
	//
	//
	//	self.webView.userInteractionEnabled = NO;
	NSLog(@"current = %d AND count = %lu", self.methodManager.gifCount, (unsigned long)[gifArray count]);
	NSURL *imageURL = [NSURL fileURLWithPath: [gifArray objectAtIndex:self.methodManager.gifCount]];
	// add to the count and mod by amount of array
	self.methodManager.gifCount += 1;
	self.methodManager.gifCount = self.methodManager.gifCount % gifArray.count;
	// Create HTML string from image URL
	// Width-value is arbitrary (and found experimentally): 750 works fine for me
	NSString *htmlString = @"<html><body><img src='%@' margin='0' padding='0' width='965' height='965'></body></html>";
	NSString *imageHTML  = [[NSString alloc] initWithFormat:htmlString, imageURL];
	
	self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, (self.view.bounds.size.height - self.view.bounds.size.width)/2 , self.view.bounds.size.width, self.view.bounds.size.width)];
	
	// Load image in UIWebView
	self.webView.scalesPageToFit = YES;
	self.webView.userInteractionEnabled = NO;
	self.automaticallyAdjustsScrollViewInsets = NO;
	
	//	NSString *padding = @"document.body.style.margin='0';document.body.style.padding = '0'";
	//	[self.webView stringByEvaluatingJavaScriptFromString:padding];
	
	// set the rotation of the GIF
	self.transform = CGAffineTransformMakeRotation(M_PI_2); // 90 degrees EAST
	
	//Obtaining the current device orientation
	UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
	
	//	NSLog(@"orienation = %ld", (long)orientation);
	if (orientation == UIDeviceOrientationLandscapeRight)
	{
		// code for RIGHT orientation
		self.transform = CGAffineTransformMakeRotation(M_PI_2 *3); // 90 degrees WEST
		
	}
	
	self.webView.transform = self.transform;
	
	[self.webView loadHTMLString:imageHTML baseURL:nil];
	[self.view addSubview:self.webView];
	
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
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
