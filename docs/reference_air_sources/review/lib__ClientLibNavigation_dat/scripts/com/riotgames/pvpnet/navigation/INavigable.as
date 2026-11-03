package com.riotgames.pvpnet.navigation
{
   import flash.net.URLVariables;
   
   public interface INavigable
   {
      
      function setParameters(param1:URLVariables) : void;
      
      function setPath(param1:String) : void;
   }
}

