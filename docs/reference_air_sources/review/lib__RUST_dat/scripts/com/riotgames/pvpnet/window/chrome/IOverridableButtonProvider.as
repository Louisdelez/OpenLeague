package com.riotgames.pvpnet.window.chrome
{
   import blix.assets.proxy.DisplayObjectProxy;
   
   public interface IOverridableButtonProvider
   {
      
      function registerPlayButtonCallback(param1:Function, param2:DisplayObjectProxy, param3:Boolean = false) : void;
      
      function registerPlayButtonCallbackAndLabel(param1:Function, param2:String, param3:DisplayObjectProxy, param4:Boolean = false) : void;
      
      function setButtonCallbackEnabled(param1:Function, param2:Boolean) : void;
      
      function unregisterPlayButtonCallback(param1:Function) : Boolean;
      
      function replacePlayButton(param1:DisplayObjectProxy, param2:DisplayObjectProxy, param3:Boolean = false) : void;
      
      function removePlayButtonReplacement(param1:DisplayObjectProxy) : Boolean;
   }
}

