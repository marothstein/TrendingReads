//
//  myArticle.m
//  TweaderTabs
//
//  Created by Alex Garcia on 11/10/11.
//  Copyright 2011 UMD HCI Lab. All rights reserved.
//

#import "myArticle.h"

@implementation myArticle

@synthesize tweeterName,tweeterImage,articleUrl,articleTitle,tweetDate,num_votes,state;
@synthesize articleID;
- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    self.tweeterName = @"tweeter not set";
    self.articleUrl = @"url not set";
    self.articleTitle = @"title not set";
    self.tweetDate = [[NSDate alloc] init];
    //NSLog(@"hurf: %@", tweetDate);
    self.tweeterImage = [UIImage imageNamed:@"Aa Icon"];
    
    return self;
}

-(NSDictionary *) asDictionary{
    
    NSMutableDictionary * dict = [[[NSMutableDictionary alloc] init]autorelease];
    
    //'title'
    //'tweeter'
    //'url'
    //'articleID'
    
    NSString * formattedTitle = [self.articleTitle stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString * formattedTweeter = [self.tweeterName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString * formattedURL = [self.articleUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString * formattedID = [self.articleID stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [dict setValue:formattedURL forKey:@"url"];
    [dict setValue:formattedTweeter forKey:@"tweeter"];
    [dict setValue:formattedTitle forKey:@"title"];
    [dict setValue:formattedID forKey:@"articleID"];
    /*
    [dict setValue:self.articleUrl forKey:@"url"];
    [dict setValue:self.tweeterName forKey:@"tweeter"];
    [dict setValue:self.articleTitle forKey:@"title"];
    [dict setValue:self.articleID forKey:@"articleID"];
     */

    return dict;
}


- (void) dealloc{
    
    [tweeterName release];
    [tweeterImage release];
    [articleUrl release];
    [articleTitle release];

}

/*+(NSInteger)articleCompare:(id)firstID against:(id)secondID withContext:(id)contect{
    
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
    
}*/


@end
