package com.riotgames.pvpnet.cap.states.captain
{
   import blix.components.button.LabelButtonX;
   import blix.context.Context;
   import com.riotgames.platform.common.state.IStateMachine;
   import com.riotgames.pvpnet.cap.audio.CapAudioKeys;
   import com.riotgames.pvpnet.cap.model.CapFeatureToggles;
   import com.riotgames.pvpnet.cap.model.CapPhase;
   import com.riotgames.pvpnet.cap.model.CapPlayerSelection;
   import com.riotgames.pvpnet.cap.states.CapViewState;
   import com.riotgames.pvpnet.cap.util.CapLocaleUtil;
   import com.riotgames.pvpnet.cap.views.ICapView;
   import com.riotgames.pvpnet.cap.views.popups.champselect.CapClassicChampSelectPopup;
   
   public final class CapCaptainSpecSolosState extends CapViewState
   {
      
      public function CapCaptainSpecSolosState(param1:ICapView, param2:Context, param3:IStateMachine)
      {
         super(param1,param2,param3);
      }
      
      override protected function showView() : void
      {
         capView.showTeamViewForCaptain();
         var _loc1_:String = CapLocaleUtil.getResourceString("gf_status_message_captain_update_to_solo_spec_phase","Ready for search criteria.");
         displayStatusMessage(_loc1_);
         if(!model.enabledFeatureToggles[CapFeatureToggles.PREMADE_RESPEC])
         {
            model.localPlayerSelection.rolePositionLocked = true;
            model.localPlayerSelection.currentState = CapPlayerSelection.ROLE_LOCKED_STATE;
         }
      }
      
      private function handleStartSearchError() : void
      {
         buttonsFooter.setActionButtonEnabled(true);
      }
      
      override protected function handlePlayerAddedToGroup(param1:CapPlayerSelection) : void
      {
         super.handlePlayerAddedToGroup(param1);
         param1.isInvitedPlayer = false;
      }
      
      private function onReadyChanged() : void
      {
         buttonsFooter.setActionButtonEnabled(captainAbleToSearchCandidatesObserver.isOccurring);
      }
      
      override protected function playMusic() : void
      {
         musicController.setLayeredMusicLevel(CapAudioKeys.LEVEL_2);
      }
      
      private function handleSearchStart() : void
      {
         buttonsFooter.setActionButtonVisible(false);
         var _loc1_:String = CapLocaleUtil.getResourceString("gf_status_message_update_to_solo_search_phase","Searching for solo players.");
         displayStatusMessage(_loc1_);
         changeState(CapCaptainSearchingForSolosState);
      }
      
      override public function handleActionButtonClicked(param1:LabelButtonX) : void
      {
         super.handleActionButtonClicked(param1);
         buttonsFooter.setActionButtonEnabled(false);
         controller.searchForPlayers(this.handleSearchStart,this.handleStartSearchError);
      }
      
      override public function onEnter() : void
      {
         super.onEnter();
         model.setShowInvitePowersButton(false);
         inviteGroup.allowedToInvite = false;
         inviteGroup.isGroupOpenToMembers = false;
         buttonsFooter.setActionButtonLabel(CapLocaleUtil.getResourceString("gf_button_captain_search_for_solos_button_label","Search "));
         buttonsFooter.setActionButtonVisible(true);
         captainAbleToSearchCandidatesObserver.occurred.add(this.onReadyChanged);
         captainAbleToSearchCandidatesObserver.rebuild();
         this.onReadyChanged();
         _champSelectPopup.championSelectionEnabled = false;
         _champSelectPopup.viewstackSelectedIndex = CapClassicChampSelectPopup.SKIN_SELECT_INDEX;
      }
      
      override public function get phase() : String
      {
         return CapPhase.SOLO_SPEC;
      }
      
      override public function onExit() : void
      {
         super.onExit();
         captainAbleToSearchCandidatesObserver.occurred.remove(this.onReadyChanged);
      }
   }
}

