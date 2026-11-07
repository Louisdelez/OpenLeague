package com.riotgames.platform.gameclient.domain
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.events.PropertyChangeEvent;
   
   [RemoteClass(alias="com.riotgames.platform.catalog.champion.ChampionSkinDTO")]
   public class ChampionSkin extends RentableInventoryItem implements IEventDispatcher
   {
      
      private var _35914986freeToPlayReward:Boolean;
      
      private var _lastSelected:Boolean;
      
      private var _900562056skinId:Number;
      
      private var _1799051449stillObtainable:Boolean = true;
      
      private var _isDefault:Boolean;
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      private var _1537709924championId:Number;
      
      private var _106164901owned:Boolean;
      
      private var _isDisabled:Boolean = false;
      
      private var champion:Champion;
      
      public function ChampionSkin(param1:Boolean = false)
      {
         super();
         this._isDefault = param1;
      }
      
      public function getIsDefault() : Boolean
      {
         return this._isDefault;
      }
      
      public function get name() : String
      {
         return this.champion.skinInfo[this.skinId.toString()].name;
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.willTrigger(param1);
      }
      
      public function set stillObtainable(param1:Boolean) : void
      {
         var _loc2_:Object = this._1799051449stillObtainable;
         if(_loc2_ !== param1)
         {
            this._1799051449stillObtainable = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"stillObtainable",_loc2_,param1));
         }
      }
      
      private function set _528878767lastSelected(param1:Boolean) : void
      {
         this._lastSelected = param1;
      }
      
      public function get skinDisabled() : Boolean
      {
         return this._isDisabled;
      }
      
      [Bindable(event="propertyChange")]
      public function set lastSelected(param1:Boolean) : void
      {
         var _loc2_:Object = this.lastSelected;
         if(_loc2_ !== param1)
         {
            this._528878767lastSelected = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"lastSelected",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get owned() : Boolean
      {
         return this._106164901owned;
      }
      
      [Bindable(event="propertyChange")]
      public function set skinIndex(param1:Number) : void
      {
         var _loc2_:Object = this.skinIndex;
         if(_loc2_ !== param1)
         {
            this._2016885077skinIndex = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"skinIndex",_loc2_,param1));
         }
      }
      
      public function get championSkinName() : String
      {
         return this.champion.skinName;
      }
      
      private function set _1410615527skinDisabled(param1:Boolean) : void
      {
         this._isDisabled = param1;
      }
      
      [Bindable(event="propertyChange")]
      public function set skinDisabled(param1:Boolean) : void
      {
         var _loc2_:Object = this.skinDisabled;
         if(_loc2_ !== param1)
         {
            this._1410615527skinDisabled = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"skinDisabled",_loc2_,param1));
         }
      }
      
      public function isAvailable() : Boolean
      {
         return this.owned || this.isRented() || this.skinIndex == 0 || this.freeToPlayReward;
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return this._bindingEventDispatcher.dispatchEvent(param1);
      }
      
      internal function setLastSelected_silent(param1:Boolean) : void
      {
         this._lastSelected = param1;
      }
      
      [Bindable(event="propertyChange")]
      public function get stillObtainable() : Boolean
      {
         return this._1799051449stillObtainable;
      }
      
      public function set championId(param1:Number) : void
      {
         var _loc2_:Object = this._1537709924championId;
         if(_loc2_ !== param1)
         {
            this._1537709924championId = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"championId",_loc2_,param1));
         }
      }
      
      public function set owned(param1:Boolean) : void
      {
         var _loc2_:Object = this._106164901owned;
         if(_loc2_ !== param1)
         {
            this._106164901owned = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"owned",_loc2_,param1));
         }
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._bindingEventDispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      public function set freeToPlayReward(param1:Boolean) : void
      {
         var _loc2_:Object = this._35914986freeToPlayReward;
         if(_loc2_ !== param1)
         {
            this._35914986freeToPlayReward = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"freeToPlayReward",_loc2_,param1));
         }
      }
      
      public function get skinIndex() : Number
      {
         if(Boolean(this.champion.skinInfo) && this.champion.skinInfo[this.skinId.toString()] != null)
         {
            return this.champion.skinInfo[this.skinId.toString()].skinIndex;
         }
         return 0;
      }
      
      public function get lastSelected() : Boolean
      {
         return this._lastSelected;
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this._bindingEventDispatcher.removeEventListener(param1,param2,param3);
      }
      
      public function getChampion() : Champion
      {
         return this.champion;
      }
      
      public function setChampion(param1:Champion) : void
      {
         this.champion = param1;
      }
      
      public function set skinId(param1:Number) : void
      {
         var _loc2_:Object = this._900562056skinId;
         if(_loc2_ !== param1)
         {
            this._900562056skinId = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"skinId",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get freeToPlayReward() : Boolean
      {
         return this._35914986freeToPlayReward;
      }
      
      [Bindable(event="propertyChange")]
      public function get championId() : Number
      {
         return this._1537709924championId;
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.hasEventListener(param1);
      }
      
      [Bindable(event="propertyChange")]
      public function get skinId() : Number
      {
         return this._900562056skinId;
      }
      
      private function set _2016885077skinIndex(param1:Number) : void
      {
         if(Boolean(this.champion.skinInfo) && this.champion.skinInfo[this.skinId.toString()] != null)
         {
            this.champion.skinInfo[this.skinId.toString()].skinIndex = param1;
         }
      }
   }
}

