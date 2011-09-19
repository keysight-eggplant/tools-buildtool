/*
   Project: buildtool

   Author: Gregory John Casamento,,,

   Created: 2011-08-20 11:42:51 -0400 by heron
*/

#import <Foundation/Foundation.h>
#import <XCode/PBXCoder.h>
#import <XCode/PBXContainer.h>
#import <XCode/NSString+PBXAdditions.h>

int
main(int argc, const char *argv[])
{
  if(argc == 0)
    {
      return 0;
    }
  
  id pool = [[NSAutoreleasePool alloc] init];
  // Your code here...
  NSString *fileName = [[NSString stringWithCString: argv[1]] 
			 stringByAppendingPathComponent: @"project.pbxproj"];
  NSString *function = [NSString stringWithCString: argv[2]];
  PBXCoder *coder = [[PBXCoder alloc] initWithContentsOfFile: fileName];
  PBXContainer *container = [coder unarchive];
  
  if([function isEqualToString: @""])
    {
      function = @"build"; // default action...
    }

  SEL operation = NSSelectorFromString(function);
  if([container respondsToSelector: operation])
    {
      // build...
      if([container performSelector: operation])
	{
	  NSLog(@"%@ Succeeded",[function stringByCapitalizingFirstCharacter]);
	}
      else
	{
	  NSLog(@"%@ Failed",[function stringByCapitalizingFirstCharacter]);
	}
    }
  else
    {
      NSLog(@"Unknown build operation \"%@\"",function);
    }

  // The end...
  [pool release];

  return 0;
}

