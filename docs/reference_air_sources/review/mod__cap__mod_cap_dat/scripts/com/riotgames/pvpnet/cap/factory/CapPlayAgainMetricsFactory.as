package com.riotgames.pvpnet.cap.factory
{
   import com.riotgames.platform.gameclient.domain.invite.InviteParticipant;
   import com.riotgames.platform.gameclient.domain.invite.InviteParticipantState;
   import com.riotgames.pvpnet.cap.model.CapPlayAgainMetrics;
   import com.riotgames.pvpnet.invite.model.InviteGroup;
   
   public class CapPlayAgainMetricsFactory
   {
      
      public function CapPlayAgainMetricsFactory()
      {
         super();
      }
      
      public function createPlayAgainMetrics(param1:Boolean, param2:Boolean, param3:String, param4:Array, param5:InviteGroup) : CapPlayAgainMetrics
      {
         var _loc6_:CapPlayAgainMetrics = new CapPlayAgainMetrics();
         _loc6_.endPhase = param3;
         _loc6_.clickedPlayAgain = param1;
         _loc6_.presentedWithSuggestedInvites = param2;
         if(param4[0])
         {
            _loc6_.solo1SummonerName = param4[0];
            _loc6_.solo1InviteState = this.determineSoloInviteState(param5.getParticipantByName(param4[0]));
         }
         if(param4[1])
         {
            _loc6_.solo2SummonerName = param4[1];
            _loc6_.solo2InviteState = this.determineSoloInviteState(param5.getParticipantByName(param4[1]));
         }
         if(param4[2])
         {
            _loc6_.solo3SummonerName = param4[2];
            _loc6_.solo3InviteState = this.determineSoloInviteState(param5.getParticipantByName(param4[2]));
         }
         if(param4[3])
         {
            _loc6_.solo4SummonerName = param4[3];
            _loc6_.solo4InviteState = this.determineSoloInviteState(param5.getParticipantByName(param4[3]));
         }
         return _loc6_;
      }
      
      private function determineSoloInviteState(param1:InviteParticipant) : int
      {
         if(!param1)
         {
            return CapPlayAgainMetrics.CAPTAIN_DID_NOT_INVITE;
         }
         if(param1.status == InviteParticipantState.QUIT)
         {
            return CapPlayAgainMetrics.SOLO_ACCEPTED_INVITE_AND_LEFT;
         }
         if(param1.status == InviteParticipantState.PENDING || param1.status == InviteParticipantState.REJECTED || param1.status == InviteParticipantState.REJECTED_FULL)
         {
            return CapPlayAgainMetrics.CAPTAIN_INVITED_SOLO_DID_NOT_ACCEPT;
         }
         if(param1.status == InviteParticipantState.ACCEPTED)
         {
            return CapPlayAgainMetrics.SOLO_ACCEPTED_INVITE;
         }
         return CapPlayAgainMetrics.NO_STATE;
      }
   }
}

