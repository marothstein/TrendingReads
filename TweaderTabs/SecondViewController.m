//
//  SecondViewController.m
//  TweaderTabs
//
//  Created by Alex Garcia on 9/20/11.
//  Copyright 2011 UMD HCI Lab. All rights reserved.
//

#import "SecondViewController.h"
#import "TweaderTabsAppDelegate.h"

@implementation SecondViewController
@synthesize webView,tapDelegate,instaDelegate;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.webView = [[UIWebView alloc] init];
    self.view = webView;
    

    //UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleTabBar:)];
    //tapGesture.numberOfTapsRequired = 3;
//    [self.view addGestureRecognizer:tapGesture];
    //[self.view setGestureRecognizers:[NSArray arrayWithObject:tapGesture]];
    //[tapGesture release];

}

-(void) toggleTabBar : (id) sender{
    
    if(tabBarShouldBeShown){
        [tapDelegate hideBar];
        
    }else{
        [tapDelegate showBar];
    }
    tabBarShouldBeShown = !tabBarShouldBeShown;
}

- (void) viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
    
    tabBarShouldBeShown = false;
    [self toggleTabBar : nil];
    
}

- (void) viewDidAppear:(BOOL)animated{
    
    //hide the tabbar
    tabBarShouldBeShown = true;
    [self toggleTabBar : nil];
    
    //
    NSString *urlAddress = @"http://www.instapaper.com/m?u=";
    TweaderTabsAppDelegate *appDelegate = (TweaderTabsAppDelegate*)[UIApplication sharedApplication].delegate;
    //appDelegate.urlToLoad;
    if(true || appDelegate.urlToLoad){
        urlAddress = [NSString stringWithFormat:@"%@%@",urlAddress,appDelegate.urlToLoad];
        NSLog(urlAddress);
        //Create a URL object.
        NSURL *url = [NSURL URLWithString:urlAddress];
        //NSLog(@"url for webview: %@",url);
        //URL Requst Object
        NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
        NSLog(@" url for main document: %@", requestObj.URL);
        //Load the request in the UIWebView.
        [webView loadRequest:requestObj];
//        [instaDelegate ]
    }

    

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


@end


