//
//  ImageTableViewCell.m
//  ImagesDownload
//
//  Created by Juliana Cipa on 03/11/2015.
//  Copyright © 2015 None. All rights reserved.
//

#import "ImageTableViewCell.h"
#import "ImageDetail.h"

@interface ImageTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *displayImageView;
@property (weak, nonatomic) IBOutlet UILabel *imageTitleLabel;

@end

@implementation ImageTableViewCell

-(void)configureWithImageDetail:(ImageDetail *)imageDetail {
    self.imageTitleLabel.text = imageDetail.title;
}

@end
