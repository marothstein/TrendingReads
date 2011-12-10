//
//  TweaderTabsAppDelegate.m
//  TweaderTabs
//
//  Created by Alex Garcia on 9/20/11.
//  Copyright 2011 UMD HCI Lab. All rights reserved.
//

#import "TweaderTabsAppDelegate.h"

@implementation TweaderTabsAppDelegate

@synthesize urlToLoad;
//@synthesize window = _window;
//@synthesize tabBarController = _tabBarController;
@synthesize window,tabBarController;
@synthesize navController,myTabController,tabBarControllers;
@synthesize itemSelection,viewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [self.window addSubview:myTabController.view];
    [self.window makeKeyAndVisible];
    return YES;
    //
    
    //
    // Add the tab bar controller's current view as a subview of the window
    //self.tabBarController = [[UITabBarController alloc] init];
    //
    //self.window.rootViewController = self.tabBarController;

    //self.myTabController = [[CustomTabBarController alloc]init];
    //self.tabBarController.view.frame = CGRectMake(0, 0, 320, 460);
    
    //self.window.rootViewController = self.myTabController;
    UIViewController * tempVC = [[[UIViewController alloc]init]retain];
    UITabBar *tabBar = [[[UITabBar alloc] initWithFrame:CGRectMake(0.0, 411, 320.0, 49.0)]retain];
    [tabBar setDelegate:self];
    [tempVC.view addSubview:tabBar];
    self.window.rootViewController = tempVC;
    [self.window makeKeyAndVisible];
    
    //
    //self.window.rootViewController = self.myTabController;
    
    //[self.window addSubview:self.myTabController.tabBar];
    

    //[UITabBarItem appearance];
    NSMutableArray * newControllers = [[[NSMutableArray alloc] initWithCapacity:3] retain];
    NSMutableArray * tabBarItems = [[[NSMutableArray alloc] initWithCapacity:3] retain];
    
    //[self.tabBarController.view setAlpha:.5];
    
    
    FirstViewController * recentArticles = [[[FirstViewController alloc]init]retain];
    recentArticles.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemMostRecent tag:0];
    
    RankedArticlesVC * rankedArticles = [[[RankedArticlesVC alloc]init]retain];
    rankedArticles.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemTopRated tag:1];
    
    SecondViewController * articleView = [[[SecondViewController alloc]init]retain];
    articleView.tabBarItem = [[UITabBarItem alloc] initWithTitle: @"Article" image:[UIImage imageNamed:@"Aa Icon.png"] tag:2];
    
    
    [newControllers insertObject:recentArticles atIndex:0];
    [newControllers insertObject:rankedArticles atIndex:1];
    [newControllers insertObject:articleView    atIndex:2];
    
    [tabBarItems insertObject:recentArticles.tabBarItem atIndex:0];
    [tabBarItems insertObject:rankedArticles.tabBarItem atIndex:1];
    [tabBarItems insertObject:articleView.tabBarItem    atIndex:2];

    [tabBar setItems:tabBarItems];
    [self.tabBarController setViewControllers:newControllers];
    self.tabBarControllers = newControllers;
    
    self.itemSelection = 0;
    [tabBar setSelectedItem:recentArticles.tabBarItem];
    
    //[tempVC presentViewController:recentArticles animated:false completion:^(void) 
     //{
         
     //}];


    //[self.myTabController.tabBar setAlpha:.5];
    //[self.myTabController.tabBar setDelegate:self.myTabController];
    //[self.myTabController assignControllers: newControllers];
    
    
    //release stuff
    //[navController release];
    [tabBar release];
    [tempVC release];
    [articleView release];
    [recentArticles release];
    [rankedArticles release];
    [newControllers release];
    [tabBarItems release];
    
    
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
    
    //Sync data from cells
    
    
}

- (void)dealloc
{
    //[_window release];
    //[_tabBarController release];
    [window release];
    [tabBarController release];
    [super dealloc];
}

-(void) tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    
    static int numCalls = 0;
    
    if(self.itemSelection == item.tag && numCalls > 0){
        return;
    }
    
    
    
    if(item.tag != 2){
        
        //article view was selected previously, so the tab bar is transparent
        //make it opaque
        if(self.itemSelection == 2){
            tabBar.alpha = 1;
        }
        
        
    } else{
        //since the function returns if the selected item was already selected, we know that the alpha value was opaque, and now needs to be transparent
        tabBar.alpha = .5;
    }
    
    
    //last step is to update which item is selected
    numCalls++;
    UITableViewController * tableVC = [[[UITableViewController alloc]init]retain];
    //UIView * view = [[self.tabBarControllers objectAtIndex:item.tag] view];
//    [self.window. insertSubview:view belowSubview:tabBar];
    self.itemSelection = item.tag;
    [tableVC release];
    //[self.window.rootViewController presentedViewController:[tabBarControllers objectAtIndex:self.itemSelection];
}


/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
}
*/

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed
{
}
*/

@end
