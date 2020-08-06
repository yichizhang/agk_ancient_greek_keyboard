//
//  KeyboardLayoutData.m
//  AGK
//
//  Created by Yichi on 4/07/2015.
//  Copyright (c) 2015 Yichi. All rights reserved.
//

@import Foundation;

#import "KeyboardLayoutData.h"

@implementation NSObject (Utils)

+ (BOOL)__isCharacterAcceptableCombination:(unichar)character
{
  int start = 0x1F00;
  int end = 0x1FFF;

  if (character >= start && character <= end)
  {
    return YES;
  }
  return NO;
}

@end
