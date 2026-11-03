package com.riotgames.pvpnet.cap.states.solo
{
   import blix.context.Context;
   import com.riotgames.platform.common.state.IStateMachine;
   import com.riotgames.pvpnet.cap.audio.CapAudioKeys;
   import com.riotgames.pvpnet.cap.states.common.CapInMatchmakingState;
   import com.riotgames.pvpnet.cap.util.CapLocaleUtil;
   import com.riotgames.pvpnet.cap.views.ICapView;
   import flash.utils.Timer;
   
   public class CapSoloInMatchmakingState extends CapInMatchmakingState
   {
      
      private var delay:Timer;
      
      public function CapSoloInMatchmakingState(param1:ICapView, param2:Context, param3:IStateMachine)
      {
         super(param1,param2,param3);
      }
      
      override protected function playMusic() : void
      {
         musicController.setLayeredMusicLevel(CapAudioKeys.LEVEL_1);
      }
      
      override protected function showView() : void
      {
         capView.showTeamViewForInvitee();
         var _loc1_:String = CapLocaleUtil.getResourceString("gf_status_message_groupie_game_started","Captain has started the game.");
         displayStatusMessage(_loc1_);
      }
      
      override public function onEnter() : void
      {
         super.onEnter();
         capLobbyTimerController.stopTimer();
         gameQueueManager.beginQueueWait(true);
         buttonsFooter.setFindAnotherGroupButtonVisible(false);
         model.groupIdChanged.addOnce(this.onGroupDisbanded);
      }
      
      override public function onExit() : void
      {
         super.onExit();
         gameQueueManager.endQueueWait();
         model.groupIdChanged.remove(this.onGroupDisbanded);
      }
      
      private function onGroupDisbanded() : void
      {
         model.inSoloQuery = true;
         changeState(CapSoloSearchingForGroupState);
      }
   }
}

