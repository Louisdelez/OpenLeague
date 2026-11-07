package com.riotgames.platform.gameclient.domain.gameconfig
{
   import com.riotgames.platform.gameclient.domain.AbstractDomainObject;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.collections.ArrayCollection;
   import mx.events.PropertyChangeEvent;
   
   [RemoteClass(alias="com.riotgames.platform.playerpreference.dto.PlayerPreferencesDto")]
   public class PlayerPreferences extends AbstractDomainObject implements IEventDispatcher
   {
      
      public static const RESPONSE_STATUS_NOT_SE:String = "NOT_SET";
      
      public static const RESPONSE_STATUS_SUCCESS:String = "SUCCESS";
      
      public static const RESPONSE_STATUS_SERVER_ERROR:String = "SERVER_ERROR";
      
      public static const RESPONSE_STATUS_RETRY:String = "RETRY";
      
      public static const RESPONSE_STATUS_RETRY_THROTTLED:String = "RETRY_THROTTLED";
      
      private var _1989861112preferences:ArrayCollection;
      
      private var _351608024version:int;
      
      private var _1609594047enabled:Boolean;
      
      private var _996046724preferenceKey:String;
      
      private var _96459667responseStatus:String;
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      private var _55126294timestamp:Number;
      
      public function PlayerPreferences()
      {
         super();
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return this._bindingEventDispatcher.dispatchEvent(param1);
      }
      
      [Bindable(event="propertyChange")]
      public function get enabled() : Boolean
      {
         return this._1609594047enabled;
      }
      
      public function set enabled(param1:Boolean) : void
      {
         var _loc2_:Object = this._1609594047enabled;
         if(_loc2_ !== param1)
         {
            this._1609594047enabled = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"enabled",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get preferenceKey() : String
      {
         return this._996046724preferenceKey;
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.willTrigger(param1);
      }
      
      public function set preferenceKey(param1:String) : void
      {
         var _loc2_:Object = this._996046724preferenceKey;
         if(_loc2_ !== param1)
         {
            this._996046724preferenceKey = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"preferenceKey",_loc2_,param1));
         }
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this._bindingEventDispatcher.removeEventListener(param1,param2,param3);
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._bindingEventDispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      [Bindable(event="propertyChange")]
      public function get responseStatus() : String
      {
         return this._96459667responseStatus;
      }
      
      [Bindable(event="propertyChange")]
      public function get timestamp() : Number
      {
         return this._55126294timestamp;
      }
      
      [Bindable(event="propertyChange")]
      public function get version() : int
      {
         return this._351608024version;
      }
      
      public function set timestamp(param1:Number) : void
      {
         var _loc2_:Object = this._55126294timestamp;
         if(_loc2_ !== param1)
         {
            this._55126294timestamp = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"timestamp",_loc2_,param1));
         }
      }
      
      public function set responseStatus(param1:String) : void
      {
         var _loc2_:Object = this._96459667responseStatus;
         if(_loc2_ !== param1)
         {
            this._96459667responseStatus = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"responseStatus",_loc2_,param1));
         }
      }
      
      public function set version(param1:int) : void
      {
         var _loc2_:Object = this._351608024version;
         if(_loc2_ !== param1)
         {
            this._351608024version = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"version",_loc2_,param1));
         }
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.hasEventListener(param1);
      }
      
      public function set preferences(param1:ArrayCollection) : void
      {
         var _loc2_:Object = this._1989861112preferences;
         if(_loc2_ !== param1)
         {
            this._1989861112preferences = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"preferences",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get preferences() : ArrayCollection
      {
         return this._1989861112preferences;
      }
   }
}

