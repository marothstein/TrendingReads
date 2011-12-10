//
//  RankedArticlesVC.m
//  TweaderTabs
//
//  Created by Alex Garcia on 11/29/11.
//  Copyright (c) 2011 UMD HCI Lab. All rights reserved.
//

#import "RankedArticlesVC.h"
#import "TweaderTabsAppDelegate.h"

@implementation RankedArticlesVC

@synthesize puller,appName,knownArticles,rankedArticles,table;
@synthesize acDelegate,pusher,unrankedArticles,rankDelegate;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.appName = @"VotedReads";
    self.rankedArticles = [[NSMutableArray alloc]init];
    self.knownArticles = [[NSMutableDictionary alloc]init];
    self.unrankedArticles = [[NSMutableArray alloc]init];
    puller = [[PullSyncObject alloc] init];
    [puller setDelegate:self];
    self.pusher = [[PushSyncObject alloc] init];
    [pusher setDelegate:self];
    updating = false;
    shouldRankAll = false;
    numPulls = 0;
}

- (void)viewDidAppear:(BOOL)animated{
        
    //[self pullFromDB];
    static int first = 0;
    if(first++ == 0){
        NSLog(@"pulling");
        //[self pullFromDB];
        [self startRankingAll];
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
 
    
    return 90;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSLog(@"ranked articles: numberOfRowsInSection");
    if(rankedArticles){
        return [rankedArticles count];
    }else{
        return 0;
    }
}


-(void) makeUnranked{
    
    NSArray * temp = [self.rankDelegate recentArticles];
    
    //
    int count = [temp count];
    NSString * message = [NSString stringWithFormat:@"Articles in recent: %d",count];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Hey There"
                                                    message:message 
                                                   delegate:self cancelButtonTitle:@"OK" 
                                          otherButtonTitles:nil];
    //[alert show];
    [alert release];
    //
    
    for(myArticle * _article in temp){
        myArticle * article = [[[myArticle alloc]init]retain];
        article.articleTitle = _article.articleTitle;
        article.articleUrl = _article.articleUrl;
        article.articleID = _article.articleID;
        article.tweeterName = _article.tweeterName;
        article.num_votes = 0;
        [unrankedArticles addObject:article];
        [article release];
    }
    
    
    
}

-(void) startRankingAll{
    
    //while true and unrankedArticles is not empty, keep ranking articles
    shouldRankAll = true;
    //reset unranked and ranked articles
    [rankedArticles removeAllObjects];
    [unrankedArticles removeAllObjects];
    [self makeUnranked];
    
    //begin pulling the rankings
    [self rankNextArticle];
    
}

-(void) rankNextArticle{
    
    static NSString * apiURLString = @"http://search.twitter.com/search.json?";
    //NSString * formattedApiString = [__apiString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    //NSMutableDictionary * headers = [[[NSMutableDictionary alloc] init]retain];
    myArticle * articleToRank = [unrankedArticles lastObject];
    NSString * urlString = articleToRank.articleUrl; //query url
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString * finalString = [NSString stringWithFormat:@"%@q=%@&rpp=100",apiURLString,urlString];
    [puller pull:finalString];
}

-(void) pullComplete:(NSData *)_data{
    static NSString * apiURLString = @"http://search.twitter.com/search.json";
    if(numPulls > 100){
        shouldRankAll = false;
        NSString * message = [NSString stringWithFormat:@"More than 100 pulls. Size of (unranked,ranked) : (%d,%d)",[unrankedArticles count],[rankedArticles count]];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Stopping Ranking"
                                                        message:message 
                                                       delegate:self cancelButtonTitle:@"OK" 
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
        
    }
    NSLog(@"Num unranked: %d", unrankedArticles.count);
    bool hasNextPage = false;
    NSString * nextPageURL = @"";
    SBJsonParser *parser = [[[SBJsonParser alloc] init] retain];
    NSDictionary *jobject = [[parser objectWithData:_data] retain];
    if([jobject respondsToSelector:@selector(objectForKey:)]){
        //NSLog(@"Ranked: responds to dictionary method");
        
        myArticle * article = [unrankedArticles lastObject];
        int votes = article.num_votes;
        NSArray * results = [jobject objectForKey:@"results"];
        if(results){ //increase the number of votes by the number of mentions ON THIS PAGE OF RESULTS
            votes = votes + [results count];
        }
        article.num_votes = votes;
        NSLog(@"votes: %d",votes);
        NSString * queryString = [jobject objectForKey:@"query"];
        NSString * nextPage    = [jobject objectForKey:@"next_page"];
        //queryString = [queryString string
        if(nextPage && ![queryString isEqual:@"\%28null\%29"]){ // is there another page of results?
            
            NSString * urlString = [NSString stringWithFormat:@"%@%@",apiURLString,nextPage];
            NSLog(@"next page: %@",urlString);
            hasNextPage = true;
            nextPageURL = urlString;
        }else{ //no next_page, so we've counted all the votes. Pop and add to ranked
            nextPage = false;
        }
        
    }else if([jobject respondsToSelector:@selector(objectAtIndex:)]){
        NSLog(@"Ranked: responds to array method");
    }
    else{
        NSLog(@"Ranked: no response to test selectors");
    }
    
    
    if(hasNextPage){ //this article has another page
        numPulls++;
        [puller pull:nextPageURL];
        
    }
    else if(!shouldRankAll || [self.unrankedArticles count] < 1){ //done ranking articles
        shouldRankAll = false;
        if(updating){
            updating = false;
            [self stopLoading];
        }
        //sort the articles
        [rankedArticles sortUsingComparator: 
         ^(id obj1, id obj2) 
         {
             NSNumber* key1 = [NSNumber numberWithInt:[obj1 num_votes]];
             NSNumber* key2 = [NSNumber numberWithInt:[obj2 num_votes]];
             return [key2 compare: key1];
         }];
        
        [self.tableView reloadData];
    }else{ //there are still articles to rank!
        numPulls++;
        [rankedArticles addObject:[unrankedArticles lastObject]];
        [unrankedArticles removeLastObject];
        [self rankNextArticle];
    }
    
    
    //release retained objects
    [parser release];
    [jobject release];
}



