//
//  ViewController.m
//  CollectionViewJSONTrial
//
//  Created by Soubhi Alhayek on 10/8/14.
//  Copyright (c) 2014 Daniwah Labs. All rights reserved.
//

#import "ViewController.h"
#import "Movie.h"
#import "CollectionViewCell.h"
#import "MovieDetailViewController.h"
#import <UIImageView+WebCache.h>
#import <AFNetworking/AFNetworking.h>


@interface ViewController () <UIViewControllerTransitioningDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@end

@implementation ViewController {
	NSInteger *selectedIndex;
	CollectionViewCell *cellForDestinationViewController;
}

-(void)viewDidLoad {
	
	[super viewDidLoad];
	
	self.title = @"Currently";
	
	self.collectionView.backgroundColor = [UIColor whiteColor];
	[self refresh];
	
}

- (void)refresh {
	
	// Create an AF HTTP REQUEST OPERATION MANAGER object to handle JSON data from trakt
	AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
	
	// Make GET request to URL data source. success: runs block for parsing JSON Data into NSDictionary object
	[manager GET:@"http://api.trakt.tv/movies/trending.json/35176d6331d2e2189eba09ad8896e0dd"
	  parameters:nil success:
	 ^(AFHTTPRequestOperation *operation, id responseObject) {
		 
		 //NSLog to to Display JSON Data
		 NSLog(@"JSON: %@", responseObject);
		 
		 NSArray *array = responseObject;
		 NSMutableArray *movies = [NSMutableArray array];
		 
		 for (NSDictionary *dictionary in array) {
			 Movie *movie = [[Movie alloc] initWithDict:dictionary];
			 
			 [movies addObject:movie];
		 }
		 self.movies = [movies copy];
		 dispatch_async(dispatch_get_main_queue(), ^{
			 [self.collectionView reloadData];
			 
		 });
		 
	 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		 NSLog(@"Error: %@", error);
	 }];
	
	//            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"Please check your internet connection!" preferredStyle:UIAlertControllerStyleAlert];
	//            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
	//            [alertController addAction:okAction];
	//            [self presentViewController:alertController animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
	return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	return [self.movies count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	
	CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
	
	Movie *movie = _movies[indexPath.row];
	dispatch_async(dispatch_get_main_queue(), ^{
		
		[cell.imageView sd_setImageWithURL:[NSURL URLWithString:movie.poster]];
		
	});
	
	cell.backgroundColor = [UIColor lightGrayColor];
	
	return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	
	if ([sender isKindOfClass:[CollectionViewCell class]]) {
		
		if ([segue.identifier isEqualToString:@"movieDetailViewSegue"]) {
			
			Movie *segueMovie = self.movies [[self.collectionView indexPathForCell:sender].row];
			//FIXME:
			[[segue destinationViewController] setMovie:segueMovie];
		}
	}
}
/*
 
 
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	
	if ([segue.identifier isEqualToString:@"movieDetailViewSegue"]) {
 
 if ([sender isKindOfClass:[CollectionViewCell class]]) {
 Movie *segueMovie = self.movies [[self.collectionView indexPathForCell:sender].row];
 //FIXME:
 [[segue destinationViewController] setMovie:segueMovie];
 }
 
 // Do something else here like another check if another type can do something to the movieDetailViewSegue
	}
 }
*/

@end
