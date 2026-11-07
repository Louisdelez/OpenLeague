package com.riotgames.pvpnet.cap.states.captain
{
   import blix.context.Context;
   import com.riotgames.platform.common.state.IStateMachine;
   import com.riotgames.pvpnet.cap.audio.CapAudioKeys;
   import com.riotgames.pvpnet.cap.states.common.CapInMatchmakingState;
   import com.riotgames.pvpnet.cap.util.CapLocaleUtil;
   import com.riotgames.pvpnet.cap.views.ICapView;
   
   public final class CapCaptainInMatchmakingState extends CapInMatchmakingState
   {
      
      public function CapCaptainInMatchmakingState(param1:ICapView, param2:Context, param3:IStateMachine)
      {
         super(param1,param2,param3);
      }
      
      override protected function playMusic() : void
      {
         musicController.setLayeredMusicLevel(CapAudioKeys.LEVEL_1);
      }
      
      override protected function showView() : void
      {
         capView.showTeamViewForCaptain();
         var _loc1_:String = CapLocaleUtil.getResourceString("gf_status_message_captain_game_started","Matchmaking started.");
         displayStatusMessage(_loc1_);
      }
      
      override public function onEnter() : void
      {
         super.onEnter();
         capLobbyTimerController.stopTimer();
         gameQueueManager.beginQueueWait(true);
      }
      
      override public function onExit() : void
      {
         super.onExit();
         gameQueueManager.endQueueWait();
      }
   }
}

