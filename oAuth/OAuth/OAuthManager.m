//
//  OAuthManager.m
//  oAuth
//
//  Created by Savitha SR on 13/11/13.
//  Copyright (c) 2013 Savitha SR. All rights reserved.
//

#import "OAuthManager.h"
#import "Consumer.h"
#import "OAuthAccessToken.h"
#import "NSString+URL_encodeAndDecode.h"
#import "Signature.h"
#import "OAuth1RequestParameter.h"
#import "NSMutableURLRequest+Parameters.h"
#import "ConnectionManager.h"
#import "WebAuthorization.h"

#define OAUTH_CALLBACK  @"OAuth_Callback"
#define OAUTH_Consumer_KEY @"oauth_consumer_key"
#define OAUTH_NOUNCE @"oauth_nonce"
#define OAUTH_SIGNATURE_METHOD @"oauth_signature_method"
#define OAUTH_TIME_STAMP @"oauth_timestamp"
#define OAUTH_TOKEN @"oauth_token"

#define REQUEST_TOKEN @"RequestToken"
#define AUTHORIZATION @"Authorization"
#define ACCESS_TOKEN @"AccessToken"
#define oAuth1 @"OAUTH 1.0"
#define oAuth2 @"OAuth 2.0"


@interface OAuthManager ()<webAuthorizedDelegate>
{
    NSString *nonce;
    NSString *timestamp;
}


@property (nonatomic,strong) OAuth1RequiredParameters *OAuthparameters;
@property (nonatomic,copy) oAuthCompletionBlock completionBlock;
@property (nonatomic,strong) Consumer *consumer;
@property (nonatomic,strong) OAuthAccessToken *requestToken;
@property (nonatomic,strong) OAuthAccessToken *accessToken;
@property (nonatomic,strong) Signature * signatureProvider;
@property (nonatomic,strong) NSString *signature;
@property (nonatomic,strong) NSString *status;
@property (nonatomic,strong) NSString *callBackURl;
@property (nonatomic,strong) UIWebView *managerWebView;
@property (nonatomic,strong) WebAuthorization *authorizeObject;
@property (nonatomic,strong) NSString *version;


-(id) initWithParameters:(OAuth1RequiredParameters *)iParameters complietionBlock:(oAuthCompletionBlock)block;
-(id) initWithParametersForOAuth2:(OAuth2Parameters *)iParameters complietionBlock:(oAuthCompletionBlock)block;

@end

@implementation OAuthManager


+(void) getAccessTokenUsingOAuth1Version:(NSString *) versionString
                     RequiredParameters:(OAuth1RequiredParameters *)parameters
             withCompletionoAuthDetails:(oAuthCompletionBlock)completionHandler
{
    id manager  = nil;
    manager = [[OAuthManager alloc]initWithParameters:parameters complietionBlock:completionHandler];
}

+(void) getAccessTokenUsingOAuth2RequiredParameters:(OAuth2Parameters *)parameters
                         withCompletionoAuthDetails:(oAuthCompletionBlock)completionHandler
{
    id manager  = nil;
    manager = [[OAuthManager alloc]initWithParametersForOAuth2:parameters complietionBlock:completionHandler];
}

-(id) initWithParameters:(OAuth1RequiredParameters *)iParameters complietionBlock:(oAuthCompletionBlock)block
{
    self = [super init];
    
    if(self)
    {
        self.OAuthparameters = iParameters;
        self.completionBlock = block;
        self.callBackURl = iParameters.callBackURL;
          self.signatureProvider  =[[Signature alloc]init];
        self.version = oAuth1;
        [self getConsumer];
        
        [self getRequestToken];

    }
    
    return self;
}

-(id) initWithParametersForOAuth2:(OAuth2Parameters *)iParameters complietionBlock:(oAuthCompletionBlock)block
{
    self = [super init];
    
    if(self)
    {
        self.version = oAuth2;
        
    }
    
    return self;
}

-(void) getConsumer
{
    self.consumer = [[Consumer alloc]initWithID:self.OAuthparameters.consumerKey secret:self.OAuthparameters.secreatKey];
}




-(void) getRequestToken
{
    
    self.status = REQUEST_TOKEN;
    
    NSURL *url = [NSURL URLWithString:self.OAuthparameters.requestTokenURL];
    
    
    NSArray *parts = [[url absoluteString] componentsSeparatedByString:@"?"];
    NSString *urlSTring =  [parts objectAtIndex:0];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:urlSTring]];
    [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"json" forHTTPHeaderField:@"Accept"];
    [request setHTTPMethod:@"GET"];
    [request addValue:[self createOAuthHeader:request] forHTTPHeaderField:@"Authorization"];
    
    
    ConnectionManager *connection = nil;
    
    connection = [[ConnectionManager alloc]initWithRequest:request WithComplition:^(id details) {
        
        NSString *stringData = details;
        
        if(!self.requestToken)
        {
            self.requestToken = [[OAuthAccessToken alloc]initWithHTTPResponseBody:stringData];
        }
        
        if(self.requestToken != nil)
        {
            [self loadWebViewForAuthorization];
        }
        else{
            self.completionBlock (nil);
        }
        
    }];
    
   
    
    
}


