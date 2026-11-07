package com.riotgames.pvpnet.cap.states.solo
{
   import blix.context.Context;
   import com.riotgames.platform.common.state.IStateMachine;
   import com.riotgames.platform.gameclient.domain.Champion;
   import com.riotgames.pvpnet.cap.audio.CapAudioKeys;
   import com.riotgames.pvpnet.cap.model.CapPlayerSelection;
   import com.riotgames.pvpnet.cap.model.CapPosition;
   import com.riotgames.pvpnet.cap.model.CapRole;
   import com.riotgames.pvpnet.cap.model.core.CapModel;
   import com.riotgames.pvpnet.cap.states.CapViewState;
   import com.riotgames.pvpnet.cap.views.ICapView;
   
   public final class CapSoloInitialState extends CapViewState
   {
      
      private var localPlayerSelection:CapPlayerSelection;
      
      public function CapSoloInitialState(param1:ICapView, param2:Context, param3:IStateMachine)
      {
         super(param1,param2,param3);
         var _loc4_:CapModel = param2.getDependency(CapModel);
         this.localPlayerSelection = _loc4_.localPlayerSelection;
      }
      
      override protected function playMusic() : void
      {
         musicController.setLayeredMusicLevel(CapAudioKeys.LEVEL_1);
      }
      
      override protected function showView() : void
      {
         capView.showSoloView();
         this.localPlayerSelection.currentState = CapPlayerSelection.INTRO_STATE;
         if(this.localPlayerSelection.champion)
         {
            this.nextState();
         }
         else
         {
            this.localPlayerSelection.championChanged.add(this.nextState);
         }
      }
      
      override public function handleRoleSelected(param1:CapRole, param2:CapPlayerSelection) : void
      {
         super.handleRoleSelected(param1,param2);
         this.updatePlayerSelectionState();
      }
      
      override public function handlePositionSelected(param1:CapPosition, param2:CapPlayerSelection) : void
      {
         super.handlePositionSelected(param1,param2);
         this.updatePlayerSelectionState();
      }
      
      override public function handleChampionSelected(param1:Champion) : void
      {
         super.handleChampionSelected(param1);
         this.nextState();
      }
      
      override public function onExit() : void
      {
         super.onExit();
         this.localPlayerSelection.championChanged.remove(this.nextState);
      }
      
      private function nextState() : void
      {
         changeState(CapSoloSelectRolePositionState);
      }
      
      private function updatePlayerSelectionState() : void
      {
         if(Boolean(this.localPlayerSelection.role) && Boolean(this.localPlayerSelection.position))
         {
            this.localPlayerSelection.currentState = CapPlayerSelection.CHAMP_SELECTED_STATE;
         }
      }
   }
}

