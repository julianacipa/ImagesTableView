//
//  ImagesDownloadTests.m
//  ImagesDownloadTests
//
//  Created by Juliana Cipa on 02/11/2015.
//  Copyright © 2015 None. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "AppDelegate.h"
#import "ImageDetail.h"

@interface ImagesDownloadTests : XCTestCase

@property (nonatomic, strong)AppDelegate *appDelegate;

@end

@implementation ImagesDownloadTests

- (void)setUp {
    [super setUp];
    
    self.appDelegate = [[AppDelegate alloc] init];
}

- (void)tearDown {
    self.appDelegate = nil;
    
    [super tearDown];
}

-(void)testAddingImageDetailObject {
    NSManagedObjectContext *context = [self.appDelegate managedObjectContext];
    NSManagedObject *imageDetail = [NSEntityDescription
                                       insertNewObjectForEntityForName:@"ImageDetail"
                                       inManagedObjectContext:context];
    [imageDetail setValue:@1 forKey:@"imageDetailsId"];
    [imageDetail setValue:@300 forKey:@"imageId"];
    [imageDetail setValue:@10 forKey:@"userId"];
    [imageDetail setValue:@"Acton Town, Ealing" forKey:@"title"];
    [imageDetail setValue:@"Benjamin" forKey:@"userName"];
    NSError *error;
    BOOL imageDetailsAreSaved = [context save:&error];
    
    XCTAssertTrue(imageDetailsAreSaved);
    XCTAssertNil(error);
}

-(void)testAddingImageDetailObjectUsingModel {
    NSManagedObjectContext *context = [self.appDelegate managedObjectContext];
    ImageDetail *imageDetail = [NSEntityDescription
                                    insertNewObjectForEntityForName:@"ImageDetail"
                                    inManagedObjectContext:context];
    imageDetail.imageDetailsId = @2;
    imageDetail.imageId = @299;
    imageDetail.userId = @9;
    imageDetail.title = @"Aldgate, City of London";
    imageDetail.userName = @"Abigail";
    
    NSError *error;
    BOOL imageDetailsAreSaved = [context save:&error];
    
    XCTAssertTrue(imageDetailsAreSaved);
    XCTAssertNil(error);
}

@end
