package com.riotgames.pvpnet.cap.states.captain
{
   import blix.context.Context;
   import com.riotgames.platform.common.state.IStateMachine;
   import com.riotgames.pvpnet.cap.audio.CapAudioKeys;
   import com.riotgames.pvpnet.cap.model.CapFeatureToggles;
   import com.riotgames.pvpnet.cap.model.CapPhase;
   import com.riotgames.pvpnet.cap.model.CapPlayerSelection;
   import com.riotgames.pvpnet.cap.states.CapViewState;
   import com.riotgames.pvpnet.cap.util.CapLocaleUtil;
   import com.riotgames.pvpnet.cap.views.ICapView;
   
   public final class CapCaptainSearchingForSolosState extends CapViewState
   {
      
      public function CapCaptainSearchingForSolosState(param1:ICapView, param2:Context, param3:IStateMachine)
      {
         super(param1,param2,param3);
      }
      
      override protected function playMusic() : void
      {
         musicController.setLayeredMusicLevel(CapAudioKeys.LEVEL_2);
      }
      
      override protected function showView() : void
      {
         capView.showTeamViewForCaptain();
         buttonsFooter.setActionButtonLabel(CapLocaleUtil.getResourceString("gf_button_captain_play_game_label","Play Game"));
      }
      
      private function onGroupAbleToMatchmakeChanged() : void
      {
         if(groupAbleToMatchmakeObserver.isOccurring)
         {
            changeState(CapCaptainFullGroupState);
         }
      }
      
      override public function onEnter() : void
      {
         super.onEnter();
         inviteGroup.allowedToInvite = false;
         groupAbleToMatchmakeObserver.occurred.add(this.onGroupAbleToMatchmakeChanged);
         groupAbleToMatchmakeObserver.refresh();
         this.onGroupAbleToMatchmakeChanged();
         if(model.enabledFeatureToggles[CapFeatureToggles.PREMADE_RESPEC])
         {
            model.localPlayerSelection.rolePositionLocked = true;
            model.localPlayerSelection.currentState = CapPlayerSelection.ROLE_LOCKED_STATE;
         }
      }
      
      override public function get phase() : String
      {
         return CapPhase.GROUP_BUILDING;
      }
      
      override public function onExit() : void
      {
         super.onExit();
         groupAbleToMatchmakeObserver.occurred.remove(this.onGroupAbleToMatchmakeChanged);
      }
   }
}

