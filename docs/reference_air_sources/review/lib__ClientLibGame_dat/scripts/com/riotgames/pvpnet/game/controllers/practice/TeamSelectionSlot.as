package com.riotgames.pvpnet.game.controllers.practice
{
   import com.riotgames.platform.gameclient.domain.GameParticipant;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.events.PropertyChangeEvent;
   
   public class TeamSelectionSlot implements IEventDispatcher
   {
      
      private var _3575610type:String;
      
      private var _1756614291slotOrdinal:int = 0;
      
      private var _767422259participant:GameParticipant;
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      public function TeamSelectionSlot(param1:String)
      {
         super();
         this.type = param1;
      }
      
      [Bindable(event="propertyChange")]
      public function get type() : String
      {
         return this._3575610type;
      }
      
      public function set type(param1:String) : void
      {
         var _loc2_:Object = this._3575610type;
         if(_loc2_ !== param1)
         {
            this._3575610type = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"type",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get slotOrdinal() : int
      {
         return this._1756614291slotOrdinal;
      }
      
      public function set slotOrdinal(param1:int) : void
      {
         var _loc2_:Object = this._1756614291slotOrdinal;
         if(_loc2_ !== param1)
         {
            this._1756614291slotOrdinal = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"slotOrdinal",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get participant() : GameParticipant
      {
         return this._767422259participant;
      }
      
      public function set participant(param1:GameParticipant) : void
      {
         var _loc2_:Object = this._767422259participant;
         if(_loc2_ !== param1)
         {
            this._767422259participant = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"participant",_loc2_,param1));
            }
         }
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._bindingEventDispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return this._bindingEventDispatcher.dispatchEvent(param1);
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.hasEventListener(param1);
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this._bindingEventDispatcher.removeEventListener(param1,param2,param3);
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.willTrigger(param1);
      }
   }
}

