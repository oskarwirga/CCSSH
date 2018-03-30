#import "OW2CCSSH.h"

@interface UIImage ()
+ (UIImage *)imageNamed:(NSString *)name inBundle:(NSBundle *)bundle;
@end

@implementation OW2CCSSH
- (UIImage *)iconGlyph {
	return [UIImage imageNamed:@"Icon" inBundle:[NSBundle bundleForClass:[self class]]];
}

- (UIColor *)selectedColor {
	return [UIColor blueColor];
}

- (BOOL)isSelected {
	return self.enabledSSH;
}

- (void)setSelected:(BOOL)selected {
	self.enabledSSH = selected;
	[super refreshState];
}
@end
