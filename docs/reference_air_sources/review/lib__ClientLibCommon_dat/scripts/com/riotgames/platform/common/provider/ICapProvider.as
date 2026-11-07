package com.riotgames.platform.common.provider
{
   import com.riotgames.platform.provider.IProvider;
   import mx.core.UIComponent;
   
   public interface ICapProvider extends IProvider
   {
      
      function set contentHolder(param1:UIComponent) : void;
      
      function isModuleActive() : Boolean;
      
      function quit(param1:Function = null, param2:Function = null) : void;
   }
}

