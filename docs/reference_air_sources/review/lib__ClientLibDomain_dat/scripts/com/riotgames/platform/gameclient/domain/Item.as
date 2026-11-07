package com.riotgames.platform.gameclient.domain
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.collections.ArrayCollection;
   import mx.events.PropertyChangeEvent;
   
   [RemoteClass(alias="com.riotgames.platform.summoner.Item")]
   public class Item implements IEventDispatcher
   {
      
      private var _1769659137gameCode:int;
      
      private var _3373707name:String;
      
      private var _1927121519itemEffects:ArrayCollection;
      
      private var _1177533677itemType:ItemType;
      
      private var _1386076078minLevel:int;
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      private var _3599308uses:int;
      
      private var _1992012396duration:int;
      
      private var _1724546052description:String;
      
      private var _3559906tier:Number;
      
      private var _318080732itemStatcodeRequirements:ArrayCollection;
      
      private var _1178662002itemId:int;
      
      private var _1063908180minTier:int;
      
      private var _1140107293toolTip:String;
      
      private var _149663550uniqueEffect:String;
      
      private var _1531276898minWinLossRatio:Number;
      
      private var _1721484885baseType:String;
      
      public function Item()
      {
         super();
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.hasEventListener(param1);
      }
      
      [Bindable(event="propertyChange")]
      public function get itemType() : ItemType
      {
         return this._1177533677itemType;
      }
      
      [Bindable(event="propertyChange")]
      public function get itemEffects() : ArrayCollection
      {
         return this._1927121519itemEffects;
      }
      
      public function isSameType(param1:Item, param2:Boolean = true) : Boolean
      {
         var _loc3_:Boolean = param1 != null && param1.itemType != null && this.itemType.name == param1.itemType.name;
         return _loc3_ && (param2 ? this.itemId != param1.itemId : true);
      }
      
      [Bindable(event="propertyChange")]
      public function get name() : String
      {
         return this._3373707name;
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.willTrigger(param1);
      }
      
      public function set uniqueEffect(param1:String) : void
      {
         var _loc2_:Object = this._149663550uniqueEffect;
         if(_loc2_ !== param1)
         {
            this._149663550uniqueEffect = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"uniqueEffect",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get duration() : int
      {
         return this._1992012396duration;
      }
      
      [Bindable(event="propertyChange")]
      public function get itemId() : int
      {
         return this._1178662002itemId;
      }
      
      public function set uses(param1:int) : void
      {
         var _loc2_:Object = this._3599308uses;
         if(_loc2_ !== param1)
         {
            this._3599308uses = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"uses",_loc2_,param1));
         }
      }
      
      public function set itemId(param1:int) : void
      {
         var _loc2_:Object = this._1178662002itemId;
         if(_loc2_ !== param1)
         {
            this._1178662002itemId = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"itemId",_loc2_,param1));
         }
      }
      
      public function set name(param1:String) : void
      {
         var _loc2_:Object = this._3373707name;
         if(_loc2_ !== param1)
         {
            this._3373707name = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"name",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get minWinLossRatio() : Number
      {
         return this._1531276898minWinLossRatio;
      }
      
      public function set minLevel(param1:int) : void
      {
         var _loc2_:Object = this._1386076078minLevel;
         if(_loc2_ !== param1)
         {
            this._1386076078minLevel = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"minLevel",_loc2_,param1));
         }
      }
      
      public function set duration(param1:int) : void
      {
         var _loc2_:Object = this._1992012396duration;
         if(_loc2_ !== param1)
         {
            this._1992012396duration = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"duration",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get baseType() : String
      {
         return this._1721484885baseType;
      }
      
      public function set minTier(param1:int) : void
      {
         var _loc2_:Object = this._1063908180minTier;
         if(_loc2_ !== param1)
         {
            this._1063908180minTier = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"minTier",_loc2_,param1));
         }
      }
      
      public function set minWinLossRatio(param1:Number) : void
      {
         var _loc2_:Object = this._1531276898minWinLossRatio;
         if(_loc2_ !== param1)
         {
            this._1531276898minWinLossRatio = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"minWinLossRatio",_loc2_,param1));
         }
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return this._bindingEventDispatcher.dispatchEvent(param1);
      }
      
      [Bindable(event="propertyChange")]
      public function get uniqueEffect() : String
      {
         return this._149663550uniqueEffect;
      }
      
      public function set tier(param1:Number) : void
      {
         var _loc2_:Object = this._3559906tier;
         if(_loc2_ !== param1)
         {
            this._3559906tier = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"tier",_loc2_,param1));
         }
      }
      
      public function set itemStatcodeRequirements(param1:ArrayCollection) : void
      {
         var _loc2_:Object = this._318080732itemStatcodeRequirements;
         if(_loc2_ !== param1)
         {
            this._318080732itemStatcodeRequirements = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"itemStatcodeRequirements",_loc2_,param1));
         }
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this._bindingEventDispatcher.removeEventListener(param1,param2,param3);
      }
      
      [Bindable(event="propertyChange")]
      public function get uses() : int
      {
         return this._3599308uses;
      }
      
      public function set toolTip(param1:String) : void
      {
         var _loc2_:Object = this._1140107293toolTip;
         if(_loc2_ !== param1)
         {
            this._1140107293toolTip = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"toolTip",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get itemStatcodeRequirements() : ArrayCollection
      {
         return this._318080732itemStatcodeRequirements;
      }
      
      [Bindable(event="propertyChange")]
      public function get minLevel() : int
      {
         return this._1386076078minLevel;
      }
      
      [Bindable(event="propertyChange")]
      public function get minTier() : int
      {
         return this._1063908180minTier;
      }
      
      public function set baseType(param1:String) : void
      {
         var _loc2_:Object = this._1721484885baseType;
         if(_loc2_ !== param1)
         {
            this._1721484885baseType = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"baseType",_loc2_,param1));
         }
      }
      
      public function set itemEffects(param1:ArrayCollection) : void
      {
         var _loc2_:Object = this._1927121519itemEffects;
         if(_loc2_ !== param1)
         {
            this._1927121519itemEffects = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"itemEffects",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get toolTip() : String
      {
         return this._1140107293toolTip;
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._bindingEventDispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      public function set itemType(param1:ItemType) : void
      {
         var _loc2_:Object = this._1177533677itemType;
         if(_loc2_ !== param1)
         {
            this._1177533677itemType = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"itemType",_loc2_,param1));
         }
      }
      
      public function set description(param1:String) : void
      {
         var _loc2_:Object = this._1724546052description;
         if(_loc2_ !== param1)
         {
            this._1724546052description = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"description",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get tier() : Number
      {
         return this._3559906tier;
      }
      
      [Bindable(event="propertyChange")]
      public function get description() : String
      {
         return this._1724546052description;
      }
      
      public function set gameCode(param1:int) : void
      {
         var _loc2_:Object = this._1769659137gameCode;
         if(_loc2_ !== param1)
         {
            this._1769659137gameCode = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"gameCode",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get gameCode() : int
      {
         return this._1769659137gameCode;
      }
   }
}

