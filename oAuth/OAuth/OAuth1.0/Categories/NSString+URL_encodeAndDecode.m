//
//  NSString+URL_encodeAndDecode.m
//  oAuth
//
//  Created by Savitha SR on 13/11/13.
//  Copyright (c) 2013 Savitha SR. All rights reserved.
//

#import "NSString+URL_encodeAndDecode.h"

@implementation NSString (URL_encodeAndDecode)

-(NSString *) encodeURL
{
    NSString *result = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                    (CFStringRef)self,
                                                                                    NULL,                   // characters to leave unescaped (NULL = all escaped sequences are replaced)
                                                                                    CFSTR("?=&+"),          // legal URL characters to be escaped (NULL = all legal characters are replaced)
                                                                                    kCFStringEncodingUTF8); // encoding
	return result;
}
-(NSString *) decodeURL
{
    NSString *result = (__bridge NSString*)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,
                                                                                                   (CFStringRef)self,
                                                                                                   CFSTR(""),
                                                                                                   kCFStringEncodingUTF8);
	
	return result;
}

-(NSString *)encodeURLParameter
{
    NSString *result = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                    (CFStringRef)self,
                                                                                    NULL,
                                                                                    CFSTR(":/=,!$&'()*+;[]@#?"),
                                                                                    kCFStringEncodingUTF8);
	return result;
}
@end
