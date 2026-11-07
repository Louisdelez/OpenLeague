package com.riotgames.platform.gameclient.module.services.watch
{
   import blix.IDestructible;
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import com.riotgames.platform.gameclient.services.watch.ReplayServiceConstants;
   import flash.errors.IOError;
   import flash.events.FileListEvent;
   import flash.filesystem.File;
   import flash.utils.Dictionary;
   import flash.utils.getQualifiedClassName;
   import flash.utils.setTimeout;
   import mx.logging.ILogger;
   import mx.logging.Log;
   
   public class ReplayDirectoryScan implements IDestructible
   {
      
      private static const SCAN_CHUNK:int = 20;
      
      private var _fileRemoved:Signal = new Signal();
      
      private var _replayDirectory:File;
      
      private var _fileRenamed:Signal = new Signal();
      
      private var _cacheMisses:int = 0;
      
      private var _cacheReplayIds:Dictionary;
      
      private var _mainDirectoryScanEnabled:Boolean = false;
      
      private var logger:ILogger = Log.getLogger(getQualifiedClassName(this).replace(/::/,"."));
      
      private var _replayFileManagerService:ReplayFileManagerService;
      
      private var _manyNewFiles:Boolean;
      
      private var _cacheFileIds:Dictionary;
      
      private var _replayDirectoryFileList:Array;
      
      private var _fileAdded:Signal = new Signal();
      
      private var _scanStart:Number;
      
      private var _scanProgress:Signal = new Signal();
      
      private var _lastRefreshPosition:int;
      
      private var _scanComplete:Signal = new Signal();
      
      public function ReplayDirectoryScan(param1:ReplayFileManagerService)
      {
         super();
         this._replayFileManagerService = param1;
      }
      
      public function getScanProgress() : ISignal
      {
         return this._scanProgress;
      }
      
      public function getScanComplete() : ISignal
      {
         return this._scanComplete;
      }
      
      private function handleRemovedReplayFiles() : void
      {
         var _loc1_:String = null;
         var _loc2_:ReplayFileCacheEntry = null;
         for(_loc1_ in this._cacheFileIds)
         {
            _loc2_ = this._cacheFileIds[_loc1_] as ReplayFileCacheEntry;
            if(!_loc2_.isValid)
            {
               this._fileRemoved.dispatch(_loc1_,_loc2_.replayId);
            }
         }
      }
      
      public function getFileRenamed() : ISignal
      {
         return this._fileRenamed;
      }
      
      private function onDirectoryList(param1:FileListEvent) : void
      {
         var _loc3_:ReplayFileCacheEntry = null;
         this._replayDirectoryFileList = param1.files;
         var _loc2_:int = 0;
         for each(_loc3_ in this._cacheFileIds)
         {
            _loc3_.isValid = false;
            _loc2_++;
         }
         this._manyNewFiles = this._replayDirectoryFileList.length - _loc2_ >= SCAN_CHUNK;
         this.updateDirectoryPartial();
      }
      
      public function getFileAdded() : ISignal
      {
         return this._fileAdded;
      }
      
      public function getFileRemoved() : ISignal
      {
         return this._fileRemoved;
      }
      
      private function handleRenamedDuplicatedOrNewReplayFile(param1:File, param2:String, param3:Object) : void
      {
         var _loc6_:File = null;
         var _loc7_:String = null;
         var _loc4_:String = this._replayFileManagerService.generateReplayId(param3.gameId,param3.platformId);
         var _loc5_:ReplayMetaDataCacheEntry = this._cacheReplayIds[_loc4_] as ReplayMetaDataCacheEntry;
         if(_loc5_ == null || _loc5_.hasNoFileInfo)
         {
            this._fileAdded.dispatch(param1,param2,_loc4_,param3);
         }
         else
         {
            _loc6_ = _loc5_.file;
            _loc7_ = _loc5_.fileId;
            this._fileRenamed.dispatch(param1,param2,_loc6_,_loc7_,param3);
         }
      }
      
      public function destroy() : void
      {
         if(this._replayDirectory != null)
         {
            this._replayDirectory.removeEventListener(FileListEvent.DIRECTORY_LISTING,this.onDirectoryList);
         }
         this._scanComplete.removeAll();
         this._scanProgress.removeAll();
         this._fileAdded.removeAll();
         this._fileRenamed.removeAll();
         this._fileRemoved.removeAll();
      }
      
      private function updateDirectoryPartial() : void
      {
         var _loc4_:File = null;
         var _loc5_:String = null;
         var _loc6_:ReplayFileCacheEntry = null;
         var _loc7_:Object = null;
         var _loc8_:int = 0;
         var _loc9_:Boolean = false;
         var _loc1_:Number = Math.min(this._replayDirectoryFileList.length,this._lastRefreshPosition + SCAN_CHUNK);
         var _loc2_:uint = uint(this._lastRefreshPosition);
         while(_loc2_ < _loc1_)
         {
            _loc4_ = this._replayDirectoryFileList[_loc2_];
            if(Boolean(_loc4_.exists) && _loc4_.extension == ReplayServiceConstants.REPLAY_EXTENSION)
            {
               _loc5_ = this._replayFileManagerService.generateCacheFileId(_loc4_);
               _loc6_ = this._cacheFileIds[_loc5_] as ReplayFileCacheEntry;
               if(_loc6_ != null)
               {
                  _loc6_.isValid = true;
               }
               else
               {
                  ++this._cacheMisses;
                  _loc7_ = this._replayFileManagerService.readReplayMetaData(_loc4_);
                  if(_loc7_ != null)
                  {
                     this.handleRenamedDuplicatedOrNewReplayFile(_loc4_,_loc5_,_loc7_);
                  }
                  else
                  {
                     this.logger.error("Unable to read metadata for replay: " + _loc4_.nativePath);
                  }
               }
            }
            ++this._lastRefreshPosition;
            _loc2_++;
         }
         var _loc3_:Number = new Date().time - this._scanStart;
         if(_loc1_ >= this._replayDirectoryFileList.length)
         {
            this.handleRemovedReplayFiles();
            this._scanComplete.dispatch(_loc3_);
         }
         else
         {
            _loc8_ = this._lastRefreshPosition * 100 / this._replayDirectoryFileList.length;
            this._scanProgress.dispatch(_loc8_,_loc3_,this._manyNewFiles);
            _loc9_ = this._cacheMisses >= SCAN_CHUNK;
            if((_loc9_) || _loc3_ > ReplayServiceConstants.SCAN_THROTTLE_DOWN_THRESHOLD)
            {
               setTimeout(this.updateDirectoryPartial,100);
            }
            else
            {
               this.updateDirectoryPartial();
            }
         }
      }
      
      public function startScan(param1:File, param2:Dictionary, param3:Dictionary) : void
      {
         var directory:File = param1;
         var cacheFileIds:Dictionary = param2;
         var cacheReplayIds:Dictionary = param3;
         this._cacheFileIds = cacheFileIds;
         this._cacheReplayIds = cacheReplayIds;
         this._lastRefreshPosition = 0;
         this._scanStart = new Date().time;
         this._replayDirectory = directory;
         this._replayDirectory.addEventListener(FileListEvent.DIRECTORY_LISTING,this.onDirectoryList);
         try
         {
            this._replayDirectory.getDirectoryListingAsync();
         }
         catch(e:IOError)
         {
            _scanComplete.dispatch(0);
         }
      }
   }
}

