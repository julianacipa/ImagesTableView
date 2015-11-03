//
//  ImageTableViewCell.h
//  ImagesDownload
//
//  Created by Juliana Cipa on 03/11/2015.
//  Copyright © 2015 None. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ImageDetail;

@interface ImageTableViewCell : UITableViewCell

-(void)configureWithImageDetail:(ImageDetail *)imageDetail;

@end
