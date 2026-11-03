package com.degrafa.states
{
   import flash.events.EventDispatcher;
   import mx.events.FlexEvent;
   
   public class State extends EventDispatcher
   {
      
      public var overrides:Array = [];
      
      public var name:String;
      
      public var basedOn:String;
      
      private var initialized:Boolean = false;
      
      public var stateManager:StateManager;
      
      public function State()
      {
         super();
      }
      
      public function initialize() : void
      {
         var _loc1_:int = 0;
         if(!initialized)
         {
            initialized = true;
            _loc1_ = 0;
            while(_loc1_ < overrides.length)
            {
               overrides[_loc1_].initialize();
               _loc1_++;
            }
         }
      }
      
      public function dispatchExitState() : void
      {
         dispatchEvent(new FlexEvent(FlexEvent.EXIT_STATE));
      }
      
      public function dispatchEnterState() : void
      {
         dispatchEvent(new FlexEvent(FlexEvent.ENTER_STATE));
      }
   }
}

