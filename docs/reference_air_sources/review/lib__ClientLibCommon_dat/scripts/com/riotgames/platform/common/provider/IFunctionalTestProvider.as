package com.riotgames.platform.common.provider
{
   import com.riotgames.platform.provider.IProvider;
   import flash.display.DisplayObjectContainer;
   
   public interface IFunctionalTestProvider extends IProvider
   {
      
      function registerCucumberSteps(param1:Array) : void;
      
      function get environmentAvailable() : Boolean;
      
      function getTransparentDisplayRoot() : DisplayObjectContainer;
      
      function set environmentAvailable(param1:Boolean) : void;
      
      function getDisplayRoot() : DisplayObjectContainer;
   }
}

