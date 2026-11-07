package com.riotgames.pvpnet.cap.states.captain
{
   import blix.components.button.LabelButtonX;
   import blix.context.Context;
   import com.riotgames.platform.common.services.lcdsproxy.servicecalls.LcdsProxyServiceCall;
   import com.riotgames.platform.common.state.IStateMachine;
   import com.riotgames.pvpnet.cap.audio.CapAudioKeys;
   import com.riotgames.pvpnet.cap.faults.CapFaults;
   import com.riotgames.pvpnet.cap.model.CapPlayerSelection;
   import com.riotgames.pvpnet.cap.states.common.CapFinishedSelfSpecState;
   import com.riotgames.pvpnet.cap.util.CapLocaleUtil;
   import com.riotgames.pvpnet.cap.util.CapModelUtil;
   import com.riotgames.pvpnet.cap.views.ICapView;
   import com.riotgames.pvpnet.system.alerter.AlertAction;
   import mx.rpc.Fault;
   
   public final class CapCaptainFinishedSelfSpecState extends CapFinishedSelfSpecState
   {
      
      private var _specSolosCallInProgress:Boolean;
      
      private var _specSolosButton:LabelButtonX;
      
      public function CapCaptainFinishedSelfSpecState(param1:ICapView, param2:Context, param3:IStateMachine)
      {
         super(param1,param2,param3);
      }
      
      override protected function showView() : void
      {
         capView.showTeamViewForCaptain();
      }
      
      override public function handleSpecSolosClicked(param1:LabelButtonX) : void
      {
         super.handleSpecSolosClicked(param1);
         controller.goToSoloSpecPhase(this.onSpecSolosSuccess,this.onSpecSolosError);
         this._specSolosCallInProgress = true;
         this._specSolosButton = param1;
         this._specSolosButton.setEnabled(false);
      }
      
      private function onSpecSolosSuccess() : void
      {
         this._specSolosCallInProgress = false;
         changeState(CapCaptainSpecSolosState);
      }
      
      override protected function handlePlayerAddedToGroup(param1:CapPlayerSelection) : void
      {
         super.handlePlayerAddedToGroup(param1);
         param1.isInvitedPlayer = true;
         this.onGroupCompositionChange();
      }
      
      private function onSpecSolosError(param1:LcdsProxyServiceCall) : void
      {
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:AlertAction = null;
         this._specSolosCallInProgress = false;
         this._specSolosButton.setEnabled(true);
         var _loc2_:Fault = param1.fault;
         var _loc3_:String = _loc2_.faultCode;
         if(_loc3_ == CapFaults.NOT_FULLY_SPECCED)
         {
            _loc4_ = CapLocaleUtil.getResourceString("gf_dialog_captain_spec_solos_failure_title","");
            _loc5_ = CapLocaleUtil.getResourceString("gf_dialog_captain_spec_solos_failure_body","");
            _loc6_ = new AlertAction(_loc4_,_loc5_);
            _loc6_.add();
         }
      }
      
      override protected function playMusic() : void
      {
         musicController.setLayeredMusicLevel(CapAudioKeys.LEVEL_1);
      }
      
      private function onGroupAbleToMatchmakeChanged() : void
      {
         if(groupAbleToMatchmakeObserver.isOccurring && !this._specSolosCallInProgress)
         {
            changeState(CapCaptainFullGroupState);
         }
         buttonsFooter.setActionButtonVisible(groupAbleToMatchmakeObserver.isOccurring);
      }
      
      override public function onEnter() : void
      {
         super.onEnter();
         this._specSolosCallInProgress = false;
         if(!model.invitePanelVisible)
         {
            inviteGroup.getInvitedParticipantsChangedSignal().addOnce(handleFirstInviteSent);
         }
         groupAbleToMatchmakeObserver.occurred.add(this.onGroupAbleToMatchmakeChanged);
         this.onGroupAbleToMatchmakeChanged();
         this.onGroupCompositionChange();
      }
      
      private function onGroupCompositionChange() : void
      {
         revealNextAvailableSlot();
         this.refreshInviteAbilityStatus();
      }
      
      override public function onExit() : void
      {
         super.onExit();
         inviteGroup.getInvitedParticipantsChangedSignal().remove(handleFirstInviteSent);
         groupAbleToMatchmakeObserver.occurred.remove(this.onGroupAbleToMatchmakeChanged);
      }
      
      override protected function handlePlayerRemovedFromGroup(param1:CapPlayerSelection) : void
      {
         super.handlePlayerRemovedFromGroup(param1);
         this.onGroupCompositionChange();
      }
      
      private function refreshInviteAbilityStatus() : void
      {
         inviteGroup.allowedToInvite = !CapModelUtil.canInvite(model);
      }
   }
}

