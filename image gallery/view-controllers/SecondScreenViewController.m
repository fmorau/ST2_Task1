//
//  SecondScreenViewController.m
//  image gallery
//
//  Created by Фёдор Морев on 6/1/19.
//  Copyright © 2019 Фёдор Морев. All rights reserved.
//

#import "SecondScreenViewController.h"

@interface SecondScreenViewController ()
@property(nonatomic, strong) NSURL *imageUrl;
@property(nonatomic, strong) UIActivityIndicatorView *loader;
@property(nonatomic, assign) int imageHeight;
@property(nonatomic, assign) int imagesAmount;
@end

@implementation SecondScreenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _imageHeight = 100;
    _imagesAmount = 30;
    self.title = @"Select Item";
    
    UIBarButtonItem *barButtonClose = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(handleClosePress:)];
    barButtonClose.tintColor = [UIColor redColor];
    self.navigationItem.rightBarButtonItem = barButtonClose;
    
    self.navigationItem.hidesBackButton = YES;
}

- (void)viewDidAppear:(BOOL)animated {
//    UILoader *loader = [[UILoader alloc] initWithHandlerBlock:^void () {
//        [self generateImages];
//        [self.loader stopAnimating];
//    }];
//    loader.color = [UIColor grayColor];
//    loader.center = self.view.center;
//    _loader = loader;
//    [loader startAnimating];
//
//    [self.view addSubview:loader];
    
    CGSize controllerSize = self.view.frame.size;
    CGSize navBarSize = self.navigationController.navigationBar.frame.size;
    
    NSString *urlStr = [NSString stringWithFormat:@"https://picsum.photos/%i/%i", (int)controllerSize.width, _imageHeight];
    _imageUrl = [NSURL URLWithString:urlStr];
    
    self.mainScrollView.contentSize = CGSizeMake(
                                                 controllerSize.width,
                                                 (_imagesAmount * _imageHeight) + navBarSize.height
                                                );
    self.mainScrollView.userInteractionEnabled = YES;
    
    [self generateImages];
}

- (void)viewDidLayoutSubviews {
    
}

-(void)generateImages {
    for (int index = 0; index < _imagesAmount; index++) {
        UIView *view = [self generateImageViewForIndex:index];
        [self.mainScrollView addSubview:view];
    }
}

- (UIView *)generateImageViewForIndex:(int)index {
    NSData *imageData = [NSData dataWithContentsOfURL:_imageUrl];
    UIImage *image = [[UIImage alloc] initWithData:imageData];
    UIImageView *imageView = [[UIImageView alloc]
                              initWithFrame:CGRectMake(0, index * image.size.height, image.size.width, image.size.height)];
    imageView.image = image;
    
    UILabel *label = [UILabel new];
    label.text = [_imageUrl absoluteString];
    [label sizeToFit];
    label.frame = CGRectMake(
                             (image.size.width / 2) - (label.frame.size.width / 2),
                             (image.size.height / 2) - (label.frame.size.height / 2),
                             label.frame.size.width,
                             label.frame.size.height
                             );
    label.textColor = [self randomColor];
    
    [imageView addSubview:label];
    
    return imageView;
}

- (UIColor *)randomColor {
    return [UIColor colorWithHue:drand48() saturation:1.0 brightness:1.0 alpha:1.0];
}

- (void)handleClosePress:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