-(void) loadWebViewForAuthorization
{
    
    self.status = AUTHORIZATION;
    NSString *userLoginURLWithToken = [NSString stringWithFormat:@"%@?oauth_token=%@",
                                       self.OAuthparameters.authorizationURL,self.requestToken.key];
    
    NSURL  *userLoginURL = [NSURL URLWithString:userLoginURLWithToken];
    self.managerWebView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, [UIApplication sharedApplication].keyWindow.frame.size.width, [UIApplication sharedApplication].keyWindow.frame.size.height)];
    [[UIApplication sharedApplication].keyWindow addSubview:self.managerWebView];
    [self.managerWebView setHidden:NO];
    
    self.authorizeObject = [[WebAuthorization alloc]init];
    self.authorizeObject.requestToken = self.requestToken;
    self.authorizeObject.authorizedUrl =self.OAuthparameters.callBackURL;
    self.authorizeObject.delegate = self;
    [self.managerWebView setDelegate:self.authorizeObject];
    NSURLRequest *request = [NSMutableURLRequest requestWithURL:userLoginURL];
    [self.managerWebView loadRequest:request];
}


-(void)loadedSuccesfully:(OAuthAccessToken *)requestToken
{
    
    if(requestToken)
    {
        self.managerWebView.hidden = YES;
        //    self.authorizeObject.delegate = nil;
        //    self.authorizeObject = nil;
        
        if([self.version isEqualToString:oAuth1])
        {
             [self getAccessToken];
        }
        else{
            
        }
       
    }
    else{
        
        self.completionBlock (nil);
    }
    
    
}

-(void) getAccessToken
{
    
    self.status = ACCESS_TOKEN;
    
    NSURL *url = [NSURL URLWithString:self.OAuthparameters.accessTokenURL];
    
    
    NSArray *parts = [[url absoluteString] componentsSeparatedByString:@"?"];
    NSString *urlSTring =  [parts objectAtIndex:0];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:urlSTring]];
    [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"json" forHTTPHeaderField:@"Accept"];
    [request setHTTPMethod:@"GET"];
    
    [request addValue:[self createOAuthHeader:request] forHTTPHeaderField:@"Authorization"];
    
    
    
    ConnectionManager *connection = [[ConnectionManager alloc]initWithRequest:request WithComplition:^(id details) {
        
        if(details)
        {
            NSString *stringData = details;
            
            self.accessToken = [[OAuthAccessToken alloc]initWithHTTPResponseBody:stringData];
            
            self.completionBlock (stringData);
        }
        else
        {
            self.completionBlock (nil);
        }
        
    }];
    
    NSLog(@"Connection %@",connection);
}


-(NSString *) createOAuthHeader:(NSMutableURLRequest *)request
{
    
    [self _generateNonce];
    [self _generateTimestamp];
    
    // set OAuth headers
	NSMutableArray *chunks = [[NSMutableArray alloc] init];
    
    [chunks addObject:[NSString stringWithFormat:@"oauth_consumer_key=\"%@\"", [self.consumer.consumerId encodeURLParameter]]];
    [chunks addObject:[NSString stringWithFormat:@"oauth_nonce=\"%@\"", nonce]];
	[chunks addObject:[NSString stringWithFormat:@"oauth_signature_method=\"%@\"", [[self.signatureProvider name] encodeURLParameter]]];
	[chunks addObject:[NSString stringWithFormat:@"oauth_timestamp=\"%@\"", timestamp]];
	[chunks	addObject:@"oauth_version=\"1.0\""];
    
    
    if([self.status isEqualToString:REQUEST_TOKEN])
    {
        [chunks addObject:[NSString stringWithFormat:@"oauth_callback=\"%@\"", [self.callBackURl encodeURLParameter]]];
    }
    
    if(self.requestToken)
    {
        
        
        
        NSDictionary *tokenParameters = [self.requestToken parameters];
        for (NSString *k in tokenParameters)
        {
            [chunks addObject:[NSString stringWithFormat:@"%@=\"%@\"", k, [[tokenParameters objectForKey:k] encodeURLParameter]]];
        }
    }
    
    
    NSString *tokenSecret = self.requestToken.secret ? self.requestToken.secret : @"";
    NSString *tokenSecretAndConsumerSecret = [NSString stringWithFormat:@"%@&%@",
                                              self.consumer.consumerSecret,
                                              tokenSecret];
    NSString *baseStringForSig = [self baseString:request];
    self.signature = [self.signatureProvider  hashedValue:baseStringForSig andMessage:tokenSecretAndConsumerSecret];
    
    [chunks addObject:[NSString stringWithFormat:@"oauth_signature=\"%@\"", [self.signature encodeURLParameter]]];
    NSString *oauthHeader = [NSString stringWithFormat:@"OAuth %@", [chunks componentsJoinedByString:@", "]];
    
    return oauthHeader;
}

- (void)_generateTimestamp
{
    timestamp = [[NSString alloc]initWithFormat:@"%ld", time(NULL)];
}

