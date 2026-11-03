package com.riotgames.platform.common.view
{
   import blix.signals.ISignal;
   import flash.display.DisplayObject;
   
   public interface IInternalBrowserAction
   {
      
      function add(param1:String, param2:Boolean, param3:Array, param4:DisplayObject, param5:int, param6:int) : void;
      
      function addMaxAndCenter(param1:String, param2:Boolean, param3:Array) : void;
      
      function remove() : void;
      
      function getBrowserClosed() : ISignal;
   }
}

