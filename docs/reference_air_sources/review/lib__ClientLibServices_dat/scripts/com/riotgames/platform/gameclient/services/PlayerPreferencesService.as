package com.riotgames.platform.gameclient.services
{
   import com.riotgames.platform.gameclient.domain.gameconfig.PlayerPreferences;
   
   public interface PlayerPreferencesService
   {
      
      function loadPreferences(param1:String, param2:Number, param3:Boolean, param4:Function, param5:Function, param6:Function) : void;
      
      function savePreferences(param1:PlayerPreferences, param2:Function, param3:Function, param4:Function) : void;
      
      function setEnabled(param1:String, param2:Boolean, param3:Function, param4:Function, param5:Function) : void;
   }
}