-(void) pullFromDB{
    
    //[pullSynchObject pull]
    //
    //static NSString * baseString = @"http://localhost:8080/api/";
    static NSString * baseString = @"http://trendingreads.appspot.com/api/";
    NSString * requestString = [NSString stringWithFormat:
                                @"allArticles?app=%@",
                                self.appName];
    requestString = [NSString stringWithFormat:@"%@%@",baseString,requestString];
    [puller pull:requestString];
}



/*
-(void) pullComplete:(NSData *)_data{
    
    SBJsonParser *parser = [[[SBJsonParser alloc] init] retain];
    [knownArticles removeAllObjects];
    [rankedArticles removeAllObjects];
    //NSLog(@"stuff after");
    NSArray *jarray = [[parser objectWithData:_data] retain];
    [parser release];
    //NSMutableArray *removalArray = [[NSMutableArray alloc]retain];
    if([jarray respondsToSelector:@selector(objectForKey:)]){
        //NSLog(@"responds to dictionary method");
    }else if([jarray respondsToSelector:@selector(objectAtIndex:)]){
        //NSLog(@"responds to array method");
        
        for(int i = 0; i < [jarray count] ; i++){
            
            NSDictionary * current = [jarray objectAtIndex:i];
            
            myArticle * article = [[[myArticle alloc] init] retain];
            article.articleTitle = [current objectForKey:@"articleTitle"];
            article.articleUrl = [current objectForKey:@"the_link"];
            article.articleID = [current objectForKey:@"articleID"];
            article.tweeterName = [current objectForKey:@"tweeter"];
            article.num_votes = [[current objectForKey:@"num_votes"] intValue];
            [knownArticles setValue:article forKey:article.articleID];
            [rankedArticles addObject:article];
            [article release];
            
        }
    }else{
        NSLog(@"no response to test selectors");
    }
    
    //[jarray release];
    [rankedArticles sortUsingComparator: 
     ^(id obj1, id obj2) 
     {
         NSNumber* key1 = [NSNumber numberWithInt:[obj1 num_votes]];
         NSNumber* key2 = [NSNumber numberWithInt:[obj2 num_votes]];
         return [key1 compare: key2];
     }];
    [self.tableView reloadData];
    if(updating){
        updating = false;
        [self stopLoading];
    }
}
*/

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
	// called when the accessory view (disclosure button) is touched	
	TweaderTabsAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    
    NSString *urlAsString = [[rankedArticles objectAtIndex:indexPath.row] articleUrl];
    appDelegate.urlToLoad = urlAsString;
    
    [self.acDelegate accessoryButtonPressed:urlAsString]; 
    //[self.tabBarController setSelectedIndex:2];
}



// Customize the appearance of table view cells.
//iPhone size
//  width: 320 points
//  height 480 points
//this function is part of the api for the UITableViewDelegate - I implement it to populate the cells that will make up the Table.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    int thisRow = indexPath.row;
    
	RankedCell *cell = (RankedCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil)
	{
		cell = (RankedCell *)[[[RankedCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
	}
    
    cell.cellArticle = [rankedArticles objectAtIndex:thisRow];
    cell.articleView.text = cell.cellArticle.articleTitle;
    [cell updateVotes];
    
	return cell;
    
}

-(void) refresh{
    
    updating = true;
    //[self pullFromDB];
    numPulls = 0;
    [self startRankingAll];
}

@end
