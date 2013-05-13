/*
   Project: buildtool

   Author: Gregory John Casamento,,,

   Created: 2011-08-20 11:42:51 -0400 by heron
*/

#import <Foundation/Foundation.h>
#import <XCode/PBXCoder.h>
#import <XCode/PBXContainer.h>
#import <XCode/NSString+PBXAdditions.h>

NSString *
findProjectFilename(NSArray *projectDirEntries)
{
  NSEnumerator *e = [projectDirEntries objectEnumerator];
  NSString     *fileName;

  while ((fileName = [e nextObject]))
    {
      NSRange range = [fileName rangeOfString:@"._"];
      if ([[fileName pathExtension] isEqual: @"xcodeproj"] && range.location == NSNotFound)
	{
	  return [fileName stringByAppendingPathComponent: @"project.pbxproj"];
	}
    }

  return nil;
}

int
main(int argc, const char *argv[])
{
  if(argc == 0)
    {
      return 0;
    }
  
  id pool = [[NSAutoreleasePool alloc] init];
  // Your code here...
  NSString                   *fileName = nil;
  NSString                   *function = nil; 
  PBXCoder                   *coder = nil;
  PBXContainer               *container = nil;
  NSString                   *projectDir;
  NSArray                    *projectDirEntries;
  NSFileManager              *fileManager = [NSFileManager defaultManager];

  projectDir        = [fileManager currentDirectoryPath];
  projectDirEntries = [fileManager directoryContentsAtPath: projectDir];

  // Get the project...
  if(argv[1] != NULL)
    {
      NSString *xcodeFilePath = [NSString stringWithCString: argv[1]];
      fileName = [xcodeFilePath
			 stringByAppendingPathComponent: 
		     @"project.pbxproj"];
      if([[xcodeFilePath pathExtension] isEqualToString:@"xcodeproj"] == NO)
	{
	  fileName = findProjectFilename(projectDirEntries);
	  function = [NSString stringWithCString: argv[1]];
	}
      else
	{
	  // If there is a project, add the build operation...
	  if(argv[2] != NULL && argc > 1)
	    {
	      function = [NSString stringWithCString: argv[2]];
	    }
	}

    }
  else
    {
      fileName = findProjectFilename(projectDirEntries);
    }

  if([function isEqualToString: @""] || function == nil)
    {
      function = @"build"; // default action...
    }

  // Unarchive...
  coder = [[PBXCoder alloc] initWithContentsOfFile: fileName];
  container = [coder unarchive];

  // Build...
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

