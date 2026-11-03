package com.riotgames.platform.gameclient.domain
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.events.PropertyChangeEvent;
   
   [RemoteClass(alias="com.riotgames.platform.summoner.runes.SummonerRune")]
   public class SummonerRune extends AbstractDomainObject implements IEventDispatcher
   {
      
      public static const DATA_FORMAT:String = "SummonerRune";
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      private var _1285004149quantity:int;
      
      private var _919815691runeId:int;
      
      private var _3512122rune:Rune;
      
      private var _147115730usesRem:int;
      
      private var _1844641713purchaseDate:Date;
      
      private var _1477214725currentAvailableQuantity:int;
      
      private var _80971529summonerId:Number;
      
      public function SummonerRune()
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
      
      [Bindable(event="propertyChange")]
      public function get quantity() : int
      {
         return this._1285004149quantity;
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.hasEventListener(param1);
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._bindingEventDispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      [Bindable(event="propertyChange")]
      public function get purchaseDate() : Date
      {
         return this._1844641713purchaseDate;
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this._bindingEventDispatcher.removeEventListener(param1,param2,param3);
      }
      
      public function set quantity(param1:int) : void
      {
         var _loc2_:Object = this._1285004149quantity;
         if(_loc2_ !== param1)
         {
            this._1285004149quantity = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"quantity",_loc2_,param1));
         }
      }
      
      public function set usesRem(param1:int) : void
      {
         var _loc2_:Object = this._147115730usesRem;
         if(_loc2_ !== param1)
         {
            this._147115730usesRem = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"usesRem",_loc2_,param1));
         }
      }
      
      public function set purchaseDate(param1:Date) : void
      {
         var _loc2_:Object = this._1844641713purchaseDate;
         if(_loc2_ !== param1)
         {
            this._1844641713purchaseDate = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"purchaseDate",_loc2_,param1));
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
      public function get usesRem() : int
      {
         return this._147115730usesRem;
      }
      
      public function set runeId(param1:int) : void
      {
         var _loc2_:Object = this._919815691runeId;
         if(_loc2_ !== param1)
         {
            this._919815691runeId = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"runeId",_loc2_,param1));
         }
      }
      
      public function set rune(param1:Rune) : void
      {
         var _loc2_:Object = this._3512122rune;
         if(_loc2_ !== param1)
         {
            this._3512122rune = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"rune",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get runeId() : int
      {
         return this._919815691runeId;
      }
      
      [Bindable(event="propertyChange")]
      public function get rune() : Rune
      {
         return this._3512122rune;
      }
      
      [Bindable(event="propertyChange")]
      public function get currentAvailableQuantity() : int
      {
         return this._1477214725currentAvailableQuantity;
      }
      
      public function recentPurchase() : Boolean
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         if(this.purchaseDate == null)
         {
            return false;
         }
         var _loc1_:Date = new Date();
         _loc2_ = _loc1_.getTime() - this.purchaseDate.getTime();
         _loc3_ = Math.floor(_loc2_ / 60 / 60000);
         return _loc3_ < 48 ? true : false;
      }
      
      public function set currentAvailableQuantity(param1:int) : void
      {
         var _loc2_:Object = this._1477214725currentAvailableQuantity;
         if(_loc2_ !== param1)
         {
            this._1477214725currentAvailableQuantity = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"currentAvailableQuantity",_loc2_,param1));
         }
      }
   }
}

