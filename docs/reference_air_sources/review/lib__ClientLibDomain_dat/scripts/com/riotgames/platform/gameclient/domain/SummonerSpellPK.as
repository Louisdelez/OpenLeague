package com.riotgames.platform.gameclient.domain
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.events.PropertyChangeEvent;
   
   [RemoteClass(alias="com.riotgames.platform.summoner.SummonerSpellPK")]
   public class SummonerSpellPK implements IEventDispatcher
   {
      
      private var _109797574sumId:Number;
      
      private var _2008194973spellId:int;
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      public function SummonerSpellPK()
      {
         super();
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return this._bindingEventDispatcher.dispatchEvent(param1);
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.hasEventListener(param1);
      }
      
      [Bindable(event="propertyChange")]
      public function get spellId() : int
      {
         return this._2008194973spellId;
      }
      
      [Bindable(event="propertyChange")]
      public function get sumId() : Number
      {
         return this._109797574sumId;
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.willTrigger(param1);
      }
      
      public function set sumId(param1:Number) : void
      {
         var _loc2_:Object = this._109797574sumId;
         if(_loc2_ !== param1)
         {
            this._109797574sumId = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"sumId",_loc2_,param1));
         }
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._bindingEventDispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this._bindingEventDispatcher.removeEventListener(param1,param2,param3);
      }
      
      public function set spellId(param1:int) : void
      {
         var _loc2_:Object = this._2008194973spellId;
         if(_loc2_ !== param1)
         {
            this._2008194973spellId = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"spellId",_loc2_,param1));
         }
      }
   }
}

