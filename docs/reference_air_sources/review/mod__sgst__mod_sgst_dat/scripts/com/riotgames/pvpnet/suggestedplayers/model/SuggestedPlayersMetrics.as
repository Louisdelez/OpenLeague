package com.riotgames.pvpnet.suggestedplayers.model
{
   import com.riotgames.platform.gameclient.domain.invite.InviteParticipant;
   import com.riotgames.platform.gameclient.domain.invite.InviteParticipantState;
   
   public class SuggestedPlayersMetrics
   {
      
      public static const GAME_STARTED:String = "gameStarted";
      
      public static const LOBBY_DISBANDED:String = "disbanded";
      
      public static const NO_STATE:int = -1;
      
      public static const DECLINED:int = 0;
      
      public static const NOT_INVITED:int = 1;
      
      public static const INVITED_BUT_DID_NOT_ACCEPT:int = 2;
      
      public static const ACCEPTED_INVITE_AND_LEFT:int = 3;
      
      public static const ACCEPTED_INVITE:int = 4;
      
      public var endState:String;
      
      public var suggestedPlayers:Array;
      
      public var inviteParticipants:Array;
      
      public var gameId:Number;
      
      public var queueId:Number;
      
      public function SuggestedPlayersMetrics()
      {
         super();
      }
      
      public function toObject() : Object
      {
         var _loc6_:SuggestedPlayer = null;
         var _loc1_:Object = {};
         _loc1_.endState = this.endState;
         var _loc2_:Array = [];
         var _loc3_:Array = [];
         var _loc4_:Array = [];
         var _loc5_:Array = [];
         for each(_loc6_ in this.suggestedPlayers)
         {
            if(!_loc6_.visible && Boolean(_loc6_.invited) || Boolean(_loc6_.declined) || Boolean(_loc6_.visible))
            {
               _loc2_.push(_loc6_.summonerName);
               _loc3_.push(this.getStateForPlayer(_loc6_,this.inviteParticipants));
               _loc4_.push(_loc6_.suggestionReason);
               _loc5_.push(_loc6_.commonFriendId);
            }
         }
         _loc1_.nameArray = _loc2_;
         _loc1_.stateArray = _loc3_;
         _loc1_.reasonArray = _loc4_;
         _loc1_.commonFriendArray = _loc5_;
         _loc1_.premadeSize = this.countAcceptedParticipants(this.inviteParticipants);
         _loc1_.gameId = this.gameId;
         _loc1_.queueId = this.queueId;
         return _loc1_;
      }
      
      private function getStateForPlayer(param1:SuggestedPlayer, param2:Array) : int
      {
         if(param1.declined)
         {
            return DECLINED;
         }
         var _loc3_:String = param1.summonerName;
         var _loc4_:InviteParticipant = this.getInviteParticipantBySummonerName(_loc3_,param2);
         if(!_loc4_)
         {
            return NOT_INVITED;
         }
         if(_loc4_.status == InviteParticipantState.QUIT)
         {
            return ACCEPTED_INVITE_AND_LEFT;
         }
         if(_loc4_.status == InviteParticipantState.PENDING || _loc4_.status == InviteParticipantState.REJECTED || _loc4_.status == InviteParticipantState.REJECTED_FULL)
         {
            return INVITED_BUT_DID_NOT_ACCEPT;
         }
         if(_loc4_.status == InviteParticipantState.ACCEPTED)
         {
            return ACCEPTED_INVITE;
         }
         return NO_STATE;
      }
      
      private function getInviteParticipantBySummonerName(param1:String, param2:Array) : InviteParticipant
      {
         var _loc3_:InviteParticipant = null;
         for each(_loc3_ in param2)
         {
            if(param1.toLowerCase() == _loc3_.name.toLowerCase())
            {
               return _loc3_;
            }
         }
         return null;
      }
      
      private function countAcceptedParticipants(param1:Array) : int
      {
         var _loc3_:InviteParticipant = null;
         var _loc2_:int = 0;
         for each(_loc3_ in param1)
         {
            if(InviteParticipantState.isMemberState(_loc3_.status))
            {
               _loc2_++;
            }
         }
         return _loc2_;
      }
   }
}

