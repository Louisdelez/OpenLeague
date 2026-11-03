package com.riotgames.platform.gameclient.domain
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.collections.ArrayCollection;
   import mx.events.PropertyChangeEvent;
   
   [RemoteClass(alias="com.riotgames.platform.statistics.AggregatedStat")]
   public class AggregatedStat extends AbstractDomainObject implements IEventDispatcher
   {
      
      private var _3355id:Number;
      
      private var _1714148973displayName:String;
      
      private var _1537709924championId:Number;
      
      private var _1317715886statType:String;
      
      private var _type:AggregatedStatType;
      
      private var _1985007172championDisplayName:String;
      
      private var _94851343count:Number;
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      private var _111972721value:Number;
      
      public function AggregatedStat()
      {
         super();
      }
      
      public static function FindAggregatedStat(param1:String, param2:ArrayCollection) : AggregatedStat
      {
         var _loc3_:AggregatedStat = null;
         for each(_loc3_ in param2)
         {
            if(param1 == _loc3_.statType)
            {
               return _loc3_;
            }
         }
         return null;
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
      public function get championDisplayName() : String
      {
         return this._1985007172championDisplayName;
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
      
      public function duplicate() : AggregatedStat
      {
         var _loc1_:AggregatedStat = new AggregatedStat();
         _loc1_.id = this.id;
         _loc1_.value = this.value;
         _loc1_.count = this.count;
         _loc1_.statType = this.statType;
         _loc1_.championId = this.championId;
         _loc1_.championDisplayName = this.championDisplayName;
         _loc1_.displayName = this.displayName;
         return _loc1_;
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._bindingEventDispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      [Bindable(event="propertyChange")]
      public function get count() : Number
      {
         return this._94851343count;
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this._bindingEventDispatcher.removeEventListener(param1,param2,param3);
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.willTrigger(param1);
      }
      
      public function set championDisplayName(param1:String) : void
      {
         var _loc2_:Object = this._1985007172championDisplayName;
         if(_loc2_ !== param1)
         {
            this._1985007172championDisplayName = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"championDisplayName",_loc2_,param1));
         }
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
      
      [Bindable(event="propertyChange")]
      public function get id() : Number
      {
         return this._3355id;
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
      
      public function set count(param1:Number) : void
      {
         var _loc2_:Object = this._94851343count;
         if(_loc2_ !== param1)
         {
            this._94851343count = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"count",_loc2_,param1));
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
      
      [Bindable(event="propertyChange")]
      public function get championId() : Number
      {
         return this._1537709924championId;
      }
      
      [Bindable(event="propertyChange")]
      public function get displayName() : String
      {
         return this._1714148973displayName;
      }
      
      [Bindable(event="propertyChange")]
      public function get value() : Number
      {
         return this._111972721value;
      }
      
      [Bindable(event="propertyChange")]
      public function get statType() : String
      {
         return this._1317715886statType;
      }
      
      public function set id(param1:Number) : void
      {
         var _loc2_:Object = this._3355id;
         if(_loc2_ !== param1)
         {
            this._3355id = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"id",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function set description(param1:String) : void
      {
         var _loc2_:Object = this.description;
         if(_loc2_ !== param1)
         {
            this._1724546052description = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"description",_loc2_,param1));
         }
      }
      
      public function get description() : String
      {
         return this.statType;
      }
      
      private function set _1724546052description(param1:String) : void
      {
      }
      
      public function combine(param1:AggregatedStat) : void
      {
         var _loc2_:Number = NaN;
         if(!this._type)
         {
            this._type = AggregatedStatType.getByName(this.statType);
         }
         if(!this._type)
         {
            return;
         }
         switch(this._type.calcType)
         {
            case AggregatedStatType.TOTAL:
            case AggregatedStatType.INCREMENT:
            case AggregatedStatType.OTHER:
               this.value += param1.value;
               break;
            case AggregatedStatType.AVERAGE:
               _loc2_ = this.value * this.count + param1.value * param1.count;
               this.value = _loc2_ / (this.count + param1.count);
               this.count += param1.count;
               break;
            case AggregatedStatType.MAX:
               this.value = Math.max(this.value,param1.value);
         }
      }
   }
}

