package com.riotgames.platform.gameclient.domain.game.matched
{
   import mx.events.PropertyChangeEvent;
   
   [RemoteClass(alias="com.riotgames.platform.matchmaking.QueueDodger")]
   public class QueueDodger extends FailedJoinPlayer
   {
      
      private var _1992258129dodgePenaltyRemainingTime:Number;
      
      public function QueueDodger()
      {
         super();
      }
      
      [Bindable(event="propertyChange")]
      public function get dodgePenaltyRemainingTime() : Number
      {
         return this._1992258129dodgePenaltyRemainingTime;
      }
      
      public function set dodgePenaltyRemainingTime(param1:Number) : void
      {
         var _loc2_:Object = this._1992258129dodgePenaltyRemainingTime;
         if(_loc2_ !== param1)
         {
            this._1992258129dodgePenaltyRemainingTime = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"dodgePenaltyRemainingTime",_loc2_,param1));
         }
      }
   }
}

