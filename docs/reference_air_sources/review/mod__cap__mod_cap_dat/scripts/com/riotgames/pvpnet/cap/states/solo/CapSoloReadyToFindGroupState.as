package com.riotgames.pvpnet.cap.states.solo
{
   import blix.components.button.LabelButtonX;
   import blix.context.Context;
   import com.riotgames.platform.common.state.IStateMachine;
   import com.riotgames.pvpnet.cap.audio.CapAudioKeys;
   import com.riotgames.pvpnet.cap.model.CapPlayerSelection;
   import com.riotgames.pvpnet.cap.states.CapViewState;
   import com.riotgames.pvpnet.cap.views.ICapView;
   
   public final class CapSoloReadyToFindGroupState extends CapViewState
   {
      
      public function CapSoloReadyToFindGroupState(param1:ICapView, param2:Context, param3:IStateMachine)
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
      }
      
      private function onCreateSoloQuerySuccess() : void
      {
         if(!model.inSoloQuery)
         {
            return;
         }
         var _loc1_:CapPlayerSelection = model.localPlayerSelection;
         _loc1_.rolePositionLocked = true;
         _loc1_.currentState = CapPlayerSelection.ROLE_LOCKED_STATE;
         changeState(CapSoloSearchingForGroupState);
      }
      
      override public function handleActionButtonClicked(param1:LabelButtonX) : void
      {
         model.inSoloQueryChanged.addOnce(this.onCreateSoloQuerySuccess);
         super.handleActionButtonClicked(param1);
         controller.createSoloQuery();
      }
   }
}

