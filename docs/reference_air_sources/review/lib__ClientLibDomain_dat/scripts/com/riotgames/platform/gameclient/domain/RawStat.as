package com.riotgames.platform.gameclient.domain
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.collections.ArrayCollection;
   import mx.events.PropertyChangeEvent;
   import mx.utils.RPCObjectUtil;
   
   [RemoteClass(alias="com.riotgames.platform.statistics.RawStat")]
   public class RawStat extends AbstractDomainObject implements IEventDispatcher
   {
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      private var _1714148973displayName:String;
      
      private var _1317715886statType:String;
      
      private var _111972721value:Number;
      
      public function RawStat()
      {
         super();
      }
      
      public static function getRawStat(param1:String, param2:ArrayCollection) : RawStat
      {
         var _loc4_:RawStat = null;
         var _loc3_:RawStat = null;
         for each(_loc4_ in param2)
         {
            if(_loc4_.statType == param1)
            {
               _loc3_ = _loc4_;
               break;
            }
         }
         return _loc3_;
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return this._bindingEventDispatcher.dispatchEvent(param1);
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.willTrigger(param1);
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this._bindingEventDispatcher.removeEventListener(param1,param2,param3);
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._bindingEventDispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      public function get statTypeName() : String
      {
         return this.statType;
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
      
      public function set statType(param1:String) : void
      {
         var _loc2_:Object = this._1317715886statType;
         if(_loc2_ !== param1)
         {
            this._1317715886statType = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"statType",_loc2_,param1));
         }
      }
      
      public function set value(param1:Number) : void
      {
         var _loc2_:Object = this._111972721value;
         if(_loc2_ !== param1)
         {
            this._111972721value = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"value",_loc2_,param1));
         }
      }
      
      public function toString() : String
      {
         return RPCObjectUtil.toString(this);
      }
      
      [Bindable(event="propertyChange")]
      public function get displayName() : String
      {
         return this._1714148973displayName;
      }
      
      [Bindable(event="propertyChange")]
      public function get statType() : String
      {
         return this._1317715886statType;
      }
      
      [Bindable(event="propertyChange")]
      public function get value() : Number
      {
         return this._111972721value;
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.hasEventListener(param1);
      }
      
      public function get description() : String
      {
         return this.statType;
      }
   }
}

