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
- (void)runPythonScript
{
    NSTask* task = [[NSTask alloc] init] ;
    task.launchPath = [@"~/Developer/TestImages" stringByStandardizingPath];
    NSString *scriptPath = [[NSBundle mainBundle] pathForResource:@"MyScript" ofType:@"py"];
    task.arguments = [NSArray arrayWithObjects: scriptPath, nil];
    
    // NSLog breaks if we don't do this...
    [task setStandardInput: [NSPipe pipe]];
    
    NSPipe *stdOutPipe = nil;
    stdOutPipe = [NSPipe pipe];
    [task setStandardOutput:stdOutPipe];
    
    NSPipe* stdErrPipe = nil;
    stdErrPipe = [NSPipe pipe];
    [task setStandardError: stdErrPipe];
    
    [task launch];
    
    //NSData* data = [[stdOutPipe fileHandleForReading] readDataToEndOfFile];
    
    [task waitUntilExit];
    
    //NSInteger exitCode = task.terminationStatus;
    
    
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
    if (![[NSFileManager defaultManager] fileExistsAtPath:[@"~/Developer/TestImages/Bad" stringByStandardizingPath] isDirectory:nil]) {
    [[NSFileManager defaultManager] createDirectoryAtPath:[@"~/Developer/TestImages/Bad" stringByStandardizingPath] withIntermediateDirectories:YES attributes:nil error:nil];
    [[NSFileManager defaultManager] createDirectoryAtPath:[@"~/Developer/TestImages/Good" stringByStandardizingPath] withIntermediateDirectories:YES attributes:nil error:nil];
    }
    //[self runPythonScript];
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
