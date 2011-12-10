
#import "RankedCell.h"


@implementation RankedCell

@synthesize cellArticle, gradient, articleView, tweeterView, photoView, dateView,starButton;
@synthesize filledImage,hollowImage;
@synthesize requestedData;
@synthesize deviceID,appName;
@synthesize votesLabel;


//
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self.deviceID = [[UIDevice currentDevice] uniqueIdentifier];
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
        articleView.textAlignment = UITextAlignmentLeft;
        articleView.numberOfLines = 1;
        articleView.lineBreakMode = UILineBreakModeTailTruncation;
        //articleView.lineBreakMode = UILineBreakModeCharacterWrap;
        articleView.adjustsFontSizeToFitWidth = FALSE;
        articleView.minimumFontSize = 12;
        //articleView.text = [NSString stringWithFormat:@"%@",[[NSDate alloc] init]];
        articleView.backgroundColor = [UIColor clearColor];
        articleView.textColor = [UIColor blackColor];
        [self.contentView addSubview:articleView];
        
        
        //setup the votes label (shows the number of time this article has been starred)
        votesLabel = [[[UILabel alloc] initWithFrame:CGRectZero] retain];
        votesLabel.textAlignment = UITextAlignmentLeft;
        votesLabel.numberOfLines = 1;
        votesLabel.lineBreakMode = UILineBreakModeTailTruncation;
        votesLabel.adjustsFontSizeToFitWidth = FALSE;
        votesLabel.minimumFontSize = 12;
        //articleView.text = [NSString stringWithFormat:@"%@",[[NSDate alloc] init]];
        votesLabel.backgroundColor = [UIColor clearColor];
        votesLabel.textColor = [UIColor blackColor];
        [self.contentView addSubview:votesLabel];
        
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
    articleView.frame = CGRectMake(xOrigin+35, 0, 250.0, 45.0);

    //***Votes Label
    votesLabel.frame = CGRectMake(xOrigin+15, yOrigin+55, 45.0, 45.0);
    //votesLabel.text = @"0";
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


- (void) updateVotes{//: (NSString*) newVoteCount{
    
    //NSLog(@"1");
    self.votesLabel.text = [NSString stringWithFormat:@"%d",self.cellArticle.num_votes];
    //NSLog(@"num votes(cell): %d",self.cellArticle.num_votes);
    // NSLog(@"2");    
}
@end
