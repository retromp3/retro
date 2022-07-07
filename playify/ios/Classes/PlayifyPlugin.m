#import "PlayifyPlugin.h"
#if __has_include(<playify/playify-Swift.h>)
#import <playify/playify-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "playify-Swift.h"
#endif

@implementation PlayifyPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftPlayifyPlugin registerWithRegistrar:registrar];
}
@end
