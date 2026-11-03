package com.riotgames.pvpnet.cap.model
{
   public class CapPlayAgainMetrics
   {
      
      public static const NO_STATE:int = -1;
      
      public static const CAPTAIN_DID_NOT_INVITE:int = 0;
      
      public static const CAPTAIN_INVITED_SOLO_DID_NOT_ACCEPT:int = 1;
      
      public static const SOLO_ACCEPTED_INVITE_AND_LEFT:int = 2;
      
      public static const SOLO_ACCEPTED_INVITE:int = 3;
      
      public var endPhase:String;
      
      public var solo4InviteState:int = -1;
      
      public var solo2InviteState:int = -1;
      
      public var clickedPlayAgain:Boolean;
      
      public var presentedWithSuggestedInvites:Boolean;
      
      public var solo1SummonerName:String;
      
      public var solo2SummonerName:String;
      
      public var solo3SummonerName:String;
      
      public var solo3InviteState:int = -1;
      
      public var solo4SummonerName:String;
      
      public var solo1InviteState:int = -1;
      
      public function CapPlayAgainMetrics()
      {
         super();
      }
      
      public function toObject() : Object
      {
         var _loc1_:Object = new Object();
         _loc1_.clickedPlayAgain = this.clickedPlayAgain;
         _loc1_.presentedWithSuggestedInvites = this.presentedWithSuggestedInvites;
         _loc1_.endPhase = this.endPhase;
         if(this.solo1SummonerName)
         {
            _loc1_.solo1SummonerName = this.solo1SummonerName;
            _loc1_.solo1InviteState = this.solo1InviteState;
         }
         if(this.solo2SummonerName)
         {
            _loc1_.solo2SummonerName = this.solo2SummonerName;
            _loc1_.solo2InviteState = this.solo2InviteState;
         }
         if(this.solo3SummonerName)
         {
            _loc1_.solo3SummonerName = this.solo3SummonerName;
            _loc1_.solo3InviteState = this.solo3InviteState;
         }
         if(this.solo4SummonerName)
         {
            _loc1_.solo4SummonerName = this.solo4SummonerName;
            _loc1_.solo4InviteState = this.solo4InviteState;
         }
         return _loc1_;
      }
   }
}

