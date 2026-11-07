package com.riotgames.pvpnet.cap.states.invitee
{
   import blix.context.Context;
   import com.riotgames.platform.common.state.IStateMachine;
   import com.riotgames.pvpnet.cap.audio.CapAudioKeys;
   import com.riotgames.pvpnet.cap.model.CapPlayerSelection;
   import com.riotgames.pvpnet.cap.states.common.CapFinishedSelfSpecState;
   import com.riotgames.pvpnet.cap.views.ICapView;
   
   public class CapInviteeFinishedSelfSpecState extends CapFinishedSelfSpecState
   {
      
      public function CapInviteeFinishedSelfSpecState(param1:ICapView, param2:Context, param3:IStateMachine)
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
      }
      
      private function onGroupAbleToMatchmakeChanged() : void
      {
         if(groupAbleToMatchmakeObserver.isOccurring)
         {
            changeState(CapInviteeFullGroupState);
         }
      }
      
      override public function onEnter() : void
      {
         super.onEnter();
         groupAbleToMatchmakeObserver.occurred.add(this.onGroupAbleToMatchmakeChanged);
         groupAbleToMatchmakeObserver.refresh();
         this.onGroupAbleToMatchmakeChanged();
      }
      
      override protected function handlePlayerAddedToGroup(param1:CapPlayerSelection) : void
      {
         super.handlePlayerAddedToGroup(param1);
         param1.isInvitedPlayer = true;
      }
      
      override public function onExit() : void
      {
         super.onExit();
         groupAbleToMatchmakeObserver.occurred.remove(this.onGroupAbleToMatchmakeChanged);
      }
   }
}

