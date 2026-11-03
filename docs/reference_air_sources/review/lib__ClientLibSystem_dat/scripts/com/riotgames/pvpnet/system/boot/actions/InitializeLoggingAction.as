package com.riotgames.pvpnet.system.boot.actions
{
   import blix.action.BasicAction;
   import com.riotgames.pvpnet.system.logging.FileTarget;
   import com.riotgames.pvpnet.system.logging.LogManager;
   import com.riotgames.pvpnet.system.logging.LogTargetFactory;
   import flash.filesystem.File;
   import flash.filesystem.FileMode;
   import flash.filesystem.FileStream;
   import mx.logging.LogEventLevel;
   import mx.logging.targets.TraceTarget;
   
   public class InitializeLoggingAction extends BasicAction
   {
      
      private var _fileTarget:FileTarget;
      
      private var _traceTarget:TraceTarget;
      
      private var _preferredLogPath:File;
      
      private var _backupLogPath:File;
      
      private var _baseName:String;
      
      private var _factory:LogTargetFactory;
      
      public function InitializeLoggingAction(param1:File, param2:File, param3:LogTargetFactory, param4:String = "")
      {
         super(false);
         this._preferredLogPath = param1;
         this._backupLogPath = param2;
         this._baseName = param4;
         this._factory = param3;
      }
      
      public function get fileTarget() : FileTarget
      {
         return this._fileTarget;
      }
      
      public function get traceTarget() : TraceTarget
      {
         return this._traceTarget;
      }
      
      override protected function doInvocation() : void
      {
         LogManager.instance.logFilters = ["com.*","LolClient*","ChannelSet*"];
         this._traceTarget = this._factory.getTraceTarget();
         this.setupTraceTarget(this._traceTarget);
         LogManager.instance.addLogTarget(this._traceTarget);
         var _loc1_:File = this.getLogPath();
         if(_loc1_ == null)
         {
            err(new Error("InitializeLoggingAction: Primary and secondary log path both unavailable"));
            return;
         }
         this._fileTarget = this.createFileTarget(_loc1_,this._baseName);
         LogManager.instance.addLogTarget(this._fileTarget);
         LogManager.instance.cleanseLogDirectory();
         complete();
      }
      
      private function setupTraceTarget(param1:TraceTarget) : void
      {
         param1.level = LogEventLevel.WARN;
      }
      
      private function createFileTarget(param1:File, param2:String = "") : FileTarget
      {
         param2 = param2 == "" ? "rolfl_log" : param2;
         var _loc3_:FileTarget = this._factory.getFileTarget(param1,param2);
         _loc3_.initialized(null,"file");
         _loc3_.includeDate = true;
         _loc3_.includeTime = true;
         _loc3_.includeCategory = true;
         _loc3_.includeLevel = true;
         _loc3_.level = LogEventLevel.WARN;
         return _loc3_;
      }
      
      private function getLogPath() : File
      {
         var _loc1_:File = this._preferredLogPath;
         if(this.getIsFolderWriteable(this._preferredLogPath))
         {
            return this._preferredLogPath;
         }
         if(this.getIsFolderWriteable(this._backupLogPath))
         {
            return this._backupLogPath;
         }
         return null;
      }
      
      private function getIsFolderWriteable(param1:File) : Boolean
      {
         var stream:FileStream = null;
         var folder:File = param1;
         var tempPath:File = folder.resolvePath("testLog.log");
         tempPath = new File(tempPath.nativePath);
         try
         {
            stream = new FileStream();
            stream.open(tempPath,FileMode.WRITE);
            stream.close();
            tempPath.deleteFile();
            return true;
         }
         catch(error:Error)
         {
            stream.close();
         }
         return false;
      }
      
      override public function destroy() : void
      {
         this._preferredLogPath = null;
         this._backupLogPath = null;
         this._fileTarget = null;
         this._traceTarget = null;
      }
   }
}

