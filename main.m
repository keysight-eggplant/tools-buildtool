/*
   Project: buildtool

   Author: Gregory John Casamento,,,

   Created: 2011-08-20 11:42:51 -0400 by heron
*/

#import <Foundation/Foundation.h>
#import <XCode/PBXCoder.h>
#import <XCode/PBXContainer.h>

int
main(int argc, const char *argv[])
{
  if(argc == 0)
    {
      return 0;
    }
  
  id pool = [[NSAutoreleasePool alloc] init];
  // Your code here...
  NSString *fileName = [NSString stringWithCString: argv[1]];
  PBXCoder *coder = [[PBXCoder alloc] initWithContentsOfFile: fileName];
  PBXContainer *container = [coder unarchive];
  
  // The end...
  [pool release];

  return 0;
}

