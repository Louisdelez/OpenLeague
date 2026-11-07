package com.riotgames.pvpnet.cap.actions.responses
{
   import blix.action.IAction;
   import com.riotgames.platform.common.services.lcdsproxy.responses.LcdsProxyMessageAction;
   import com.riotgames.platform.common.utils.decode.IDecode;
   import com.riotgames.platform.gameclient.chat.INotificationsProvider;
   import com.riotgames.platform.gameclient.chat.actions.DockedPromptAction;
   import com.riotgames.platform.gameclient.domain.Spell;
   import com.riotgames.pvpnet.cap.controllers.CapLobbyTimerController;
   import com.riotgames.pvpnet.cap.controllers.ICapController;
   import com.riotgames.pvpnet.cap.model.CapPlayerSelection;
   import com.riotgames.pvpnet.cap.model.core.CapModel;
   import com.riotgames.pvpnet.cap.util.CapLocaleUtil;
   import com.riotgames.pvpnet.cap.util.CapModelUtil;
   import com.riotgames.pvpnet.system.alerter.AlertAction;
   import flash.desktop.DockIcon;
   import flash.desktop.NativeApplication;
   import flash.desktop.NotificationType;
   import flash.display.NativeWindow;
   import mx.resources.ResourceManager;
   
   public class CapRemovedFromServiceV1 extends LcdsProxyMessageAction
   {
      
      private static const REASON_AFK:String = "CANDIDATE_FAILED_TO_RESPOND";
      
      private static const REASON_GROUP_DISBANDED:String = "GROUP_DISBANDED";
      
      private static const REASON_CANDIDATE_DECLINED_GROUP:String = "CANDIDATE_DECLINED_GROUP";
      
      private static const REASON_KEY:String = "reason";
      
      public static const METHOD_NAME:String = "removedFromServiceV1";
      
      private var _model:CapModel;
      
      private var _timerController:CapLobbyTimerController;
      
      private var _controller:ICapController;
      
      private var _dockedNotificationProvider:INotificationsProvider;
      
      public function CapRemovedFromServiceV1(param1:CapModel, param2:IDecode, param3:INotificationsProvider, param4:CapLobbyTimerController, param5:ICapController, param6:String = null)
      {
         this._model = param1;
         this._controller = param5;
         this._dockedNotificationProvider = param3;
         this._timerController = param4;
         super(METHOD_NAME,param2,param6);
      }
      
      private function notifyUser() : void
      {
         var _loc1_:DockIcon = null;
         var _loc2_:NativeWindow = null;
         if(NativeApplication.supportsDockIcon)
         {
            _loc1_ = NativeApplication.nativeApplication.icon as DockIcon;
            _loc1_.bounce(NotificationType.CRITICAL);
         }
         else if(NativeApplication.supportsSystemTrayIcon)
         {
            _loc2_ = NativeApplication.nativeApplication.openedWindows[0];
            _loc2_.notifyUser(NotificationType.CRITICAL);
         }
      }
      
      override protected function doDecode(param1:Object) : void
      {
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc7_:IAction = null;
         var _loc8_:Spell = null;
         var _loc9_:Spell = null;
         var _loc10_:CapPlayerSelection = null;
         var _loc2_:String = param1[REASON_KEY];
         this._controller.trackPlayAgainMetrics();
         if(_loc2_ == REASON_AFK)
         {
            _loc3_ = CapLocaleUtil.getResourceString("gf_docked_message_solo_afk_message","You have been removed from the queue for being AFK.");
            _loc4_ = CapLocaleUtil.getResourceString("gf_docked_message_solo_afk_title","Removed from queue.");
            _loc5_ = "PVP.NET";
            _loc6_ = ResourceManager.getInstance().getString("resources","common_button_close");
            _loc7_ = new DockedPromptAction(false,this._dockedNotificationProvider,_loc3_,_loc4_,_loc5_,_loc6_);
            _loc7_.invoke();
         }
         if(_loc2_ == REASON_GROUP_DISBANDED)
         {
            if(!this._model.groupId)
            {
               return;
            }
            this._timerController.stopTimer();
            this._model.groupId = null;
            this._model.inMatchmakingQueue = false;
            _loc8_ = this._model.localPlayerSelection.spell1;
            _loc9_ = this._model.localPlayerSelection.spell2;
            for each(_loc10_ in CapModelUtil.getAllAvailablePlayerSelections(this._model))
            {
               _loc10_.clearValues();
            }
            this._model.localPlayerSelection.spell1 = _loc8_;
            this._model.localPlayerSelection.spell2 = _loc9_;
            if(!this._model.localPlayerCausedDisband)
            {
               this.displayDisbandedAlert();
               this.notifyUser();
            }
         }
         this._controller.hasQuit();
      }
      
      private function displayDisbandedAlert() : void
      {
         var _loc1_:String = CapLocaleUtil.getResourceString("gf_dialog_group_disbanded_title","Group Disbanded");
         var _loc2_:String = CapLocaleUtil.getResourceString("gf_dialog_group_disbanded_body","Your group has been disbanded.");
         var _loc3_:AlertAction = new AlertAction(_loc1_,_loc2_);
         _loc3_.add();
      }
   }
}

