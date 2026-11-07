package com.riotgames.platform.gameclient.domain
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.events.PropertyChangeEvent;
   
   [RemoteClass(alias="com.riotgames.platform.summoner.SummonerDefaultSpells")]
   public class SummonerDefaultSpells extends AbstractDomainObject implements IEventDispatcher
   {
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      private var _116043608spellDefault1:Spell;
      
      private var _80971529summonerId:Number;
      
      private var _116043609spellDefault2:Spell;
      
      public function SummonerDefaultSpells()
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
      
      [Bindable(event="propertyChange")]
      public function get summonerId() : Number
      {
         return this._80971529summonerId;
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._bindingEventDispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this._bindingEventDispatcher.removeEventListener(param1,param2,param3);
      }
      
      [Bindable(event="propertyChange")]
      public function get spellDefault1() : Spell
      {
         return this._116043608spellDefault1;
      }
      
      [Bindable(event="propertyChange")]
      public function get spellDefault2() : Spell
      {
         return this._116043609spellDefault2;
      }
      
      public function set summonerId(param1:Number) : void
      {
         var _loc2_:Object = this._80971529summonerId;
         if(_loc2_ !== param1)
         {
            this._80971529summonerId = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"summonerId",_loc2_,param1));
         }
      }
      
      public function set spellDefault1(param1:Spell) : void
      {
         var _loc2_:Object = this._116043608spellDefault1;
         if(_loc2_ !== param1)
         {
            this._116043608spellDefault1 = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"spellDefault1",_loc2_,param1));
         }
      }
      
      public function set spellDefault2(param1:Spell) : void
      {
         var _loc2_:Object = this._116043609spellDefault2;
         if(_loc2_ !== param1)
         {
            this._116043609spellDefault2 = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"spellDefault2",_loc2_,param1));
         }
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.hasEventListener(param1);
      }
   }
}

