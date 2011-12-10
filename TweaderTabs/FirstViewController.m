//
//  FirstViewController.m
//  TweaderTabs
//
//  Created by Alex Garcia on 9/20/11.
//  Copyright 2011 UMD HCI Lab. All rights reserved.
//

#import "FirstViewController.h"
#import "SA_OAuthTwitterEngine.h"
#import "TweaderTabsAppDelegate.h"

#define kOAuthConsumerKey      @"UmSCIqH21XB3TgsD0FFSLQ"
#define kOAuthConsumerSecret   @"yIKKPuCSqOmCxMrrNvFE3muDj8yXvh4VtuTOT9gWBWE"
@implementation FirstViewController
//@synthesize table;
@synthesize statusStrings;
@synthesize deviceID;
@synthesize userImageData;
@synthesize timeLineArray;
@synthesize tweeterOf;
@synthesize articleArray;
@synthesize monthDictionary;
@synthesize appName;
@synthesize modifiedArticlesDict,knownArticlesDict,puller,pusher,readyForPull,pushComplete;
@synthesize acDelegate;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    updating = false;
    numStatuses = -1;
    appName = @"VotedReads";
    //make the month dictionary
    NSArray *months = [NSArray arrayWithObjects:@"Jan",@"Feb",@"Mar",@"Apr",@"May",@"Jun",
                       @"Jul",@"Aug",@"Sep",@"Oct",@"Nov",@"Dec",nil];
    NSArray *numMonths = [NSArray arrayWithObjects:@"01",@"02",@"03",@"04",@"05",@"06",@"07",
                          @"08",@"09",@"10",@"11",@"12",nil];
    monthDictionary = [[NSDictionary alloc] initWithObjects:numMonths forKeys:months];
    
    //self.lastSyncState = [[NSMutableDictionary alloc] initWithCapacity:0];
    //self.currentState = [[NSMutableDictionary alloc] initWithCapacity:0];
    modifiedArticlesDict = [[NSMutableDictionary alloc] initWithCapacity:0];
    knownArticlesDict = [[NSMutableDictionary alloc] initWithCapacity:0];
    [self setArticleArray:[[NSMutableArray alloc] init]];
    [self setPuller:[[PullSyncObject alloc] init]];
    [self setPusher:[[PushSyncObject alloc] init]];
    [self.puller setDelegate:self];
    [self.pusher setDelegate:self];
    timeSinceLastUpdate = -1;
    self.deviceID = [[UIDevice currentDevice] uniqueIdentifier];
    self.pushComplete = false;
    self.readyForPull = false;
    NSLog(@"device ID: %@", deviceID);
    //NSLog(@"%@",monthDictionary);
    //NSLog(@"%d statuses!",numStatuses);
    //load first view controller
    
}

- (void)viewDidAppear:(BOOL)animated{

    if(!_engine){
        NSLog(@"Making engine");
        _engine = [[[SA_OAuthTwitterEngine alloc] initOAuthWithDelegate:self] retain];  
        _engine.consumerKey    = kOAuthConsumerKey;  
        _engine.consumerSecret = kOAuthConsumerSecret;
    }
    
    NSLog(@"Checking for authorization.");
    
    if(![_engine isAuthorized]){
        UIViewController *controller = [SA_OAuthTwitterController controllerToEnterCredentialsWithTwitterEngine:_engine delegate:self];  
        
        if (controller){
            NSLog(@"  presenting controller");
            [self presentModalViewController: controller animated: YES];  
        }
        else{
            NSLog(@"  controller does't exist");
        }
        NSLog(@"  Engine not authorized, %d", timeSinceLastUpdate);
        
    } else if(timeSinceLastUpdate < 0 || timeSinceLastUpdate > 100000){
        NSLog(@"  Engine authorized. Getting statuses.");
        //[_engine checkUserCredentials];
        //[_engine getFollowedTimelineSinceID: 0 startingAtPage:3 count:30];
        //NSLog(@"  Engine Authorized!");
        [self startReload];
        timeSinceLastUpdate = 1;
    }

    
}

