package com.riotgames.pvpnet.system.config.cdc
{
   public class ConfigurationRegistry implements IConfigurationRegistry
   {
      
      private var _registry:Array = [];
      
      public function ConfigurationRegistry()
      {
         super();
      }
      
      public function registerConfigurationModel(param1:ConfigurationModel) : void
      {
         var _loc2_:String = this.assembleKey(param1.getNamespace(),param1.getKey());
         this._registry[_loc2_] = param1;
      }
      
      public function getConfigurationModel(param1:String, param2:String) : ConfigurationModel
      {
         var _loc3_:String = this.assembleKey(param1,param2);
         return ConfigurationModel(this._registry[_loc3_]);
      }
      
      public function removeConfigurationModel(param1:String, param2:String) : void
      {
         var _loc3_:String = this.assembleKey(param1,param2);
         delete this._registry[_loc3_];
      }
      
      private function assembleKey(param1:String, param2:String) : String
      {
         return param1 + "." + param2;
      }
   }
}

