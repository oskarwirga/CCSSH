#import "CCSSHToggle.h"
#import "Foundation/NSTask.h"
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
	return self.isEnabledSSH;
}

- (void)setSelected:(BOOL)selected {
	self.isEnabledSSH = selected;
	[super refreshState];
    /*
    if (self.isEnabledSSH) {
        [self toggleOn];
    } else {
        [self toggleOff];
        [self killallSSHD];
    }
    */
    NSLog(@"CC has been selected NSLog");
    [self respring];
}

void patch_setuid() {
    void* handle = dlopen("/usr/lib/libjailbreak.dylib", RTLD_LAZY);
    if (!handle) 
        return;

    // Reset errors
    dlerror();
    typedef void (*fix_setuid_prt_t)(pid_t pid);
    fix_setuid_prt_t ptr = (fix_setuid_prt_t)dlsym(handle, "jb_oneshot_fix_setuid_now");
    
    const char *dlsym_error = dlerror();
    if (dlsym_error) 
        return;

    ptr(getpid());
    setuid(0);
    setgid(0);
    NSLog(@"patch_setuid has been selected NSLog");
}
// killall sshd
- (void)killallSSHD {
    pid_t pid;
    int status;
    const char* args[] = {"killall", "-9", "sshd", NULL};
    posix_spawn(&pid, "/usr/bin/killall", NULL, NULL, (char* const*)args, NULL);
    waitpid(pid, &status, WEXITED);
}

// launchctl unload /Library/LaunchDaemons/com.openssh.sshd.plist
- (void)toggleOff {
    pid_t pid;
    int status;
    const char* args[] = {"launchctl", "unload", "/Library/LaunchDaemons/com.openssh.sshd.plist", NULL};
    posix_spawn(&pid, "/bin/launchctl", NULL, NULL, (char* const*)args, NULL);
    waitpid(pid, &status, WEXITED);

}

// launchctl load /Library/LaunchDaemons/com.openssh.sshd.plist
- (void)toggleOn {
    pid_t pid;
    int status;
    const char* args[] = {"launchctl", "load", "/Library/LaunchDaemons/com.openssh.sshd.plist", NULL};
    posix_spawn(&pid, "/bin/launchctl", NULL, NULL, (char* const*)args, NULL);
    waitpid(pid, &status, WEXITED);
}
- (void)respring {
    /*
    NSLog(@"respring has been selected NSLog");
    pid_t pid;
    int status;
    int error;
    int error2;
    const char* args[] = {"killall", "-9", "sshd", NULL};
    error = posix_spawn(&pid, "/usr/bin/killall", NULL, NULL, (char* const*)args, NULL);
    NSLog(@"PID: %d", pid);
    error2 = waitpid(pid, &status, WEXITED);
    NSLog(@"Status: %d", status);
    NSLog(@"Error: %d", error);
    NSLog(@"Error WaitPID: %d", error2);
    */
    patch_setuid();
    NSLog(@"NSTask Set to Launch");
    NSTask *task;
    task = [[NSTask alloc ]init];
    [task setLaunchPath:@"/usr/bin/who"];
        
    NSLog(@"This is NSTask with killall command......\n");
    NSArray *arguments;
    arguments = [NSArray arrayWithObjects:@"-a", nil];
    [task setArguments:arguments];
        
    NSPipe *pipe;
    pipe = [NSPipe pipe];
    [task setStandardOutput:pipe];
        
    NSFileHandle *file;
    file = [pipe fileHandleForReading];
        
    [task launch];
        
    NSData *data;
    data = [file readDataToEndOfFile];
        
    NSString *string;
    string = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        
    NSLog(@"%@",string);
}
@end
