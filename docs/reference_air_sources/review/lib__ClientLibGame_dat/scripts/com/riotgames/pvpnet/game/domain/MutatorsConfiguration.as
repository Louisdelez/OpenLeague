package com.riotgames.pvpnet.game.domain
{
   import com.riotgames.pvpnet.system.config.cdc.ConfigurationModel;
   import com.riotgames.pvpnet.system.config.cdc.DynamicClientConfigManager;
   import com.riotgames.util.json.jsonDecode;
   import com.riotgames.util.string.RiotStringUtil;
   import mx.logging.ILogger;
   import mx.logging.Log;
   
   public class MutatorsConfiguration
   {
      
      public static const NAMESPACE:String = "Mutators";
      
      public static const ENABLED_MUTATORS:String = "EnabledMutators";
      
      public static const ENABLED_MODES:String = "EnabledModes";
      
      private static var LOGGER:ILogger = Log.getLogger("com.riotgames.pvpnet.game.domain.MutatorsConfigurationEnum");
      
      public function MutatorsConfiguration()
      {
         super();
      }
      
      public static function isConfigurationEnabled(param1:String, param2:String) : Boolean
      {
         var _loc5_:String = null;
         var _loc3_:ConfigurationModel = DynamicClientConfigManager.getConfiguration(MutatorsConfiguration.NAMESPACE,param1,false);
         var _loc4_:Array = _loc3_.getValue() as Array;
         if(_loc4_ == null && _loc3_.getValue() is String)
         {
            _loc4_ = parseJsonStringArray(_loc3_.getString());
            _loc3_.setValue(_loc4_,false);
         }
         if(_loc4_ != null)
         {
            for each(_loc5_ in _loc4_)
            {
               if(param2 == _loc5_)
               {
                  return true;
               }
            }
         }
         return false;
      }
      
      private static function parseJsonStringArray(param1:String) : Array
      {
         var jsonString:String = param1;
         var stringArray:Array = [];
         if(!RiotStringUtil.isEmpty(jsonString) && jsonString != "[]")
         {
            try
            {
               stringArray = jsonDecode(jsonString) as Array;
            }
            catch(error:Error)
            {
               LOGGER.error("Garbled dynamic configuration: " + error.toString());
            }
         }
         return stringArray;
      }
   }
}

