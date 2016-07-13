//
//  UIImage+MASUI.h
//  MASUI
//
//  Copyright (c) 2016 CA. All rights reserved.
//
//  This software may be modified and distributed under the terms
//  of the MIT license. See the LICENSE file for details.
//

#import <UIKit/UIKit.h>


static NSString *const MASUIAuthenticationProviderEnterpriseImageKey = @"enterprise";
static NSString *const MASUIAuthenticationProviderFacebookImageKey = @"facebook";
static NSString *const MASUIAuthenticationProviderGoogleImageKey = @"google";
static NSString *const MASUIAuthenticationProviderLinkedInImageKey = @"linkedin";
static NSString *const MASUIAuthenticationProviderQrCodeImageKey = @"qrcode";
static NSString *const MASUIAuthenticationProviderSalesforceImageKey = @"salesforce";


@interface UIImage (MASUI)



///--------------------------------------
/// @name Bundle Images
///-------------------------------------

# pragma mark - Bundle Images

/**
 * Retrieve the branded authentication provider image for the given key in enabled or disabled mode.
 * 
 * @param key The key applicable to a given authentication provider.
 * @param enabled YES if want the enabled version of the image, NO if the disabled version.
 * @return Returns The applicable UIImage if any found.
 */
+ (UIImage *)masUIAuthenticationProviderImageForKey:(NSString *)key enabled:(BOOL)enabled;


/**
 * Retrieve the image within the MASUI framework for the given name.
 *
 * @param imageName The specific name of the requested image.  Note if not png must add
 *     the extension (i.e. .jpg).
 * @return Returns The applicable UIImage if any found.
 */
+ (UIImage *)masUIImageNamed:(NSString *)imageName;

@end
