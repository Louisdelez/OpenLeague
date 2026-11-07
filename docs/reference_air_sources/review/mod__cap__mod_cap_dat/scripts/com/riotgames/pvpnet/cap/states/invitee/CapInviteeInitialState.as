package com.riotgames.pvpnet.cap.states.invitee
{
   import blix.context.Context;
   import com.riotgames.platform.common.state.IStateMachine;
   import com.riotgames.pvpnet.cap.audio.CapAudioKeys;
   import com.riotgames.pvpnet.cap.model.CapPlayerSelection;
   import com.riotgames.pvpnet.cap.model.core.CapModel;
   import com.riotgames.pvpnet.cap.states.common.CapFinishedSelfSpecState;
   import com.riotgames.pvpnet.cap.util.CapLocaleUtil;
   import com.riotgames.pvpnet.cap.views.ICapView;
   
   public final class CapInviteeInitialState extends CapFinishedSelfSpecState
   {
      
      private var localPlayerSelection:CapPlayerSelection;
      
      public function CapInviteeInitialState(param1:ICapView, param2:Context, param3:IStateMachine)
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
         capView.showTeamViewForInvitee();
         buttonsFooter.setActionButtonLabel(CapLocaleUtil.getResourceString("gf_button_groupie_ready_label","Ready"));
      }
      
      override public function onExit() : void
      {
         super.onExit();
         this.localPlayerSelection.championChanged.remove(this.nextState);
      }
      
      override public function onEnter() : void
      {
         super.onEnter();
         model.invitePanelVisible = true;
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
      
      override protected function handlePlayerAddedToGroup(param1:CapPlayerSelection) : void
      {
         super.handlePlayerAddedToGroup(param1);
         param1.isInvitedPlayer = true;
      }
      
      private function nextState() : void
      {
         if(this.localPlayerSelection.champion != null)
         {
            changeState(CapInviteeSelectRolePositionState);
         }
      }
   }
}

