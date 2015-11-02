//
//  ImageDetail+CoreDataProperties.h
//  ImagesDownload
//
//  Created by Juliana Cipa on 02/11/2015.
//  Copyright © 2015 None. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "ImageDetail.h"

NS_ASSUME_NONNULL_BEGIN

@interface ImageDetail (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *imageId;
@property (nullable, nonatomic, retain) NSNumber *imageDetailsId;
@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSNumber *userId;
@property (nullable, nonatomic, retain) NSString *userName;

@end

NS_ASSUME_NONNULL_END
