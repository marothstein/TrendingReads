//
//  RankedArticlesVC.h
//  TweaderTabs
//
//  Created by Alex Garcia on 11/29/11.
//  Copyright (c) 2011 UMD HCI Lab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PullSyncObject.h"
#import "PushSyncObject.h"
#import "RankedCell.h"
#import "SBJson.h"
#import "PullRefreshTableViewController.h"
#import "ArticleCellProtocol.h"

@interface RankedArticlesVC : PullRefreshTableViewController<UITableViewDataSource, UITableViewDelegate, PullProtocol, PushProtocol>{
    
    bool updating;
    int numPulls;
    bool shouldRankAll;
    //int currentIndex;
    bool pulling;
    
}

-(void) startRankingAll;
-(void) rankNextArticle;
-(void) makeUnranked;
-(void) pullFromDB;

@property (nonatomic, retain)  PullSyncObject * puller;
@property (nonatomic, retain)  PushSyncObject * pusher;
@property (nonatomic, copy  )  NSString * appName;
@property (nonatomic, retain)  NSMutableDictionary * knownArticles;
@property (nonatomic, retain)  NSMutableArray * rankedArticles;
@property (retain) IBOutlet UITableView * table;
@property (nonatomic, assign) id <ArticleCellProtocol>acDelegate;
@property (nonatomic, retain) NSMutableArray * unrankedArticles;
@property (nonatomic, assign) id <RankingDelegate> rankDelegate;


@end
