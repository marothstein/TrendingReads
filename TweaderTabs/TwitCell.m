
#import "TwitCell.h"

@implementation TwitCell

@synthesize cellArticle, gradient, articleView, tweeterView, photoView, dateView,starButton;
@synthesize filledImage,hollowImage;
@synthesize requestedData;
@synthesize deviceID,appName;
@synthesize votesLabel;
@synthesize delegate;

//
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    //UILabel *articleTitle,*tweeterLabel;
    //UIImageView * photo;
    //UIView *backgroundView;
    //UIButton *upVoteButton,*downVoteButton;
    self.deviceID = [[UIDevice currentDevice] uniqueIdentifier];
    //NSLog(deviceID);
    cellArticle = 0;
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
	{

		self.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
		
		//***Make clear background
        //***Make the gradient
        gradient = [CAGradientLayer layer];
        gradient.startPoint = CGPointMake(0.0,.0);
        gradient.endPoint = CGPointMake(1.0,1.0);
        gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor whiteColor] CGColor], (id)[[UIColor grayColor] CGColor], nil];
        //***Disable highlighting on selection
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        //add a button for detail views
        self.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
        
        //find/save the origin of the content view
        
        //NSLog(@"origin: (%d,%d)",xOrigin,yOrigin);
        //article
        //UILabel * articleTitle = [[[UILabel alloc] initWithFrame:CGRectMake(xOrigin+35, yOrigin, 150.0, 45.0)] autorelease];
        
        //setup the article title view
        articleView = [[[UILabel alloc] initWithFrame:CGRectZero] retain];
        articleView.textAlignment = UITextAlignmentRight;
        articleView.numberOfLines = 1;
        articleView.lineBreakMode = UILineBreakModeTailTruncation;
        articleView.adjustsFontSizeToFitWidth = TRUE;
        articleView.minimumFontSize = 12;
        //articleView.text = [NSString stringWithFormat:@"%@",[[NSDate alloc] init]];
        articleView.backgroundColor = [UIColor clearColor];
        articleView.textColor = [UIColor blackColor];
        [self.contentView addSubview:articleView];
        
        //setup the tweeter name subview
        tweeterView = [[[UILabel alloc] initWithFrame:CGRectZero] retain];
        tweeterView.numberOfLines = 1;
        tweeterView.textAlignment = UITextAlignmentRight;
        tweeterView.textColor = [UIColor redColor];
        tweeterView.lineBreakMode = UILineBreakModeTailTruncation;
        tweeterView.adjustsFontSizeToFitWidth = TRUE;
        tweeterView.minimumFontSize = 10;
        tweeterView.backgroundColor = [UIColor clearColor];
        //tweeterView.text = @"!!";
        [self.contentView addSubview:tweeterView];
        
        //setup the photo view
        photoView = [[[UIImageView alloc] initWithFrame:CGRectZero] retain];
        photoView.backgroundColor = [UIColor clearColor];
        //photoView.image = [[UIImage alloc] init];
        [self.contentView addSubview:photoView];
        
        //setup the date view
        dateView = [[[UILabel alloc] initWithFrame:CGRectZero] retain];
        [self.contentView addSubview:dateView];
        
        
        //setup the star icon
        starButton = [UIButton buttonWithType:UIButtonTypeCustom]; 
        hollowImage = [[[UIImage imageNamed:@"star_unfilled_resized.png"] stretchableImageWithLeftCapWidth:12.0 topCapHeight:0.0] retain];
        filledImage = [[[UIImage imageNamed:@"star_filled_resized.png"] stretchableImageWithLeftCapWidth:12.0 topCapHeight:0.0] retain];
        
        [starButton setBackgroundImage:hollowImage forState:UIControlStateNormal];
        [starButton addTarget:self action:@selector(starButtonPressed:) forControlEvents:UIControlEventTouchDown];
        
        [self.contentView addSubview:starButton];
        
        //setup the votes label (shows the number of time this article has been starred)
        votesLabel = [[[UILabel alloc] initWithFrame:CGRectZero] retain];
        votesLabel.textAlignment = UITextAlignmentCenter;
        votesLabel.numberOfLines = 1;
        votesLabel.lineBreakMode = UILineBreakModeTailTruncation;
        votesLabel.adjustsFontSizeToFitWidth = TRUE;
        votesLabel.minimumFontSize = 12;
        //articleView.text = [NSString stringWithFormat:@"%@",[[NSDate alloc] init]];
        votesLabel.backgroundColor = [UIColor clearColor];
        votesLabel.textColor = [UIColor blackColor];
        [self.contentView addSubview:votesLabel];

        
        state = false;

	}
	return self;
}


- (void)layoutSubviews
{
	[super layoutSubviews];
    //***Gradient
    UIView * backgroundView = [ [ [ UIView alloc ] initWithFrame:CGRectMake(0, 0, 400, 90)] retain];
    gradient.frame = backgroundView.bounds;
    [backgroundView.layer insertSublayer:gradient atIndex:0];
    self.backgroundView = backgroundView;
    
    int xOrigin = self.contentView.frame.origin.x;
    int yOrigin = self.contentView.frame.origin.y;
    
    //***Article Title
    articleView.frame = CGRectMake(xOrigin+35, yOrigin, 150.0, 45.0);
    //articleView.text = [NSString stringWithFormat:@"%@",[[NSDate alloc] init]];
    
    //***Tweeter
    tweeterView.frame = CGRectMake(xOrigin+80, yOrigin+50, 70.0, 15.0);
    
    //***Photo
    photoView.frame = CGRectMake(xOrigin+190, 15.0, 60.0, 60.0);
    
    //***Star Button
    starButton.frame = CGRectMake(xOrigin, yOrigin+20, 30.0, 30.0);
    
    //***Votes Label
    votesLabel.frame = CGRectMake(xOrigin+15, yOrigin+55, 15.0, 15.0);
    //votesLabel.text = @"0";
}

