package com.riotgames.pvpnet.system.config.cdc
{
   public interface IConfigurationRegistry
   {
      
      function registerConfigurationModel(param1:ConfigurationModel) : void;
      
      function getConfigurationModel(param1:String, param2:String) : ConfigurationModel;
      
      function removeConfigurationModel(param1:String, param2:String) : void;
   }
}

