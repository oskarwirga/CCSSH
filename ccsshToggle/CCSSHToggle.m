#import "CCSSHToggle.h"
#import "NSTask.h"
#include <dlfcn.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <unistd.h>
// Image to be displayed on the toggle
@interface UIImage ()
+ (UIImage *)imageNamed:(NSString *)name inBundle:(NSBundle *)bundle;
@end

@implementation CCSSHToggle
// This is an init function which will set the state of the toggle on start
-(id)init {
    // Set init class to self
    self = [super init];
    // Set up an NSTask
    NSTask *task;
    // Allocate an NSTask object
    task = [[NSTask alloc ]init];
    // Set launch path
    [task setLaunchPath:@"/bin/bash"];
    // Search for SSH within launchctl's list of processes 
    NSArray *args = [NSArray arrayWithObjects:@"-l",
                 @"-c",
                 @"launchctl list | grep ssh",
                 nil];
    [task setArguments: args];
    // Create a pipe for this task to read from
    NSPipe *pipe;
    pipe = [NSPipe pipe];
    [task setStandardOutput:pipe];
    NSFileHandle *file;
    file = [pipe fileHandleForReading];
    // Exec
    [task launch];
    // Read data into a file from a pipe into data into a string
    NSData *data;
    data = [file readDataToEndOfFile];
    NSString *stringOld;
    stringOld = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    // Look for SSHD and set the toggle on or off depending on the state of sshd
    NSString *processName = @"com.openssh.sshd";
    if ([stringOld containsString:processName]) {
        self.isEnabledSSH = YES;
    } else {
        self.isEnabledSSH = NO;
    }
    return self;
}

- (UIImage *)iconGlyph {
	return [UIImage imageNamed:@"Icon" inBundle:[NSBundle bundleForClass:[self class]]];
}

- (UIColor *)selectedColor {
	return [UIColor blueColor];
}

- (BOOL)isSelected {
    NSTask *task;
    task = [[NSTask alloc ]init];
    [task setLaunchPath:@"/bin/bash"];
    NSArray *args = [NSArray arrayWithObjects:@"-l",
                 @"-c",
                 @"launchctl list | grep ssh",
                 nil];
    [task setArguments: args];
    NSPipe *pipe;
    pipe = [NSPipe pipe];
    [task setStandardOutput:pipe];
    NSFileHandle *file;
    file = [pipe fileHandleForReading];
    [task launch];
    NSData *data;
    data = [file readDataToEndOfFile];
    NSString *stringOld;
    stringOld = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];

    NSString *processName = @"com.openssh.sshd";
    if ([stringOld containsString:processName]) {
        self.isEnabledSSH = YES;
    } else {
        self.isEnabledSSH = NO;
    }
    return self.isEnabledSSH;
}

- (void)setSelected:(BOOL)selected {
	self.isEnabledSSH = selected;
    [super refreshState];
    // If the toggle is tapped, open up the sshadmin app
    UIApplication *application = [UIApplication sharedApplication];
    NSURL *URL = [NSURL URLWithString:@"sshadmin://"];
    if ([application respondsToSelector:@selector(openURL:options:completionHandler:)]){
        [application openURL:URL options:@{}
        completionHandler:^(BOOL success) {
        }];
    }else{
    }
}
@end
