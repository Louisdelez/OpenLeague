package com.riotgames.platform.gameclient.domain
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.collections.ArrayCollection;
   import mx.events.PropertyChangeEvent;
   
   [RemoteClass(alias="com.riotgames.platform.statistics.RecentGames")]
   public class RecentGames implements IEventDispatcher
   {
      
      private var _836030906userId:Number;
      
      private var _1242688843gameStatistics:ArrayCollection;
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      public function RecentGames()
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
      
      public function set userId(param1:Number) : void
      {
         var _loc2_:Object = this._836030906userId;
         if(_loc2_ !== param1)
         {
            this._836030906userId = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"userId",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get userId() : Number
      {
         return this._836030906userId;
      }
      
      public function set gameStatistics(param1:ArrayCollection) : void
      {
         var _loc2_:Object = this._1242688843gameStatistics;
         if(_loc2_ !== param1)
         {
            this._1242688843gameStatistics = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"gameStatistics",_loc2_,param1));
         }
      }
      
      public function toString() : String
      {
         var _loc1_:String = "";
         _loc1_ += "userId=" + this.userId;
         return _loc1_ + (":gameStatistics count=" + (this.gameStatistics == null ? 0 : this.gameStatistics.length));
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._bindingEventDispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this._bindingEventDispatcher.removeEventListener(param1,param2,param3);
      }
      
      [Bindable(event="propertyChange")]
      public function get gameStatistics() : ArrayCollection
      {
         return this._1242688843gameStatistics;
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.willTrigger(param1);
      }
   }
}

