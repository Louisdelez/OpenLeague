package com.riotgames.platform.gameclient.domain.reroll
{
   [RemoteClass(alias="com.riotgames.platform.reroll.pojo.RollResult")]
   public class RollResult
   {
      
      public var _championId:Number;
      
      public var _pointSummary:PointSummary;
      
      public function RollResult()
      {
         super();
      }
      
      public function get championId() : Number
      {
         return this._championId;
      }
      
      public function set championId(param1:Number) : void
      {
         this._championId = param1;
      }
      
      public function set pointSummary(param1:PointSummary) : void
      {
         this._pointSummary = param1;
      }
      
      public function get pointSummary() : PointSummary
      {
         return this._pointSummary;
      }
   }
}

