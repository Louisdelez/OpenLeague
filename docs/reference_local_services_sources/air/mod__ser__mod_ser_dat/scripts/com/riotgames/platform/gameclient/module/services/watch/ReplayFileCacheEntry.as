package com.riotgames.platform.gameclient.module.services.watch
{
   public class ReplayFileCacheEntry
   {
      
      public var isValid:Boolean;
      
      public var replayId:String;
      
      public function ReplayFileCacheEntry(param1:String)
      {
         super();
         this.replayId = param1;
         this.isValid = true;
      }
   }
}

