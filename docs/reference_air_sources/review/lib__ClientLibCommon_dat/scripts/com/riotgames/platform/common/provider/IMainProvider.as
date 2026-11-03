package com.riotgames.platform.common.provider
{
   import com.riotgames.platform.provider.IProvider;
   import flash.display.DisplayObjectContainer;
   import flash.events.Event;
   
   public interface IMainProvider extends IProvider
   {
      
      function showMainView(param1:DisplayObjectContainer, param2:Function) : void;
      
      function onExiting(param1:Event) : void;
      
      function onClosing(param1:Boolean) : void;
      
      function onRestore() : void;
   }
}

