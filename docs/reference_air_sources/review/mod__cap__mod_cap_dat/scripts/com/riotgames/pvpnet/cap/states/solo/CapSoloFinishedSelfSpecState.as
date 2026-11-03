package com.riotgames.pvpnet.cap.states.solo
{
   import blix.context.Context;
   import com.riotgames.platform.common.state.IStateMachine;
   import com.riotgames.platform.gameclient.domain.lobby.LobbyViewState;
   import com.riotgames.pvpnet.cap.audio.CapAudioKeys;
   import com.riotgames.pvpnet.cap.model.CapPlayerSelection;
   import com.riotgames.pvpnet.cap.states.CapViewState;
   import com.riotgames.pvpnet.cap.util.CapLocaleUtil;
   import com.riotgames.pvpnet.cap.util.CapModelUtil;
   import com.riotgames.pvpnet.cap.views.ICapView;
   
   public class CapSoloFinishedSelfSpecState extends CapViewState
   {
      
      public function CapSoloFinishedSelfSpecState(param1:ICapView, param2:Context, param3:IStateMachine)
      {
         super(param1,param2,param3);
      }
      
      override protected function playMusic() : void
      {
         musicController.setLayeredMusicLevel(CapAudioKeys.LEVEL_1);
      }
      
      override protected function showView() : void
      {
         lobbyController.currentLobbyState = LobbyViewState.CAP_STATE;
         capView.showTeamViewForSolo();
         buttonsFooter.setActionButtonLabel(CapLocaleUtil.getResourceString("gf_button_groupie_ready_label","Ready"));
         CapModelUtil.refreshCollection(model);
      }
      
      private function onGroupAbleToMatchmakeChanged() : void
      {
         if(groupAbleToMatchmakeObserver.isOccurring)
         {
            changeState(CapSoloFullGroupState);
         }
      }
      
      override public function onEnter() : void
      {
         super.onEnter();
         model.groupIdChanged.add(this.backToFindGroup);
         model.invitePanelVisible = false;
         groupAbleToMatchmakeObserver.occurred.add(this.onGroupAbleToMatchmakeChanged);
         groupAbleToMatchmakeObserver.refresh();
         this.onGroupAbleToMatchmakeChanged();
      }
      
      private function backToFindGroup() : void
      {
         if(model.groupId)
         {
            return;
         }
         model.inSoloQuery = true;
         changeState(CapSoloSearchingForGroupState);
      }
      
      override protected function handlePlayerAddedToGroup(param1:CapPlayerSelection) : void
      {
         super.handlePlayerAddedToGroup(param1);
         param1.isInvitedPlayer = false;
      }
      
      override public function onExit() : void
      {
         super.onExit();
         model.groupIdChanged.remove(this.backToFindGroup);
         groupAbleToMatchmakeObserver.occurred.remove(this.onGroupAbleToMatchmakeChanged);
      }
   }
}

