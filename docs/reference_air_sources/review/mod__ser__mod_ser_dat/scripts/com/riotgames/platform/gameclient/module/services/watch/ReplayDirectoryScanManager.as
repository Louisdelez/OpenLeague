package com.riotgames.platform.gameclient.module.services.watch
{
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import flash.events.TimerEvent;
   import flash.filesystem.File;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   import flash.utils.getQualifiedClassName;
   import mx.logging.ILogger;
   import mx.logging.Log;
   
   public class ReplayDirectoryScanManager
   {
      
      private static const REPLAY_DIRECTORY_SCAN_PERIOD_MILLISECONDS:int = 3000;
      
      private var _fileRemoved:Signal = new Signal();
      
      private var _fileRenamed:Signal = new Signal();
      
      private var _cacheReplayIds:Dictionary;
      
      private var logger:ILogger = Log.getLogger(getQualifiedClassName(this).replace(/::/,"."));
      
      private var _replayFileManagerService:ReplayFileManagerService;
      
      private var _scanCount:uint;
      
      private var _cacheFileIds:Dictionary;
      
      private var _directoryScanInProgress:ReplayDirectoryScan;
      
      private var _fileAdded:Signal = new Signal();
      
      private var _scanProgress:Signal = new Signal();
      
      private var _directory:File;
      
      private var _scanComplete:Signal = new Signal();
      
      private var _directoryTimer:Timer;
      
      public function ReplayDirectoryScanManager(param1:ReplayFileManagerService, param2:File, param3:Dictionary, param4:Dictionary)
      {
         super();
         this._replayFileManagerService = param1;
         this._directory = param2;
         this._cacheFileIds = param3;
         this._cacheReplayIds = param4;
      }
      
      public function getScanProgress() : ISignal
      {
         return this._scanProgress;
      }
      
      private function onFileRenamed(param1:File, param2:String, param3:File, param4:String, param5:Object) : void
      {
         this._fileRenamed.dispatch(param1,param2,param3,param4,param5);
      }
      
      public function activateScanning() : void
      {
         if(this._directoryTimer == null)
         {
            this._directoryTimer = new Timer(REPLAY_DIRECTORY_SCAN_PERIOD_MILLISECONDS);
            this._directoryTimer.addEventListener(TimerEvent.TIMER,this.performDirectoryScan);
         }
         if(!this._directoryTimer.running && this._directoryTimer.currentCount == 0)
         {
            this.performDirectoryScan();
         }
         this._directoryTimer.start();
      }
      
      public function getFileAdded() : ISignal
      {
         return this._fileAdded;
      }
      
      private function onScanProgress(param1:int, param2:Boolean, param3:Boolean) : void
      {
         this._scanProgress.dispatch(param1,param2,param3);
      }
      
      public function getScanComplete() : ISignal
      {
         return this._scanComplete;
      }
      
      public function getFileRemoved() : ISignal
      {
         return this._fileRemoved;
      }
      
      private function cleanupScanInProgress() : void
      {
         if(this._directoryScanInProgress != null)
         {
            this._directoryScanInProgress.destroy();
         }
         this._directoryScanInProgress = null;
      }
      
      public function getFileRenamed() : ISignal
      {
         return this._fileRenamed;
      }
      
      private function onScanComplete(param1:Number) : void
      {
         var _loc2_:Number = NaN;
         ++this._scanCount;
         this.cleanupScanInProgress();
         if(this._directoryTimer != null && this._directoryTimer.running)
         {
            _loc2_ = this._directoryTimer.delay;
            if(this._scanCount > 1 && param1 * 4 >= REPLAY_DIRECTORY_SCAN_PERIOD_MILLISECONDS)
            {
               this._directoryTimer.delay = param1 * 4;
            }
            else
            {
               this._directoryTimer.delay = REPLAY_DIRECTORY_SCAN_PERIOD_MILLISECONDS;
            }
         }
         this._scanComplete.dispatch(param1);
      }
      
      public function deactivateScanning() : void
      {
         if(this._directoryTimer != null)
         {
            this._directoryTimer.stop();
         }
      }
      
      public function getScanCount() : uint
      {
         return this._scanCount;
      }
      
      private function onFileRemoved(param1:String, param2:String) : void
      {
         this._fileRemoved.dispatch(param1,param2);
      }
      
      public function performDirectoryScan(param1:TimerEvent = null) : void
      {
         if(this._directoryScanInProgress != null)
         {
            return;
         }
         if(param1 == null && this._directoryTimer != null && this._directoryTimer.running)
         {
            return;
         }
         var _loc2_:File = this._directory;
         if(!_loc2_.exists)
         {
            _loc2_.createDirectory();
         }
         this._directoryScanInProgress = new ReplayDirectoryScan(this._replayFileManagerService);
         this._directoryScanInProgress.getScanComplete().add(this.onScanComplete);
         this._directoryScanInProgress.getScanProgress().add(this.onScanProgress);
         this._directoryScanInProgress.getFileAdded().add(this.onFileAdded);
         this._directoryScanInProgress.getFileRenamed().add(this.onFileRenamed);
         this._directoryScanInProgress.getFileRemoved().add(this.onFileRemoved);
         this._directoryScanInProgress.startScan(_loc2_,this._cacheFileIds,this._cacheReplayIds);
      }
      
      private function onFileAdded(param1:File, param2:String, param3:String, param4:Object) : void
      {
         this._fileAdded.dispatch(param1,param2,param3,param4);
      }
   }
}

