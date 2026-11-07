package com.riotgames.platform.gameclient.domain
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.events.PropertyChangeEvent;
   
   [RemoteClass(alias="com.riotgames.platform.statistics.PlayerStatSummary")]
   public class PlayerStatSummary extends AbstractDomainObject implements IEventDispatcher
   {
      
      private var _836030906userId:Number;
      
      private var _623138783maxRating:int = 0;
      
      private var _1106736996leaves:int = 0;
      
      private var _1210904456modifyDate:Date;
      
      private var _1096968431losses:int = 0;
      
      private var _938102371rating:int = 0;
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      private var _3649559wins:int = 0;
      
      private var _893031445playerStatSummaryType:String;
      
      private var _640804122aggregatedStats:SummaryAggStats;
      
      public function PlayerStatSummary()
      {
         super();
      }
      
      public function isType(param1:String) : Boolean
      {
         return this.playerStatSummaryType == param1;
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.willTrigger(param1);
      }
      
      [Bindable(event="propertyChange")]
      public function get modifyDate() : Date
      {
         return this._1210904456modifyDate;
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
      
      public function set modifyDate(param1:Date) : void
      {
         var _loc2_:Object = this._1210904456modifyDate;
         if(_loc2_ !== param1)
         {
            this._1210904456modifyDate = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"modifyDate",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get losses() : int
      {
         return this._1096968431losses;
      }
      
      [Bindable(event="propertyChange")]
      public function get wins() : int
      {
         return this._3649559wins;
      }
      
      [Bindable(event="propertyChange")]
      public function get leaves() : int
      {
         return this._1106736996leaves;
      }
      
      [Bindable(event="propertyChange")]
      public function get maxRating() : int
      {
         return this._623138783maxRating;
      }
      
      public function set losses(param1:int) : void
      {
         var _loc2_:Object = this._1096968431losses;
         if(_loc2_ !== param1)
         {
            this._1096968431losses = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"losses",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get rating() : int
      {
         return this._938102371rating;
      }
      
      [Bindable(event="propertyChange")]
      public function get aggregatedStats() : SummaryAggStats
      {
         return this._640804122aggregatedStats;
      }
      
      public function set wins(param1:int) : void
      {
         var _loc2_:Object = this._3649559wins;
         if(_loc2_ !== param1)
         {
            this._3649559wins = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"wins",_loc2_,param1));
         }
      }
      
      public function set aggregatedStats(param1:SummaryAggStats) : void
      {
         var _loc2_:Object = this._640804122aggregatedStats;
         if(_loc2_ !== param1)
         {
            this._640804122aggregatedStats = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"aggregatedStats",_loc2_,param1));
         }
      }
      
      public function set leaves(param1:int) : void
      {
         var _loc2_:Object = this._1106736996leaves;
         if(_loc2_ !== param1)
         {
            this._1106736996leaves = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"leaves",_loc2_,param1));
         }
      }
      
      public function set rating(param1:int) : void
      {
         var _loc2_:Object = this._938102371rating;
         if(_loc2_ !== param1)
         {
            this._938102371rating = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"rating",_loc2_,param1));
         }
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return this._bindingEventDispatcher.dispatchEvent(param1);
      }
      
      public function set maxRating(param1:int) : void
      {
         var _loc2_:Object = this._623138783maxRating;
         if(_loc2_ !== param1)
         {
            this._623138783maxRating = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"maxRating",_loc2_,param1));
         }
      }
      
      public function getGamesPlayed() : int
      {
         return this.wins + this.losses + this.leaves;
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
      public function get userId() : Number
      {
         return this._836030906userId;
      }
      
      public function set playerStatSummaryType(param1:String) : void
      {
         var _loc2_:Object = this._893031445playerStatSummaryType;
         if(_loc2_ !== param1)
         {
            this._893031445playerStatSummaryType = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"playerStatSummaryType",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get playerStatSummaryType() : String
      {
         return this._893031445playerStatSummaryType;
      }
      
      public function toString() : String
      {
         var _loc1_:String = "";
         _loc1_ += "userId=" + this.userId;
         _loc1_ += ":type=" + this.playerStatSummaryType;
         _loc1_ += ":rating=" + this.rating;
         _loc1_ += ":maxRating=" + this.maxRating;
         _loc1_ += ":wins=" + this.wins;
         _loc1_ += ":losses=" + this.losses;
         _loc1_ += ":leaves=" + this.leaves;
         return _loc1_ + (":modifyDate=" + this.modifyDate);
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.hasEventListener(param1);
      }
   }
}

