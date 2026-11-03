package com.riotgames.pvpnet.cap.actions.responses
{
   import com.riotgames.platform.common.provider.IInventoryController;
   import com.riotgames.platform.common.provider.ISoundProvider;
   import com.riotgames.platform.common.services.lcdsproxy.responses.LcdsProxyMessageAction;
   import com.riotgames.platform.common.utils.decode.IDecode;
   import com.riotgames.platform.gameclient.domain.Champion;
   import com.riotgames.pvpnet.cap.audio.CapAudioKeys;
   import com.riotgames.pvpnet.cap.model.CapPlayerSelection;
   import com.riotgames.pvpnet.cap.model.CapRole;
   import com.riotgames.pvpnet.cap.model.CapRoles;
   import com.riotgames.pvpnet.cap.model.core.CapModel;
   import com.riotgames.pvpnet.cap.util.CapModelUtil;
   import com.riotgames.pvpnet.cap.util.LcdsProxyMessageActionDataUtil;
   import flash.desktop.DockIcon;
   import flash.desktop.NativeApplication;
   import flash.desktop.NotificationType;
   import flash.display.NativeWindow;
   
   public class CapCandidateFoundV2Action extends LcdsProxyMessageAction
   {
      
      public static const METHOD_NAME:String = "candidateFoundV2";
      
      public static const SLOT_ID_KEY:String = "slotId";
      
      public static const CHAMPION_ID_KEY:String = "championId";
      
      public static const ROLE_KEY:String = "role";
      
      public static const TIMEOUT_KEY:String = "autoDeclineCandidateTimeout";
      
      private var _soundProvider:ISoundProvider;
      
      private var _inventoryController:IInventoryController;
      
      private var _model:CapModel;
      
      public function CapCandidateFoundV2Action(param1:String, param2:CapModel, param3:IDecode, param4:IInventoryController, param5:ISoundProvider)
      {
         super(METHOD_NAME,param3,param1);
         this._model = param2;
         this._inventoryController = param4;
         this._soundProvider = param5;
      }
      
      override protected function doDecode(param1:Object) : void
      {
         LcdsProxyMessageActionDataUtil.validate(param1,[SLOT_ID_KEY,CHAMPION_ID_KEY,ROLE_KEY,TIMEOUT_KEY]);
         var _loc2_:Number = Number(param1[SLOT_ID_KEY]);
         var _loc3_:CapPlayerSelection = CapModelUtil.getPlayerSelectionSlotById(this._model,_loc2_);
         var _loc4_:CapPlayerSelection = _loc3_ ? _loc3_ : CapModelUtil.getFirstUnslottedTeammatePlayerSelection(this._model.playerSelections);
         if(_loc4_ == null)
         {
            throw new Error("Unable to update player selection - no player found.");
         }
         this.updateChampion(_loc4_,param1[CHAMPION_ID_KEY]);
         this.updateRole(_loc4_,CapRoles[param1[ROLE_KEY]]);
         _loc4_.timeToApprove = param1[TIMEOUT_KEY];
         _loc4_.slotId = _loc2_;
         _loc4_.currentState = CapPlayerSelection.FOUND_STATE;
         _loc4_.isCandidate = true;
         this.notifyUser();
      }
      
      private function updateRole(param1:CapPlayerSelection, param2:CapRole) : void
      {
         if(param2 == null)
         {
            logger.error("Unable to update role - no role found.");
         }
         else
         {
            param1.role = param2;
         }
      }
      
      private function getChampionById(param1:Number) : Champion
      {
         return this._inventoryController.getChampionById(param1);
      }
      
      private function updateChampion(param1:CapPlayerSelection, param2:Number) : void
      {
         var _loc3_:Champion = this.getChampionById(param2);
         if(_loc3_ == null)
         {
            logger.error("Unable to update champion - no champion found.");
         }
         else
         {
            param1.champion = _loc3_;
         }
      }
      
      private function notifyUser() : void
      {
         var _loc1_:DockIcon = null;
         var _loc2_:NativeWindow = null;
         this._soundProvider.play(CapAudioKeys.CAP_SOLO_PLAYER_PROPOSED);
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
   }
}

