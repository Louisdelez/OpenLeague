package com.riotgames.pvpnet.seasonrewards.models
{
   public class RewardModel
   {
      
      private var _rewardCost:int;
      
      private var _rewardName:String;
      
      private var _rewardDescription:String;
      
      private var _rewardIcon:String;
      
      public function RewardModel(param1:String, param2:int, param3:String, param4:String)
      {
         super();
         this.rewardName = param1;
         this.rewardCost = param2;
         this.rewardDescription = param3;
         this.rewardIcon = param4;
      }
      
      public function get rewardCost() : int
      {
         return this._rewardCost;
      }
      
      public function set rewardCost(param1:int) : void
      {
         this._rewardCost = param1;
      }
      
      public function get rewardName() : String
      {
         return this._rewardName;
      }
      
      public function set rewardName(param1:String) : void
      {
         this._rewardName = param1;
      }
      
      public function get rewardDescription() : String
      {
         return this._rewardDescription;
      }
      
      public function set rewardDescription(param1:String) : void
      {
         this._rewardDescription = param1;
      }
      
      public function get rewardIcon() : String
      {
         return this._rewardIcon;
      }
      
      public function set rewardIcon(param1:String) : void
      {
         this._rewardIcon = param1;
      }
   }
}