- (void)dealloc
{
    NSLog(@"dealloc!");
    //make a push call to save modifiedArticleDict
    
    //
    [_engine release];  
    [tweetTextField release];  
    [knownArticlesDict release];
    [modifiedArticlesDict release];
    [articleArray release];
    [puller release];
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
	//called when the accessory view (disclosure button) is touched
    TweaderTabsAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    NSString *urlAsString = [[articleArray objectAtIndex:indexPath.row] articleUrl];
    appDelegate.urlToLoad = urlAsString;
    [acDelegate accessoryButtonPressed:urlAsString];
    //[self.tabBarController setSelectedIndex:2];
}

-(void)starButtonPressed:(NSString *)articleID{
    
    myArticle * article = [knownArticlesDict objectForKey:articleID];
    if(article){
        
        if([modifiedArticlesDict valueForKey:articleID]){
            [modifiedArticlesDict removeObjectForKey:articleID];
            NSLog(@"removing article from modifed(%d)",[modifiedArticlesDict count]);
        }else{
            [modifiedArticlesDict setValue:article forKey:articleID];
            NSLog(@"adding article to modified(%d)",[modifiedArticlesDict count]);
        }
        
        article.state = !article.state;
        int change = -1 + 2*article.state;
        //NSLog(@"change: %d",change);
//        if(article.state){change = 1;}
        article.num_votes = article.num_votes + change;
        
        
    }else{
        NSLog(@"Error, star button pressed for unknown article ID: %@",articleID);
    }
    
}


#pragma mark SA_OAuthTwitterEngineDelegate  


- (void) storeCachedTwitterOAuthData: (NSString *) data forUsername: (NSString *) username {  
    NSUserDefaults          *defaults = [NSUserDefaults standardUserDefaults];  
 
    [defaults setObject: data forKey: @"authData"];  
    [defaults synchronize];  
}  
 
 - (NSString *) cachedTwitterOAuthDataForUsername: (NSString *) username {  
     
     return [[NSUserDefaults standardUserDefaults] objectForKey: @"authData"];  
     
 }


#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;

}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if([_engine isAuthorized]){
        NSLog ( @"Num rows = num statuses = %d || unique statuses = %d", numStatuses,[knownArticlesDict count]);
        //return numStatuses;        
        return [articleArray count];
    }
    else {
        NSLog ( @"Engine not authenticated %d.", numStatuses);
        return 0;
    }

}


