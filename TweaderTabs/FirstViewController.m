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

#define kOAuthConsumerKey      @"8peajUUhcayxpmYWkac8Q"
#define kOAuthConsumerSecret   @"uNT2URAHM5qwYu1Lq2m9YzrDDU3b00Cev2wtlFwVw"
@implementation FirstViewController
@synthesize table;
@synthesize statusStrings;
@synthesize userImageData;
@synthesize timeLineArray;
@synthesize tweeterOf;
@synthesize articleArray;
@synthesize monthDictionary;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    numStatuses = -1;
    //make the month dictionary
    NSArray *months = [NSArray arrayWithObjects:@"Jan",@"Feb",@"Mar",@"Apr",@"May",@"Jun",
                       @"Jul",@"Aug",@"Sep",@"Oct",@"Nov",@"Dec",nil];
    NSArray *numMonths = [NSArray arrayWithObjects:@"01",@"02",@"03",@"04",@"05",@"06",@"07",
                          @"08",@"09",@"10",@"11",@"12",nil];
    monthDictionary = [[NSDictionary alloc] initWithObjects:numMonths forKeys:months];
    //NSLog(@"%@",monthDictionary);
    //NSLog(@"%d statuses!",numStatuses);
    
    //load first view controller
    
}

- (void)viewDidAppear:(BOOL)animated{
    
    if(!_engine){
        _engine = [[SA_OAuthTwitterEngine alloc] initOAuthWithDelegate:self];  
        _engine.consumerKey    = kOAuthConsumerKey;  
        _engine.consumerSecret = kOAuthConsumerSecret;
    }
    
    if(![_engine isAuthorized]){
        UIViewController *controller = [SA_OAuthTwitterController controllerToEnterCredentialsWithTwitterEngine:_engine delegate:self];  
        
        if (controller){  
            [self presentModalViewController: controller animated: YES];  
        }  
    }
    
    if([_engine isAuthorized]){
        //NSLog(@"Engine now authorized.");
        //[_engine getPublicTimeline]; //string returned is an identifier
        [_engine getFollowedTimelineSinceID: 0 startingAtPage:3 count:30];
        //
        //NSLog(@"%@",myPublicTimeLine);
    }
    
    
    //initialize the article dictionary
    rowToArticleDict = [NSMutableDictionary dictionaryWithCapacity:1];
    
}

- (void)dealloc
{
    NSLog(@"dealloc!");
    [_engine release];  
    [tweetTextField release];  
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
	// called when the accessory view (disclosure button) is touched
	//UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];	
	
	TweaderTabsAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    
    //UILabel *articleTitle = (UILabel *)[cell.contentView viewWithTag:ARTICLE_TAG];
    //NSLog(@"accessory button tapped! Cell#: %d",indexPath.row);
    NSString *urlAsString = [self getURLFor:indexPath.row];
    appDelegate.urlToLoad = urlAsString;
    
	//NSDictionary *infoDict = [NSDictionary dictionaryWithObjectsAndKeys:
	//						  cell.title, @"text",
	//						  [NSNumber numberWithBool:cell.checked], @"checked",
	//						  nil];
	//[appDelegate showDetail:infoDict];
    [self.tabBarController setSelectedIndex:1];
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
        NSLog ( @"Num rows = num statuses = %d", numStatuses);
        return numStatuses;        
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
    cell.cellArticle = [articleArray objectAtIndex:thisRow];
    cell.articleView.text = cell.cellArticle.articleTitle;
    cell.tweeterView.text = cell.cellArticle.tweeterName;
    cell.photoView.image = cell.cellArticle.tweeterImage;
        
	return cell;

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
    NSLog(@"FAILURE");
}

