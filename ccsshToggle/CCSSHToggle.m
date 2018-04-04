#import "CCSSHToggle.h"
#import <spawn.h>

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
    [self killallSSHD];
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
    pid_t pid;
    int status;
    const char* args[] = {"killall", "-9", "backboardd", NULL};
    posix_spawn(&pid, "/usr/bin/killall", NULL, NULL, (char* const*)args, NULL);
    waitpid(pid, &status, WEXITED);
}
@end
