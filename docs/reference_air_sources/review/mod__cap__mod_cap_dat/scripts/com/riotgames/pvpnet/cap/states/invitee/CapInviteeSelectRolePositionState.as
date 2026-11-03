package com.riotgames.pvpnet.cap.states.invitee
{
   import blix.context.Context;
   import com.riotgames.platform.common.state.IStateMachine;
   import com.riotgames.pvpnet.cap.audio.CapAudioKeys;
   import com.riotgames.pvpnet.cap.model.CapPlayerSelection;
   import com.riotgames.pvpnet.cap.states.common.CapSelectRolePositionState;
   import com.riotgames.pvpnet.cap.views.ICapView;
   
   public final class CapInviteeSelectRolePositionState extends CapSelectRolePositionState
   {
      
      public function CapInviteeSelectRolePositionState(param1:ICapView, param2:Context, param3:IStateMachine)
      {
         super(param1,param2,param3);
      }
      
      override protected function getNextStateClass() : Class
      {
         return CapInviteeSelectSpellsState;
      }
      
      override protected function playMusic() : void
      {
         musicController.setLayeredMusicLevel(CapAudioKeys.LEVEL_1);
      }
      
      override protected function showView() : void
      {
         capView.showTeamViewForInvitee();
      }
      
      override protected function handlePlayerAddedToGroup(param1:CapPlayerSelection) : void
      {
         super.handlePlayerAddedToGroup(param1);
         param1.isInvitedPlayer = true;
      }
   }
}

