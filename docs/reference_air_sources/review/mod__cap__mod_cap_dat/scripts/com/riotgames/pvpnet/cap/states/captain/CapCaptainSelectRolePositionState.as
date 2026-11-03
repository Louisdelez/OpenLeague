package com.riotgames.pvpnet.cap.states.captain
{
   import blix.context.Context;
   import com.riotgames.platform.common.state.IStateMachine;
   import com.riotgames.pvpnet.cap.audio.CapAudioKeys;
   import com.riotgames.pvpnet.cap.model.CapPlayerSelection;
   import com.riotgames.pvpnet.cap.states.common.CapSelectRolePositionState;
   import com.riotgames.pvpnet.cap.views.ICapView;
   
   public final class CapCaptainSelectRolePositionState extends CapSelectRolePositionState
   {
      
      public function CapCaptainSelectRolePositionState(param1:ICapView, param2:Context, param3:IStateMachine)
      {
         super(param1,param2,param3);
      }
      
      override protected function getNextStateClass() : Class
      {
         return CapCaptainSelectSpellsState;
      }
      
      override protected function playMusic() : void
      {
         musicController.setLayeredMusicLevel(CapAudioKeys.LEVEL_1);
      }
      
      override protected function showView() : void
      {
         capView.showTeamViewForCaptain();
      }
      
      override protected function handlePlayerAddedToGroup(param1:CapPlayerSelection) : void
      {
         super.handlePlayerAddedToGroup(param1);
         param1.isInvitedPlayer = true;
         revealNextAvailableSlot();
      }
   }
}

