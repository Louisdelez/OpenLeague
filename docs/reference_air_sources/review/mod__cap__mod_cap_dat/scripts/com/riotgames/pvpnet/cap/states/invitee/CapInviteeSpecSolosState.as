package com.riotgames.pvpnet.cap.states.invitee
{
   import blix.context.Context;
   import com.riotgames.platform.common.state.IStateMachine;
   import com.riotgames.pvpnet.cap.audio.CapAudioKeys;
   import com.riotgames.pvpnet.cap.model.CapPhase;
   import com.riotgames.pvpnet.cap.model.CapPlayerSelection;
   import com.riotgames.pvpnet.cap.states.CapViewState;
   import com.riotgames.pvpnet.cap.util.CapLocaleUtil;
   import com.riotgames.pvpnet.cap.views.ICapView;
   import com.riotgames.pvpnet.cap.views.popups.champselect.CapClassicChampSelectPopup;
   
   public class CapInviteeSpecSolosState extends CapViewState
   {
      
      public function CapInviteeSpecSolosState(param1:ICapView, param2:Context, param3:IStateMachine)
      {
         super(param1,param2,param3);
      }
      
      override public function onEnter() : void
      {
         super.onEnter();
         inviteGroup.allowedToInvite = false;
         inviteGroup.isGroupOpenToMembers = false;
         _champSelectPopup.championSelectionEnabled = false;
         _champSelectPopup.viewstackSelectedIndex = CapClassicChampSelectPopup.SKIN_SELECT_INDEX;
      }
      
      override protected function playMusic() : void
      {
         musicController.setLayeredMusicLevel(CapAudioKeys.LEVEL_2);
      }
      
      override protected function showView() : void
      {
         capView.showTeamViewForInvitee();
         var _loc1_:String = CapLocaleUtil.getResourceString("gf_status_message_invitee_update_to_solo_spec_phase","Captain is preparing to search for solo players.");
         displayStatusMessage(_loc1_);
      }
      
      override public function get phase() : String
      {
         return CapPhase.SOLO_SPEC;
      }
      
      override protected function handlePlayerAddedToGroup(param1:CapPlayerSelection) : void
      {
         super.handlePlayerAddedToGroup(param1);
         param1.isInvitedPlayer = false;
      }
   }
}

