//
//  KeyboardLayoutData.h
//  AGK
//
//  Created by Yichi on 4/07/2015.
//  Copyright (c) 2015 Yichi. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (Utils)

/*
 To check if character is in Greek Extended (Range: 1F00–1FFF)
 For more details, please see https://unicode.org/charts/PDF/U1F00.pdf
 */
+ (BOOL)__isCharacterAcceptableCombination:(unichar)character;

@end

NS_ASSUME_NONNULL_END
