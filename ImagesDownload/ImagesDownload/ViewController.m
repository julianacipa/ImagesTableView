//
//  ViewController.m
//  ImagesDownload
//
//  Created by Juliana Cipa on 02/11/2015.
//  Copyright © 2015 None. All rights reserved.
//

#import "ViewController.h"
#import "ImageDetail.h"
#import "ImageTableViewCell.h"

static NSString *const DISPLAY_IMAGES_NOTIFICATION = @"DisplayImages";
static NSString *const kCellImage = @"imageCell";

@interface ViewController ()

@property(nonatomic, strong)NSArray *imageDetails;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(displayImages:)
                                                 name:DISPLAY_IMAGES_NOTIFICATION
                                               object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:DISPLAY_IMAGES_NOTIFICATION
                                                  object:nil];
}

-(void)displayImages:(NSNotification *)note {
    self.imageDetails = note.object;
    [self.tableView reloadData];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if(self.tableView.contentOffset.y >= (self.tableView.contentSize.height - self.tableView.bounds.size.height)) {
        if (self.imageDetails && self.imageDetails.count > 0) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"PrintStatistics" object:nil];
            [[NSNotificationCenter defaultCenter] removeObserver:@"PrintStatistics"];
        }
    }
}

#pragma mark - UITableViewDataSource methods

- (NSInteger)tableView:(UITableView * __unused)tableView numberOfRowsInSection:(NSInteger)section {
    return self.imageDetails.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger row = (NSUInteger)indexPath.row;
    ImageTableViewCell *cell = (ImageTableViewCell *)[tableView dequeueReusableCellWithIdentifier:kCellImage
                                                                               forIndexPath:indexPath];
    ImageDetail *imageDetail = self.imageDetails[row];
    [cell configureWithImageDetail:imageDetail];
    return cell;
}

@end
