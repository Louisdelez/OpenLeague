package com.riotgames.platform.gameclient.config
{
   import com.riotgames.platform.module.RiotModuleManager;
   import com.riotgames.platform.provider.ProviderModuleInfo;
   import flash.filesystem.File;
   import flash.utils.getQualifiedClassName;
   import mx.logging.ILogger;
   import mx.logging.Log;
   
   public class ProvidersLoader
   {
      
      private var logger:ILogger = Log.getLogger(getQualifiedClassName(this).replace(/::/,"."));
      
      public function ProvidersLoader()
      {
         super();
      }
      
      public function loadProviders(param1:File, param2:Function, param3:Function, param4:Function = null) : void
      {
         var moduleEntriesDao:ModuleEntriesDao;
         var modulesDirectory:File = param1;
         var filterFunction:Function = param2;
         var completedHandler:Function = param3;
         var erredHandler:Function = param4;
         this.logger.info("Loading providers from: " + modulesDirectory.nativePath);
         moduleEntriesDao = new ModuleEntriesDao();
         moduleEntriesDao.getModuleConfigs(modulesDirectory,function(param1:Vector.<ModuleEntry>):void
         {
            var _loc2_:ModuleEntry = null;
            var _loc3_:Vector.<String> = null;
            var _loc4_:ProviderEntry = null;
            var _loc5_:ProviderModuleInfo = null;
            for each(_loc2_ in param1)
            {
               if(!filterFunction(_loc2_))
               {
                  logger.info("Skipping module " + _loc2_.name);
               }
               else
               {
                  logger.info("Found module " + _loc2_.name);
                  _loc3_ = new Vector.<String>();
                  for each(_loc4_ in _loc2_.providers)
                  {
                     _loc3_[_loc3_.length] = _loc4_.interfaceClassName;
                  }
                  _loc5_ = new ProviderModuleInfo(_loc2_.name,_loc2_.modulePath,_loc2_.extraData,_loc3_);
                  RiotModuleManager.addModuleInfo(_loc5_);
                  if(erredHandler != null)
                  {
                     _loc5_.getErred().add(erredHandler);
                  }
               }
            }
            if(completedHandler != null)
            {
               if(completedHandler.length == 0)
               {
                  completedHandler();
               }
               else
               {
                  completedHandler(param1);
               }
            }
         },erredHandler);
      }
   }
}

