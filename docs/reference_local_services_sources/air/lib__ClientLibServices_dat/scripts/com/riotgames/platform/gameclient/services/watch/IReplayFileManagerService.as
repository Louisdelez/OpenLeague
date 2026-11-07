package com.riotgames.platform.gameclient.services.watch
{
   import blix.signals.ISignal;
   import flash.filesystem.File;
   import flash.utils.ByteArray;
   import flash.utils.Dictionary;
   
   public interface IReplayFileManagerService
   {
      
      function isValidReplayFileName(param1:String) : Boolean;
      
      function deleteReplay(param1:File, param2:Object, param3:Function) : void;
      
      function renameReplay(param1:File, param2:String, param3:Object, param4:Function) : File;
      
      function get replayDirectory() : File;
      
      function getCachedMetaData(param1:String) : Object;
      
      function addDownloadedReplayFile(param1:ByteArray, param2:String) : void;
      
      function readReplayMetaData(param1:File) : Object;
      
      function getMainFileDeleted() : ISignal;
      
      function getExternalScanCount() : uint;
      
      function setCachedMetaData(param1:String, param2:Object) : void;
      
      function getReplayFileNameCharacterLimit() : int;
      
      function getMainScanProgress() : ISignal;
      
      function getMainFileRenamed() : ISignal;
      
      function getVersionsToReplaysMap() : Dictionary;
      
      function activateMainScanning() : void;
      
      function deactivateMainScanning() : void;
      
      function getExternalFileAdded() : ISignal;
      
      function generateCacheFileId(param1:File) : String;
      
      function getMainScanComplete() : ISignal;
      
      function getMainScanCount() : uint;
      
      function getExternalScanProgress() : ISignal;
      
      function performExternalDirectoryScan() : void;
      
      function activateExternalScanning() : void;
      
      function deactivateExternalScanning() : void;
      
      function forEachReplay(param1:Function) : void;
      
      function replayExists(param1:String) : Boolean;
      
      function getMainFileAdded() : ISignal;
      
      function generateReplayId(param1:String, param2:String) : String;
      
      function getReplayFile(param1:String) : File;
      
      function getReplayFileExists(param1:String) : Boolean;
      
      function getExternalScanComplete() : ISignal;
      
      function performMainDirectoryScan() : void;
   }
}

