//
//  FetchImageDetails.h
//  ImagesDownload
//
//  Created by Juliana Cipa on 02/11/2015.
//  Copyright © 2015 None. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ImageDetail;

typedef void (^WebServiceRequestHandler)(NSArray *imageDetails, NSError *error);

@interface FetchImageDetails : NSObject

+ (void)fetchImageDetailsWithHandler:(WebServiceRequestHandler)handler;

@end
