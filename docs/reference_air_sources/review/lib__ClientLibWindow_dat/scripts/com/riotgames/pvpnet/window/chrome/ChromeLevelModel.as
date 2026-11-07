package com.riotgames.pvpnet.window.chrome
{
   public class ChromeLevelModel
   {
      
      private var _level:Number;
      
      private var _currentXP:Number;
      
      private var _levelXP:Number;
      
      private var _previousLevelXP:Number;
      
      public function ChromeLevelModel(param1:Number, param2:Number, param3:Number, param4:Number)
      {
         super();
         this._level = param1;
         this._currentXP = param2;
         this._levelXP = param3;
         this._previousLevelXP = param4;
      }
      
      public function getLevel() : Number
      {
         return this._level;
      }
      
      public function getCurrentXP() : Number
      {
         return this._currentXP;
      }
      
      public function getLevelXP() : Number
      {
         return this._levelXP;
      }
      
      public function getPreviousLevelXP() : Number
      {
         return this._previousLevelXP;
      }
      
      public function getXPProgressPercent() : Number
      {
         var _loc1_:Number = this._levelXP - this._previousLevelXP;
         var _loc2_:Number = this._currentXP - this._previousLevelXP;
         return _loc2_ / _loc1_;
      }
   }
}

