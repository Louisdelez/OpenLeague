package com.riotgames.pvpnet.cap.states.captain
{
   import blix.components.button.LabelButtonX;
   import blix.context.Context;
   import com.riotgames.platform.common.state.IStateMachine;
   import com.riotgames.pvpnet.cap.audio.CapAudioKeys;
   import com.riotgames.pvpnet.cap.model.CapPlayerSelection;
   import com.riotgames.pvpnet.cap.states.common.CapFullGroupState;
   import com.riotgames.pvpnet.cap.util.CapLocaleUtil;
   import com.riotgames.pvpnet.cap.views.ICapView;
   import flash.desktop.NativeApplication;
   import flash.display.NativeWindow;
   
   public final class CapCaptainFullGroupState extends CapFullGroupState
   {
      
      public function CapCaptainFullGroupState(param1:ICapView, param2:Context, param3:IStateMachine)
      {
         super(param1,param2,param3);
      }
      
      override public function onEnter() : void
      {
         super.onEnter();
         inviteGroup.allowedToInvite = false;
         buttonsFooter.setActionButtonVisible(true);
         captainAbleToStartMatchmakingObserver.occurred.add(this.onAbleToStartMatchmakingChanged);
         this.onAbleToStartMatchmakingChanged();
         groupAbleToMatchmakeObserver.occurred.add(this.onGroupAbleToMatchmakeChanged);
         model.inMatchmakingQueueChanged.add(this.onStartMatchmakingComplete);
         groupUnreadyObserver.setupSignals();
      }
      
      override protected function showView() : void
      {
         capView.showTeamViewForCaptain();
         var _loc1_:String = CapLocaleUtil.getResourceString("gf_status_captain_wait_for_ready","All players must click Ready.");
         displayStatusMessage(_loc1_);
         buttonsFooter.setActionButtonLabel(CapLocaleUtil.getResourceString("gf_button_captain_play_game_label","Play Game"));
      }
      
      override public function onExit() : void
      {
         super.onExit();
         groupUnreadyObserver.removeSignals();
         groupAbleToMatchmakeObserver.occurred.remove(this.onGroupAbleToMatchmakeChanged);
         captainAbleToStartMatchmakingObserver.occurred.remove(this.onAbleToStartMatchmakingChanged);
         model.inMatchmakingQueueChanged.remove(this.onStartMatchmakingComplete);
      }
      
      private function onStartMatchmakingComplete() : void
      {
         if(model.inMatchmakingQueue)
         {
            buttonsFooter.setActionButtonLabel(CapLocaleUtil.getResourceString("gf_button_captain_play_game_clicked_label","Finding Match..."));
            changeState(CapCaptainInMatchmakingState);
         }
      }
      
      override protected function handlePlayerAddedToGroup(param1:CapPlayerSelection) : void
      {
         super.handlePlayerAddedToGroup(param1);
         param1.isInvitedPlayer = false;
      }
      
      override protected function playMusic() : void
      {
         musicController.setLayeredMusicLevel(CapAudioKeys.LEVEL_3);
      }
      
      private function onAbleToStartMatchmakingChanged() : void
      {
         buttonsFooter.setActionButtonEnabled(captainAbleToStartMatchmakingObserver.isOccurring);
         if(captainAbleToStartMatchmakingObserver.isOccurring)
         {
            soundProvider.play(CapAudioKeys.CAP_CAPTAIN_ALL_PLAYERS_READY);
            displayAllPlayersReadyStatusMessage();
            this.orderClientToFront();
         }
      }
      
      private function orderClientToFront() : void
      {
         var _loc1_:NativeWindow = NativeApplication.nativeApplication.openedWindows[0];
         _loc1_.activate();
         _loc1_.orderToFront();
         _loc1_.alwaysInFront = true;
         _loc1_.alwaysInFront = false;
      }
      
      private function onGroupAbleToMatchmakeChanged() : void
      {
         if(!groupAbleToMatchmakeObserver.isOccurring)
         {
            controller.unreadyGroup();
            if(model.searchingForSolos)
            {
               changeState(CapCaptainSearchingForSolosState);
            }
            else
            {
               changeState(CapCaptainFinishedSelfSpecState);
            }
         }
      }
      
      override public function handleActionButtonClicked(param1:LabelButtonX) : void
      {
         super.handleActionButtonClicked(param1);
         controller.startMatchmaking(this.onAbleToStartMatchmakingChanged);
         buttonsFooter.setActionButtonEnabled(false);
      }
   }
}

