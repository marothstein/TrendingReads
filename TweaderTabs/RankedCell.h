#import <UIKit/UIKit.h>
#import "myArticle.h"
#import <QuartzCore/QuartzCore.h>



@interface RankedCell : UITableViewCell
{
    int votes;
}

//@property (nonatomic, assign) BOOL starred;
@property (nonatomic, retain) myArticle *cellArticle;
//
@property (nonatomic, retain) CAGradientLayer * gradient;
@property (nonatomic, retain) UILabel *tweeterView;
@property (nonatomic, retain) UILabel *articleView;
@property (nonatomic, retain) UIImageView *photoView;
@property (nonatomic, retain) UILabel *dateView;
@property (nonatomic, retain) UIButton *starButton;
@property (nonatomic, retain) UIImage *filledImage;
@property (nonatomic, retain) UIImage *hollowImage;
@property (nonatomic, retain) NSMutableData *requestedData;
@property (nonatomic, retain) NSString * deviceID;
@property (nonatomic, retain) NSString *appName;
@property (nonatomic, retain) UILabel *votesLabel;

//@property (nonatomic, retain) NSURLConnection *connection;

-(void) starButtonPressed;
-(void) makeConnection:(NSURLRequest*)theRequest;
-(void) updateVotes;//:(NSString*)newVoteCount;
-(void) updateStar;
-(void) toggleState;
-(void) changeState:(bool)state;
-(void) formatArticleOnly;
-(void) showNonArticleData;



@end
