
#import "TwitCell.h"

@implementation TwitCell

@synthesize cellArticle, gradient, articleView, tweeterView, photoView, dateView,starButton;
@synthesize filledImage,hollowImage;

//
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    //UILabel *articleTitle,*tweeterLabel;
    //UIImageView * photo;
    //UIView *backgroundView;
    //UIButton *upVoteButton,*downVoteButton;
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
    starButton.frame = CGRectMake(xOrigin, yOrigin+30, 30.0, 30.0);
}


- (void)dealloc
{
	//[starButton release];
	[cellArticle release];
    [super dealloc];
    [self.backgroundView release];
}



// action for when an article is starred 
- (void)starButtonPressed:(id)sender
{
    if(state){
        [starButton setBackgroundImage:hollowImage forState:UIControlStateNormal];
    } else{
        [starButton setBackgroundImage:filledImage forState:UIControlStateNormal];
    }
    state = !state;

}

@end
