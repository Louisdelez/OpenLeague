package com.riotgames.platform.gameclient.domain
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.events.PropertyChangeEvent;
   
   [RemoteClass(alias="com.riotgames.platform.summoner.spellbook.SpellBookPageRune")]
   public class SpellBookPageRune implements IEventDispatcher
   {
      
      private var _950481995comp_id:SpellBookPageRunePK;
      
      private var _summonerRune:SummonerRune;
      
      private var _820693080runeSlot:RuneSlot;
      
      private var _1476276832spellBookPage:SpellBookPageDTO;
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      public function SpellBookPageRune()
      {
         super();
      }
      
      private function set _504516008summonerRune(param1:SummonerRune) : void
      {
         var _loc2_:int = 0;
         if(param1 == null)
         {
            _loc2_ = 1;
         }
         this._summonerRune = param1;
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.willTrigger(param1);
      }
      
      public function set spellBookPage(param1:SpellBookPageDTO) : void
      {
         var _loc2_:Object = this._1476276832spellBookPage;
         if(_loc2_ !== param1)
         {
            this._1476276832spellBookPage = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"spellBookPage",_loc2_,param1));
         }
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this._bindingEventDispatcher.removeEventListener(param1,param2,param3);
      }
      
      [Bindable(event="propertyChange")]
      public function get comp_id() : SpellBookPageRunePK
      {
         return this._950481995comp_id;
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._bindingEventDispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      [Bindable(event="propertyChange")]
      public function set summonerRune(param1:SummonerRune) : void
      {
         var _loc2_:Object = this.summonerRune;
         if(_loc2_ !== param1)
         {
            this._504516008summonerRune = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"summonerRune",_loc2_,param1));
         }
      }
      
      public function set comp_id(param1:SpellBookPageRunePK) : void
      {
         var _loc2_:Object = this._950481995comp_id;
         if(_loc2_ !== param1)
         {
            this._950481995comp_id = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"comp_id",_loc2_,param1));
         }
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return this._bindingEventDispatcher.dispatchEvent(param1);
      }
      
      [Bindable(event="propertyChange")]
      public function get spellBookPage() : SpellBookPageDTO
      {
         return this._1476276832spellBookPage;
      }
      
      public function get summonerRune() : SummonerRune
      {
         return this._summonerRune;
      }
      
      public function set runeSlot(param1:RuneSlot) : void
      {
         var _loc2_:Object = this._820693080runeSlot;
         if(_loc2_ !== param1)
         {
            this._820693080runeSlot = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"runeSlot",_loc2_,param1));
         }
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.hasEventListener(param1);
      }
      
      [Bindable(event="propertyChange")]
      public function get runeSlot() : RuneSlot
      {
         return this._820693080runeSlot;
      }
   }
}

