package com.riotgames.platform.gameclient.controllers.game
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   
   public class EventQueue extends EventDispatcher
   {
      
      public static const EVENT_NEW_STATE_ENTERED:String = "newState";
      
      private var stateStack:Array = null;
      
      private var currentState:EventState = null;
      
      public function EventQueue()
      {
         super();
      }
      
      public function skipToEnd() : void
      {
         if(this.currentState != null)
         {
            if(this.currentState.onExit != null)
            {
               this.currentState.onExit();
            }
            this.currentState = null;
         }
         this.stateStack = new Array();
      }
      
      protected function cleanUp() : void
      {
      }
      
      private function stateStackEmptied() : void
      {
      }
      
      public function pushNewState(param1:Function, param2:Function) : void
      {
         var _loc3_:EventState = new EventState(param1,param2);
         this.stateStack.push(_loc3_);
      }
      
      public function clear() : void
      {
         if(this.currentState != null)
         {
            if(this.currentState.onExit != null)
            {
               this.currentState.onExit();
            }
            this.currentState = null;
         }
         this.cleanUp();
         this.stateStack = [];
      }
      
      public function advanceState() : void
      {
         if(this.currentState != null)
         {
            if(this.currentState.onExit != null)
            {
               this.currentState.onExit();
            }
            this.cleanUp();
         }
         if(this.stateStack.length > 0)
         {
            this.currentState = this.stateStack.shift() as EventState;
         }
         else
         {
            this.currentState = null;
            this.stateStackEmptied();
         }
         if(this.currentState != null)
         {
            if(this.currentState.onEnter != null)
            {
               this.currentState.onEnter();
               dispatchEvent(new Event(EVENT_NEW_STATE_ENTERED));
            }
         }
      }
   }
}

class EventState
{
   
   public var onEnter:Function = null;
   
   public var onExit:Function = null;
   
   public function EventState(param1:Function, param2:Function)
   {
      super();
      this.onEnter = param1;
      this.onExit = param2;
   }
}
