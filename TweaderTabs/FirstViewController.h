//
//  FirstViewController.h
//  TweaderTabs
//
//  Created by Alex Garcia on 9/20/11.
//  Copyright 2011 UMD HCI Lab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SA_OAuthTwitterController.h"
#import <QuartzCore/QuartzCore.h>
//#import "NSDateF.h"
#import "TwitCell.h"


#define ARTICLE_TAG 0
#define TWEETER_TAG 1
#define PHOTO_TAG   2

@interface FirstViewController : UIViewController<UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate, SA_OAuthTwitterControllerDelegate>{
    
    IBOutlet UITextField     *tweetTextField;
    SA_OAuthTwitterEngine    *_engine;
    NSMutableDictionary      *rowToArticleDict;
    int numStatuses;
    //NSArray *statusStrings;
    
}

@property (copy) NSArray *timeLineArray;
@property (copy) NSMutableArray *statusStrings;
@property (copy) NSMutableArray *userImageData;
@property (copy) NSMutableArray *tweeterOf;
@property (nonatomic, retain) NSDictionary *monthDictionary;
@property (nonatomic, retain) NSMutableArray *articleArray;
@property (nonatomic, retain) NSArray *cellArray;
@property (retain) IBOutlet UITableView * table;

-(NSString*)getURLFor:(int)RowNumber;
-(IBAction) processUpVote:(id)sender;
-(IBAction) processDownVote:(id)sender;
-(void) makeConnection:(NSURLRequest*)request;
-(void) starAction:(id)sender;

//+(NSInteger)articleCompare:(id)firstID against:(id)secondID withContext:(id)contect;
static NSInteger articleCompare(id, id, void*);

@end