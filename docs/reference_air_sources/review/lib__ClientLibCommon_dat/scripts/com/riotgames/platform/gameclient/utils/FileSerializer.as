package com.riotgames.platform.gameclient.utils
{
   import flash.filesystem.File;
   import flash.filesystem.FileMode;
   import flash.filesystem.FileStream;
   import flash.utils.Dictionary;
   import mx.logging.ILogger;
   import mx.logging.Log;
   import mx.utils.StringUtil;
   
   public class FileSerializer
   {
      
      private static var _instance:FileSerializer;
      
      private static var logger:ILogger = Log.getLogger("com.riotgames.platform.gameclient.utils.FileSerializer");
      
      public function FileSerializer()
      {
         super();
      }
      
      public static function get instance() : FileSerializer
      {
         if(_instance == null)
         {
            _instance = new FileSerializer();
         }
         return _instance;
      }
      
      public function readObjectFromFile(param1:String) : Object
      {
         var file:File = null;
         var obj:Object = null;
         var fileStream:FileStream = null;
         var fname:String = param1;
         try
         {
            file = File.applicationStorageDirectory.resolvePath(fname);
            if(file.exists)
            {
               fileStream = new FileStream();
               fileStream.open(file,FileMode.READ);
               obj = fileStream.readObject();
               fileStream.close();
               return obj;
            }
         }
         catch(e:Error)
         {
            logger.error("Unable to read file: " + fname);
         }
         return null;
      }
      
      public function loadTextPreferences(param1:File, param2:Boolean) : Dictionary
      {
         var propertiesArray:Array;
         var propertiesMap:Dictionary;
         var path:String = null;
         var property:String = null;
         var fStream:FileStream = null;
         var contents:String = null;
         var keyValueSeparatorIndex:int = 0;
         var key:String = null;
         var value:String = null;
         var file:File = param1;
         var optional:Boolean = param2;
         path = file.nativePath;
         if(!file.exists)
         {
            if(!optional)
            {
               logger.error("Properties file not found: " + path);
            }
            return null;
         }
         propertiesArray = null;
         try
         {
            fStream = new FileStream();
            fStream.open(file,FileMode.READ);
            contents = fStream.readUTFBytes(fStream.bytesAvailable);
            propertiesArray = contents.split(File.lineEnding);
            fStream.close();
         }
         catch(streamError:Error)
         {
            logger.error("Properties file could not be read: " + path);
            logger.error(streamError.toString());
            return null;
         }
         propertiesMap = new Dictionary();
         for each(property in propertiesArray)
         {
            property = StringUtil.trim(property);
            keyValueSeparatorIndex = property.indexOf("=");
            if(keyValueSeparatorIndex > 0)
            {
               key = property.substring(0,keyValueSeparatorIndex);
               value = property.substring(keyValueSeparatorIndex);
               value = StringUtil.trim(value);
               if(value.length > 1)
               {
                  propertiesMap[key] = value.substring(1);
               }
            }
         }
         return propertiesMap;
      }
      
      public function writeObjectToFile(param1:Object, param2:String) : void
      {
         var file:File = null;
         var fileStream:FileStream = null;
         var object:Object = param1;
         var fname:String = param2;
         try
         {
            file = File.applicationStorageDirectory.resolvePath(fname);
            fileStream = new FileStream();
            fileStream.open(file,FileMode.WRITE);
            fileStream.writeObject(object);
            fileStream.close();
         }
         catch(e:Error)
         {
            logger.error("Unable to write file: " + fname);
         }
      }
      
      public function saveTextPreferences(param1:String, param2:Dictionary) : void
      {
         var iterKey:String = null;
         var file:File = null;
         var iterValue:String = null;
         var fStream:FileStream = null;
         var fname:String = param1;
         var propertiesMap:Dictionary = param2;
         var propertiesArray:Array = [];
         for(iterKey in propertiesMap)
         {
            iterValue = propertiesMap[iterKey];
            if(iterValue != null && iterValue.length > 0 && StringUtil.trim(iterValue).length > 0)
            {
               propertiesArray.push(iterKey + "=" + iterValue);
            }
         }
         file = File.applicationStorageDirectory.resolvePath(fname);
         try
         {
            fStream = new FileStream();
            fStream.open(file,FileMode.WRITE);
            fStream.writeUTFBytes(propertiesArray.join(File.lineEnding));
            fStream.close();
         }
         catch(streamError:Error)
         {
            logger.error("Properties file could not be saved: " + file.nativePath);
            logger.error(streamError.toString());
         }
      }
   }
}

