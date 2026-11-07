package com.riotgames.pvpnet.CLS.localeHelper
{
   public interface ILocaleHelper
   {
      
      function localeLookup(param1:String, param2:Array = null) : String;
      
      function externalLocaleLookup(param1:String, param2:String, param3:Array = null) : String;
      
      function getLeagueName(param1:String) : String;
   }
}

