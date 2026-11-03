package com.riotgames.pvpnet.system.messaging
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   
   public class ShellDispatcher
   {
      
      private static var _instance:ShellDispatcher;
      
      private var _dispatcher:IEventDispatcher;
      
      public function ShellDispatcher()
      {
         super();
         this._dispatcher = new EventDispatcher();
      }
      
      public static function get instance() : ShellDispatcher
      {
         if(_instance == null)
         {
            _instance = new ShellDispatcher();
         }
         return _instance;
      }
      
      public function addEventListener(param1:String, param2:Function) : void
      {
         this._dispatcher.addEventListener(param1,param2,false,0,true);
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return this._dispatcher.dispatchEvent(param1);
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this._dispatcher.hasEventListener(param1);
      }
      
      public function removeEventListener(param1:String, param2:Function) : void
      {
         this._dispatcher.removeEventListener(param1,param2,false);
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return this._dispatcher.willTrigger(param1);
      }
      
      public function asDispatcher() : IEventDispatcher
      {
         return this._dispatcher;
      }
      
      public function set dispatcher(param1:IEventDispatcher) : void
      {
         this._dispatcher = param1;
      }
   }
}

