package com.riotgames.platform.gameclient.domain
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.collections.ArrayCollection;
   import mx.events.PropertyChangeEvent;
   
   [RemoteClass(alias="com.riotgames.platform.statistics.PlayerStatSummaries")]
   public class PlayerStatSummaries extends AbstractDomainObject implements IEventDispatcher
   {
      
      private static const WINS:String = "WINS";
      
      private static const LEAVES:String = "LEAVES";
      
      private static const LOSSES:String = "LOSSES";
      
      private static const DEFAULT_RATING:int = 1200;
      
      private var _860093039playerStatSummarySet:ArrayCollection;
      
      private var _836030906userId:Number;
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      public function PlayerStatSummaries()
      {
         super();
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return this._bindingEventDispatcher.dispatchEvent(param1);
      }
      
      private function findNotNull(param1:String) : PlayerStatSummary
      {
         return this.find(PlayerStatSummaryType.convert(param1),true);
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.hasEventListener(param1);
      }
      
      public function getTotalWins() : int
      {
         return this.getAggregation(WINS);
      }
      
      public function getTotalGamesPlayed() : int
      {
         return this.getTotalWins() + this.getTotalLosses() + this.getTotalLeaves();
      }
      
      public function getTotalLeaves() : int
      {
         return this.getAggregation(LEAVES);
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
      
      public function getTotalLosses() : int
      {
         return this.getAggregation(LOSSES);
      }
      
      [Bindable(event="propertyChange")]
      public function get playerStatSummarySet() : ArrayCollection
      {
         return this._860093039playerStatSummarySet;
      }
      
      public function getRating(param1:String) : int
      {
         var _loc2_:PlayerStatSummary = this.findNotNull(param1);
         return _loc2_.rating;
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._bindingEventDispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.willTrigger(param1);
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this._bindingEventDispatcher.removeEventListener(param1,param2,param3);
      }
      
      public function getPlayerStatSummary(param1:String) : PlayerStatSummary
      {
         return this.find(PlayerStatSummaryType.convert(param1),false);
      }
      
      public function set playerStatSummarySet(param1:ArrayCollection) : void
      {
         var _loc2_:Object = this._860093039playerStatSummarySet;
         if(_loc2_ !== param1)
         {
            this._860093039playerStatSummarySet = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"playerStatSummarySet",_loc2_,param1));
         }
      }
      
      public function getMaxRating(param1:String) : int
      {
         var _loc2_:PlayerStatSummary = this.findNotNull(param1);
         return _loc2_.maxRating;
      }
      
      public function toString() : String
      {
         var _loc2_:PlayerStatSummary = null;
         var _loc1_:String = "";
         if(this.playerStatSummarySet == null || this.playerStatSummarySet.length == 0)
         {
            _loc1_ += "NULL/Empty";
         }
         else
         {
            _loc1_ += "[";
            for each(_loc2_ in this.playerStatSummarySet)
            {
               _loc1_ += _loc2_.toString();
               _loc1_ += "|";
            }
            _loc1_ += "]";
         }
         return _loc1_;
      }
      
      private function getAggregation(param1:String) : int
      {
         var _loc3_:PlayerStatSummary = null;
         if(this.playerStatSummarySet == null)
         {
            return 0;
         }
         var _loc2_:int = 0;
         for each(_loc3_ in this.playerStatSummarySet)
         {
            switch(param1)
            {
               case WINS:
                  _loc2_ += _loc3_.wins;
                  break;
               case LOSSES:
                  _loc2_ += _loc3_.losses;
                  break;
               case LEAVES:
                  _loc2_ += _loc3_.leaves;
                  break;
               default:
                  throw new Error("Unexpected type: " + param1);
            }
         }
         return _loc2_;
      }
      
      private function getInitialRankedRating() : int
      {
         var _loc2_:PlayerStatSummary = null;
         var _loc1_:int = 0;
         for each(_loc2_ in this.playerStatSummarySet)
         {
            if(PlayerStatSummaryType.isRanked(_loc2_.playerStatSummaryType))
            {
               _loc1_ = Math.max(_loc1_,_loc2_.rating);
            }
         }
         if(_loc1_ == 0)
         {
            _loc1_ = DEFAULT_RATING;
         }
         else
         {
            _loc1_ = Math.round((_loc1_ + 2400) / 3);
         }
         return _loc1_;
      }
      
      private function find(param1:String, param2:Boolean) : PlayerStatSummary
      {
         var _loc4_:PlayerStatSummary = null;
         var _loc3_:PlayerStatSummary = null;
         for each(_loc4_ in this.playerStatSummarySet)
         {
            if(_loc4_.isType(param1))
            {
               _loc3_ = _loc4_;
               break;
            }
         }
         if(_loc3_ == null && param2)
         {
            _loc3_ = new PlayerStatSummary();
            _loc3_.userId = this.userId;
            _loc3_.playerStatSummaryType = param1;
            this.setInitialRating(_loc3_);
            this.playerStatSummarySet.addItem(_loc3_);
         }
         return _loc3_;
      }
      
      public function getGamesPlayed(param1:String) : int
      {
         var _loc2_:PlayerStatSummary = this.findNotNull(param1);
         return _loc2_.getGamesPlayed();
      }
      
      private function setInitialRating(param1:PlayerStatSummary) : void
      {
         if(PlayerStatSummaryType.isRanked(param1.playerStatSummaryType))
         {
            param1.rating = this.getInitialRankedRating();
         }
         else
         {
            param1.rating = DEFAULT_RATING;
         }
      }
   }
}

