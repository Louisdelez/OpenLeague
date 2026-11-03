package com.riotgames.platform.gameclient.services.watch
{
   import blix.signals.ISignal;
   
   public interface IReplayDownloadAgent
   {
      
      function getOnReplayDownloadError() : ISignal;
      
      function getOnReplayMetadataIOError() : ISignal;
      
      function getOnReplayDownloadUnauthorized() : ISignal;
      
      function get isReplayDownloading() : Boolean;
      
      function getOnReplayDownloadProgressUpdate() : ISignal;
      
      function getOnReplayMetadataComplete() : ISignal;
      
      function getOnReplayMetadataSecurityError() : ISignal;
      
      function getOnReplayDownloadComplete() : ISignal;
      
      function downloadMetadata() : void;
      
      function downloadReplay() : void;
   }
}

