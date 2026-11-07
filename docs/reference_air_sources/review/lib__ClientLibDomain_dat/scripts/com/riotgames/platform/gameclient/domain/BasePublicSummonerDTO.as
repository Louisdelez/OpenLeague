package com.riotgames.platform.gameclient.domain
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.events.PropertyChangeEvent;
   
   [RemoteClass(alias="com.riotgames.platform.summoner.BasePublicSummonerDTO")]
   public class BasePublicSummonerDTO implements IEventDispatcher
   {
      
      private var _1359356291profileIconId:int;
      
      private var _80146712internalName:String;
      
      private var _3373707name:String;
      
      private var _871602060previousSeasonHighestTier:String;
      
      private var _109797574sumId:Number;
      
      private var _1423447922acctId:Number;
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      public function BasePublicSummonerDTO()
      {
         super();
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return this._bindingEventDispatcher.dispatchEvent(param1);
      }
      
      [Bindable(event="propertyChange")]
      public function get sumId() : Number
      {
         return this._109797574sumId;
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this._bindingEventDispatcher.removeEventListener(param1,param2,param3);
      }
      
      public function set sumId(param1:Number) : void
      {
         var _loc2_:Object = this._109797574sumId;
         if(_loc2_ !== param1)
         {
            this._109797574sumId = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"sumId",_loc2_,param1));
         }
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._bindingEventDispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      [Bindable(event="propertyChange")]
      public function get acctId() : Number
      {
         return this._1423447922acctId;
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
      
      [Bindable(event="propertyChange")]
      public function get name() : String
      {
         return this._3373707name;
      }
      
      [Bindable(event="propertyChange")]
      public function get previousSeasonHighestTier() : String
      {
         return this._871602060previousSeasonHighestTier;
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
      
      public function set previousSeasonHighestTier(param1:String) : void
      {
         var _loc2_:Object = this._871602060previousSeasonHighestTier;
         if(_loc2_ !== param1)
         {
            this._871602060previousSeasonHighestTier = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"previousSeasonHighestTier",_loc2_,param1));
         }
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.willTrigger(param1);
      }
      
      public function set acctId(param1:Number) : void
      {
         var _loc2_:Object = this._1423447922acctId;
         if(_loc2_ !== param1)
         {
            this._1423447922acctId = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"acctId",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get internalName() : String
      {
         return this._80146712internalName;
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.hasEventListener(param1);
      }
      
      public function set profileIconId(param1:int) : void
      {
         var _loc2_:Object = this._1359356291profileIconId;
         if(_loc2_ !== param1)
         {
            this._1359356291profileIconId = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"profileIconId",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get profileIconId() : int
      {
         return this._1359356291profileIconId;
      }
   }
}

