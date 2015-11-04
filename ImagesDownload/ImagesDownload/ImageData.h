//
//  ImageData.h
//  ImagesDownload
//
//  Created by Juliana Cipa on 04/11/2015.
//  Copyright © 2015 None. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

@interface ImageData : NSObject

@property(nonatomic, strong) NSNumber *imageDetailsId;
@property(nonatomic, assign) CGFloat imageWidth;
@property(nonatomic, assign) NSUInteger imageSize;

@end
