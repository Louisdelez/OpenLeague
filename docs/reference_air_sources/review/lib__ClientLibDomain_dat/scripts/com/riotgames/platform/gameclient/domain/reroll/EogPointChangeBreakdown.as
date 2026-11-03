package com.riotgames.platform.gameclient.domain.reroll
{
   [RemoteClass(alias="com.riotgames.platform.reroll.pojo.EogPointChangeBreakdown")]
   public class EogPointChangeBreakdown
   {
      
      public var _pointChangeFromChampionsOwned:Number;
      
      public var _pointChangeFromGameplay:Number;
      
      public var _previousPoints:Number;
      
      public var _pointsUsed:Number;
      
      public function EogPointChangeBreakdown()
      {
         super();
      }
      
      public function get pointsUsed() : Number
      {
         return this._pointsUsed;
      }
      
      public function get pointChangeFromChampionsOwned() : Number
      {
         return this._pointChangeFromChampionsOwned;
      }
      
      public function set pointsUsed(param1:Number) : void
      {
         this._pointsUsed = param1;
      }
      
      public function set pointChangeFromChampionsOwned(param1:Number) : void
      {
         this._pointChangeFromChampionsOwned = param1;
      }
      
      public function set pointChangeFromGameplay(param1:Number) : void
      {
         this._pointChangeFromGameplay = param1;
      }
      
      public function get pointChangeFromGameplay() : Number
      {
         return this._pointChangeFromGameplay;
      }
      
      public function set previousPoints(param1:Number) : void
      {
         this._previousPoints = param1;
      }
      
      public function get previousPoints() : Number
      {
         return this._previousPoints;
      }
   }
}

