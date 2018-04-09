#import "CCSSHToggle.h"
#import "NSTask.h"
#include <spawn.h>
#include <dlfcn.h>

@interface UIImage ()
+ (UIImage *)imageNamed:(NSString *)name inBundle:(NSBundle *)bundle;
@end

@implementation CCSSHToggle
- (UIImage *)iconGlyph {
	return [UIImage imageNamed:@"Icon" inBundle:[NSBundle bundleForClass:[self class]]];
}

- (UIColor *)selectedColor {
	return [UIColor blueColor];
}

- (BOOL)isSelected {
    /*
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
        return YES;
    } else {
        NSLog(@"string does not contain bla");
        return NO;
    }
    */
    return self.isEnabledSSH;
}

- (void)setSelected:(BOOL)selected {
	self.isEnabledSSH = selected;
	[super refreshState];
    if (self.isEnabledSSH){
        CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), CFSTR("com.oskarw.sshadmin/enablessh"), NULL, NULL, YES);
    }else{
        CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), CFSTR("com.oskarw.sshadmin/disablessh"), NULL, NULL, YES);
    }
}
@end
