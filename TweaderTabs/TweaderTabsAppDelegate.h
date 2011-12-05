//
//  TweaderTabsAppDelegate.h
//  TweaderTabs
//
//  Created by Alex Garcia on 9/20/11.
//  Copyright 2011 UMD HCI Lab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SA_OAuthTwitterController.h"
#import "RankedArticlesVC.h"
#import "FirstViewController.h"
    
@interface TweaderTabsAppDelegate : NSObject <UIApplicationDelegate, SA_OAuthTwitterControllerDelegate,UITabBarControllerDelegate>{

    //SA_OAuthTwitterEngine    *_engine;
    
}

@property (nonatomic, copy) NSString *urlToLoad;

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;

@property (nonatomic, retain) UINavigationController * navController;

@end
