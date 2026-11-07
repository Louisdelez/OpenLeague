package com.riotgames.platform.gameclient.domain
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.collections.ArrayCollection;
   import mx.events.PropertyChangeEvent;
   
   [RemoteClass(alias="com.riotgames.platform.summoner.SummonerSummary")]
   public class SummonerSummary implements IEventDispatcher
   {
      
      private var _80146712internalName:String;
      
      private var _3649559wins:Number;
      
      private var _3373707name:String;
      
      private var _581949073playerStatSummaries:PlayerStatSummaries;
      
      private var _192252332socialNetworkUserIds:ArrayCollection;
      
      private var _1106736996leaves:Number;
      
      private var _1096968431losses:Number;
      
      private var _1827029976accountId:Number;
      
      private var _102865796level:Number;
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      public function SummonerSummary()
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
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this._bindingEventDispatcher.removeEventListener(param1,param2,param3);
      }
      
      [Bindable(event="propertyChange")]
      public function get name() : String
      {
         return this._3373707name;
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._bindingEventDispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      public function set level(param1:Number) : void
      {
         var _loc2_:Object = this._102865796level;
         if(_loc2_ !== param1)
         {
            this._102865796level = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"level",_loc2_,param1));
         }
      }
      
      public function set accountId(param1:Number) : void
      {
         var _loc2_:Object = this._1827029976accountId;
         if(_loc2_ !== param1)
         {
            this._1827029976accountId = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"accountId",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get losses() : Number
      {
         return this._1096968431losses;
      }
      
      [Bindable(event="propertyChange")]
      public function get level() : Number
      {
         return this._102865796level;
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.willTrigger(param1);
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
      
      public function set internalName(param1:String) : void
      {
         var _loc2_:Object = this._80146712internalName;
         if(_loc2_ !== param1)
         {
            this._80146712internalName = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"internalName",_loc2_,param1));
         }
      }
      
      public function set socialNetworkUserIds(param1:ArrayCollection) : void
      {
         var _loc2_:Object = this._192252332socialNetworkUserIds;
         if(_loc2_ !== param1)
         {
            this._192252332socialNetworkUserIds = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"socialNetworkUserIds",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get wins() : Number
      {
         return this._3649559wins;
      }
      
      public function set losses(param1:Number) : void
      {
         var _loc2_:Object = this._1096968431losses;
         if(_loc2_ !== param1)
         {
            this._1096968431losses = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"losses",_loc2_,param1));
         }
      }
      
      public function set playerStatSummaries(param1:PlayerStatSummaries) : void
      {
         var _loc2_:Object = this._581949073playerStatSummaries;
         if(_loc2_ !== param1)
         {
            this._581949073playerStatSummaries = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"playerStatSummaries",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get accountId() : Number
      {
         return this._1827029976accountId;
      }
      
      [Bindable(event="propertyChange")]
      public function get socialNetworkUserIds() : ArrayCollection
      {
         return this._192252332socialNetworkUserIds;
      }
      
      public function set wins(param1:Number) : void
      {
         var _loc2_:Object = this._3649559wins;
         if(_loc2_ !== param1)
         {
            this._3649559wins = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"wins",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get internalName() : String
      {
         return this._80146712internalName;
      }
      
      [Bindable(event="propertyChange")]
      public function get playerStatSummaries() : PlayerStatSummaries
      {
         return this._581949073playerStatSummaries;
      }
      
      [Bindable(event="propertyChange")]
      public function get leaves() : Number
      {
         return this._1106736996leaves;
      }
      
      public function set leaves(param1:Number) : void
      {
         var _loc2_:Object = this._1106736996leaves;
         if(_loc2_ !== param1)
         {
            this._1106736996leaves = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"leaves",_loc2_,param1));
         }
      }
   }
}

