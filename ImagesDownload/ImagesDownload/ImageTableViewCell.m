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

static NSString *const GET_PHOTO_URL = @"http://challenge.superfling.com/photos/";

@interface ImageTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *displayImageView;
@property (weak, nonatomic) IBOutlet UILabel *imageTitleLabel;

@end

@implementation ImageTableViewCell

-(void)configureWithImageDetail:(ImageDetail *)imageDetail {
    self.imageTitleLabel.text = imageDetail.title;
    
    NSString *getPhotoUrlString = [NSString stringWithFormat:@"%@%@", GET_PHOTO_URL, imageDetail.imageId];
    NSURL *getPhotoURL = [NSURL URLWithString:getPhotoUrlString];
    [self.displayImageView sd_setImageWithURL:getPhotoURL
                             placeholderImage:[UIImage imageNamed:@"download"]];
}

@end
