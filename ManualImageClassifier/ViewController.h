//
//  ViewController.h
//  ManualImageClassifier
//
//  Created by Samuel Mueller on 08.05.16.
//  Copyright © 2016 MullerMuller. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ViewController : NSViewController
@property (weak) IBOutlet NSButton *backButton;
@property (weak) IBOutlet NSButton *goodButton;
@property (weak) IBOutlet NSButton *badButton;

@property (weak) IBOutlet NSImageView *imageView;
@property (nonatomic) int imageIndex;
@property (nonatomic, strong) NSMutableArray *imArray;
@end

