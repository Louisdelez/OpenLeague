package com.riotgames.pvpnet.cap.actions.responses
{
   import com.riotgames.platform.common.services.lcdsproxy.responses.LcdsProxyMessageAction;
   import com.riotgames.platform.common.utils.decode.IDecode;
   import com.riotgames.pvpnet.cap.controllers.ICapController;
   import com.riotgames.pvpnet.cap.model.CapPlayerSelection;
   import com.riotgames.pvpnet.cap.model.CapRoles;
   import com.riotgames.pvpnet.cap.model.core.CapModel;
   import com.riotgames.pvpnet.cap.util.CapModelUtil;
   import com.riotgames.pvpnet.invite.model.InviteGroup;
   
   public class CapUpdateToCandidateSpecPhaseV2Action extends LcdsProxyMessageAction
   {
      
      public static const METHOD_NAME:String = "soloSpecPhaseStartedV2";
      
      private static const INITIAL_SPEC_ROLE_KEY:String = "initialSoloSpecRole";
      
      protected var inviteGroup:InviteGroup;
      
      protected var model:CapModel;
      
      protected var controller:ICapController;
      
      public function CapUpdateToCandidateSpecPhaseV2Action(param1:String, param2:IDecode, param3:CapModel, param4:InviteGroup, param5:ICapController)
      {
         super(METHOD_NAME,param2,param1);
         this.model = param3;
         this.inviteGroup = param4;
         this.controller = param5;
      }
      
      override protected function doDecode(param1:Object) : void
      {
         var _loc3_:CapPlayerSelection = null;
         if(!param1 || !param1[INITIAL_SPEC_ROLE_KEY])
         {
            return;
         }
         var _loc2_:String = param1[INITIAL_SPEC_ROLE_KEY];
         if(_loc2_ == CapRoles.ANY.id)
         {
            for each(_loc3_ in this.model.playerSelections)
            {
               if(!_loc3_.isPopulated)
               {
                  _loc3_.advertisedRole = CapRoles.ANY;
               }
            }
         }
      }
      
      protected function getSpecSoloState() : String
      {
         return CapPlayerSelection.CHOOSE_ROLE_STATE;
      }
      
      private function stopAcceptingAdditionalInvites() : void
      {
         this.controller.closeLobbyToAdditionalInvitees();
         this.inviteGroup.isAcceptingInvites = false;
      }
      
      override protected function doInvocation() : void
      {
         this.model.searchingForSolos = true;
         this.updatePlayerSelectionsToSoloSpecState();
         this.stopAcceptingAdditionalInvites();
         super.doInvocation();
      }
      
      protected function updatePlayerSelectionsToSoloSpecState() : void
      {
         var _loc3_:CapPlayerSelection = null;
         var _loc1_:Array = CapModelUtil.getAllAvailablePlayerSelections(this.model);
         var _loc2_:String = this.getSpecSoloState();
         for each(_loc3_ in _loc1_)
         {
            if(!_loc3_.isLocalPlayer)
            {
               _loc3_.visible = true;
               _loc3_.rolePositionLocked = true;
               if(!_loc3_.isInvitedPlayer)
               {
                  _loc3_.currentState = _loc2_;
               }
            }
         }
         CapModelUtil.refreshCollection(this.model);
      }
   }
}