// Customize the appearance of table view cells.
//iPhone size
//  width: 320 points
//  height 480 points
//this function is part of the api for the UITableViewDelegate - I implement it to populate the 'cells' that will make up the Table.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *CellIdentifier = @"Cell";
    int thisRow = indexPath.row;
    
	TwitCell *cell = (TwitCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil)
	{
		cell = (TwitCell *)[[[TwitCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
	}
    
    //load the appropriate content into the cell
    [cell setDelegate:self];
    cell.cellArticle = [articleArray objectAtIndex:thisRow];
    cell.articleView.text = cell.cellArticle.articleTitle;
    cell.tweeterView.text = cell.cellArticle.tweeterName;
    cell.photoView.image = cell.cellArticle.tweeterImage;
    cell.appName = self.appName;
    //NSLog(@"num votes(first view): %d",cell.cellArticle.num_votes);
    //NSLog(@"num votes(first view 2): %d",cell.cellArticle.num_votes);
    //NSLog(@"---");
    //
    bool state = cell.cellArticle.state;
    [cell changeState:state];
    [cell updateVotes];
    
	return cell;
    
}

-(void)loadState{
    
}


-(void)starAction:(id)sender{
    
    NSLog(@"star time!");
    
    [(UIButton*)(sender) setBackgroundImage:
     [[UIImage imageNamed:@"star_filled_resized.png"] stretchableImageWithLeftCapWidth:12.0 topCapHeight:0.0] forState:UIControlStateNormal];
    
}

-(NSString*)getURLFor:(int)RowNumber{
    
    if(numStatuses <= RowNumber){return @"--";}
    //NSLog(@"%d",RowNumber);
    //NSDictionary *at0 = [timeLineDictArray objectAtIndex:0];
    //NSLog(@"%d",RowNumber);
    //NSLog(@"%d",[statusStrings count]);
    return [statusStrings objectAtIndex:RowNumber];
    //return [NSString stringWithFormat:@"placeholder %d",RowNumber];
}




- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

- (void)requestSucceeded:(NSString *)requestIdentifier{
    //numStatuses = 1;
}
- (void)requestFailed:(NSString *)requestIdentifier withError:(NSError *)error{
    //numStatuses = 2;
    NSLog(@"Request failed with erorr: %@", error);
    [_engine getRateLimitStatus];

}
- (void)miscInfoReceived:(NSArray *)miscInfo forRequest:(NSString *)connectionIdentifier{
    
    NSLog(@"rate limit request: %@",miscInfo);
    
}

- (void)userInfoReceived:(NSArray *)userInfo forRequest:(NSString *)connectionIdentifier{
    
    //NSLog(@"user info received: %@",userInfo);
    
}



- (void)statusesReceived:(NSArray *)statuses forRequest:(NSString *)identifier{

    //numStatuses = [statuses count];
    numStatuses = 0;
    NSLog(@"all statuses: %d",[statuses count]);
    
    [self clearLocalData];
    for(int i = 0; i < [statuses count]; i++){
       // NSLog(@"  1");
        NSString * text = [[statuses objectAtIndex:i] valueForKey:@"text"];
        NSString * tweeter = [[[statuses objectAtIndex:i] valueForKey:@"user"] valueForKey:@"name"];
        NSString *photoURL = [[[statuses objectAtIndex:i] valueForKey:@"user"] valueForKey:@"profile_image_url"];
        

        NSError *error = NULL;

        NSString *altRegexString = @"\.[a-zA-Z]+([-0-9a-zA-Z]+/)+[0-9a-zA-Z]*";
        NSArray * tokens = [text componentsSeparatedByString: @" "];

        NSRegularExpression *AltURLRegex = [NSRegularExpression regularExpressionWithPattern:altRegexString options:NSRegularExpressionCaseInsensitive error:&error];
        bool isMatched = false;
        int ti = 0;

        NSTextCheckingResult *altMatch;
        NSString * matched;

        while(!isMatched && ti < [tokens count]){
            
            NSString * currentToken = [tokens objectAtIndex:ti];

            altMatch = [AltURLRegex firstMatchInString:currentToken options:0 range:NSMakeRange(0, [currentToken length])];
            if(altMatch){
                isMatched = true;
                matched = currentToken;
                //NSLog(currentToken);
                altMatch = [AltURLRegex firstMatchInString:currentToken options:0 range:NSMakeRange(0, [currentToken length])];
                if(altMatch){
                    NSRange matchRange = [altMatch range];
                    NSString *matchText = [currentToken substringWithRange:matchRange];

                }
            }
            
            else{
                ti++;
            }
        }
        // NSLog(@"  4");
        
        //setup the article object, and stick it in the dictionary
        if (altMatch) {
            
            //do we already have this article?
            NSString *articleID = [NSString stringWithFormat:@"%@%@",tweeter,matched];
            if([knownArticlesDict valueForKey:articleID]){
                NSLog(@"article exists ... %@",articleID);
                
            }
            else{
                
                
                NSString *matchText = matched;
                NSURL *url = [NSURL URLWithString:photoURL];
                
                NSString * temp = [[statuses objectAtIndex:i] valueForKey:@"created_at"];
                NSArray * tokens = [temp componentsSeparatedByString: @" "];
                //NSLog(@"%@",tokens);
                NSString *year = [tokens objectAtIndex:([tokens count]-1)];
                NSString * month = [tokens objectAtIndex:1];
                month = [monthDictionary objectForKey:month];
                //NSString *month = [monthDictionary objectForKey:[tokens objectAtIndex:2]];
                NSString *day = [tokens objectAtIndex:2];
                NSString *mdy = [NSString stringWithFormat:@"%@-%@-%@",year,month,day];
                NSString *time = [tokens objectAtIndex:3];
                NSString *adjust = [tokens objectAtIndex:4];
                NSString *dateString = [NSString stringWithFormat:@"%@ %@ %@",mdy,time,adjust];
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss z"];
                NSDate *date = [dateFormatter dateFromString:dateString];
                
                //NSString *pageString = matched;
                NSString * ipURL = @"http://www.instapaper.com/m?u=";
                NSString * luURL = @"http://longurl.org/expand?url=";
                //NSString * testPageString = @"http://www.businessinsider.com/netflix-login-problems-2011-11";
                NSString * ipPageString = [NSString stringWithFormat:@"%@%@",
                                           ipURL,
                                           matched];
                NSURL * pageURL = [NSURL URLWithString:ipPageString];
                NSError *error;
                NSStringEncoding * encoding;
                NSString *pageAsString = [NSString stringWithContentsOfURL:pageURL 
                                                                  encoding:NSASCIIStringEncoding
                                                                   error:&error];
                //NSLog(@"pageURL: %@",pageURL);
                //NSLog(@"pageAsString: %@",pageAsString);
                //NSLog(@"error: %@",error);
                NSArray *tempArray = [pageAsString componentsSeparatedByString:@"<!-- IP:TITLE"];
                //NSArray *tempArray = [pageAsString componentsSeparatedByString:@"<head>"];
                NSString * title = matched;
                //NSLog(@"%@",tempArray);
                if([tempArray count] > 1){
                    
                    tempArray = [[tempArray objectAtIndex:1] componentsSeparatedByString:@"/IP:TITLE"];
                    if([tempArray count] > 1){
                        title = [tempArray objectAtIndex:0];
                    }
                }
                //NSLog(@"Title: %@",title);
                NSData *data = [[[NSData alloc] initWithContentsOfURL:url] retain];
                myArticle * article = [[[myArticle alloc] init] retain];
//                article.articleTitle = matched;
                article.articleTitle = title;
                article.articleUrl = matched;
                article.articleID = articleID;
                
                article.tweeterImage = [UIImage imageWithData:data];
                article.tweeterName = tweeter;
                article.tweetDate = date;
                article.state = false;
                article.num_votes = 0;
                
                
                [knownArticlesDict setValue:article forKey:articleID];
                [articleArray addObject:article];
                [article release];
                [data release];
                [dateFormatter release];
            }
            numStatuses++;
        }
    }
    [articleArray sortedArrayUsingFunction:articleCompare context:nil];
    //
    
    [self pullFromDB];
        

}

-(void) pullFromDB{

    //[pullSynchObject pull]
    //
    //static NSString * baseString = @"http://localhost:8080/api/";
    static NSString * baseString = @"http://trendingreads.appspot.com/api/";
    NSString * requestString = [NSString stringWithFormat:
                                @"myArticles?app=%@&deviceID=%@",
                                self.appName,
                                self.deviceID];
    requestString = [NSString stringWithFormat:@"%@%@",baseString,requestString];
    [puller pull:requestString];
    
}

-(void) pullComplete:(NSData *)_data{
    
    SBJsonParser *parser = [[[SBJsonParser alloc] init] retain];
    //NSLog(@"stuff after");
    NSArray *jarray = [[parser objectWithData:_data] retain];
    [parser release];
    //NSArray *jdict;
    //NSLog(@"string after being converted: %@",string);
    //NSLog(@"json data: %@",data);
    NSLog(@"json dict: %@",jarray);
    //if(error){
      //  NSLog(@"error: %@", [error localizedDescription]);
        //return;
    //}
    if([jarray respondsToSelector:@selector(objectForKey:)]){
        NSLog(@"responds to dictionary method");
    }else if([jarray respondsToSelector:@selector(objectAtIndex:)]){
        NSLog(@"responds to array method");
        
        for(int i = 0; i < [jarray count] ; i++){
            
            NSDictionary * current = [jarray objectAtIndex:i];
            NSString * articleID = [current objectForKey:@"articleID"];
            myArticle * article = [knownArticlesDict objectForKey:articleID];
            if(article){
                article.state = true;
                NSString *votesString = [current objectForKey:@"num_votes"];
                article.num_votes = [votesString intValue];
            }
            NSLog(@"modifying article: %@",article);
        }
    }else{
        NSLog(@"no response to test selectors");
    }
    
    [jarray release];
    [self.tableView reloadData];
    if(updating){
        updating = false;
        [self stopLoading];
    }
    
    
}

-(void)clearLocalData{
    
    [modifiedArticlesDict removeAllObjects];
    [knownArticlesDict removeAllObjects];
    [articleArray removeAllObjects];
    
}

-(void)startReload{
    
    [self pushToDB]; //push modifiedArticleDict to DB
    //[self clearLocalData]; //clears modifiedArticlesDict, knownArticlesDict, and articlesArray
}

-(void) pushToDB{
    //static NSString * requestString = @"http://localhost:8080/api/updateArticles?";
    static NSString * requestString = @"http://trendingreads.appspot.com/api/updateArticles?";
    self.pushComplete = false;
    //return; //don't use yet
    
    if([modifiedArticlesDict count] < 1){ //if no articles have been modified, then do nothing
        
        NSLog(@"No modified articles. Returning.");
        [self pushComplete:nil];
        return;
        
    } else{
        
        NSMutableDictionary * headers = [NSMutableDictionary dictionaryWithCapacity:2];
    
        NSLog(@"Push to db. appname : %@, deviceID : %@",self.appName,self.deviceID);
        
        [headers setValue:self.appName forKey:@"app"];
        [headers setValue:self.deviceID forKey:@"deviceID"];
    
        //set the request body
        //step one, serialize modifed articles as JSON
        NSData * bodyData = [NSData dataWithData:[self serializeModifiedArticles]];
        //
        SBJsonParser * parser = [[[SBJsonParser alloc] init] retain];
        NSLog(@"json string for articles: %@",[parser objectWithData:bodyData]);
        [parser release];
        //
        
        [pusher push:requestString WithData:bodyData AndHeaders:headers];
        //[bodyData release];
        
    }
}

-(NSData *) serializeModifiedArticles{ //returns JSON utf8 data
    
    //NSMutableData * data = [[[NSMutableData alloc] init] autorelease];
    SBJsonWriter *writer = [[[SBJsonWriter alloc] init] retain];
    NSArray * modifiedArticles = [modifiedArticlesDict allValues];
    NSMutableArray * jsonArray = [[[NSMutableArray alloc]init]retain];
    for(int i = 0; i < [modifiedArticlesDict count]; i++){
        
        myArticle * article = [modifiedArticles objectAtIndex:i];
        [jsonArray addObject:[article asDictionary]];
        //NSDictionary * artDict = [article asDictionary];
        //NSLog(@"artDict: %@",artDict);
        //NSData * incData = [writer dataWithObject:artDict];
        //if(!incData){
          //  NSLog(@"incorrect formatting for json object.");
        //}else{
          //  [data appendData:incData];
        //}
    }
    NSMutableData * data = [[[NSMutableData alloc] initWithData:[writer dataWithObject:jsonArray]]autorelease];
    if(!data){
        NSLog(@"incorrect formatting for json object.");
    }
    [jsonArray release];
    [writer release];
    return data;
    
}

-(void) pushComplete:(NSData*)data{
    
    if(data){
        NSString * string = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]retain];
    
        NSLog(@"pushComplete");
        NSLog(@"%@",string);
    }
    
    //[self clearLocalData];
    [_engine getFollowedTimelineSinceID: 0 startingAtPage:3 count:30];
    //self.pushComplete = true;
    //[string release];
    //if(self.readyForPull){
        //[self pullFromDB];
    //}
    
}


-(void) synchWithSelf{
    
    //make the connection call;
    //
}

- (void)directMessagesReceived:(NSArray *)messages forRequest:(NSString *)identifier{
    //numStatuses = 4;
}

- (void) refresh{
    updating = true;
    [self startReload];
    
}


NSInteger articleCompare(id firstID, id secondID, void * context){
    
    //cast firstID and secondID appropriately, get the dates they were posted
    NSDate * date1 = ((myArticle*)firstID).tweetDate;
    NSDate * date2 = ((myArticle*)secondID).tweetDate;
    
    //compare the dates
    if (date1 < date2){
        return NSOrderedAscending;
    }
    else if (date1 > date2){
        return NSOrderedDescending;
    }
    else{
        return NSOrderedSame;
    }
    
}







@end
