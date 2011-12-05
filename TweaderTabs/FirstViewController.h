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
#import "SBJson.h"
#import "TwitCell.h"
#import "PullSyncObject.h"
#import "PushSyncObject.h"
#import "PullRefreshTableViewController.h"


#define ARTICLE_TAG 0
#define TWEETER_TAG 1
#define PHOTO_TAG   2

@interface FirstViewController : UIViewController<UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate, PullProtocol, PushProtocol,SA_OAuthTwitterControllerDelegate,TwitCellDelegate>{
    
    IBOutlet UITextField     *tweetTextField;
    SA_OAuthTwitterEngine    *_engine;
    NSMutableDictionary      *rowToArticleDict;
    int numStatuses;
    int timeSinceLastUpdate;
    //NSArray *statusStrings;
    
}

@property (copy) NSArray *timeLineArray;
@property (copy) NSMutableArray *statusStrings;
@property (copy) NSMutableArray *userImageData;
@property (copy) NSMutableArray *tweeterOf;
@property (nonatomic, copy) NSString * deviceID;
@property (nonatomic, retain) NSMutableDictionary * modifiedArticlesDict; //the known articles that have had their vote state changed
@property (nonatomic, retain) NSMutableDictionary * knownArticlesDict; //the articles that were created in getStatuses
@property (nonatomic, retain) NSDictionary *monthDictionary;
@property (nonatomic, retain) NSMutableArray *articleArray;
@property (retain) IBOutlet UITableView * table;
@property (nonatomic, retain) NSString *appName;
@property (nonatomic, retain) PullSyncObject * puller;
@property (nonatomic, retain) PushSyncObject * pusher;
@property (nonatomic, assign) bool readyForPull;
@property (nonatomic, assign) bool pushComplete;

-(NSString*)getURLFor:(int)RowNumber;
-(void) starAction:(id)sender;
-(void) pullFromDB;
-(void) pushToDB;
-(void) pushComplete:(NSData*)data;
-(void) clearLocalData;
-(void) startReload;
-(NSData*) serializeModifiedArticles;

//+(NSInteger)articleCompare:(id)firstID against:(id)secondID withContext:(id)contect;
static NSInteger articleCompare(id, id, void*);

@end