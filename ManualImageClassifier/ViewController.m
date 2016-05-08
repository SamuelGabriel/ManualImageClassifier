//
//  ViewController.m
//  ManualImageClassifier
//
//  Created by Samuel Mueller on 08.05.16.
//  Copyright © 2016 MullerMuller. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[self.view window] becomeFirstResponder];
    // Do any additional setup after loading the view.
    self.backButton.enabled = NO;
   }
- (IBAction)badPressed:(NSButton *)sender {
    NSLog(@"bad");
    if ( [[NSFileManager defaultManager] isReadableFileAtPath:self.imArray[self.imageIndex]] ){
        NSError *error;
        [[NSFileManager defaultManager] copyItemAtPath:self.imArray[self.imageIndex] toPath:[self addSubfolder:@"Bad" toPath:self.imArray[self.imageIndex]] error:&error];
        if (!error) {
            [[NSFileManager defaultManager] removeItemAtPath:self.imArray[self.imageIndex] error:&error];
        }
    }
    [self setNewImage];
    
}
- (IBAction)GoodPressed:(id)sender {
    if ( [[NSFileManager defaultManager] isReadableFileAtPath:self.imArray[self.imageIndex]] ){
        NSError *error;
        [[NSFileManager defaultManager] copyItemAtPath:self.imArray[self.imageIndex] toPath:[self addSubfolder:@"Good" toPath:self.imArray[self.imageIndex]] error:&error];
        if (!error) {
            [[NSFileManager defaultManager] removeItemAtPath:self.imArray[self.imageIndex] error:&error];
        }
    }
    
    [self setNewImage];
}
- (IBAction)back:(NSButton *)sender {
    self.goodButton.enabled = YES;
    self.badButton.enabled = YES;
    self.imageIndex--;
    if(self.imageIndex == 0){
        self.backButton.enabled = NO;
    }
    if (self.imageIndex >= 0 && self.imageIndex < self.imArray.count) {
        [self.imageView setImage: [[NSImage alloc] initWithContentsOfFile:self.imArray[self.imageIndex]]];
        if ( [[NSFileManager defaultManager] isReadableFileAtPath:[self addSubfolder:@"Good" toPath:self.imArray[self.imageIndex]]]){
            NSLog(@"Good delete");
            [[NSFileManager defaultManager] moveItemAtPath:[self addSubfolder:@"Good" toPath:self.imArray[self.imageIndex]] toPath:self.imArray[self.imageIndex] error:nil];
            
        }else if ([[NSFileManager defaultManager] isReadableFileAtPath:[self addSubfolder:@"Bad" toPath:self.imArray[self.imageIndex]]]){
            NSLog(@"Bad delete");
            [[NSFileManager defaultManager] moveItemAtPath:[self addSubfolder:@"Bad" toPath:self.imArray[self.imageIndex]] toPath:self.imArray[self.imageIndex] error:nil];
    }
        [self.imageView setImage:[[NSImage alloc] initWithContentsOfFile:self.imArray[self.imageIndex]]];
    }
}

-(NSString *)addSubfolder:(NSString *)subfolder toPath:(NSString *)path{
    NSArray *pathcomponents = [path pathComponents];
    NSString *newPath = [NSString pathWithComponents:[pathcomponents subarrayWithRange:(NSRange){0,pathcomponents.count-1}]];
    newPath = [newPath stringByAppendingString:[NSString stringWithFormat:@"/%@",subfolder]];
    newPath = [newPath stringByAppendingString:@"/"];
    newPath = [newPath stringByAppendingString:[path lastPathComponent]];
    NSLog(newPath);
    return newPath;

}
-(void)setNewImage{
    self.backButton.enabled = YES;
    self.imageIndex++;
    if (self.imageIndex < self.imArray.count) {
        [self.imageView setImage: [[NSImage alloc] initWithContentsOfFile:self.imArray[self.imageIndex]]] ;
    }else if(self.imageIndex==self.imArray.count){
        self.goodButton.enabled = NO;
        self.badButton.enabled = NO;
    }
}

-(void)viewDidAppear{
    [super viewDidAppear];
    NSArray* dirs = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[@"~/Developer/TestImages" stringByStandardizingPath]error:nil];
    self.imArray = [[NSMutableArray alloc] init];
    self.imageIndex = 0;
    [dirs enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *filename = (NSString *)obj;
        NSString *extension = [[filename pathExtension] lowercaseString];
        if ([extension isEqualToString:@"png"] || [extension isEqualToString:@"jpeg"] || [extension isEqualToString:@"jpg"]) {
            [self.imArray addObject:[[@"~/Developer/TestImages" stringByStandardizingPath] stringByAppendingPathComponent:filename]];
        }
    }];
    for (NSString *inFilePath in self.imArray) {
        NSImage *testImage = [[NSImage alloc] initWithContentsOfFile:inFilePath];
#if !__has_feature(objc_arc)
        [testImage autorelease];
#endif
        [self.imageView setImage:testImage];
        break;
    }

}
- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

@end