- (void)_generateNonce
{
    CFUUIDRef theUUID = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, theUUID);
	if (nonce) {
		CFRelease((__bridge CFTypeRef)(nonce));
	}
    nonce = (__bridge NSString *)string;
    
}

-(NSString *)baseString:(NSMutableURLRequest *)request
{
    NSMutableArray *parameterPairs = [[NSMutableArray alloc] init];
    [parameterPairs addObject:[self URLEncodedName:@"oauth_consumer_key" Value:self.OAuthparameters.consumerKey]];
    [parameterPairs addObject:[self URLEncodedName:@"oauth_signature_method" Value:[self.signatureProvider name]]];
    [parameterPairs addObject:[self URLEncodedName:@"oauth_timestamp" Value:timestamp]];
    [parameterPairs addObject:[self URLEncodedName:@"oauth_nonce" Value:nonce]];
    [parameterPairs addObject:[self URLEncodedName:@"oauth_version" Value:@"1.0"]];
    
    
    
    
    if([self.status isEqualToString:REQUEST_TOKEN])
    {
        if ([self.callBackURl length] > 0)
        {
            [parameterPairs addObject:[self URLEncodedName:@"oauth_callback" Value:self.callBackURl]];
        }
    }
    
    if (self.requestToken) {
        
        NSDictionary *tokenParameters = [self.requestToken parameters];
        
        for(NSString *k in tokenParameters) {
            [parameterPairs addObject:[[OAuth1RequestParameter requestParameter:k value:[tokenParameters objectForKey:k]] URLEncodedNameValuePair]];
        }
        
    }
    
    if(request)
    {
        
        NSArray *parameters  =[request parameters];
        if (![[request valueForHTTPHeaderField:@"Content-Type"] hasPrefix:@"multipart/form-data"]) {
            for (OAuth1RequestParameter *param in parameters) {
                [parameterPairs addObject:[param URLEncodedNameValuePair]];
            }
        }
    }
    
    
	
    NSArray *sortedPairs = [parameterPairs sortedArrayUsingSelector:@selector(compare:)];
    NSString *normalizedRequestParameters = [sortedPairs componentsJoinedByString:@"&"];
    NSURL *url =nil;
    
    url = [request URL];
    
    NSArray *parts = [[url absoluteString] componentsSeparatedByString:@"?"];
    NSString *urlSTring =  [parts objectAtIndex:0];
    
    
    // OAuth Spec, Section 9.1.2 "Concatenate Request Elements"
    
    
    return [NSString stringWithFormat:@"%@&%@&%@",
            [request HTTPMethod],
            [urlSTring encodeURLParameter],
            [normalizedRequestParameters encodeURL]];
	
}

- (NSString *)URLEncodedName:(NSString *)name Value:(NSString *)value {
    return [NSString stringWithFormat:@"%@=%@",name, [value encodeURLParameter]];
}

-(void) AuthorizeusingOAuth2:(OAuth2Parameters *)parameter
{
    self.status = AUTHORIZATION;
    NSString *userLoginURLWithToken = [NSString stringWithFormat:@"%@?response_type=code&client_id=%@&state=%@&redirect_uri=%@",
                                       parameter.authorizationURL,parameter.clientID,parameter.state,[parameter.redirectURL encodeURL]];
    
    NSURL  *userLoginURL = [NSURL URLWithString:userLoginURLWithToken];
    self.managerWebView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, [UIApplication sharedApplication].keyWindow.frame.size.width, [UIApplication sharedApplication].keyWindow.frame.size.height)];
    [[UIApplication sharedApplication].keyWindow addSubview:self.managerWebView];
    [self.managerWebView setHidden:NO];
    
    self.authorizeObject = [[WebAuthorization alloc]init];
    self.authorizeObject.requestToken = self.requestToken;
    self.authorizeObject.authorizedUrl =self.OAuthparameters.callBackURL;
    self.authorizeObject.delegate = self;
    [self.managerWebView setDelegate:self.authorizeObject];
    NSURLRequest *request = [NSMutableURLRequest requestWithURL:userLoginURL];
    [self.managerWebView loadRequest:request];
}

- (void) loadedSuccesfullyusingOAuth:(NSString *)code
{
    [self getAccessTokenUsingOAuth:code];
}

-(void)getAccessTokenUsingOAuth:(id)code
{
    NSURL *url = [NSURL URLWithString:self.OAuthparameters.accessTokenURL];
    
    
    NSArray *parts = [[url absoluteString] componentsSeparatedByString:@"?"];
    NSString *urlSTring =  [parts objectAtIndex:0];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:urlSTring]];
    [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"json" forHTTPHeaderField:@"Accept"];
    [request setHTTPMethod:@"POST"];
    
    
    ConnectionManager *connection = [[ConnectionManager alloc]initWithRequest:request WithComplition:^(id details) {
        
        if(details)
        {
            NSString *stringData = details;
            
            self.accessToken = [[OAuthAccessToken alloc]initWithHTTPResponseBody:stringData];
            
            self.completionBlock (stringData);
        }
        else
        {
            self.completionBlock (nil);
        }
        
    }];
}

@end
