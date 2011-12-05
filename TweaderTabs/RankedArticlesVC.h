//
//  RankedArticlesVC.h
//  TweaderTabs
//
//  Created by Alex Garcia on 11/29/11.
//  Copyright (c) 2011 UMD HCI Lab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PullSyncObject.h"
#import "TwitCell.h"
#import "SBJson.h"
#import "PullRefreshTableViewController.h"

@interface RankedArticlesVC : PullRefreshTableViewController<UITableViewDataSource, UITableViewDelegate, PullProtocol,TwitCellDelegate>{
    
    bool updating;
    
}

-(void) pullFromDB;

@property (nonatomic, retain)  PullSyncObject * puller;
@property (nonatomic, copy  )  NSString * appName;
@property (nonatomic, retain)  NSMutableDictionary * knownArticles;
@property (nonatomic, retain)  NSMutableArray * rankedArticles;
@property (retain) IBOutlet UITableView * table;


@end
