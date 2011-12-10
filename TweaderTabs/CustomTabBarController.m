//
//  CustomTabBarController.m
//  TweaderTabs
//
//  Created by Alex Garcia on 12/8/11.
//  Copyright (c) 2011 UMD HCI Lab. All rights reserved.
//

#import "CustomTabBarController.h"

@implementation CustomTabBarController

@synthesize myTabBar,tabBarControllers,tabBarItems;
@synthesize contentViewController;
@synthesize pusher,myToolBar,tapGesture;

static int barHeight = 49;

-(void) viewDidLoad{
    
    NSLog(@"Custom: View Did Load");
    [super viewDidLoad];
    contentViewController = nil;
    
    //setup the controllers and tab bar items
    NSMutableArray * controllers = [[[NSMutableArray alloc] initWithCapacity:3] retain];
    NSMutableArray * items = [[[NSMutableArray alloc] initWithCapacity:3] retain];

    FirstViewController * recentArticles = [[[FirstViewController alloc]init]retain];
    recentArticles.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemMostRecent tag:0];
    [recentArticles setAcDelegate:self];
    
    RankedArticlesVC * rankedArticles = [[[RankedArticlesVC alloc]init]retain];
    rankedArticles.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemTopRated tag:1];
    [rankedArticles setAcDelegate:self];
    [rankedArticles setRankDelegate:self];
    
    SecondViewController * articleView = [[[SecondViewController alloc]init]retain];
    articleView.tabBarItem = [[UITabBarItem alloc] initWithTitle: @"Article" image:[UIImage imageNamed:@"Aa Icon.png"] tag:2];
    [articleView setTapDelegate:self];
    
    
    [controllers insertObject:recentArticles atIndex:0];
    [controllers insertObject:rankedArticles atIndex:1];
    [controllers insertObject:articleView    atIndex:2];
    
    [items insertObject:recentArticles.tabBarItem atIndex:0];
    [items insertObject:rankedArticles.tabBarItem atIndex:1];
    [items insertObject:articleView.tabBarItem    atIndex:2];
    
    tabBarControllers = controllers;
    tabBarItems = items;
    [controllers release];
    [items release];
    //
    
    //assign the tabbar items to the tab bar
    self.myTabBar = [[UITabBar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-barHeight, self.view.frame.size.width, barHeight)];
    
    
    [self.myTabBar setItems:tabBarItems];
    [self.myTabBar setDelegate:self];
    [self.view addSubview:self.myTabBar];
    
    
    //make the toolbar
    self.myToolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width, barHeight)];
    self.myToolBar.hidden = true;
    [self.myToolBar setBarStyle:UIBarStyleBlack];
    self.myToolBar.translucent = true;
    UIBarButtonItem * saveItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self action:@selector(savePage:)];
    [self.myToolBar setItems:[NSArray arrayWithObjects:saveItem, nil]];
    [self.view addSubview:self.myToolBar];
    //[self.
    
    
    //attach the gesture recognizer for hiding the toolbar
    tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleTabBar:)];
    tapGesture.numberOfTapsRequired = 2;
    //[self.view setGestureRecognizers:[NSArray arrayWithObject:tapGesture]];
    [self.view addGestureRecognizer:tapGesture];
    [tapGesture setDelegate:self];
    
    
    //view the first page
    UITabBarItem * item = [tabBarItems objectAtIndex:0];
    [self.myTabBar.delegate tabBar:self.myTabBar didSelectItem:item];
    self.myTabBar.selectedItem = item;
    
    
}

-(void) tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    
    static int numCalls = 0;
    if(selectedIndex == item.tag && numCalls > 0){
        NSLog(@"returning early");
        return;
    }
    UIViewController * newVC = [tabBarControllers objectAtIndex:item.tag];
    newVC.view.frame = CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height);
    if(item.tag != 2){
        
        //article view was selected previously, so the tab bar is transparent
        //make it opaque
        if(selectedIndex == 2){
            [self.myToolBar setHidden:true];
            tabBar.alpha = 1;
        }
        
        
    } else{
        //since the function returns if the selected item was already selected, we know that the alpha value was opaque, and now needs to be transparent
        [self.myToolBar setHidden:false];
        tabBar.alpha = .75;
    }
    
    //last step is to update which item is selected
    //UITableViewController * tableVC = [[[UITableViewController alloc]init]retain];
    //tableVC.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-barHeight);
    if(contentViewController){
        [contentViewController.view removeFromSuperview];
    }
    numCalls++;
    contentViewController = newVC;
    [self.view insertSubview:contentViewController.view belowSubview:self.myTabBar];
    [contentViewController viewDidAppear:TRUE];
    
    
    selectedIndex = item.tag;
    NSLog(@"Returning");
  
}

-(void) accessoryButtonPressed:(NSString *)urlToLoad{
    
    UITabBarItem * articleItem = [tabBarItems objectAtIndex:2];
    [self.myTabBar.delegate tabBar:self.myTabBar didSelectItem:articleItem];
    self.myTabBar.selectedItem = articleItem;
}

-(void) toggleTabBar : (id) sender{
 
    NSLog(@"toggle toggle");
    
}

-(void) hideBar{
    
    [self.myTabBar setHidden:TRUE];
    [self.myToolBar setHidden:TRUE];
    
}

-(void) showBar{
    [self.myTabBar setHidden:FALSE];
    [self.myToolBar setHidden:FALSE];
}

-(void) savePage : (id) sender{

    
    NSString * message = [NSString stringWithFormat:@"Successfuly saved to instapaper."];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Woot"
                                                    message:message 
                                                   delegate:self cancelButtonTitle:@"OK" 
                                          otherButtonTitles:nil];
    
    [alert show];
    [alert release];
    
    
}
     
-(void) saveToInstaPaper : (NSString *) url {
    
    static NSString * requestString = @"https://www.instapaper.com/api/add";

    if(false){ //if no article selected, do nothing
            
        return;
            
    } else{
            
        NSMutableDictionary * headers = [NSMutableDictionary dictionaryWithCapacity:2];
        
        [headers setValue:url forKey:@"url"];
        [pusher push:requestString WithData:nil AndHeaders:headers];
        //[bodyData release];
            
    }

    
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    SecondViewController * svc = [tabBarControllers objectAtIndex:2];
    if( [touch.view isDescendantOfView:svc.view] && [gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]){
        
        if(svc == contentViewController){
            
            [svc toggleTabBar:nil];
        }
        return true;
    } else{
        return false;
    }
}

-(void) viewDidUnload{
    
    [tapGesture release];
    [myTabBar release];
    [myToolBar release];
    
}

-(NSArray*) recentArticles{
    
    FirstViewController * fvc = [tabBarControllers objectAtIndex:0];
    return ( [fvc.knownArticlesDict allValues]);
    
}

@end
