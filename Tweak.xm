/* How to Hook with Logos
Hooks are written with syntax similar to that of an Objective-C @implementation.
You don't need to #include <substrate.h>, it will be done automatically, as will
the generation of a class list and an automatic constructor.

%hook ClassName

// Hooking a class method
+ (id)sharedInstance {
	return %orig;
}

// Hooking an instance method with an argument.
- (void)messageName:(int)argument {
	%log; // Write a message about this call, including its class, name and arguments, to the system log.

	%orig; // Call through to the original function with its original arguments.
	%orig(nil); // Call through to the original function with a custom argument.

	// If you use %orig(), you MUST supply all arguments (except for self and _cmd, the automatically generated ones.)
}

// Hooking an instance method with no arguments.
- (id)noArguments {
	%log;
	id awesome = %orig;
	[awesome doSomethingElse];

	return awesome;
}

// Always make sure you clean up after yourself; Not doing so could have grave consequences!
%end
#import <UIKit/UIKit.h>
#import <spawn.h>


void viewsshconnections() {
    UIWindow* topWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    topWindow.rootViewController = [UIViewController new];
    topWindow.windowLevel = UIWindowLevelAlert + 1;

    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"SSH Connections" 
                                message:@"root@127.0.0.1\noskar@127.0.0.2" 
                                preferredStyle:UIAlertControllerStyleAlert];

    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"OK",@"confirm") 
                      style:UIAlertActionStyleCancel 
                      handler:^(UIAlertAction * _Nonnull action) {
    // continue your work
    // important to hide the window after work completed.
    // this also keeps a reference to the window until the action is invoked.
    topWindow.hidden = YES;
    }]];

    [topWindow makeKeyAndVisible];
    [topWindow.rootViewController presentViewController:alert animated:YES completion:nil];
    
}

%ctor {
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)viewsshconnections, CFSTR("com.oskarw.ccssh/viewsshconnections"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
}
*/
