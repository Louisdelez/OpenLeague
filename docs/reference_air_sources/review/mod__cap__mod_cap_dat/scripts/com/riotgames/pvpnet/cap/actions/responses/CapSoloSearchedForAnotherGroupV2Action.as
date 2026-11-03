package com.riotgames.pvpnet.cap.actions.responses
{
   import blix.action.IAction;
   import com.riotgames.platform.common.services.lcdsproxy.responses.LcdsProxyMessageAction;
   import com.riotgames.platform.common.utils.decode.IDecode;
   import com.riotgames.platform.gameclient.chat.INotificationsProvider;
   import com.riotgames.platform.gameclient.chat.actions.DockedPromptAction;
   import com.riotgames.pvpnet.cap.model.CapPlayerSelection;
   import com.riotgames.pvpnet.cap.model.core.CapModel;
   import com.riotgames.pvpnet.cap.util.CapLocaleUtil;
   import com.riotgames.pvpnet.cap.util.CapModelUtil;
   import mx.resources.ResourceManager;
   
   public class CapSoloSearchedForAnotherGroupV2Action extends LcdsProxyMessageAction
   {
      
      public static const METHOD_NAME:String = "soloSearchedForAnotherGroupV2";
      
      public static const SLOT_ID_KEY:String = "slotId";
      
      public static const REASON_KEY:String = "reason";
      
      public static const KICKED_REASON:String = "KICKED";
      
      public static const DISBANDED_REASON:String = "GROUP_DISBANDED";
      
      private static const PENALTY_TIME_PROPERTY:String = "penaltyInSeconds";
      
      private var _dockedNotificationsProvider:INotificationsProvider;
      
      protected var _model:CapModel;
      
      public function CapSoloSearchedForAnotherGroupV2Action(param1:CapModel, param2:INotificationsProvider, param3:IDecode, param4:String = null)
      {
         super(METHOD_NAME,param3,param4);
         this._model = param1;
         this._dockedNotificationsProvider = param2;
      }
      
      private function displayDisbandedDockedPrompt() : void
      {
         var _loc1_:String = CapLocaleUtil.getResourceString("gf_docked_message_solo_group_disbanded_message","Your group has been disbanded. Requeuing...");
         var _loc2_:String = CapLocaleUtil.getResourceString("gf_docked_message_solo_group_disbanded_title","Group Disbanded");
         var _loc3_:String = "PVP.NET";
         var _loc4_:String = ResourceManager.getInstance().getString("resources","common_button_close");
         var _loc5_:IAction = new DockedPromptAction(false,this._dockedNotificationsProvider,_loc1_,_loc2_,_loc3_,_loc4_);
         _loc5_.invoke();
      }
      
      override protected function doDecode(param1:Object) : void
      {
         var _loc2_:CapPlayerSelection = CapModelUtil.getPlayerSelectionSlotById(this._model,param1[SLOT_ID_KEY]);
         var _loc3_:String = param1[REASON_KEY];
         this._model.inMatchmakingQueue = false;
         if(!_loc2_)
         {
            return;
         }
         var _loc4_:int = int(param1[PENALTY_TIME_PROPERTY]);
         if(_loc4_ > 0)
         {
            _loc2_.penaltyTimeInSeconds = _loc4_;
            _loc2_.currentState = CapPlayerSelection.PENALTY_STATE;
         }
         if(_loc2_.isLocalPlayer)
         {
            this.clearOutGroup();
         }
         else
         {
            _loc2_.isPopulated = false;
            _loc2_.clearValuesForSolo();
         }
         if(_loc3_ == KICKED_REASON)
         {
            this.displayKickedDockedPrompt();
         }
         else if(_loc3_ == DISBANDED_REASON)
         {
            this.displayDisbandedDockedPrompt();
         }
      }
      
      private function displayKickedDockedPrompt() : void
      {
         var _loc1_:String = CapLocaleUtil.getResourceString("gf_docked_message_kicked_message","You’ve been kicked from the lobby and re-entered into the queue.");
         var _loc2_:String = CapLocaleUtil.getResourceString("gf_docked_message_kicked_title","Kicked");
         var _loc3_:String = "PVP.NET";
         var _loc4_:String = ResourceManager.getInstance().getString("resources","common_button_close");
         var _loc5_:IAction = new DockedPromptAction(false,this._dockedNotificationsProvider,_loc1_,_loc2_,_loc3_,_loc4_);
         _loc5_.invoke();
      }
      
      private function clearOutGroup() : void
      {
         var _loc1_:CapPlayerSelection = null;
         this._model.groupId = null;
         this._model.localPlayerSelection.isReady = false;
         for each(_loc1_ in this._model.playerSelections)
         {
            if(!_loc1_.isLocalPlayer)
            {
               _loc1_.clearValues();
            }
         }
      }
   }
}

