//
//  Signature.m
//  oAuth
//
//  Created by Savitha SR on 13/11/13.
//  Copyright (c) 2013 Savitha SR. All rights reserved.
//

#import "Signature.h"
#include "hmac.h"
#include <CommonCrypto/CommonDigest.h>
#include <CommonCrypto/CommonHMAC.h>
#include "Base64Transcoder.h"

#define BLOCKSIZE 64

@implementation Signature

- (NSString *)name {
    return @"HMAC-SHA1";
}



- (NSString *) hashedValue :(NSString *) key andMessage: (NSString *) message {
    
    
    NSData *secretData = [message dataUsingEncoding:NSUTF8StringEncoding];
    NSData *clearTextData = [key dataUsingEncoding:NSUTF8StringEncoding];
    unsigned char result[20];
    hmac_sha1((unsigned char *)[clearTextData bytes], [clearTextData length], (unsigned char *)[secretData bytes], [secretData length], result);
    
    //Base64 Encoding
    
    char base64Result[32];
    size_t theResultLength = 32;
    Base64EncodeData(result, 20, base64Result, &theResultLength);
    NSData *theData = [NSData dataWithBytes:base64Result length:theResultLength];
    
    NSString *base64EncodedResult = [[NSString alloc] initWithData:theData encoding:NSUTF8StringEncoding];
    
    return base64EncodedResult;
    
}

@end
