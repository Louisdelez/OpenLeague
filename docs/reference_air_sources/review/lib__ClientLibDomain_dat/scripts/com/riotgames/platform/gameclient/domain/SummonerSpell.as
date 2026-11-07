package com.riotgames.platform.gameclient.domain
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.events.PropertyChangeEvent;
   
   [RemoteClass(alias="com.riotgames.platform.summoner.SummonerSpell")]
   public class SummonerSpell implements IEventDispatcher
   {
      
      private var _950481995comp_id:SummonerSpellPK;
      
      private var _109642024spell:Spell;
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      public function SummonerSpell()
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
      
      public function willTrigger(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.willTrigger(param1);
      }
      
      [Bindable(event="propertyChange")]
      public function get spell() : Spell
      {
         return this._109642024spell;
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this._bindingEventDispatcher.removeEventListener(param1,param2,param3);
      }
      
      [Bindable(event="propertyChange")]
      public function get comp_id() : SummonerSpellPK
      {
         return this._950481995comp_id;
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._bindingEventDispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      public function set spell(param1:Spell) : void
      {
         var _loc2_:Object = this._109642024spell;
         if(_loc2_ !== param1)
         {
            this._109642024spell = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"spell",_loc2_,param1));
         }
      }
      
      public function set comp_id(param1:SummonerSpellPK) : void
      {
         var _loc2_:Object = this._950481995comp_id;
         if(_loc2_ !== param1)
         {
            this._950481995comp_id = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"comp_id",_loc2_,param1));
         }
      }
   }
}

