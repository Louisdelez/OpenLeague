package com.riotgames.platform.gameclient.services.watch
{
   import blix.signals.ISignal;
   
   public interface IReplayDownloadService
   {
      
      function isDownloading() : Boolean;
      
      function getDownloadStateChange() : ISignal;
      
      function getReplayDownloadAgent(param1:Number, param2:Boolean, param3:Boolean) : IReplayDownloadAgent;
   }
}

