//
//  SyncObject.m
//  TweaderTabs
//
//  Created by Alex Garcia on 11/21/11.
//  Copyright (c) 2011 UMD HCI Lab. All rights reserved.
//

#import "SyncObject.h"


@implementation SyncObject

@synthesize delegate,requestedData,authenticatingService;
@synthesize uname,pword;

-(void)syncData:(NSString *) requestString{
    
    //static NSString * baseString = @"http://localhost:8080/";
    //NSString * requestString = [NSString stringWithFormat:@"%@%@",baseString,extension];
    
    NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:requestString]
                                                         cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                     timeoutInterval:20.0];
    //[request setHTTPMethod:requestType];
    //if(requestType == @"POST"){
        //[request setHTTPBody:postData];
    //}
    
    [self connectWithRequest:request];
    
}

-(void)connectWithRequest:(NSURLRequest *) request{
    
    NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (theConnection) {
        NSLog(@"SyncObject: Connection made.");
        self.requestedData = [NSMutableData dataWithLength:0]; 
    } else {
        // Inform the user that the connection failed.
        NSLog(@"SyncObject: Connection failed.");
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    // This method is called when the server has determined that it
    // has enough information to create the NSURLResponse.
    
    // It can be called multiple times, for example in the case of a
    // redirect, so each time we reset the data.
    
    //NSLog(@"SyncObject: did receive response");
    [self.requestedData setLength:0];
    //NSLog(@"SyncObject: requestedData resized to 0");
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // Append the new data to receivedData.
    //NSLog(@"SyncObject: did receive data");
    //NSLog(@"SyncObject: received %d bytes of data",data.length);
    [self.requestedData appendData:data];
    //    NSString * string = [[NSString alloc] initWithString:<#(NSString *)#>[requestedData bytes]];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
    //NSLog(@"SyncObject: Succeeded! Received %u bytes of data",[self.requestedData length]);
    //NSLog(@"%@",self.requestedData);    
    //the connection isn't an instance variable - it's defined and allocated in (void)syncData:NSString*
    //so, now that we're done with it, we need to release it
    [connection release];
    [self.delegate dataObatained:self.requestedData];
}

- (void)connection:(NSURLConnection *)connection 
didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    // Access has failed two times...
    if ([challenge previousFailureCount] > 1)
    {
        [connection release];
        NSString * failureMessage = [NSString stringWithFormat:@"Unable to authenticate with %@. Please check your username and password.",self.authenticatingService];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Authentication Error"
                                                     message:failureMessage 
                                                     delegate:self cancelButtonTitle:@"OK" 
                                                     otherButtonTitles:nil];
        
        [alert show];
        [alert release];
    }
    else 
    {
        // Answer the challenge
        NSURLCredential *cred = [[[NSURLCredential alloc] initWithUser:self.uname 
                                                          password:self.pword
                                                          persistence:NSURLCredentialPersistenceForSession] autorelease];
        [[challenge sender] useCredential:cred forAuthenticationChallenge:challenge];
    }
}

@end
