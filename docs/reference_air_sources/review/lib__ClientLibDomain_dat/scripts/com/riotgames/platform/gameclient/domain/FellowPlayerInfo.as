package com.riotgames.platform.gameclient.domain
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.events.PropertyChangeEvent;
   import mx.utils.RPCObjectUtil;
   
   [RemoteClass(alias="com.riotgames.platform.statistics.FellowPlayerInfo")]
   public class FellowPlayerInfo implements IEventDispatcher
   {
      
      private var _1537709924championId:Number;
      
      private var _80971529summonerId:Number;
      
      private var _877713320teamId:Number;
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      public function FellowPlayerInfo()
      {
         super();
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return this._bindingEventDispatcher.dispatchEvent(param1);
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
      
      [Bindable(event="propertyChange")]
      public function get summonerId() : Number
      {
         return this._80971529summonerId;
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this._bindingEventDispatcher.removeEventListener(param1,param2,param3);
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._bindingEventDispatcher.addEventListener(param1,param2,param3,param4,param5);
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
      
      public function willTrigger(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.willTrigger(param1);
      }
      
      [Bindable(event="propertyChange")]
      public function get teamId() : Number
      {
         return this._877713320teamId;
      }
      
      [Bindable(event="propertyChange")]
      public function get championId() : Number
      {
         return this._1537709924championId;
      }
      
      public function toString() : String
      {
         return RPCObjectUtil.toString(this);
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.hasEventListener(param1);
      }
      
      public function set teamId(param1:Number) : void
      {
         var _loc2_:Object = this._877713320teamId;
         if(_loc2_ !== param1)
         {
            this._877713320teamId = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"teamId",_loc2_,param1));
         }
      }
   }
}

