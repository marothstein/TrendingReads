//
//  SecondViewController.h
//  TweaderTabs
//
//  Created by Alex Garcia on 9/20/11.
//  Copyright 2011 UMD HCI Lab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArticleCellProtocol.h"



@interface SecondViewController : UIViewController {
    IBOutlet UIWebView *webView;
    bool tabBarShouldBeShown;
}

@property (nonatomic, retain) UIWebView *webView;
@property (nonatomic, retain) UINavigationController *navController;
@property (nonatomic, assign) id <TapToHideProtocol> tapDelegate;
@property (nonatomic, assign) id <IPDelegate> instaDelegate;

-(void) toggleTabBar : (id) sender;



@end
