package com.riotgames.platform.gameclient.domain
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.events.PropertyChangeEvent;
   
   [RemoteClass(alias="com.riotgames.platform.summoner.spellbook.SpellBookPageRunePK")]
   public class SpellBookPageRunePK implements IEventDispatcher
   {
      
      private var _995752950pageId:Number;
      
      private var _491418397summonerRuneId:Number;
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      public function SpellBookPageRunePK()
      {
         super();
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.hasEventListener(param1);
      }
      
      [Bindable(event="propertyChange")]
      public function get summonerRuneId() : Number
      {
         return this._491418397summonerRuneId;
      }
      
      [Bindable(event="propertyChange")]
      public function get pageId() : Number
      {
         return this._995752950pageId;
      }
      
      public function set summonerRuneId(param1:Number) : void
      {
         var _loc2_:Object = this._491418397summonerRuneId;
         if(_loc2_ !== param1)
         {
            this._491418397summonerRuneId = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"summonerRuneId",_loc2_,param1));
         }
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return this._bindingEventDispatcher.dispatchEvent(param1);
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this._bindingEventDispatcher.removeEventListener(param1,param2,param3);
      }
      
      public function set pageId(param1:Number) : void
      {
         var _loc2_:Object = this._995752950pageId;
         if(_loc2_ !== param1)
         {
            this._995752950pageId = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"pageId",_loc2_,param1));
         }
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.willTrigger(param1);
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._bindingEventDispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
   }
}