-(void) formatArticleOnly{
    
    //[];
    [starButton setEnabled:false];
    [starButton setHidden:true];
    
    
    
    
}

-(void) showNonArticleData{
    
    
}


- (void)dealloc
{
	//[starButton release];
    [deviceID release];
	[cellArticle release];
    [super dealloc];
    [self.backgroundView release];
}


#pragma mark NSURLConnection and Stars

// action for when an article is starred 
- (void)starButtonPressed:(id)sender
{
    [delegate starButtonPressed:self.cellArticle.articleID];
    [self updateVotes];
    [self toggleState];
    return;
    
    static NSString * baseString = @"http://localhost:8080/";
    //NSLog(@"(1): %@",cellArticle.articleUrl);
    //NSLog(@"(2): %@",self.deviceID);
    //NSLog(@"(3): %@",self.appName);
    
    //format all of the requests
    NSString * formattedURL = [NSString stringWithString:self.cellArticle.articleUrl];
    formattedURL = [formattedURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString * formattedTitle = [NSString stringWithString:self.cellArticle.articleTitle];
    formattedTitle = [formattedTitle stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //NSLog(@"star pressed, title: %@",formattedTitle);
    NSString * formattedID = [NSString stringWithString:self.deviceID];
    formattedID = [formattedID stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *formattedArticleID = [NSString stringWithString:self.cellArticle.articleID];
    formattedArticleID = [formattedArticleID stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //
    
    NSString * requestString = [NSString stringWithFormat:
                                    @"api/vote?url=%@&id=%@&app=%@&title=%@&articleID=%@",
                                    formattedURL,
                                    formattedID,
                                    self.appName,
                                    formattedTitle,
                                    formattedArticleID];
    //NSString *requestString = @"api/vote?url=aurl&app=someapp&id=01";
    requestString = [NSString stringWithFormat:@"%@%@",baseString,requestString];
    //NSLog(@"request string: %@",requestString);
    //NSLog(@"full url: %@",[NSURL URLWithString:requestString]);
    
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:requestString]
                                    cachePolicy:NSURLRequestUseProtocolCachePolicy
                                    timeoutInterval:20.0];
    NSURL *dataStoreURL = [NSURL URLWithString:requestString];
    request.HTTPMethod = @"GET";
    request.URL = dataStoreURL;
    //NSURLConnection * conn = [[[NSURLConnection alloc] initWithRequest:request delegate:self] retain];
    [self makeConnection:request];
    //if(state){
       // NSString *requestString = [NSString stringWithFormat:@"%@%@",baseString,unstarString];
       // NSURL *dataStoreURL = [NSURL URLWithString:baseString];
        
        
        //[starButton setBackgroundImage:hollowImage forState:UIControlStateNormal];
        
    //} else{
        //[starButton setBackgroundImage:filledImage forState:UIControlStateNormal];
    //}
    //state = !state;
    //[request release];
}


-(void)makeConnection:(NSURLRequest*)theRequest{
    
    // create the connection with the request
    // and start loading the data
    NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    if (theConnection) {
        NSLog(@"Connection made.");
        self.requestedData = [NSMutableData dataWithLength:0];// retain];
    } else {
        // Inform the user that the connection failed.
        NSLog(@"Connection failed.");
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    // This method is called when the server has determined that it
    // has enough information to create the NSURLResponse.
    
    // It can be called multiple times, for example in the case of a
    // redirect, so each time we reset the data.
        
    NSLog(@"did receive response");
    [self.requestedData setLength:0];
    NSLog(@"requestedData resized to 0");
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // Append the new data to receivedData.
    NSLog(@"did receive data");
    NSLog(@"received %d bytes of data",data.length);
    [self.requestedData appendData:data];
    //    NSString * string = [[NSString alloc] initWithString:<#(NSString *)#>[requestedData bytes]];
}

- (void)toggleState{
    
    [self changeState:!state];
    
}


- (void) updateVotes{//: (NSString*) newVoteCount{
    
    //NSLog(@"1");
    self.votesLabel.text = [NSString stringWithFormat:@"%d",self.cellArticle.num_votes];
    //NSLog(@"num votes(cell): %d",self.cellArticle.num_votes);
   // NSLog(@"2");    
}

-(void) changeState:(bool)newState{
    
    if(newState){
        [self.starButton setBackgroundImage:filledImage forState:UIControlStateNormal];
    } else{
        [self.starButton setBackgroundImage:hollowImage forState:UIControlStateNormal];
    }
    
    state = newState;
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // do something with the data
    // receivedData is declared as a method instance elsewhere
    NSLog(@"Succeeded! Received %u bytes of data",[self.requestedData length]);
    //NSLog(@"%@",self.requestedData);
    // release the connection, and the data object
    
    //    NSString * string = [[NSString alloc] initWithBytes:[requestedData bytes] length:[requestedData length]];
    NSString* string = [[[NSString alloc] initWithData:self.requestedData encoding:NSASCIIStringEncoding] retain];
    //NSString *descString = [NSString stringWithFormat:@"%@", [requestedData description]];
    NSLog(@"requested string: %@", string);
    //NSLog(@"description string: %@",descString);
    //NSLog();
    [string release];
    [connection release];
    [self toggleState];
    NSString * numvotes = @"0";
    
    if([self.requestedData length] > 0){
        //NSLog(numvotes);
        numvotes = string;
    }
    self.cellArticle.num_votes = [numvotes intValue];
    [self updateVotes];//:numvotes];
    //[self.requestedData release];
}

@end
