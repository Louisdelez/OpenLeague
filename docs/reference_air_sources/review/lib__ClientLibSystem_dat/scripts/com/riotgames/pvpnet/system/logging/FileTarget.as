package com.riotgames.pvpnet.system.logging
{
   import com.riotgames.pvpnet.system.config.ClientConfig;
   import flash.events.TimerEvent;
   import flash.filesystem.File;
   import flash.filesystem.FileMode;
   import flash.filesystem.FileStream;
   import flash.utils.Timer;
   import mx.logging.targets.LineFormattedTarget;
   
   public class FileTarget extends LineFormattedTarget
   {
      
      private static const DEFAULT_LOG_LOCATION:File = File.applicationStorageDirectory.resolvePath("logs");
      
      private var _logDirectory:File = FileTarget.DEFAULT_LOG_LOCATION;
      
      private var _baseLogFileName:String = "airLog";
      
      private var logFile:File;
      
      private var _logFileStream:FileStream;
      
      private var _cachedMessages:Vector.<String> = new Vector.<String>();
      
      private var _shouldWrite:Boolean;
      
      private var flushTimer:Timer;
      
      private var _flushTimeoutMsecs:uint = 0;
      
      private const _maxCachedMessags:uint = 400;
      
      public function FileTarget(param1:File = null, param2:String = null, param3:uint = 500)
      {
         super();
         if(param1 != null)
         {
            this._logDirectory = param1;
         }
         if(param2 != null)
         {
            this._baseLogFileName = param2;
         }
         this._flushTimeoutMsecs = param3;
         this.flushTimer = new Timer(this._flushTimeoutMsecs,1);
         this.flushTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.flushTimerCompleteHandler);
         ClientConfig.instance.getEnableFileLogTargetChanged().add(this.updateLogState);
         this.updateLogState();
      }
      
      public function getLogDirectory() : File
      {
         return this._logDirectory;
      }
      
      private function updateLogState() : void
      {
         if(ClientConfig.instance.enableFileLogTarget)
         {
            if(this.logFile == null)
            {
               this.createLogFile();
            }
            this._shouldWrite = true;
            this.writeCacheToFile();
         }
         else
         {
            this._shouldWrite = false;
            if(this._logFileStream != null)
            {
               this.closeLogFile();
            }
         }
      }
      
      private function createLogFile() : void
      {
         var _loc1_:Date = new Date();
         var _loc2_:String = this._baseLogFileName;
         _loc2_ += ".";
         _loc2_ += _loc1_.getFullYear().toString();
         var _loc3_:int = _loc1_.getMonth() + 1;
         _loc2_ += _loc3_ < 10 ? "0" + _loc3_ : _loc3_;
         _loc3_ = _loc1_.getDate();
         _loc2_ += _loc3_ < 10 ? "0" + _loc3_ : _loc3_;
         _loc2_ += ".";
         _loc3_ = _loc1_.getHours();
         _loc2_ += _loc3_ < 10 ? "0" + _loc3_ : _loc3_;
         _loc3_ = _loc1_.getMinutes();
         _loc2_ += _loc3_ < 10 ? "0" + _loc3_ : _loc3_;
         _loc3_ = _loc1_.getSeconds();
         _loc2_ += _loc3_ < 10 ? "0" + _loc3_ : _loc3_;
         _loc2_ += ".log";
         var _loc4_:File = this._logDirectory.resolvePath(_loc2_);
         this.logFile = new File(_loc4_.nativePath);
      }
      
      private function openLogFile() : void
      {
         if(this._logFileStream == null)
         {
            this.doOpenLogFile();
         }
         if(this.flushTimer.running)
         {
            this.flushTimer.reset();
         }
         else
         {
            this.flushTimer.start();
         }
      }
      
      private function doOpenLogFile() : void
      {
         try
         {
            this._logFileStream = new FileStream();
            this._logFileStream.open(this.logFile,FileMode.APPEND);
         }
         catch(error:Error)
         {
            throw error;
         }
      }
      
      public function closeLogFile() : void
      {
         try
         {
            if(this._logFileStream != null)
            {
               this._logFileStream.close();
               this._logFileStream = null;
            }
         }
         catch(error:Error)
         {
            throw error;
         }
      }
      
      override §§namespace("http://www.adobe.com/2006/flex/mx/internal") function internalLog(param1:String) : void
      {
         var _loc2_:Object = null;
         var _loc3_:Array = null;
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:Array = null;
         if(SensitiveStrings.mute > 0)
         {
            return;
         }
         for(_loc2_ in SensitiveStrings.sensitiveStrings)
         {
            _loc3_ = SensitiveStrings.sensitiveStrings[_loc2_];
            for each(_loc4_ in _loc3_)
            {
               _loc5_ = String(_loc2_[_loc4_]);
               if(_loc5_ != null && _loc5_.length >= 4)
               {
                  _loc6_ = param1.split(_loc5_);
                  param1 = _loc6_.join("#######");
               }
            }
         }
         if(this._shouldWrite)
         {
            this.logToFile(param1);
         }
         else
         {
            this.logToCache(param1);
         }
      }
      
      private function logToFile(param1:String) : void
      {
         var message:String = param1;
         this.openLogFile();
         try
         {
            this._logFileStream.writeUTFBytes(message + "\r\n");
         }
         catch(error:Error)
         {
         }
      }
      
      private function logToCache(param1:String) : void
      {
         this._cachedMessages.push(param1);
         if(this._cachedMessages.length > this._maxCachedMessags)
         {
            this._cachedMessages.shift();
         }
      }
      
      private function writeCacheToFile() : void
      {
         var _loc1_:String = null;
         for each(_loc1_ in this._cachedMessages)
         {
            this.logToFile(_loc1_);
         }
      }
      
      protected function flushTimerCompleteHandler(param1:TimerEvent) : void
      {
         this.closeLogFile();
         this.flushTimer.stop();
      }
   }
}

