#import <UIKit/UIKit.h>
#import "myArticle.h"
#import <QuartzCore/QuartzCore.h>


@interface TwitCell : UITableViewCell
{
	//BOOL starred;
	//UIButton *starButton;
}

//@property (nonatomic, assign) BOOL starred;
@property (nonatomic, retain) myArticle *cellArticle;
@property (nonatomic, retain) CAGradientLayer * gradient;
@property (nonatomic, retain) UILabel *tweeterView;
@property (nonatomic, retain) UILabel *articleView;
@property (nonatomic, retain) UIImageView *photoView;
@property (nonatomic, retain) UILabel *dateView;


@end
