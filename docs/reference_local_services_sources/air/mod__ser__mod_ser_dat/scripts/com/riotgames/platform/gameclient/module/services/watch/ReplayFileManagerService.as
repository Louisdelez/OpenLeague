package com.riotgames.platform.gameclient.module.services.watch
{
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import com.riotgames.platform.gameclient.services.watch.IReplayFileManagerService;
   import com.riotgames.platform.gameclient.services.watch.ReplayFileEvent;
   import com.riotgames.pvpnet.system.config.ClientConfig;
   import com.riotgames.util.json.jsonDecode;
   import flash.errors.IOError;
   import flash.filesystem.File;
   import flash.filesystem.FileMode;
   import flash.filesystem.FileStream;
   import flash.utils.ByteArray;
   import flash.utils.Dictionary;
   import flash.utils.Endian;
   import flash.utils.getQualifiedClassName;
   import mx.logging.ILogger;
   import mx.logging.Log;
   
   public class ReplayFileManagerService implements IReplayFileManagerService
   {
      
      private static const REPLAY_FILE_NAME_CHARACTER_LIMIT:int = 100;
      
      private static const REPLAY_DIRECTORY_PATH:String = "League of Legends/Replays";
      
      private static const EXTERNAL_REPLAY_DIRECTORY_PATH:String = REPLAY_DIRECTORY_PATH + "/.external";
      
      private var _mainScanProgress:Signal = new Signal();
      
      private var _externalDirectoryScanManager:ReplayDirectoryScanManager;
      
      private var _mainScanComplete:Signal = new Signal();
      
      private var logger:ILogger = Log.getLogger(getQualifiedClassName(this).replace(/::/,"."));
      
      private var _mainFileRenamed:Signal = new Signal();
      
      private var _externalReplayFileNames:Dictionary = new Dictionary();
      
      private var _externalScanProgress:Signal = new Signal();
      
      private var _mainReplayIds:Dictionary = new Dictionary();
      
      private var _externalScanComplete:Signal = new Signal();
      
      private var _mainFileAdded:Signal = new Signal();
      
      private var _mainFileDeleted:Signal = new Signal();
      
      private var _externalFileAdded:Signal = new Signal();
      
      private var _mainFileIds:Dictionary = new Dictionary();
      
      private var _mainDirectoryScanManager:ReplayDirectoryScanManager;
      
      public function ReplayFileManagerService()
      {
         super();
         this._mainDirectoryScanManager = new ReplayDirectoryScanManager(this,this.replayDirectory,this._mainFileIds,this._mainReplayIds);
         this._mainDirectoryScanManager.getFileAdded().add(this.registerMainReplayFileAdded);
         this._mainDirectoryScanManager.getFileRenamed().add(this.registerMainReplayFileRenamed);
         this._mainDirectoryScanManager.getFileRemoved().add(this.registerMainReplayFileRemoved);
         this._mainDirectoryScanManager.getScanProgress().add(this.forwardMainScanProgress);
         this._mainDirectoryScanManager.getScanComplete().add(this.forwardMainScanComplete);
         this._externalDirectoryScanManager = new ReplayDirectoryScanManager(this,this.externalReplayDirectory,new Dictionary(),new Dictionary());
         this._externalDirectoryScanManager.getFileAdded().add(this.registerExternalReplayFileAdded);
         this._externalDirectoryScanManager.getScanProgress().add(this.forwardExternalScanProgress);
         this._externalDirectoryScanManager.getScanComplete().add(this.forwardExternalScanComplete);
      }
      
      private static function isValidMetaData(param1:Object) : Boolean
      {
         return param1 != null && param1.gameId != null && param1.platformId != null;
      }
      
      public function getCachedMetaData(param1:String) : Object
      {
         var _loc2_:ReplayMetaDataCacheEntry = this._mainReplayIds[param1] as ReplayMetaDataCacheEntry;
         if(_loc2_ != null)
         {
            return _loc2_.metaData;
         }
         return null;
      }
      
      private function forwardMainScanProgress(param1:int, param2:Boolean, param3:Boolean) : void
      {
         this._mainScanProgress.dispatch(param1,param2,param3);
      }
      
      public function readReplayMetaData(param1:File) : Object
      {
         var fileStream:FileStream;
         var metaData:Object;
         var myBytes:ByteArray;
         var magicString:String = null;
         var metadataOffset:uint = 0;
         var metadataSize:uint = 0;
         var metaDataBytes:String = null;
         var parts:Object = null;
         var file:File = param1;
         if(file == null || !file.exists)
         {
            return null;
         }
         myBytes = new ByteArray();
         myBytes.endian = Endian.LITTLE_ENDIAN;
         fileStream = new FileStream();
         try
         {
            fileStream.open(file,FileMode.READ);
            fileStream.readBytes(myBytes,0,file.size);
            fileStream.close();
         }
         catch(error:Error)
         {
            logger.error("Cannot read replay file: " + error.toString());
            return null;
         }
         metaData = null;
         try
         {
            magicString = myBytes.readUTFBytes(4);
            if(magicString != "RIOT")
            {
               return null;
            }
            myBytes.position = 268;
            metadataOffset = myBytes.readUnsignedInt();
            metadataSize = myBytes.readUnsignedInt();
            myBytes.position = metadataOffset;
            if(myBytes.position + metadataSize > myBytes.length)
            {
               this.logger.error("Invalid replay file, garbled: " + file.nativePath);
               return null;
            }
            metaDataBytes = myBytes.readUTFBytes(metadataSize);
            parts = jsonDecode(metaDataBytes);
            if(parts.statsJSON != "")
            {
               parts.stats = jsonDecode(parts.statsJSON);
            }
            else
            {
               parts.statsJSON = {};
            }
            metaData = parts;
         }
         catch(error:Error)
         {
            metaData = null;
         }
         if(isValidMetaData(metaData))
         {
            return metaData;
         }
         this.logger.error("Invalid replay file, bad metadata: " + file.nativePath);
         return null;
      }
      
      public function getMainFileRenamed() : ISignal
      {
         return this._mainFileRenamed;
      }
      
      public function deactivateMainScanning() : void
      {
         this._mainDirectoryScanManager.deactivateScanning();
      }
      
      private function forwardExternalScanProgress(param1:int, param2:Boolean, param3:Boolean) : void
      {
         this._externalScanProgress.dispatch(param1,param2,param3);
      }
      
      private function forwardExternalScanComplete(param1:Number) : void
      {
         this._externalScanComplete.dispatch(param1);
      }
      
      public function getExternalFileAdded() : ISignal
      {
         return this._externalFileAdded;
      }
      
      public function getMainScanComplete() : ISignal
      {
         return this._mainScanComplete;
      }
      
      public function deactivateExternalScanning() : void
      {
         this._externalDirectoryScanManager.deactivateScanning();
      }
      
      public function getMainScanProgress() : ISignal
      {
         return this._mainScanProgress;
      }
      
      public function getMainScanCount() : uint
      {
         return this._mainDirectoryScanManager.getScanCount();
      }
      
      public function activateMainScanning() : void
      {
         this._mainDirectoryScanManager.activateScanning();
      }
      
      public function activateExternalScanning() : void
      {
         this._externalDirectoryScanManager.activateScanning();
      }
      
      public function getExternalScanComplete() : ISignal
      {
         return this._externalScanComplete;
      }
      
      public function generateCacheFileId(param1:File) : String
      {
         return param1.name + "_" + param1.modificationDate.time;
      }
      
      public function get externalReplayDirectory() : File
      {
         return File.documentsDirectory.resolvePath(EXTERNAL_REPLAY_DIRECTORY_PATH);
      }
      
      public function getExternalScanProgress() : ISignal
      {
         return this._externalScanProgress;
      }
      
      public function getReplayFileExists(param1:String) : Boolean
      {
         var _loc2_:File = File.documentsDirectory.resolvePath(REPLAY_DIRECTORY_PATH + "/" + param1 + ".rofl");
         return _loc2_.exists;
      }
      
      public function get replayDirectory() : File
      {
         return File.documentsDirectory.resolvePath(REPLAY_DIRECTORY_PATH);
      }
      
      private function registerMainReplayFileAdded(param1:File, param2:String, param3:String, param4:Object) : void
      {
         this._mainFileIds[param2] = new ReplayFileCacheEntry(param3);
         this._mainReplayIds[param3] = new ReplayMetaDataCacheEntry(param4,param1,param2);
         var _loc5_:Boolean = false;
         if(this._externalReplayFileNames[param1.name] != null)
         {
            _loc5_ = true;
            delete this._externalReplayFileNames[param1.name];
         }
         var _loc6_:ReplayFileEvent = new ReplayFileEvent(ReplayFileEvent.NEW_REPLAY_FILE,param1);
         _loc6_.metaData = param4;
         _loc6_.isExternal = _loc5_;
         this._mainFileAdded.dispatch(_loc6_);
      }
      
      public function performExternalDirectoryScan() : void
      {
         this._externalDirectoryScanManager.performDirectoryScan();
      }
      
      public function setCachedMetaData(param1:String, param2:Object) : void
      {
         var _loc3_:ReplayMetaDataCacheEntry = this._mainReplayIds[param1] as ReplayMetaDataCacheEntry;
         if(_loc3_ == null)
         {
            _loc3_ = new ReplayMetaDataCacheEntry(null,null,null);
            this._mainReplayIds[param1] = _loc3_;
         }
         _loc3_.metaData = param2;
      }
      
      public function getMainFileDeleted() : ISignal
      {
         return this._mainFileDeleted;
      }
      
      public function isValidReplayFileName(param1:String) : Boolean
      {
         var _loc2_:RegExp = /[\\\/\:\*\?\"<>|]/;
         return param1.length <= this.getReplayFileNameCharacterLimit() && param1.search(_loc2_) == -1;
      }
      
      public function replayExists(param1:String) : Boolean
      {
         var _loc2_:File = this.getReplayFile(param1);
         return _loc2_ != null && Boolean(_loc2_.exists);
      }
      
      public function getExternalScanCount() : uint
      {
         return this._externalDirectoryScanManager.getScanCount();
      }
      
      public function addDownloadedReplayFile(param1:ByteArray, param2:String) : void
      {
         var metaData:Object;
         var replayId:String = null;
         var bytes:ByteArray = param1;
         var fileName:String = param2;
         var file:File = File.documentsDirectory.resolvePath(REPLAY_DIRECTORY_PATH + "/" + fileName);
         var fileStream:FileStream = new FileStream();
         try
         {
            fileStream.open(file,FileMode.WRITE);
            fileStream.writeBytes(bytes,0,bytes.length);
            fileStream.close();
         }
         catch(error:Error)
         {
            logger.error("Cannot write downloaded replay file to disk: " + error.toString());
            return;
         }
         metaData = this.readReplayMetaData(file);
         if(metaData != null)
         {
            replayId = this.generateReplayId(metaData["gameId"],metaData["platformId"]);
            this.registerMainReplayFileAdded(file,this.generateCacheFileId(file),replayId,metaData);
         }
         else
         {
            file.deleteFile();
         }
      }
      
      public function renameReplay(param1:File, param2:String, param3:Object, param4:Function) : File
      {
         var oldFileId:String = null;
         var newFile:File = null;
         var oldFile:File = param1;
         var newFileName:String = param2;
         var metaData:Object = param3;
         var onFailure:Function = param4;
         if(this.isValidReplayFileName(newFileName))
         {
            oldFileId = this.generateCacheFileId(oldFile);
            newFile = File.documentsDirectory.resolvePath(REPLAY_DIRECTORY_PATH + "/" + newFileName + ".rofl");
            if(oldFile.nativePath != newFile.nativePath)
            {
               try
               {
                  oldFile.moveTo(newFile);
               }
               catch(e:IOError)
               {
                  onFailure();
                  return oldFile;
               }
               if(isValidMetaData(metaData))
               {
                  this.registerMainReplayFileRenamed(newFile,this.generateCacheFileId(newFile),oldFile,oldFileId,metaData);
               }
               return newFile;
            }
         }
         return oldFile;
      }
      
      public function getReplayFileNameCharacterLimit() : int
      {
         return REPLAY_FILE_NAME_CHARACTER_LIMIT;
      }
      
      private function registerExternalReplayFileAdded(param1:File, param2:String, param3:String, param4:Object) : void
      {
         var targetFile:File = null;
         var file:File = param1;
         var fileId:String = param2;
         var replayId:String = param3;
         var metaData:Object = param4;
         this._externalReplayFileNames[file.name] = file.name;
         targetFile = this.replayDirectory.resolvePath(file.name);
         if(!targetFile.exists)
         {
            try
            {
               file.moveToAsync(targetFile);
            }
            catch(e:IOError)
            {
               logger.error("Could not copy over external replay file: " + file.nativePath);
            }
         }
         else
         {
            try
            {
               file.deleteFileAsync();
            }
            catch(e:IOError)
            {
               logger.error("Could not delete external replay file: " + targetFile.nativePath);
            }
         }
         this._externalFileAdded.dispatch(targetFile);
      }
      
      private function registerMainReplayFileRenamed(param1:File, param2:String, param3:File, param4:String, param5:Object) : void
      {
         var _loc6_:String = this.generateReplayId(param5.gameId,param5.platformId);
         this._mainFileIds[param2] = new ReplayFileCacheEntry(_loc6_);
         this._mainReplayIds[_loc6_] = new ReplayMetaDataCacheEntry(param5,param1,param2);
         if(param3 != null && !param3.exists)
         {
            delete this._mainFileIds[param4];
         }
         this._mainFileRenamed.dispatch(new ReplayFileEvent(ReplayFileEvent.REPLAY_FILE_RENAME,param1,param3));
      }
      
      private function forwardMainScanComplete(param1:Number) : void
      {
         this._mainScanComplete.dispatch(param1);
      }
      
      public function getVersionsToReplaysMap() : Dictionary
      {
         var _loc2_:ReplayMetaDataCacheEntry = null;
         var _loc3_:Vector.<File> = null;
         var _loc1_:Dictionary = new Dictionary();
         for each(_loc2_ in this._mainReplayIds)
         {
            if(_loc2_.file != null && _loc2_.gameVersion != null)
            {
               _loc3_ = _loc1_[_loc2_.gameVersion] as Vector.<File>;
               if(_loc3_ == null)
               {
                  _loc3_ = new Vector.<File>();
                  _loc1_[_loc2_.gameVersion] = _loc3_;
               }
               _loc3_.push(_loc2_.file);
            }
         }
         return _loc1_;
      }
      
      public function forEachReplay(param1:Function) : void
      {
         var _loc2_:ReplayMetaDataCacheEntry = null;
         for each(_loc2_ in this._mainReplayIds)
         {
            if(_loc2_.file != null)
            {
               param1(_loc2_.file,_loc2_.metaData);
            }
         }
      }
      
      public function deleteReplay(param1:File, param2:Object, param3:Function) : void
      {
         var file:File = param1;
         var metaData:Object = param2;
         var onFailure:Function = param3;
         if(!isValidMetaData(metaData))
         {
            return;
         }
         this.registerMainReplayFileRemoved(this.generateCacheFileId(file),this.generateReplayId(metaData.gameId,metaData.platformId));
         try
         {
            file.deleteFile();
         }
         catch(e:Error)
         {
            onFailure();
         }
      }
      
      public function getMainFileAdded() : ISignal
      {
         return this._mainFileAdded;
      }
      
      public function performMainDirectoryScan() : void
      {
         this._mainDirectoryScanManager.performDirectoryScan();
      }
      
      public function getReplayFile(param1:String) : File
      {
         var _loc2_:ReplayMetaDataCacheEntry = this._mainReplayIds[param1] as ReplayMetaDataCacheEntry;
         if(_loc2_ != null)
         {
            return _loc2_.file;
         }
         return null;
      }
      
      private function registerMainReplayFileRemoved(param1:String, param2:String) : void
      {
         var _loc3_:ReplayMetaDataCacheEntry = this._mainReplayIds[param2] as ReplayMetaDataCacheEntry;
         if(_loc3_ != null)
         {
            this._mainFileDeleted.dispatch(new ReplayFileEvent(ReplayFileEvent.REPLAY_FILE_DELETE,_loc3_.file));
         }
         delete this._mainFileIds[param1];
         delete this._mainReplayIds[param2];
      }
      
      public function generateReplayId(param1:String, param2:String) : String
      {
         var _loc3_:ClientConfig = null;
         if(param2 == null)
         {
            _loc3_ = ClientConfig.instance;
            param2 = _loc3_.platformId;
         }
         return param2 + "_" + param1;
      }
   }
}

