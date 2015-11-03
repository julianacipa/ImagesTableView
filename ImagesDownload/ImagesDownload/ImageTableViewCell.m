//
//  ImageTableViewCell.m
//  ImagesDownload
//
//  Created by Juliana Cipa on 03/11/2015.
//  Copyright © 2015 None. All rights reserved.
//

#import "ImageTableViewCell.h"
#import "ImageDetail.h"
#import "UIImageView+WebCache.h"
#include <math.h>

#define DEG2RAD(degrees) (degrees * 0.01745327)

static NSString *const GET_PHOTO_URL = @"http://challenge.superfling.com/photos/";

@interface ImageTableViewCell ()

@property (strong, nonatomic) ImageDetail *imageDetail;

@property (weak, nonatomic) IBOutlet UIImageView *displayImageView;
@property (weak, nonatomic) IBOutlet UILabel *imageTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *imageButton;

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
                                            self.displayImageView.alpha = 0.0;
                                            self.displayImageView.transform =CGAffineTransformMakeScale(0.8, 0.8);
                                            [UIView animateWithDuration:1.0 animations:^{
                                                self.displayImageView.alpha = 1.0;
                                                self.displayImageView.transform =CGAffineTransformMakeScale(1.0, 1.0);
                                            } completion:^(BOOL completion) {
                                                self.imageButton.enabled = YES;
                                            }];
                                        } else {
                                            self.imageButton.enabled = YES;
                                        }
                                    }];
}

- (IBAction)onImageTapped {
    NSAssert(self.imageDetail, @"Image details should not be nil");
    [UIView transitionWithView:self.displayImageView
                      duration:2.4
                       options:UIViewAnimationOptionTransitionFlipFromLeft
                    animations:^{}
                    completion:^(BOOL finished) {
                        self.imageButton.enabled = YES;
                    }];
}

@end
