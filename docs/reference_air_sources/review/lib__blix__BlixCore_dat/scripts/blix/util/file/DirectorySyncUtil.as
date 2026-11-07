package blix.util.file
{
   import flash.events.ErrorEvent;
   import flash.events.Event;
   import flash.events.FileListEvent;
   import flash.events.IOErrorEvent;
   import flash.filesystem.File;
   
   public class DirectorySyncUtil
   {
      
      public function DirectorySyncUtil()
      {
         super();
      }
      
      internal static function directorySyncInternal(param1:File, param2:File, param3:Function, param4:Function, param5:Vector.<File>, param6:Vector.<File>, param7:Vector.<File>, param8:Boolean = true, param9:Boolean = true, param10:Boolean = true) : void
      {
         var oldFile:File = null;
         var newFile:File = null;
         var pendingCount:int = 0;
         var hasFailed:Boolean = false;
         var asyncCompleteHandler:Function = null;
         var failHandler:Function = null;
         var fromDir:File = param1;
         var toDir:File = param2;
         var successCallback:Function = param3;
         var failCallback:Function = param4;
         var filesCreated:Vector.<File> = param5;
         var filesUpdated:Vector.<File> = param6;
         var filesDeleted:Vector.<File> = param7;
         var propagateDeletion:Boolean = param8;
         var propagateCreation:Boolean = param9;
         var propagateOverwrite:Boolean = param10;
         if(!fromDir.exists)
         {
            throw new ArgumentError("from directory does not exist.");
         }
         fromDir = fromDir.clone();
         toDir = toDir.clone();
         if(!toDir.exists)
         {
            toDir.createDirectory();
         }
         pendingCount = 0;
         asyncCompleteHandler = function(param1:Event = null):void
         {
            --pendingCount;
            if(pendingCount <= 0)
            {
               if(!hasFailed)
               {
                  if(successCallback.length == 3)
                  {
                     successCallback(filesCreated,filesUpdated,filesDeleted);
                  }
                  else
                  {
                     successCallback();
                  }
               }
            }
         };
         failHandler = function(param1:ErrorEvent = null):void
         {
            hasFailed = true;
            if(failCallback.length == 1)
            {
               failCallback(param1);
            }
            else
            {
               failCallback();
            }
         };
         pendingCount++;
         toDir.addEventListener(FileListEvent.DIRECTORY_LISTING,function(param1:FileListEvent):void
         {
            for each(oldFile in param1.files)
            {
               newFile = new File(fromDir.nativePath + "/" + oldFile.name);
               if(!newFile.exists)
               {
                  if(propagateDeletion)
                  {
                     ++pendingCount;
                     oldFile.addEventListener(Event.COMPLETE,asyncCompleteHandler);
                     oldFile.addEventListener(IOErrorEvent.IO_ERROR,failHandler);
                     filesDeleted[filesDeleted.length] = oldFile;
                     oldFile.deleteFileAsync();
                  }
               }
            }
            asyncCompleteHandler();
         });
         toDir.getDirectoryListingAsync();
         pendingCount++;
         fromDir.addEventListener(FileListEvent.DIRECTORY_LISTING,function(param1:FileListEvent):void
         {
            for each(newFile in param1.files)
            {
               oldFile = new File(toDir.nativePath + "/" + newFile.name);
               if(newFile.isDirectory)
               {
                  if(oldFile.isDirectory)
                  {
                     ++pendingCount;
                     directorySyncInternal(newFile,oldFile,asyncCompleteHandler,failHandler,filesCreated,filesUpdated,filesDeleted,propagateDeletion,propagateCreation,propagateOverwrite);
                  }
                  else
                  {
                     ++pendingCount;
                     newFile.addEventListener(Event.COMPLETE,asyncCompleteHandler);
                     newFile.addEventListener(IOErrorEvent.IO_ERROR,failHandler);
                     filesCreated[filesCreated.length] = newFile;
                     newFile.copyToAsync(oldFile,propagateOverwrite);
                  }
               }
               else if(Boolean(oldFile.exists) && oldFile.modificationDate.time < newFile.modificationDate.time && propagateOverwrite || !oldFile.exists && propagateCreation)
               {
                  ++pendingCount;
                  newFile.addEventListener(Event.COMPLETE,asyncCompleteHandler);
                  newFile.addEventListener(IOErrorEvent.IO_ERROR,failHandler);
                  if(!oldFile.exists)
                  {
                     filesCreated[filesCreated.length] = newFile;
                  }
                  else
                  {
                     filesUpdated[filesUpdated.length] = newFile;
                  }
                  newFile.copyToAsync(oldFile,true);
               }
            }
            asyncCompleteHandler();
         });
         fromDir.getDirectoryListingAsync();
      }
   }
}

