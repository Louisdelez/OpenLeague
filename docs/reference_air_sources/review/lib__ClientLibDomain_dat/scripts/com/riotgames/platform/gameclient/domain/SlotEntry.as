package com.riotgames.platform.gameclient.domain
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.events.PropertyChangeEvent;
   
   [RemoteClass(alias="com.riotgames.platform.summoner.spellbook.SlotEntry")]
   public class SlotEntry extends AbstractDomainObject implements IEventDispatcher
   {
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      private var _rune:Rune;
      
      private var _runeSlot:RuneSlot;
      
      public function SlotEntry()
      {
         super();
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return this._bindingEventDispatcher.dispatchEvent(param1);
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.willTrigger(param1);
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._bindingEventDispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      public function getRuneSlot() : RuneSlot
      {
         return this._runeSlot;
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this._bindingEventDispatcher.removeEventListener(param1,param2,param3);
      }
      
      private function set _919815691runeId(param1:int) : void
      {
         if(Boolean(this._rune))
         {
            throw new Error("Can\'t set the rune id of an existing slot entry!");
         }
         this._rune = new Rune();
         this._rune.itemId = param1;
      }
      
      public function get runeSlotId() : int
      {
         if(Boolean(this._runeSlot))
         {
            return this._runeSlot.id;
         }
         return 0;
      }
      
      public function setRuneSlot(param1:RuneSlot) : void
      {
         this._runeSlot = param1;
      }
      
      private function set _1587930221runeSlotId(param1:int) : void
      {
         if(Boolean(this._runeSlot))
         {
            throw new Error("Can\'t set the slot id of an existing slot entry!");
         }
         this._runeSlot = new RuneSlot();
         this._runeSlot.id = param1;
      }
      
      [Bindable(event="propertyChange")]
      public function set runeSlotId(param1:int) : void
      {
         var _loc2_:Object = this.runeSlotId;
         if(_loc2_ !== param1)
         {
            this._1587930221runeSlotId = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"runeSlotId",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function set runeId(param1:int) : void
      {
         var _loc2_:Object = this.runeId;
         if(_loc2_ !== param1)
         {
            this._919815691runeId = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"runeId",_loc2_,param1));
         }
      }
      
      public function getRune() : Rune
      {
         return this._rune;
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.hasEventListener(param1);
      }
      
      public function get runeId() : int
      {
         if(Boolean(this._rune))
         {
            return this._rune.itemId;
         }
         return 0;
      }
      
      public function setRune(param1:Rune) : void
      {
         this._rune = param1;
      }
   }
}

