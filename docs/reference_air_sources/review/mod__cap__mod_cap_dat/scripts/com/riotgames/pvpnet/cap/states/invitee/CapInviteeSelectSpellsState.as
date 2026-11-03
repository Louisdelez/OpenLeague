package com.riotgames.pvpnet.cap.states.invitee
{
   import blix.context.Context;
   import com.riotgames.platform.common.state.IStateMachine;
   import com.riotgames.pvpnet.cap.audio.CapAudioKeys;
   import com.riotgames.pvpnet.cap.model.CapPlayerSelection;
   import com.riotgames.pvpnet.cap.observers.observable.IObservable;
   import com.riotgames.pvpnet.cap.states.common.CapSelectSpellsState;
   import com.riotgames.pvpnet.cap.views.ICapView;
   
   public final class CapInviteeSelectSpellsState extends CapSelectSpellsState
   {
      
      public function CapInviteeSelectSpellsState(param1:ICapView, param2:Context, param3:IStateMachine)
      {
         super(param1,param2,param3);
      }
      
      override protected function onReadyChanged() : void
      {
         if(_readyObserver.isOccurring)
         {
            changeState(CapInviteeFullGroupState);
         }
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
      
      override protected function getReadyObserver() : IObservable
      {
         return groupAbleToMatchmakeObserver;
      }
   }
}

