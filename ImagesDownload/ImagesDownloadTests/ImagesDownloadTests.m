//
//  ImagesDownloadTests.m
//  ImagesDownloadTests
//
//  Created by Juliana Cipa on 02/11/2015.
//  Copyright © 2015 None. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "AppDelegate.h"

@interface ImagesDownloadTests : XCTestCase

@end

@implementation ImagesDownloadTests

- (void)setUp {
    [super setUp];
    
    
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

-(void)testAddingImageDetailObject {
    AppDelegate *appDelegate = [[AppDelegate alloc] init];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
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

@end
