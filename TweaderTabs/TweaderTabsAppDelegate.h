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
#import "SecondViewController.h"
#import "CustomTabBarController.h"
    
@interface TweaderTabsAppDelegate : NSObject <UIApplicationDelegate, SA_OAuthTwitterControllerDelegate,UITabBarControllerDelegate, UITabBarDelegate>{

    //SA_OAuthTwitterEngine    *_engine;
    NSInteger selected;
    
}

@property (nonatomic, copy) NSString *urlToLoad;

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) UITabBarController *tabBarController;

@property (nonatomic, retain) IBOutlet CustomTabBarController * myTabController;

@property (nonatomic, retain) UINavigationController * navController;

@property (nonatomic, retain) UIViewController * viewController;

@property (nonatomic, retain) NSArray * tabBarControllers;

@property (nonatomic, assign) NSInteger itemSelection;


-(void) addControllersAndItems : (NSArray*) controllers;

//@property (

@end
