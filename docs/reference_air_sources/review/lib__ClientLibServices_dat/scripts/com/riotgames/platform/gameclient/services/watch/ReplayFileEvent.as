package com.riotgames.platform.gameclient.services.watch
{
   import flash.events.Event;
   import flash.filesystem.File;
   import mx.events.FileEvent;
   
   public class ReplayFileEvent extends FileEvent
   {
      
      public static const NEW_REPLAY_FILE:String = "ReplayFileEvent.NewReplayFile";
      
      public static const REPLAY_FILE_RENAME:String = "ReplayFileEvent.ReplayFileRename";
      
      public static const REPLAY_FILE_DELETE:String = "ReplayFileEvent.ReplayFileDelete";
      
      public static const EXTERNAL_REPLAY_FILE:String = "ReplayFileEvent.ExternalReplayFile";
      
      public var oldFile:File;
      
      public var isExternal:Boolean;
      
      public var metaData:Object;
      
      public function ReplayFileEvent(param1:String, param2:File = null, param3:File = null, param4:Boolean = false, param5:Boolean = false)
      {
         super(param1,param4,param5,param2);
         this.oldFile = param3;
      }
      
      override public function clone() : Event
      {
         return new ReplayFileEvent(type,file,this.oldFile,bubbles,cancelable);
      }
   }
}

