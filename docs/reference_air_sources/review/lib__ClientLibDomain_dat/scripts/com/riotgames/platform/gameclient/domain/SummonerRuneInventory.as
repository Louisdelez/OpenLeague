package com.riotgames.platform.gameclient.domain
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.collections.ArrayCollection;
   import mx.events.PropertyChangeEvent;
   
   [RemoteClass(alias="com.riotgames.platform.summoner.runes.SummonerRuneInventory")]
   public class SummonerRuneInventory extends AbstractDomainObject implements IEventDispatcher
   {
      
      private var _1539872821summonerRunes:ArrayCollection;
      
      private var _532037983dateString:String;
      
      private var _80971529summonerId:Number;
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      public function SummonerRuneInventory()
      {
         super();
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return this._bindingEventDispatcher.dispatchEvent(param1);
      }
      
      public function findSummonerRune(param1:int) : SummonerRune
      {
         var _loc2_:SummonerRune = null;
         for each(_loc2_ in this.summonerRunes)
         {
            if(_loc2_.runeId == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public function addRune(param1:SummonerRune) : void
      {
         var _loc2_:SummonerRune = null;
         for each(_loc2_ in this.summonerRunes)
         {
            if(_loc2_.runeId == param1.runeId)
            {
               if(_loc2_.quantity < param1.quantity)
               {
                  _loc2_.quantity = param1.quantity;
               }
               return;
            }
         }
         this.summonerRunes.addItem(param1);
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
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this._bindingEventDispatcher.removeEventListener(param1,param2,param3);
      }
      
      [Bindable(event="propertyChange")]
      public function get summonerRunes() : ArrayCollection
      {
         return this._1539872821summonerRunes;
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._bindingEventDispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      public function set summonerRunes(param1:ArrayCollection) : void
      {
         var _loc2_:Object = this._1539872821summonerRunes;
         if(_loc2_ !== param1)
         {
            this._1539872821summonerRunes = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"summonerRunes",_loc2_,param1));
         }
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
      
      [Bindable(event="propertyChange")]
      public function get dateString() : String
      {
         return this._532037983dateString;
      }
      
      public function addRuneQunatity(param1:RuneQuantity) : SummonerRune
      {
         var _loc2_:SummonerRune = null;
         var _loc3_:SummonerRune = null;
         for each(_loc2_ in this.summonerRunes)
         {
            if(_loc2_.runeId == param1.runeId)
            {
               _loc2_.quantity += param1.quantity;
               return _loc2_;
            }
         }
         _loc3_ = new SummonerRune();
         _loc3_.runeId = param1.runeId;
         _loc3_.quantity = param1.quantity;
         this.summonerRunes.addItem(_loc3_);
         return _loc3_;
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.hasEventListener(param1);
      }
      
      public function set dateString(param1:String) : void
      {
         var _loc2_:Object = this._532037983dateString;
         if(_loc2_ !== param1)
         {
            this._532037983dateString = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"dateString",_loc2_,param1));
         }
      }
   }
}

