package com.riotgames.platform.gameclient.domain.game.matched
{
   import mx.events.PropertyChangeEvent;
   
   [RemoteClass(alias="com.riotgames.platform.matchmaking.BustedLeaver")]
   public class BustedLeaver extends FailedJoinPlayer
   {
      
      private var _529425150leaverPenaltyMillisRemaining:Number;
      
      private var _1042689291accessToken:String;
      
      public function BustedLeaver()
      {
         super();
      }
      
      [Bindable(event="propertyChange")]
      public function get leaverPenaltyMillisRemaining() : Number
      {
         return this._529425150leaverPenaltyMillisRemaining;
      }
      
      [Bindable(event="propertyChange")]
      public function get accessToken() : String
      {
         return this._1042689291accessToken;
      }
      
      public function set accessToken(param1:String) : void
      {
         var _loc2_:Object = this._1042689291accessToken;
         if(_loc2_ !== param1)
         {
            this._1042689291accessToken = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"accessToken",_loc2_,param1));
         }
      }
      
      public function set leaverPenaltyMillisRemaining(param1:Number) : void
      {
         var _loc2_:Object = this._529425150leaverPenaltyMillisRemaining;
         if(_loc2_ !== param1)
         {
            this._529425150leaverPenaltyMillisRemaining = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"leaverPenaltyMillisRemaining",_loc2_,param1));
         }
      }
   }
}

