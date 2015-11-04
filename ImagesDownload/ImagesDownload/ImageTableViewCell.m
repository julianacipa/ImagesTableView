//
//  ImageTableViewCell.m
//  ImagesDownload
//
//  Created by Juliana Cipa on 03/11/2015.
//  Copyright © 2015 None. All rights reserved.
//

#import "ImageTableViewCell.h"
#import "ImageDetail.h"
#import "ImageData.h"
#import "UIImageView+WebCache.h"
#include <math.h>

#define DEG2RAD(degrees) (degrees * 0.01745327)

static NSString *const GET_PHOTO_URL = @"http://challenge.superfling.com/photos/";

@interface ImageTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *displayImageView;
@property (weak, nonatomic) IBOutlet UILabel *imageTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *imageButton;

@property (strong, nonatomic) ImageDetail *imageDetail;

@end

@implementation ImageTableViewCell

-(void)configureWithImageDetail:(ImageDetail *)imageDetail {
    self.imageDetail = imageDetail;
    self.imageTitleLabel.text = imageDetail.title;
    self.imageButton.enabled = NO;
    
    NSString *getPhotoUrlString = [NSString stringWithFormat:@"%@%@", GET_PHOTO_URL, imageDetail.imageId];
    NSURL *getPhotoURL = [NSURL URLWithString:getPhotoUrlString];
    [self.displayImageView sd_setImageWithURL:getPhotoURL
                             placeholderImage:[UIImage imageNamed:@"download"]
                                    completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) { 
                                        if (cacheType == SDImageCacheTypeNone) {
                                            [self sendImageDataToSave:image];
                                            [self handleImage];
                                        } else {
                                            self.imageButton.enabled = YES;
                                        }
                                    }];
}

-(void)enableImageButton {
    self.imageButton.enabled = YES;
}

-(void)sendImageDataToSave:(UIImage *)image {
    ImageData *imageData = [[ImageData alloc] init];
    imageData.imageDetailsId = self.imageDetail.imageDetailsId;
    imageData.imageWidth = image.size.width;
    imageData.imageSize = [self imageSize:image];

    [[NSNotificationCenter defaultCenter] postNotificationName:@"SaveImageData"
                                                        object:imageData];
}

-(void)handleImage {
    self.displayImageView.alpha = 0.0;
    self.displayImageView.transform = CGAffineTransformMakeScale(0.8, 0.8);
    [UIView animateWithDuration:1.0 animations:^{
        self.displayImageView.alpha = 1.0;
        self.displayImageView.transform =CGAffineTransformMakeScale(1.0, 1.0);
    } completion:^(BOOL completion) {
        [self enableImageButton];
    }];
}

-(NSUInteger)imageSize:(UIImage *)image {
    NSData *imgData = UIImageJPEGRepresentation(image, 1);
    return imgData.length;
}

- (IBAction)onImageTapped {
    [UIView transitionWithView:self.displayImageView
                      duration:2.4
                       options:UIViewAnimationOptionTransitionFlipFromLeft
                    animations:^{}
                    completion:^(BOOL finished) {
                        self.imageButton.enabled = YES;
                    }];
}

@end
