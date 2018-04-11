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
    NSLog(@"In the init CCSSHToggle method");
    self = [super init];
    NSTask *task;
    task = [[NSTask alloc ]init];
    [task setLaunchPath:@"/bin/bash"];
    NSLog(@"NSTask Set to Launch");
    NSLog(@"This is NSTask with who command......\n");
    NSArray *args = [NSArray arrayWithObjects:@"-l",
                 @"-c",
                 @"launchctl list | grep ssh",
                 nil];
    [task setArguments: args];
    NSLog(@"NSTask who command set to exec");
    NSPipe *pipe;
    pipe = [NSPipe pipe];
    [task setStandardOutput:pipe];
    NSFileHandle *file;
    file = [pipe fileHandleForReading];
    NSLog(@"NSTask who command exec-ing");
    [task launch];
    NSData *data;
    data = [file readDataToEndOfFile];
    NSString *stringOld;
    stringOld = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"%@",stringOld);

    NSString *processName = @"com.openssh.sshd";
    if ([stringOld containsString:processName]) {
        NSLog(@"string contains bla!");
        self.isEnabledSSH = YES;
    } else {
        NSLog(@"string does not contain bla");
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
    /*
    */
    NSTask *task;
    task = [[NSTask alloc ]init];
    [task setLaunchPath:@"/bin/bash"];
    NSLog(@"NSTask Set to Launch");
    NSLog(@"This is NSTask with who command......\n");
    NSArray *args = [NSArray arrayWithObjects:@"-l",
                 @"-c",
                 @"launchctl list | grep ssh",
                 nil];
    [task setArguments: args];
    NSLog(@"NSTask who command set to exec");
    NSPipe *pipe;
    pipe = [NSPipe pipe];
    [task setStandardOutput:pipe];
    NSFileHandle *file;
    file = [pipe fileHandleForReading];
    NSLog(@"NSTask who command exec-ing");
    [task launch];
    NSData *data;
    data = [file readDataToEndOfFile];
    NSString *stringOld;
    stringOld = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"%@",stringOld);

    NSString *processName = @"com.openssh.sshd";
    if ([stringOld containsString:processName]) {
        NSLog(@"string contains bla!");
        self.isEnabledSSH = YES;
    } else {
        NSLog(@"string does not contain bla");
        self.isEnabledSSH = NO;
    }
    return self.isEnabledSSH;
}

- (void)setSelected:(BOOL)selected {
	self.isEnabledSSH = selected;
    [super refreshState];

    NSLog(@"Tapped CC Icon");
    NSURL *customURL = [NSURL URLWithString:@"sshadmin://"];
    UIApplication *application = [UIApplication sharedApplication];
    NSURL *URL = [NSURL URLWithString:@"sshadmin://"];
    if ([application respondsToSelector:@selector(openURL:options:completionHandler:)]){
        [application openURL:URL options:@{}
        completionHandler:^(BOOL success) {
        NSLog(@"Open %@: %d",customURL,success);
        }];
    }else{
        NSLog(@"Failed to Open %@",customURL);
    }
}
@end
