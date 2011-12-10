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
@synthesize acDelegate;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.appName = @"VotedReads";
    self.rankedArticles = [[[NSMutableArray alloc]init]retain];
    self.knownArticles = [[[NSMutableDictionary alloc]init]retain];
    puller = [[PullSyncObject alloc] init];
    [puller setDelegate:self];
    updating = false;
    
}

- (void)viewDidAppear:(BOOL)animated{
        
    //[self pullFromDB];
    static int first = 0;
    if(first++ == 0){
        NSLog(@"pulling");
        [self pullFromDB];
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
    [self pullFromDB];
}

@end