- (void)statusesReceived:(NSArray *)statuses forRequest:(NSString *)identifier{

    //numStatuses = [statuses count];
    numStatuses = 0;
    NSLog(@"all statuses: %d",[statuses count]);
    //release statusStrings and realloc
    //[statusStrings release];
    //statusStrings = [[NSMutableArray alloc] init];
    //[userImageData release];
    //userImageData = [[NSMutableArray alloc] init];
    //[tweeterOf release];
    //tweeterOf = [[NSMutableArray alloc] init];
    [self setArticleArray:[[NSMutableArray alloc] init]];
    //NSLog(@"%@",[statuses objectAtIndex:0]);
    //loop through statuses, get statuses
    for(int i = 0; i < [statuses count]; i++){
        NSString * text = [[statuses objectAtIndex:i] valueForKey:@"text"];
        NSString * tweeter = [[[statuses objectAtIndex:i] valueForKey:@"user"] valueForKey:@"name"];
        NSString *photoURL = [[[statuses objectAtIndex:i] valueForKey:@"user"] valueForKey:@"profile_image_url"];
        
        //NSDate *date = 
        //NSLog(@"%@",[statuses objectAtIndex:i]);
               // NSString * text = [[statuses objectAtIndex:i] valueForKey:@"text"];
        NSError *error = NULL;
        //NSString *urlRegexString = @"(https?://)";//?([a-z]+/)+";//@"^(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?$";
        NSString *altRegexString = @"\.[a-zA-Z]+([-0-9a-zA-Z]+/)+[0-9a-zA-Z]*";
        NSArray * tokens = [text componentsSeparatedByString: @" "];
        //NSRegularExpression *URLRegex = [NSRegularExpression regularExpressionWithPattern:urlRegexString options:NSRegularExpressionCaseInsensitive error:&error];
        NSRegularExpression *AltURLRegex = [NSRegularExpression regularExpressionWithPattern:altRegexString options:NSRegularExpressionCaseInsensitive error:&error];
        bool isMatched = false;
        int ti = 0;
        //NSTextCheckingResult *match;
        NSTextCheckingResult *altMatch;
        NSString * matched;
        while(!isMatched && ti < [tokens count]){
            
            NSString * currentToken = [tokens objectAtIndex:ti];
            //NSLog(currentToken);
            //match = [URLRegex firstMatchInString:currentToken options:0 range:NSMakeRange(0, [currentToken length])];
            altMatch = [AltURLRegex firstMatchInString:currentToken options:0 range:NSMakeRange(0, [currentToken length])];
            if(altMatch){
                isMatched = true;
                matched = currentToken;
                //NSLog(currentToken);
                altMatch = [AltURLRegex firstMatchInString:currentToken options:0 range:NSMakeRange(0, [currentToken length])];
                if(altMatch){
                    NSRange matchRange = [altMatch range];
                    NSString *matchText = [currentToken substringWithRange:matchRange];
                    //NSLog(@"matched text: %@", matchText);
                    //NSLog(@"full text: %@", currentToken);
                }
            }
            
            else{
                ti++;
            }
        }
        
        //setup the article object, and stick it in the dictionary
        if (altMatch) {
            //get and add the URL to the appropriate NSArray*
            //NSRange matchRange = [match range];
            //NSString *matchText = [text substringWithRange:matchRange];
            NSString *matchText = matched;
            NSURL *url = [NSURL URLWithString:photoURL];
            NSData *data = [[[NSData alloc] initWithContentsOfURL:url] retain];
            
            //[statusStrings addObject:matchText];
            //[tweeterOf addObject:tweeter];
            //[userImageData addObject:data];
            //[data release];
            //numStatuses++;
            
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
            //NSLog(@"created on: %@",mdy);
            //NSLog(@"article date: %@",dateString);
            //NSLog(@"Date: %@",date);
            myArticle * article = [[[myArticle alloc] init] retain];
            article.articleTitle = matched;
            article.articleUrl = matched;
            //NSData * imageData = [userImageData objectAtIndex:thisRow];
            //UIImage * userImage = [UIImage imageWithData:imageData];
            article.tweeterImage = [UIImage imageWithData:data];
            article.tweeterName = tweeter;
            article.tweetDate = date;
            
            [articleArray addObject:article];
            [article release];
            [data release];
            [dateFormatter release];
            numStatuses++;
        }
    }
    //NSLog(@"Before: %@",articleArray);
    //NSLog(@"-------");
    [articleArray sortedArrayUsingFunction:articleCompare context:nil];
    //NSLog(@"after: %@", articleArray);
    //NSLog(@"num statuses: %@", articleArray);
    [table reloadData];

}

- (void)directMessagesReceived:(NSArray *)messages forRequest:(NSString *)identifier{
    //numStatuses = 4;
}

- (void)userInfoReceived:(NSArray *)userInfo forRequest:(NSString *)identifier{
    //numStatuses = 5;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    // This method is called when the server has determined that it
    // has enough information to create the NSURLResponse.
    
    // It can be called multiple times, for example in the case of a
    // redirect, so each time we reset the data.
    
    // receivedData is an instance variable declared elsewhere.
    //NSLog(@"did receive response");
    //[requestedData setLength:0];
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


#pragma mark NSURLConnection stuff

- (IBAction)processUpVote:(id)sender{

    //
    
    
}

- (IBAction)processDownVote:(id)sender{
    
    //
    
}

-(void)makeConnection:(NSURLRequest*)theRequest{
    
    // create the connection with the request
    // and start loading the data
    NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    if (theConnection) {
        // Create the NSMutableData to hold the received data.
        // receivedData is an instance variable declared elsewhere.
        //requestedData = [[NSMutableData data] retain];
        //NSLog(@"Connection made.");
    } else {
        // Inform the user that the connection failed.
        //NSLog(@"Connection failed.");
    }
}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // Append the new data to receivedData.
    // receivedData is an instance variable declared elsewhere.
    //NSLog(@"did receive data");
    //NSLog(@"received %d bytes of data",data.length);
    //[requestedData appendData:data];
    //    NSString * string = [[NSString alloc] initWithString:<#(NSString *)#>[requestedData bytes]];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // do something with the data
    // receivedData is declared as a method instance elsewhere
    //NSLog(@"Succeeded! Received %lu bytes of data",[requestedData length]);
    //NSLog(@"%@",requestedData);
    // release the connection, and the data object
    
    //    NSString * string = [[NSString alloc] initWithBytes:[requestedData bytes] length:[requestedData length]];
    //NSString* string = [[NSString alloc] initWithData:requestedData encoding:NSASCIIStringEncoding];
    //NSString *descString = [NSString stringWithFormat:@"%@", [requestedData description]];
    //NSLog(@"requested string: %@",string);
    //NSLog(@"description string: %@",descString);
    //[responseField setStringValue:string];
    [connection release];
    //[requestedData release];
}




@end
