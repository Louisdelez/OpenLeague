package com.riotgames.platform.gameclient.module.services.lcds
{
   import com.riotgames.platform.common.exception.PlatformException;
   import com.riotgames.platform.gameclient.domain.gameconfig.PlayerPreferences;
   import com.riotgames.platform.gameclient.exception.GameException;
   import com.riotgames.platform.gameclient.services.PlayerPreferencesService;
   import flash.utils.Dictionary;
   
   public class PlayerPreferencesServiceImpl extends BaseLcdsService implements PlayerPreferencesService
   {
      
      public function PlayerPreferencesServiceImpl()
      {
         super();
      }
      
      private function getErrorMap(param1:Function) : Dictionary
      {
         var _loc2_:Dictionary = new Dictionary();
         _loc2_[GameException] = param1;
         _loc2_[PlatformException] = param1;
         return _loc2_;
      }
      
      public function loadPreferences(param1:String, param2:Number, param3:Boolean, param4:Function, param5:Function, param6:Function) : void
      {
         invokeServiceWithoutSession("playerPreferencesService","loadPreferencesByKey",[param1,param2,param3],param4,param5,this.getErrorMap(param6));
      }
      
      public function savePreferences(param1:PlayerPreferences, param2:Function, param3:Function, param4:Function) : void
      {
         invokeServiceWithoutSession("playerPreferencesService","savePreferences",[param1],param2,param3,this.getErrorMap(param4));
      }
      
      public function setEnabled(param1:String, param2:Boolean, param3:Function, param4:Function, param5:Function) : void
      {
         invokeServiceWithoutSession("playerPreferencesService","setEnabled",[param1,param2],param3,param4,this.getErrorMap(param5));
      }
   }
}

