package com.riotgames.platform.gameclient.domain
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.collections.ArrayCollection;
   import mx.events.PropertyChangeEvent;
   
   [RemoteClass(alias="com.riotgames.leagues.pojo.LeagueListDTO")]
   public class LeagueListDTO implements IEventDispatcher
   {
      
      private var _419789780requestorsName:String;
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      private var _3373707name:String;
      
      private var _419670579requestorsRank:String;
      
      private var _107944209queue:String;
      
      private var _1591573360entries:ArrayCollection;
      
      private var _3559906tier:String;
      
      private var _1167324332maxLeagueSize:Number;
      
      private var _2107809758nextApexUpdate:Number;
      
      public function LeagueListDTO()
      {
         super();
      }
      
      public function set nextApexUpdate(param1:Number) : void
      {
         var _loc2_:Object = this._2107809758nextApexUpdate;
         if(_loc2_ !== param1)
         {
            this._2107809758nextApexUpdate = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"nextApexUpdate",_loc2_,param1));
         }
      }
      
      public function set tier(param1:String) : void
      {
         var _loc2_:Object = this._3559906tier;
         if(_loc2_ !== param1)
         {
            this._3559906tier = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"tier",_loc2_,param1));
         }
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.willTrigger(param1);
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
      
      [Bindable(event="propertyChange")]
      public function get requestorsRank() : String
      {
         return this._419670579requestorsRank;
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return this._bindingEventDispatcher.dispatchEvent(param1);
      }
      
      [Bindable(event="propertyChange")]
      public function get entries() : ArrayCollection
      {
         return this._1591573360entries;
      }
      
      [Bindable(event="propertyChange")]
      public function get queue() : String
      {
         return this._107944209queue;
      }
      
      [Bindable(event="propertyChange")]
      public function get maxLeagueSize() : Number
      {
         return this._1167324332maxLeagueSize;
      }
      
      public function set requestorsName(param1:String) : void
      {
         var _loc2_:Object = this._419789780requestorsName;
         if(_loc2_ !== param1)
         {
            this._419789780requestorsName = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"requestorsName",_loc2_,param1));
         }
      }
      
      public function set requestorsRank(param1:String) : void
      {
         var _loc2_:Object = this._419670579requestorsRank;
         if(_loc2_ !== param1)
         {
            this._419670579requestorsRank = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"requestorsRank",_loc2_,param1));
         }
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
      
      [Bindable(event="propertyChange")]
      public function get nextApexUpdate() : Number
      {
         return this._2107809758nextApexUpdate;
      }
      
      public function set entries(param1:ArrayCollection) : void
      {
         var _loc2_:Object = this._1591573360entries;
         if(_loc2_ !== param1)
         {
            this._1591573360entries = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"entries",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get tier() : String
      {
         return this._3559906tier;
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._bindingEventDispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      public function set maxLeagueSize(param1:Number) : void
      {
         var _loc2_:Object = this._1167324332maxLeagueSize;
         if(_loc2_ !== param1)
         {
            this._1167324332maxLeagueSize = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"maxLeagueSize",_loc2_,param1));
         }
      }
      
      public function set queue(param1:String) : void
      {
         var _loc2_:Object = this._107944209queue;
         if(_loc2_ !== param1)
         {
            this._107944209queue = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"queue",_loc2_,param1));
         }
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.hasEventListener(param1);
      }
      
      [Bindable(event="propertyChange")]
      public function get requestorsName() : String
      {
         return this._419789780requestorsName;
      }
   }
}

