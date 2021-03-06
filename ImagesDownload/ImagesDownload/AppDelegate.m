//
//  AppDelegate.m
//  ImagesDownload
//
//  Created by Juliana Cipa on 02/11/2015.
//  Copyright © 2015 None. All rights reserved.
//

#import "AppDelegate.h"
#import "FetchImageDetails.h"
#import "ImageDetail.h"
#import "ImageData.h"

static NSString *const NUMBER_OF_POSTS = @"numberOfPosts";
static NSString *const AVERAGE_IMAGE_SIZE = @"averageImageSize";
static NSString *const MAX_WIDTH = @"maxWidth";

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self clearImageDetails];
    [self fetchImageDetails];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(saveImagesSizeAndWidth:)
                                                 name:@"SaveImageData"
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(printStatistics)
                                                 name:@"PrintStatistics"
                                               object:nil];
    
    return YES;
}

-(void) clearImageDetails {
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"ImageDetail"];
    NSBatchDeleteRequest *delete = [[NSBatchDeleteRequest alloc] initWithFetchRequest:request];
    
    NSError *deleteError = nil;
    [self.persistentStoreCoordinator executeRequest:delete
                                        withContext:self.managedObjectContext
                                              error:&deleteError];
}

-(void)fetchImageDetails {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    [FetchImageDetails fetchImageDetailsWithHandler:^(NSArray *imageDetails, NSError *error) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        if (error || !imageDetails || imageDetails.count == 0) {
            //handle error here
        } else {
            [self saveImageDetails:imageDetails];
            [self displayImages];
        }
    }];
}

-(void)saveImageDetails:(NSArray *)imageDetailsArray {
    [imageDetailsArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        ImageDetail *imageDetail = [NSEntityDescription
                                          insertNewObjectForEntityForName:@"ImageDetail"
                                          inManagedObjectContext:self.managedObjectContext];
        imageDetail.imageDetailsId = [obj objectForKey:@"ID"];
        imageDetail.imageId = [obj objectForKey:@"ImageID"];
        imageDetail.title = [obj objectForKey:@"Title"];
        imageDetail.userId = [obj objectForKey:@"UserID"];
        imageDetail.userName = [obj objectForKey:@"UserName"];

        NSError *error;
        if (![self.managedObjectContext save:&error]) {
            NSLog(@"Handle error");
        }
    }];
}

-(void)displayImages {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ImageDetail"
                                              inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSError *error;
    NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DisplayImages"
                                                        object:fetchedObjects];
}

-(void)saveImagesSizeAndWidth:(NSNotification *)note {
    ImageData *imageData = note.object;
    
    NSFetchRequest *fetchImageDetails = [NSFetchRequest fetchRequestWithEntityName:@"ImageDetail"];
    fetchImageDetails.predicate = [NSPredicate predicateWithFormat:@"(imageDetailsId = %@)", imageData.imageDetailsId];
    fetchImageDetails.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"imageDetailsId" ascending:NO]];
    NSError *fetchError;
    NSArray *results = [self.managedObjectContext executeFetchRequest:fetchImageDetails error:&fetchError];
  
    if (results == nil) {
        NSLog(@"Error: %@", [fetchError localizedDescription]);
    } else if (fetchError){
        NSLog(@"Error - handle error");
    } else {
        ImageDetail *imageDetail = results[0];
        imageDetail.imageWidth = [NSNumber numberWithFloat:imageData.imageWidth];
        imageDetail.imageSize = [NSNumber numberWithFloat:imageData.imageSize];
        
        [self saveContext];
    }
}

-(void)printStatistics {
    NSEntityDescription* entity = [NSEntityDescription entityForName:@"ImageDetail"
                                              inManagedObjectContext:self.managedObjectContext];
    NSAttributeDescription* userIdDesc = [entity.attributesByName objectForKey:@"userId"];
    NSAttributeDescription* userNameDesc = [entity.attributesByName objectForKey:@"userName"];
    
    NSExpressionDescription *countExpressionDescription = [self expressionWithKeyPath:@"userName"
                                                                         withFunction:@"count:"
                                                               andWithDescriptionName:NUMBER_OF_POSTS
                                                                 andWithAttributetype:NSInteger16AttributeType];
    
    NSExpressionDescription *averageExpressionDescription = [self expressionWithKeyPath:@"imageSize"
                                                                           withFunction:@"average:"
                                                                 andWithDescriptionName:AVERAGE_IMAGE_SIZE
                                                                   andWithAttributetype:NSFloatAttributeType];
    
    NSExpressionDescription *maxWidthExpressionDescription = [self expressionWithKeyPath:@"imageWidth"
                                                                            withFunction:@"max:"
                                                                  andWithDescriptionName:MAX_WIDTH
                                                                    andWithAttributetype:NSInteger32AttributeType];
    
    NSFetchRequest *fetchGroupedImageDetails = [NSFetchRequest fetchRequestWithEntityName:@"ImageDetail"];
    [fetchGroupedImageDetails setPropertiesToFetch:[NSArray arrayWithObjects:userNameDesc, countExpressionDescription, averageExpressionDescription, maxWidthExpressionDescription, nil]];
    [fetchGroupedImageDetails setPropertiesToGroupBy:[NSArray arrayWithObject:userNameDesc]];
    [fetchGroupedImageDetails setResultType:NSDictionaryResultType];
    NSError* error = nil;
    NSArray *results = [self.managedObjectContext executeFetchRequest:fetchGroupedImageDetails
                                                                error:&error];
    
    [self logResults:results];
}

-(void)logResults:(NSArray *)results {
    NSLog(@"-----------------------------------------------------------------------------------");
    NSLog(@"User name   -   Number of posts   -   Average image size   -   Greatest Photo Width");
    NSLog(@"-----------------------------------------------------------------------------------");
    for (NSDictionary *imageDetail in results) {
        NSLog(@"%@          %@                 %@                   %@", imageDetail[@"userName"], imageDetail[NUMBER_OF_POSTS], imageDetail[AVERAGE_IMAGE_SIZE], imageDetail[MAX_WIDTH]);
    }
    NSLog(@"-----------------------------------------------------------------------------------");
}

-(NSExpressionDescription *)expressionWithKeyPath:(NSString *)keyPath
                                     withFunction:(NSString *)functionName
                           andWithDescriptionName:(NSString *)descriptionName
                             andWithAttributetype:(NSAttributeType)attributeType {
    NSExpression *keyPathExpression = [NSExpression expressionForKeyPath: keyPath];
    NSExpression *functionxpression = [NSExpression expressionForFunction: functionName
                                                                arguments: [NSArray arrayWithObject:keyPathExpression]];
    
    NSExpressionDescription *expressionDescription = [[NSExpressionDescription alloc] init];
    [expressionDescription setName: descriptionName];
    [expressionDescription setExpression: functionxpression];
    [expressionDescription setExpressionResultType: attributeType];
    
    return expressionDescription;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [[NSNotificationCenter defaultCenter] removeObserver:@"PrintStatistics"];
    [[NSNotificationCenter defaultCenter] removeObserver:@"SaveImageData"];
    [self saveContext];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.julianacipa.ImagesDownload" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"ImagesDownload" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"ImagesDownload.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
