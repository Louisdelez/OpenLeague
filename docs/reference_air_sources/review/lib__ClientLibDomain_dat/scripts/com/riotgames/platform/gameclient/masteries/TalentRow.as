package com.riotgames.platform.gameclient.masteries
{
   import com.riotgames.platform.gameclient.domain.AbstractDomainObject;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.collections.ArrayCollection;
   import mx.events.PropertyChangeEvent;
   
   [RemoteClass(alias="com.riotgames.platform.summoner.TalentRow")]
   public class TalentRow extends AbstractDomainObject implements IEventDispatcher
   {
      
      private var _768819449tltRowId:int;
      
      private var _1543869177talents:ArrayCollection;
      
      private var _991666338tltGroupId:int;
      
      private var _945771985pointsToActivate:int;
      
      private var _100346066index:int;
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      public function TalentRow()
      {
         super();
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return this._bindingEventDispatcher.dispatchEvent(param1);
      }
      
      [Bindable(event="propertyChange")]
      public function get talents() : ArrayCollection
      {
         return this._1543869177talents;
      }
      
      public function set talents(param1:ArrayCollection) : void
      {
         var _loc2_:Object = this._1543869177talents;
         if(_loc2_ !== param1)
         {
            this._1543869177talents = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"talents",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get pointsToActivate() : int
      {
         return this._945771985pointsToActivate;
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._bindingEventDispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.willTrigger(param1);
      }
      
      [Bindable(event="propertyChange")]
      public function get index() : int
      {
         return this._100346066index;
      }
      
      [Bindable(event="propertyChange")]
      public function get tltGroupId() : int
      {
         return this._991666338tltGroupId;
      }
      
      public function set pointsToActivate(param1:int) : void
      {
         var _loc2_:Object = this._945771985pointsToActivate;
         if(_loc2_ !== param1)
         {
            this._945771985pointsToActivate = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"pointsToActivate",_loc2_,param1));
         }
      }
      
      public function set index(param1:int) : void
      {
         var _loc2_:Object = this._100346066index;
         if(_loc2_ !== param1)
         {
            this._100346066index = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"index",_loc2_,param1));
         }
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this._bindingEventDispatcher.removeEventListener(param1,param2,param3);
      }
      
      public function set tltRowId(param1:int) : void
      {
         var _loc2_:Object = this._768819449tltRowId;
         if(_loc2_ !== param1)
         {
            this._768819449tltRowId = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"tltRowId",_loc2_,param1));
         }
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.hasEventListener(param1);
      }
      
      [Bindable(event="propertyChange")]
      public function get tltRowId() : int
      {
         return this._768819449tltRowId;
      }
      
      public function set tltGroupId(param1:int) : void
      {
         var _loc2_:Object = this._991666338tltGroupId;
         if(_loc2_ !== param1)
         {
            this._991666338tltGroupId = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"tltGroupId",_loc2_,param1));
         }
      }
   }
}

