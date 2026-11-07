package com.riotgames.platform.common.utils.file
{
   import flash.filesystem.File;
   import flash.filesystem.FileMode;
   import flash.filesystem.FileStream;
   import mx.logging.ILogger;
   import mx.logging.Log;
   
   public class GameIniFile
   {
      
      private static const commentChar:String = ";";
      
      private var filename:String;
      
      private var data:GameCfgData;
      
      private var logger:ILogger = Log.getLogger("com.riotgames.platform.gameclient.utils.file.IniReader");
      
      public function GameIniFile()
      {
         super();
      }
      
      public function getData() : GameCfgData
      {
         return this.data;
      }
      
      public function initializeFromData(param1:String, param2:GameCfgData) : void
      {
         this.data = param2;
         this.filename = param1;
      }
      
      public function setValue(param1:String, param2:String, param3:String) : void
      {
         this.data.setValue(param1,param2,param3);
      }
      
      private function readFile() : void
      {
         var _loc5_:String = null;
         var _loc1_:File = File.applicationDirectory.resolvePath(this.filename);
         var _loc2_:File = File.applicationStorageDirectory.resolvePath(_loc1_.nativePath);
         var _loc3_:String = _loc2_.nativePath;
         var _loc4_:FileStream = new FileStream();
         if(_loc2_.exists)
         {
            _loc4_.open(_loc2_,FileMode.READ);
            _loc5_ = _loc4_.readUTFBytes(_loc4_.bytesAvailable);
            _loc4_.close();
            this.data = new GameCfgData();
            this.data.parse(_loc5_);
         }
         else
         {
            this.logger.warn("IniReader.readFile: File " + this.filename + " not found at " + _loc3_);
         }
      }
      
      public function initializeFromFile(param1:String) : void
      {
         this.data = new GameCfgData();
         this.filename = param1;
         this.readFile();
      }
      
      public function readValue(param1:String, param2:String, param3:String) : String
      {
         return this.data.readValue(param1,param2,param3);
      }
      
      public function save() : void
      {
         var _loc1_:File = File.applicationDirectory.resolvePath(this.filename);
         var _loc2_:File = File.applicationStorageDirectory.resolvePath(_loc1_.nativePath);
         var _loc3_:String = _loc2_.nativePath;
         var _loc4_:FileStream = new FileStream();
         _loc4_.open(_loc2_,FileMode.WRITE);
         var _loc5_:String = this.data.render();
         _loc4_.writeUTFBytes(_loc5_);
         _loc4_.close();
      }
   }
}

