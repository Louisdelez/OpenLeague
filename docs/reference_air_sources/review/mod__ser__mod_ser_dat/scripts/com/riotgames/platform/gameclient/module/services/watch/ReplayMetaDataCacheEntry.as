package com.riotgames.platform.gameclient.module.services.watch
{
   import flash.filesystem.File;
   
   public class ReplayMetaDataCacheEntry
   {
      
      public var fileId:String;
      
      public var file:File;
      
      public var metaData:Object;
      
      public function ReplayMetaDataCacheEntry(param1:Object, param2:File, param3:String)
      {
         super();
         this.metaData = param1;
         this.file = param2;
         this.fileId = param3;
      }
      
      public function get hasNoFileInfo() : Boolean
      {
         return this.file == null && this.fileId == null;
      }
      
      public function get gameVersion() : String
      {
         if(this.metaData != null)
         {
            return this.metaData.gameVersion;
         }
         return null;
      }
   }
}

