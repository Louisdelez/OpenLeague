package com.riotgames.platform.gameclient.module.services.utils
{
   import com.riotgames.platform.common.RiotServiceConfig;
   import flash.filesystem.File;
   import flash.filesystem.FileMode;
   import flash.filesystem.FileStream;
   import hr.binaria.asx3m.Asx3mer;
   import mx.rpc.events.ResultEvent;
   
   public class ServicesPersistenceUtils
   {
      
      public function ServicesPersistenceUtils()
      {
         super();
      }
      
      private static function getRpcFilePath(param1:String) : String
      {
         return getRpcObjectDirectory() + File.separator + param1;
      }
      
      private static function saveResultToDisk(param1:String, param2:Object, param3:Boolean) : void
      {
         var _loc5_:File = null;
         var _loc6_:String = null;
         var _loc7_:File = null;
         var _loc8_:FileStream = null;
         var _loc4_:Date = new Date();
         if(param2 != null)
         {
            if(param2 is ResultEvent)
            {
               param2 = (param2 as ResultEvent).result;
            }
            _loc5_ = new File();
            _loc6_ = getRpcObjectDirectory();
            _loc5_.nativePath = _loc6_;
            if(!_loc5_.exists)
            {
               _loc5_.createDirectory();
            }
            _loc6_ = getRpcFilePath(param1);
            _loc7_ = new File();
            _loc7_.nativePath = _loc6_;
            _loc8_ = new FileStream();
            _loc8_.open(_loc7_,FileMode.WRITE);
            marshallResult(_loc8_,param2,param3);
            _loc8_.close();
         }
      }
      
      private static function marshallResult(param1:FileStream, param2:Object, param3:Boolean) : void
      {
         var _loc4_:XML = null;
         var _loc5_:String = null;
         if(param3)
         {
            param1.writeObject(param2);
         }
         else
         {
            _loc4_ = Asx3mer.instance.toXML(param2);
            _loc5_ = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>" + _loc4_.toXMLString();
            param1.writeUTFBytes(_loc5_);
         }
      }
      
      public static function onSuccessWrapper(param1:String, param2:RiotServiceConfig, param3:Function) : Function
      {
         var updateCache:Boolean = false;
         var saveInBinary:Boolean = false;
         var destination:String = param1;
         var config:RiotServiceConfig = param2;
         var onSuccess:Function = param3;
         updateCache = Boolean(config.updateCache);
         saveInBinary = Boolean(config.binaryCache);
         return function(param1:Object):void
         {
            if(updateCache)
            {
               saveResultToDisk(destination,param1,saveInBinary);
            }
            if(onSuccess != null)
            {
               onSuccess.apply(null,[param1]);
            }
         };
      }
      
      private static function getRpcObjectDirectory() : String
      {
         return File.userDirectory.nativePath + File.separator + "rpc-objects";
      }
   }
}

