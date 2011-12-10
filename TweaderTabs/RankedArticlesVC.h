//
//  RankedArticlesVC.h
//  TweaderTabs
//
//  Created by Alex Garcia on 11/29/11.
//  Copyright (c) 2011 UMD HCI Lab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PullSyncObject.h"
#import "RankedCell.h"
#import "SBJson.h"
#import "PullRefreshTableViewController.h"
#import "ArticleCellProtocol.h"

@interface RankedArticlesVC : PullRefreshTableViewController<UITableViewDataSource, UITableViewDelegate, PullProtocol>{
    
    bool updating;
    
}

-(void) pullFromDB;

@property (nonatomic, retain)  PullSyncObject * puller;
@property (nonatomic, copy  )  NSString * appName;
@property (nonatomic, retain)  NSMutableDictionary * knownArticles;
@property (nonatomic, retain)  NSMutableArray * rankedArticles;
@property (retain) IBOutlet UITableView * table;
@property (nonatomic, assign) id <ArticleCellProtocol>acDelegate;


@end
