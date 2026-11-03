package com.riotgames.pvpnet.cap.actions.responses.invitee
{
   import com.riotgames.platform.common.utils.decode.IDecode;
   import com.riotgames.pvpnet.cap.actions.responses.CapUpdateToCandidateSpecPhaseV2Action;
   import com.riotgames.pvpnet.cap.controllers.ICapController;
   import com.riotgames.pvpnet.cap.mediators.CapViewMediator;
   import com.riotgames.pvpnet.cap.model.CapFeatureToggles;
   import com.riotgames.pvpnet.cap.model.CapPlayerSelection;
   import com.riotgames.pvpnet.cap.model.core.CapModel;
   import com.riotgames.pvpnet.cap.states.invitee.CapInviteeSpecSolosState;
   import com.riotgames.pvpnet.invite.model.InviteGroup;
   
   public class CapUpdateToCandidateSpecPhaseAsInviteeV2Action extends CapUpdateToCandidateSpecPhaseV2Action
   {
      
      private var _viewMediator:CapViewMediator;
      
      public function CapUpdateToCandidateSpecPhaseAsInviteeV2Action(param1:String, param2:IDecode, param3:CapViewMediator, param4:CapModel, param5:InviteGroup, param6:ICapController)
      {
         super(param1,param2,param4,param5,param6);
         this._viewMediator = param3;
      }
      
      override protected function getSpecSoloState() : String
      {
         return CapPlayerSelection.CAPTAIN_SPECCING_STATE;
      }
      
      override protected function updatePlayerSelectionsToSoloSpecState() : void
      {
         if(!model.enabledFeatureToggles[CapFeatureToggles.PREMADE_RESPEC])
         {
            model.localPlayerSelection.currentState = CapPlayerSelection.ROLE_LOCKED_STATE;
            model.localPlayerSelection.rolePositionLocked = true;
         }
         super.updatePlayerSelectionsToSoloSpecState();
      }
      
      override protected function doInvocation() : void
      {
         super.doInvocation();
         this._viewMediator.changeStateByClass(CapInviteeSpecSolosState);
      }
   }
}

