package com.degrafa.core
{
   import flash.events.IEventDispatcher;
   
   public interface IDegrafaObject extends IEventDispatcher
   {
      
      function set suppressEventProcessing(param1:Boolean) : void;
      
      function set parent(param1:IDegrafaObject) : void;
      
      function dispatchPropertyChange(param1:Boolean = false, param2:Object = null, param3:Object = null, param4:Object = null, param5:Object = null) : Boolean;
      
      function set enableEvents(param1:Boolean) : void;
      
      function get parent() : IDegrafaObject;
      
      function get enableEvents() : Boolean;
      
      function get hasEventManager() : Boolean;
      
      function get suppressEventProcessing() : Boolean;
   }
}

