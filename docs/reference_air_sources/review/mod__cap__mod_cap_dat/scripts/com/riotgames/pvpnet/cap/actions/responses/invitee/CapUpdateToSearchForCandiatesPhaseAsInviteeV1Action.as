package com.riotgames.pvpnet.cap.actions.responses.invitee
{
   import com.riotgames.pvpnet.cap.actions.responses.CapUpdateToSearchForCandidatesPhaseV1Action;
   import com.riotgames.pvpnet.cap.mediators.CapViewMediator;
   import com.riotgames.pvpnet.cap.model.core.CapModel;
   import com.riotgames.pvpnet.cap.states.invitee.CapInviteeSearchingForSolosState;
   
   public class CapUpdateToSearchForCandiatesPhaseAsInviteeV1Action extends CapUpdateToSearchForCandidatesPhaseV1Action
   {
      
      private var _viewMediator:CapViewMediator;
      
      public function CapUpdateToSearchForCandiatesPhaseAsInviteeV1Action(param1:CapModel, param2:CapViewMediator)
      {
         super(param1);
         this._viewMediator = param2;
      }
      
      override protected function doInvocation() : void
      {
         super.doInvocation();
         _model.searchingForSolos = true;
         this._viewMediator.changeStateByClass(CapInviteeSearchingForSolosState);
      }
   }
}

