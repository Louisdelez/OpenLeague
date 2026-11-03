package com.riotgames.platform.gameclient.domain.invite
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.events.PropertyChangeEvent;
   
   public class InviteProperties implements IEventDispatcher
   {
      
      public static const TEAM_SIZE_UNSELECTED:int = -1;
      
      private var _506947444teamSizeIndex:int = -1;
      
      private var _631413252inviteId:String = "";
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      public function InviteProperties()
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
      
      public function set inviteId(param1:String) : void
      {
         var _loc2_:Object = this._631413252inviteId;
         if(_loc2_ !== param1)
         {
            this._631413252inviteId = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"inviteId",_loc2_,param1));
         }
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this._bindingEventDispatcher.removeEventListener(param1,param2,param3);
      }
      
      [Bindable(event="propertyChange")]
      public function get inviteId() : String
      {
         return this._631413252inviteId;
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._bindingEventDispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      public function set teamSizeIndex(param1:int) : void
      {
         var _loc2_:Object = this._506947444teamSizeIndex;
         if(_loc2_ !== param1)
         {
            this._506947444teamSizeIndex = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"teamSizeIndex",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get teamSizeIndex() : int
      {
         return this._506947444teamSizeIndex;
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return this._bindingEventDispatcher.dispatchEvent(param1);
      }
   }
}

