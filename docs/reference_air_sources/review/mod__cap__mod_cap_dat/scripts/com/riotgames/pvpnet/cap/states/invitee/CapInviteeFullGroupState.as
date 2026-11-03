package com.riotgames.pvpnet.cap.states.invitee
{
   import blix.components.button.LabelButtonX;
   import blix.context.Context;
   import com.riotgames.platform.common.state.IStateMachine;
   import com.riotgames.pvpnet.cap.audio.CapAudioKeys;
   import com.riotgames.pvpnet.cap.model.CapPlayerSelection;
   import com.riotgames.pvpnet.cap.states.common.CapFullGroupState;
   import com.riotgames.pvpnet.cap.util.CapLocaleUtil;
   import com.riotgames.pvpnet.cap.views.CapView;
   import com.riotgames.pvpnet.cap.views.components.CapActionButton;
   
   public final class CapInviteeFullGroupState extends CapFullGroupState
   {
      
      public function CapInviteeFullGroupState(param1:CapView, param2:Context, param3:IStateMachine)
      {
         super(param1,param2,param3);
      }
      
      override protected function playMusic() : void
      {
         musicController.setLayeredMusicLevel(CapAudioKeys.LEVEL_3);
      }
      
      override protected function showView() : void
      {
         capView.showTeamViewForInvitee();
         var _loc1_:String = CapLocaleUtil.getResourceString("gf_status_groupie_wait_for_ready","Captain is waiting for all players to click Ready.");
         displayStatusMessage(_loc1_);
      }
      
      private function onGroupAbleToMatchmakeChanged() : void
      {
         buttonsFooter.setActionButtonEnabled(groupAbleToMatchmakeObserver.isOccurring);
         buttonsFooter.setActionButtonReadyState(CapActionButton.READY_STATE);
         if(!groupAbleToMatchmakeObserver.isOccurring)
         {
            controller.unreadyGroup();
            if(model.searchingForSolos)
            {
               changeState(CapInviteeSearchingForSolosState);
            }
            else
            {
               changeState(CapInviteeFinishedSelfSpecState);
            }
         }
      }
      
      override public function handleActionButtonClicked(param1:LabelButtonX) : void
      {
         var _loc2_:CapPlayerSelection = model.localPlayerSelection;
         var _loc3_:Boolean = !_loc2_.isReady;
         controller.indicateReadiness(_loc3_);
      }
      
      private function onAllPlayersReadyChanged() : void
      {
         if(captainAbleToStartMatchmakingObserver.isOccurring)
         {
            displayAllPlayersReadyStatusMessage();
         }
      }
      
      override public function onEnter() : void
      {
         super.onEnter();
         model.localPlayerSelection.isReadyChanged.add(this.onLocalPlayerReadyChanged);
         model.inMatchmakingQueueChanged.add(this.onMatchmakingQueueStatusChanged);
         groupAbleToMatchmakeObserver.occurred.add(this.onGroupAbleToMatchmakeChanged);
         groupAbleToMatchmakeObserver.refresh();
         this.onGroupAbleToMatchmakeChanged();
         captainAbleToStartMatchmakingObserver.occurred.add(this.onAllPlayersReadyChanged);
         captainAbleToStartMatchmakingObserver.refresh();
         this.onAllPlayersReadyChanged();
         groupUnreadyObserver.setupSignals();
      }
      
      private function onMatchmakingQueueStatusChanged() : void
      {
         if(model.inMatchmakingQueue)
         {
            changeState(CapInviteeInMatchmakingState);
         }
      }
      
      override public function onExit() : void
      {
         super.onExit();
         groupUnreadyObserver.removeSignals();
         groupAbleToMatchmakeObserver.occurred.remove(this.onGroupAbleToMatchmakeChanged);
         captainAbleToStartMatchmakingObserver.occurred.remove(this.onAllPlayersReadyChanged);
         model.localPlayerSelection.isReadyChanged.remove(this.onLocalPlayerReadyChanged);
         model.inMatchmakingQueueChanged.remove(this.onMatchmakingQueueStatusChanged);
      }
      
      private function onLocalPlayerReadyChanged() : void
      {
         buttonsFooter.setActionButtonMouseEnabled(true);
         buttonsFooter.setActionButtonEnabled(true);
         if(model.localPlayerSelection.isReady)
         {
            buttonsFooter.setActionButtonLabel(CapLocaleUtil.getResourceString("gf_button_groupie_unready_label","Un-Ready"));
            buttonsFooter.setActionButtonReadyState(CapActionButton.UNREADY_STATE);
         }
         else
         {
            buttonsFooter.setActionButtonLabel(CapLocaleUtil.getResourceString("gf_button_groupie_ready_label","Ready"));
            buttonsFooter.setActionButtonReadyState(CapActionButton.READY_STATE);
         }
      }
   }
}

