package com.riotgames.platform.gameclient.config
{
   import blix.util.xml.XMLUtils;
   import blix.util.xml.XMLUtilsSparkManifest_4_1;
   import flash.filesystem.File;
   import flash.filesystem.FileMode;
   import flash.filesystem.FileStream;
   
   public class ModuleEntriesDao
   {
      
      public static const MODULE_DESCRIPTOR:String = "info.riotmod";
      
      public static const MODULE_BLACKLIST:Array = ["fale","rds"];
      
      public function ModuleEntriesDao()
      {
         super();
         XMLUtilsSparkManifest_4_1.initialize();
      }
      
      public function getModuleConfigs(param1:File, param2:Function, param3:Function) : void
      {
         var moduleEntries:Vector.<ModuleEntry>;
         var moduleFolder:File = null;
         var moduleDescriptor:File = null;
         var moduleEntry:ModuleEntry = null;
         var fileStream:FileStream = null;
         var contents:String = null;
         var modulesDirectory:File = param1;
         var completedHandler:Function = param2;
         var erredHandler:Function = param3;
         if(!modulesDirectory.exists)
         {
            throw new Error("Modules directory does not exist.");
         }
         moduleEntries = new Vector.<ModuleEntry>();
         for each(moduleFolder in modulesDirectory.getDirectoryListing())
         {
            if(MODULE_BLACKLIST.indexOf(moduleFolder.name) == -1)
            {
               moduleDescriptor = moduleFolder.resolvePath(MODULE_DESCRIPTOR);
               if(moduleDescriptor.exists)
               {
                  moduleEntry = null;
                  fileStream = new FileStream();
                  fileStream.open(moduleDescriptor,FileMode.READ);
                  contents = fileStream.readUTFBytes(fileStream.bytesAvailable);
                  try
                  {
                     moduleEntry = this.unmarshalModule(contents);
                  }
                  catch(error:Error)
                  {
                     erredHandler(error);
                     return;
                  }
                  fileStream.close();
                  moduleEntries[moduleEntries.length] = moduleEntry;
               }
            }
         }
         completedHandler(moduleEntries);
      }
      
      private function unmarshalModule(param1:String) : ModuleEntry
      {
         var _loc2_:XML = new XML(param1);
         return XMLUtils.unmarshal(_loc2_);
      }
   }
}

