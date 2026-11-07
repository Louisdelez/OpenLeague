package com.riotgames.pvpnet.system.logging
{
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import com.riotgames.platform.common.RiotServiceConfig;
   import com.riotgames.platform.common.services.ServiceProxy;
   import com.riotgames.platform.common.session.Session;
   import com.riotgames.platform.common.utils.RiotResourceLoader;
   import com.riotgames.platform.gameclient.application.Version;
   import com.riotgames.platform.gameclient.error.MailError;
   import com.riotgames.pvpnet.system.config.ClientConfig;
   import deng.fzip.FZip;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.filesystem.File;
   import flash.filesystem.FileMode;
   import flash.filesystem.FileStream;
   import flash.system.Capabilities;
   import flash.utils.ByteArray;
   import mx.logging.AbstractTarget;
   import mx.logging.ILogger;
   import mx.logging.ILoggingTarget;
   import mx.logging.Log;
   import mx.logging.LogEventLevel;
   import mx.resources.ResourceManager;
   import mx.utils.StringUtil;
   
   public class LogManager
   {
      
      private static var _instance:LogManager;
      
      private static const MILLISECONDS_PER_DAY:Number = 1000 * 60 * 60 * 24;
      
      private static const ZIPPED_LOGS_FILENAME:String = "LoLLogs.zip";
      
      public var clientConfig:ClientConfig = ClientConfig.instance;
      
      public var serviceProxy:ServiceProxy = ServiceProxy.instance;
      
      public var serviceConfig:RiotServiceConfig = RiotServiceConfig.instance;
      
      public var session:Session = Session.instance;
      
      private var logTargets:Array = new Array();
      
      private var proxiedOnError:Function;
      
      private var overridesLoaded:Boolean = false;
      
      private var proxiedOnComplete:Function;
      
      private var _isBusy:Boolean;
      
      private var _isBusyChanged:Signal = new Signal();
      
      private var logger:ILogger = Log.getLogger("com.riotgames.platform.common.utils.LogManager");
      
      private var _logLevel:int;
      
      private var _logFilters:Array;
      
      public function LogManager(param1:SingletonEnforcer)
      {
         super();
      }
      
      public static function get instance() : LogManager
      {
         if(_instance == null)
         {
            _instance = new LogManager(new SingletonEnforcer());
         }
         return _instance;
      }
      
      public static function checkFilters(param1:String, param2:Array) : Boolean
      {
         var _loc3_:String = null;
         var _loc4_:int = -1;
         var _loc5_:uint = 0;
         while(_loc5_ < param2.length)
         {
            _loc3_ = param2[_loc5_];
            _loc4_ = _loc3_.indexOf("*");
            if(_loc4_ == 0)
            {
               return true;
            }
            _loc4_ = param1.length;
            _loc4_ = _loc4_ < 0 ? (_loc4_) : int(_loc4_ - 1);
            if(param1.substring(0,_loc4_) == _loc3_.substring(0,_loc4_))
            {
               return true;
            }
            _loc5_++;
         }
         return false;
      }
      
      public function get isBusy() : Boolean
      {
         return this._isBusy;
      }
      
      public function set isBusy(param1:Boolean) : void
      {
         var _loc2_:Boolean = false;
         if(this._isBusy != param1)
         {
            _loc2_ = this._isBusy;
            this._isBusy = param1;
            this._isBusyChanged.dispatch(_loc2_,param1);
         }
      }
      
      public function getIsBusy() : Boolean
      {
         return this.isBusy;
      }
      
      public function getIsBusyChanged() : ISignal
      {
         return this._isBusyChanged;
      }
      
      public function get logLevel() : int
      {
         return this._logLevel;
      }
      
      public function set logLevel(param1:int) : void
      {
         var _loc2_:AbstractTarget = null;
         this._logLevel = param1;
         for each(_loc2_ in this.logTargets)
         {
            _loc2_.level = param1;
         }
      }
      
      public function setLogLevelByString(param1:String) : void
      {
         if(param1 in LogEventLevel)
         {
            this.logLevel = LogEventLevel[param1];
         }
      }
      
      public function get logFilters() : Array
      {
         return this._logFilters;
      }
      
      public function set logFilters(param1:Array) : void
      {
         var _loc2_:AbstractTarget = null;
         this._logFilters = param1;
         for each(_loc2_ in this.logTargets)
         {
            _loc2_.filters = this._logFilters;
         }
      }
      
      public function addLogTarget(param1:ILoggingTarget) : void
      {
         param1.filters = this._logFilters;
         this.logTargets.push(param1);
         Log.addTarget(param1);
      }
      
      public function assertLogFiltering() : void
      {
         var _loc1_:AbstractTarget = null;
         var _loc2_:Array = null;
         for each(_loc1_ in this.logTargets)
         {
            _loc2_ = _loc1_.filters;
            if(!_loc2_ || _loc2_.length < 3)
            {
               throw new Error("log filtering is in doubt.");
            }
         }
      }
      
      public function logMemorySnapshot() : void
      {
      }
      
      public function submitLogs(param1:String, param2:String, param3:String, param4:Array, param5:Array, param6:Function, param7:Function) : void
      {
         var _loc12_:int = 0;
         this.isBusy = true;
         this.proxiedOnComplete = param6;
         this.proxiedOnError = param7;
         var _loc8_:File = this.zipLogFiles();
         var _loc9_:ByteArray = new ByteArray();
         var _loc10_:FileStream = new FileStream();
         _loc10_.open(_loc8_,FileMode.READ);
         var _loc11_:Boolean = false;
         while(!_loc11_)
         {
            _loc12_ = int(_loc10_.bytesAvailable);
            if(_loc12_ == 0)
            {
               _loc11_ = true;
            }
            else
            {
               _loc10_.readBytes(_loc9_,_loc9_.length,_loc12_);
            }
         }
         _loc10_.close();
         param4 = param4 == null ? new Array() : param4;
         param5 = param5 == null ? new Array() : param5;
         param4.push(_loc9_);
         param5.push(LogManager.ZIPPED_LOGS_FILENAME);
         this.checkOverrides();
         this.serviceProxy.smtpMailService.sendMail(this.clientConfig.mailHost,this.clientConfig.mailPort,param1,this.clientConfig.submitLogsToEmailAddress,param2,this.buildPrependedContent() + param3,param4,param5,this.onMailSentSuccessfully,this.onMailAttemptComplete,this.onMailError);
         this.deleteLogZipFile();
      }
      
      public function submitErrorReport(param1:String, param2:String, param3:Function, param4:Function) : void
      {
         this.isBusy = true;
         this.proxiedOnComplete = param3;
         this.proxiedOnError = param4;
         var _loc5_:String = this.buildPrependedContent() + "\n" + "Summary: " + param1 + "\n\n" + param2;
         this.checkOverrides();
         this.serviceProxy.smtpMailService.sendMail(this.clientConfig.mailHost,this.clientConfig.mailPort,this.clientConfig.submitErrorReportFromEmailAddress,this.clientConfig.submitLogsToEmailAddress,"Error Report: " + param1,_loc5_,null,null,this.onMailSentSuccessfully,this.onMailAttemptComplete,this.onMailError);
      }
      
      private function checkOverrides() : void
      {
         var _loc1_:String = null;
         var _loc2_:String = null;
         var _loc3_:String = null;
         if(!this.overridesLoaded)
         {
            this.overridesLoaded = true;
            _loc1_ = ResourceManager.getInstance().getString(RiotResourceLoader.RESOURCES_STRING,"submitLogsToEmailAddress_override");
            _loc2_ = ResourceManager.getInstance().getString(RiotResourceLoader.RESOURCES_STRING,"mailHost_override");
            _loc3_ = ResourceManager.getInstance().getString(RiotResourceLoader.RESOURCES_STRING,"mailPort_override");
            if(_loc1_ != null && StringUtil.trim(_loc1_).length > 0)
            {
               this.clientConfig.submitLogsToEmailAddress = _loc1_;
            }
            if(_loc2_ != null && StringUtil.trim(_loc2_).length > 0)
            {
               this.clientConfig.mailHost = _loc2_;
            }
            if(_loc3_ != null && StringUtil.trim(_loc3_).length > 0)
            {
               this.clientConfig.mailPort = parseInt(_loc3_);
            }
         }
      }
      
      private function buildPrependedContent() : String
      {
         var _loc1_:Boolean = Capabilities.hasIME;
         var _loc2_:String = Capabilities.os;
         var _loc3_:String = Capabilities.version;
         var _loc4_:String = Boolean(this.session.summoner) ? this.session.summoner.name : "**NotLoggedIn**";
         return "<b>Summoner Name:</b>&nbsp;&nbsp;" + _loc4_ + "<br/>" + "\n" + "<b>Has IME?:</b>&nbsp;&nbsp;" + (_loc1_ ? "Yes" : "No") + "<br/>" + "\n" + "<b>Operating System:</b>&nbsp;&nbsp;" + _loc2_ + "<br/>" + "\n" + "<b>Flash Player Version:</b>&nbsp;&nbsp;" + _loc3_ + "<br/>" + "\n" + "<b>PVP.net Version:</b>&nbsp;&nbsp;" + Version.CURRENT_VERSION + "<br/><br/>" + "\n" + "Message from player:<br/>" + "\n";
      }
      
      public function cleanseLogDirectory() : void
      {
         var appDir:File = null;
         var myVersionDir:File = null;
         var releaseDir:File = null;
         var versionFolders:Array = null;
         var versionFolder:File = null;
         var airLogFolder:File = null;
         var millisecondThreshold:Number = this.clientConfig.logRetentionDays * LogManager.MILLISECONDS_PER_DAY;
         try
         {
            this.forEachLogFile(this.deleteLogFileIfOlderThanThreshold,millisecondThreshold);
            appDir = File.applicationDirectory.resolvePath("..");
            myVersionDir = appDir.resolvePath(appDir.nativePath + "/..");
            releaseDir = myVersionDir.resolvePath(myVersionDir.nativePath + "/..");
            versionFolders = releaseDir.getDirectoryListing();
            for each(versionFolder in versionFolders)
            {
               if(Boolean(versionFolder.isDirectory) && Boolean(versionFolder.name.match(/\d+\.\d+\.\d+\.\d+/)) && versionFolder.name != myVersionDir.name)
               {
                  airLogFolder = versionFolder.resolvePath("deploy/logs");
                  if(airLogFolder.exists)
                  {
                     this.forEachLogFileIn(airLogFolder,["log"],this.deleteLogFileIfOlderThanThreshold,millisecondThreshold);
                  }
               }
            }
         }
         catch(error:Error)
         {
         }
         this.deleteLogZipFile();
      }
      
      private function onMailSentSuccessfully() : void
      {
      }
      
      private function onMailAttemptComplete(param1:Boolean) : void
      {
         this.isBusy = false;
         if(this.proxiedOnComplete != null)
         {
            this.proxiedOnComplete.apply(null,[param1]);
         }
         this.proxiedOnComplete = null;
      }
      
      private function onMailError(param1:MailError) : void
      {
         if(this.proxiedOnError != null)
         {
            this.proxiedOnError.apply(null,[param1]);
         }
         this.proxiedOnError = null;
      }
      
      private function getLogPath() : File
      {
         var stream:FileStream = null;
         var logPath:File = File.applicationDirectory.resolvePath("logs");
         var tempPath:File = logPath.resolvePath(new Date().getTime().toString() + ".log");
         tempPath = new File(tempPath.nativePath);
         try
         {
            stream = new FileStream();
            stream.open(tempPath,FileMode.WRITE);
            stream.close();
            tempPath.deleteFile();
         }
         catch(error:Error)
         {
            stream.close();
            logPath = null;
         }
         if(logPath == null)
         {
            logPath = File.applicationStorageDirectory.resolvePath("logs");
         }
         return logPath;
      }
      
      private function zipLogFiles() : File
      {
         var newFzip:FZip = null;
         var parentDir:File = null;
         var lolDir:File = null;
         var maestroLog:File = null;
         var patcher_lib:File = null;
         var patcher_update:File = null;
         var gameDirectory:File = null;
         var logZipFile:File = null;
         var tmpFile:File = null;
         var fileStream:FileStream = null;
         try
         {
            this.closeCurrentLogFileTargets();
            this.deleteLogZipFile();
            newFzip = new FZip();
            this.forEachLogFile(this.addLogFileToZipIfWithinThreshold,newFzip);
            parentDir = File.applicationDirectory.resolvePath("..");
            lolDir = parentDir.resolvePath(parentDir.nativePath + "/..");
            maestroLog = lolDir.resolvePath("maestro-server.log");
            this.addLogFileToZipIfWithinThreshold(maestroLog,newFzip);
            patcher_lib = lolDir.resolvePath("patcher_lib.log");
            this.addLogFileToZipIfWithinThreshold(patcher_lib,newFzip);
            patcher_update = lolDir.resolvePath("patcher_update.log");
            this.addLogFileToZipIfWithinThreshold(patcher_update,newFzip);
            gameDirectory = lolDir.resolvePath("Game");
            this.addGameDirectoryLogsToZip(gameDirectory,newFzip);
            logZipFile = File.applicationDirectory.resolvePath(LogManager.ZIPPED_LOGS_FILENAME);
            tmpFile = new File(logZipFile.nativePath);
            fileStream = new FileStream();
            fileStream.open(tmpFile,FileMode.WRITE);
            newFzip.serialize(fileStream,true);
            fileStream.close();
         }
         catch(error:Error)
         {
         }
         return logZipFile;
      }
      
      private function forEachLogFile(param1:Function, param2:Object) : void
      {
         var _loc3_:File = File.applicationDirectory.resolvePath("logs");
         this.forEachLogFileIn(_loc3_,["log"],param1,param2);
      }
      
      private function forEachLogFileIn(param1:File, param2:Array, param3:Function, param4:Object) : void
      {
         var _loc6_:File = null;
         if(!param1.exists)
         {
            return;
         }
         var _loc5_:Array = param1.getDirectoryListing();
         for each(_loc6_ in _loc5_)
         {
            if(param2.indexOf(_loc6_.extension) >= 0)
            {
               param3.apply(null,[_loc6_,param4]);
            }
         }
      }
      
      private function deleteLogFileIfOlderThanThreshold(param1:File, param2:Number) : void
      {
         var tmpFile:File = null;
         var file:File = param1;
         var thresholdMilliseconds:Number = param2;
         var currentTime:Number = new Date().getTime();
         var createTime:Number = Number(file.creationDate.time);
         var differenceMilliseconds:Number = currentTime - createTime;
         if(thresholdMilliseconds >= 0 && differenceMilliseconds > thresholdMilliseconds)
         {
            try
            {
               tmpFile = new File(file.nativePath);
               tmpFile.addEventListener(IOErrorEvent.IO_ERROR,this.deleteIOErrorHandler);
               tmpFile.addEventListener(Event.COMPLETE,this.removeDeleteListeners);
               tmpFile.deleteFileAsync();
            }
            catch(error:Error)
            {
               logger.error("LogManager.deleteLogFileIfOlderThanThreshhold: Unable to delete file " + file.nativePath);
            }
         }
      }
      
      private function deleteIOErrorHandler(param1:IOErrorEvent) : void
      {
         var _loc2_:File = param1.target as File;
         if(_loc2_ != null)
         {
            this.logger.error("LogManager.deleteLogFileIfOlderThanThreshhold: Unable to delete file " + _loc2_.nativePath);
            this.removeDeleteListeners(param1);
         }
      }
      
      private function removeDeleteListeners(param1:Event) : void
      {
         var _loc2_:File = param1.target as File;
         if(_loc2_ != null)
         {
            _loc2_.removeEventListener(Event.COMPLETE,this.removeDeleteListeners);
            _loc2_.removeEventListener(IOErrorEvent.IO_ERROR,this.deleteIOErrorHandler);
         }
      }
      
      private function deleteGameLogFile(param1:File, param2:Number) : void
      {
         var _loc5_:String = null;
         var _loc3_:Array = ["r3dlog","netlog"];
         var _loc4_:Boolean = false;
         for each(_loc5_ in _loc3_)
         {
            if(param1.name.indexOf(_loc5_) != -1)
            {
               _loc4_ = true;
               break;
            }
         }
         if(_loc4_)
         {
            this.deleteLogFileIfOlderThanThreshold(param1,param2);
         }
      }
      
      private function addLogFileToZipIfWithinThreshold(param1:File, param2:FZip) : void
      {
         if(param1 == null || !param1.exists)
         {
            return;
         }
         var _loc3_:Number = Number(param1.modificationDate.time);
         var _loc4_:Number = new Date().getTime();
         var _loc5_:Number = _loc4_ - _loc3_;
         var _loc6_:Number = this.clientConfig.logSubmissionDays * LogManager.MILLISECONDS_PER_DAY;
         if(_loc6_ > 0 && _loc5_ > _loc6_)
         {
            return;
         }
         var _loc7_:FileStream = new FileStream();
         _loc7_.open(param1,FileMode.READ);
         var _loc8_:ByteArray = new ByteArray();
         _loc7_.readBytes(_loc8_);
         param2.addFile(param1.name,_loc8_);
         _loc7_.close();
      }
      
      private function deleteLogZipFile() : void
      {
         var _loc1_:File = File.applicationDirectory.resolvePath(LogManager.ZIPPED_LOGS_FILENAME);
         if(!_loc1_.exists)
         {
            return;
         }
         var _loc2_:File = new File(_loc1_.nativePath);
         _loc2_.deleteFile();
      }
      
      private function addGameDirectoryLogsToZip(param1:File, param2:FZip) : void
      {
         var _loc4_:File = null;
         if(!param1.exists)
         {
            return;
         }
         var _loc3_:Array = param1.getDirectoryListing();
         for each(_loc4_ in _loc3_)
         {
            if(_loc4_.extension == "log" || _loc4_.extension == "txt")
            {
               this.addLogFileToZipIfWithinThreshold(_loc4_,param2);
            }
         }
      }
      
      private function closeCurrentLogFileTargets() : void
      {
         var _loc1_:AbstractTarget = null;
         var _loc2_:FileTarget = null;
         for each(_loc1_ in this.logTargets)
         {
            if(_loc1_ is FileTarget)
            {
               _loc2_ = _loc1_ as FileTarget;
               _loc2_.closeLogFile();
            }
         }
      }
      
      private function reopenCurrentLogFileTargets() : void
      {
         var _loc1_:AbstractTarget = null;
         var _loc2_:FileTarget = null;
         for each(_loc1_ in this.logTargets)
         {
            if(_loc1_ is FileTarget)
            {
               _loc2_ = _loc1_ as FileTarget;
            }
         }
      }
   }
}

class SingletonEnforcer
{
   
   public function SingletonEnforcer()
   {
      super();
   }
}
