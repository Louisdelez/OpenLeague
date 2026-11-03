package com.riotgames.pvpnet.cap.states.solo
{
   import blix.action.IAction;
   import blix.context.Context;
   import com.riotgames.platform.common.services.lcdsproxy.servicecalls.ILcdsProxyServiceCall;
   import com.riotgames.platform.common.state.IStateMachine;
   import com.riotgames.pvpnet.cap.audio.CapAudioKeys;
   import com.riotgames.pvpnet.cap.faults.CapFaults;
   import com.riotgames.pvpnet.cap.states.CapViewState;
   import com.riotgames.pvpnet.cap.util.CapLocaleUtil;
   import com.riotgames.pvpnet.cap.views.ICapView;
   import com.riotgames.pvpnet.cap.views.popups.CapSoloGroupFoundPopup;
   import mx.resources.ResourceManager;
   
   public final class CapSoloGroupFoundState extends CapViewState
   {
      
      public function CapSoloGroupFoundState(param1:ICapView, param2:Context, param3:IStateMachine)
      {
         super(param1,param2,param3);
      }
      
      override protected function playMusic() : void
      {
         musicController.setLayeredMusicLevel(CapAudioKeys.LEVEL_1);
         soundProvider.play(CapAudioKeys.CAP_GROUP_FOUND);
      }
      
      override protected function showView() : void
      {
         capView.showSoloView();
      }
      
      private function onGroupNotFound(param1:ILcdsProxyServiceCall) : void
      {
         var _loc2_:IAction = null;
         this.onDeclineClicked();
         if(param1.fault.faultCode == CapFaults.GROUP_NOT_FOUND || param1.fault.faultCode == CapFaults.NO_NODE_FOR_GROUP_ID)
         {
            _loc2_ = actionFactory.getDockedPromptAction(true,CapLocaleUtil.getResourceString("gf_docked_message_solo_unable_to_join_group_group_not_found_title","Unable to Join Group"),CapLocaleUtil.getResourceString("gf_docked_message_solo_unable_to_join_group_group_not_found_message","The group no longer exists. Requeueing..."),"PVP.NET",ResourceManager.getInstance().getString("resources","common_button_close"));
            _loc2_.invoke();
         }
         else
         {
            CapFaults.handleActionFaulted(param1);
         }
      }
      
      private function onAcceptClicked() : void
      {
         controller.joinGroupAsSolo(this.onSoloInGroup,this.onGroupNotFound);
         capView.hideGroupFoundPopup();
      }
      
      override public function onEnter() : void
      {
         super.onEnter();
         capView.showGroupFoundPopup();
         var _loc1_:CapSoloGroupFoundPopup = capView.soloGroupFoundPopup;
         _loc1_.getAcceptClicked().add(this.onAcceptClicked);
         _loc1_.getDeclineClicked().add(this.onDeclineClicked);
      }
      
      private function onSoloInGroup() : void
      {
         changeState(CapSoloFinishedSelfSpecState);
      }
      
      override public function onExit() : void
      {
         super.onExit();
         var _loc1_:CapSoloGroupFoundPopup = capView.soloGroupFoundPopup;
         if(_loc1_)
         {
            _loc1_.getAcceptClicked().remove(this.onAcceptClicked);
            _loc1_.getDeclineClicked().remove(this.onDeclineClicked);
         }
      }
      
      private function onDeclineClicked() : void
      {
         capView.hideGroupFoundPopup();
         controller.declineGroupAsSolo(null);
      }
   }
}

