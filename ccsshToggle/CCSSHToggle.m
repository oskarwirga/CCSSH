#import "CCSSHToggle.h"
#import "NSTask.h"
#include <dlfcn.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <unistd.h>

@interface UIImage ()
+ (UIImage *)imageNamed:(NSString *)name inBundle:(NSBundle *)bundle;
@end

@implementation CCSSHToggle

-(id)init {
    self = [super init];
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
