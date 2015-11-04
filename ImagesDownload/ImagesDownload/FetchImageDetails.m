//
//  FetchImageDetails.m
//  ImagesDownload
//
//  Created by Juliana Cipa on 02/11/2015.
//  Copyright © 2015 None. All rights reserved.
//

#import "FetchImageDetails.h"

NSString *const GET_IMAGE_DETAILS_URL = @"http://challenge.superfling.com";

@implementation FetchImageDetails

+ (void)fetchImageDetailsWithHandler:(WebServiceRequestHandler)handler {
    NSURL *url = [NSURL URLWithString: GET_IMAGE_DETAILS_URL];
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    [[session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            if (handler) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    handler(nil, error);
                });
            }
            return;
        }
        
        NSHTTPURLResponse *httpResp = (NSHTTPURLResponse*) response;
        if (httpResp.statusCode == 200) {
            NSError *deserializationError = nil;
            id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&deserializationError];
            
            if (deserializationError) {
                if (handler) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        handler(nil, deserializationError);
                    });
                }
                return;
            }
            
            NSArray *responseArray = (NSArray *) jsonObject;
            
            if (handler) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    handler(responseArray, nil);
                });
            }
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                handler(nil, [NSError errorWithDomain:@"domain" code:httpResp.statusCode userInfo:nil]);
            });
        }
        
    }] resume];
}

@end
