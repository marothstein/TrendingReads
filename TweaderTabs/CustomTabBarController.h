//
//  CustomTabBarController.h
//  TweaderTabs
//
//  Created by Alex Garcia on 12/8/11.
//  Copyright (c) 2011 UMD HCI Lab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "RankedArticlesVC.h"
#import "FirstViewController.h"
#import "SecondViewController.h"
#import "ArticleCellProtocol.h"
#import "PushSyncObject.h"

@interface CustomTabBarController : UIViewController<UITabBarDelegate, ArticleCellProtocol, TapToHideProtocol, IPDelegate, UIGestureRecognizerDelegate, RankingDelegate>{
    
    int selectedIndex;
    
}

//the tabbar
@property (nonatomic, retain) UITabBar * myTabBar;
@property (nonatomic, retain) UIToolbar * myToolBar;
@property (nonatomic, retain) NSArray  * tabBarControllers;
@property (nonatomic, retain) NSArray  * tabBarItems;
@property (nonatomic, retain) NSArray  * currentArticles;
@property (nonatomic, retain) UIViewController   * contentViewController;
@property (nonatomic, retain) PushSyncObject *pusher;
@property (nonatomic, retain) UITapGestureRecognizer * tapGesture;

-(void) toggleTabBar : (id) sender;
-(void) saveToInstaPaper : (NSString *) url;
-(void) savePage : (id) sender;

@end
