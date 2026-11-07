package com.riotgames.pvpnet.cap.states.solo
{
   import blix.context.Context;
   import com.riotgames.platform.common.state.IStateMachine;
   import com.riotgames.pvpnet.cap.audio.CapAudioKeys;
   import com.riotgames.pvpnet.cap.states.CapViewState;
   import com.riotgames.pvpnet.cap.views.ICapView;
   
   public final class CapSoloSearchingForGroupState extends CapViewState
   {
      
      public function CapSoloSearchingForGroupState(param1:ICapView, param2:Context, param3:IStateMachine)
      {
         super(param1,param2,param3);
      }
      
      override protected function playMusic() : void
      {
         musicController.setLayeredMusicLevel(CapAudioKeys.LEVEL_1);
      }
      
      override protected function showView() : void
      {
         capView.showSoloView();
         lobbyController.showLobbyLanding();
      }
      
      override public function onEnter() : void
      {
         super.onEnter();
         model.searchingForSolos = false;
         gameQueueManager.beginQueueWait(true);
         capLobbyTimerController.stopTimer();
         buttonsFooter.setActionButtonEnabled(false);
         model.localPlayerSelection.rolePositionLocked = true;
         model.groupIdChanged.add(this.onGroupFound);
         buttonsFooter.setFindAnotherGroupButtonVisible(true);
         controller.leaveChatRoom();
      }
      
      private function onGroupFound() : void
      {
         changeState(CapSoloGroupFoundState);
      }
      
      override public function onExit() : void
      {
         super.onExit();
         model.groupIdChanged.remove(this.onGroupFound);
      }
   }
}

