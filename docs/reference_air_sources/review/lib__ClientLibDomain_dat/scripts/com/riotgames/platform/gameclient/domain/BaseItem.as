package com.riotgames.platform.gameclient.domain
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.collections.ArrayCollection;
   import mx.events.PropertyChangeEvent;
   
   [RemoteClass(alias="com.riotgames.platform.catalog.BaseItem")]
   public class BaseItem extends AbstractDomainObject implements IEventDispatcher
   {
      
      private var _1769659137gameCode:int;
      
      private var _1714148973displayName:String = "**RuneName";
      
      private var _3373707name:String;
      
      private var _1927121519itemEffects:ArrayCollection;
      
      private var _872782374displayDescription:String = "**RuneDesc";
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      private var _3599308uses:int;
      
      private var _1992012396duration:int;
      
      private var _3559906tier:int;
      
      private var _1724546052description:String;
      
      private var _1178662002itemId:int;
      
      private var _1140107293toolTip:String;
      
      private var _1721484885baseType:String;
      
      public function BaseItem()
      {
         super();
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
      public function get name() : String
      {
         return this._3373707name;
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
      
      public function set name(param1:String) : void
      {
         var _loc2_:Object = this._3373707name;
         if(_loc2_ !== param1)
         {
            this._3373707name = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"name",_loc2_,param1));
         }
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
      
      public function set displayDescription(param1:String) : void
      {
         var _loc2_:Object = this._872782374displayDescription;
         if(_loc2_ !== param1)
         {
            this._872782374displayDescription = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"displayDescription",_loc2_,param1));
         }
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return this._bindingEventDispatcher.dispatchEvent(param1);
      }
      
      public function set tier(param1:int) : void
      {
         var _loc2_:Object = this._3559906tier;
         if(_loc2_ !== param1)
         {
            this._3559906tier = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"tier",_loc2_,param1));
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
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._bindingEventDispatcher.addEventListener(param1,param2,param3,param4,param5);
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
      
      public function set displayName(param1:String) : void
      {
         var _loc2_:Object = this._1714148973displayName;
         if(_loc2_ !== param1)
         {
            this._1714148973displayName = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"displayName",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get tier() : int
      {
         return this._3559906tier;
      }
      
      [Bindable(event="propertyChange")]
      public function get toolTip() : String
      {
         return this._1140107293toolTip;
      }
      
      [Bindable(event="propertyChange")]
      public function get displayDescription() : String
      {
         return this._872782374displayDescription;
      }
      
      [Bindable(event="propertyChange")]
      public function get displayName() : String
      {
         return this._1714148973displayName;
      }
      
      [Bindable(event="propertyChange")]
      public function get itemEffects() : ArrayCollection
      {
         return this._1927121519itemEffects;
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

