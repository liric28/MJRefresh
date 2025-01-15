//
//  NSBundle+MJRefresh.m
//  MJRefresh
//
//  Created by MJ Lee on 16/6/13.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "NSBundle+MJRefresh.h"
#import "MJRefreshComponent.h"
#import "MJRefreshConfig.h"

static NSBundle *mj_defaultI18nBundle = nil;
static NSBundle *mj_systemI18nBundle = nil;

@implementation NSBundle (MJRefresh)
+ (instancetype)mj_refreshBundle
{
    static NSBundle *refreshBundle = nil;
    if (refreshBundle == nil) {
#ifdef SWIFT_PACKAGE
        NSBundle *containnerBundle = SWIFTPM_MODULE_BUNDLE;
#else
        NSBundle *containnerBundle = [NSBundle bundleForClass:[MJRefreshComponent class]];
#endif
        refreshBundle = [NSBundle bundleWithPath:[containnerBundle pathForResource:@"MJRefresh" ofType:@"bundle"]];
    }
    return refreshBundle;
}

+ (UIImage *)mj_arrowImage
{
    static UIImage *arrowImage = nil;
    if (arrowImage == nil) {
        arrowImage = [[UIImage imageWithContentsOfFile:[[self mj_refreshBundle] pathForResource:@"arrow@2x" ofType:@"png"]] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    }
    return arrowImage;
}

+ (UIImage *)mj_trailArrowImage {
    static UIImage *arrowImage = nil;
    if (arrowImage == nil) {
        arrowImage = [[UIImage imageWithContentsOfFile:[[self mj_refreshBundle] pathForResource:@"trail_arrow@2x" ofType:@"png"]] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    }
    return arrowImage;
}

+ (NSString *)mj_localizedStringForKey:(NSString *)key
{
    return [self mj_localizedStringForKey:key value:nil];
}

+ (NSString *)mj_localizedStringForKey:(NSString *)key value:(NSString *)value
{
    mj_systemI18nBundle = [self mj_defaultI18nBundleWithLanguage:nil];
    value = [mj_systemI18nBundle localizedStringForKey:key value:value table:nil];
    return value;
}

+ (NSBundle *)mj_defaultI18nBundleWithLanguage:(NSString *)language {
    NSString *userLanguage = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserLanguage"];
    if ([userLanguage isEqualToString:@"en"]) {
        language = @"en";
    } else if ([userLanguage isEqualToString:@"zh-Hans"]) {
        language = @"zh-Hans"; // 简体中文
    } else if ([userLanguage isEqualToString:@"zh-Hant"]) {
        language = @"zh-Hant"; // 繁體中文
    }
    
    // 从MJRefresh.bundle中查找资源
    return [NSBundle bundleWithPath:[[NSBundle mj_refreshBundle] pathForResource:language ofType:@"lproj"]];
}
@end

@implementation MJRefreshConfig (Bundle)

+ (void)resetLanguageResourceCache {
    mj_defaultI18nBundle = nil;
    mj_systemI18nBundle = nil;
}

@end
