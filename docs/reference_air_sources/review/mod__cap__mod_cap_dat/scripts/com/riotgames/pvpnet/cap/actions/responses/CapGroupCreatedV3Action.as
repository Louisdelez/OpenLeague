package com.riotgames.pvpnet.cap.actions.responses
{
   import com.riotgames.platform.common.services.lcdsproxy.responses.LcdsProxyMessageAction;
   import com.riotgames.platform.common.utils.decode.IDecode;
   import com.riotgames.platform.gameclient.domain.Champion;
   import com.riotgames.pvpnet.cap.controllers.CapLobbyTimerController;
   import com.riotgames.pvpnet.cap.model.CapPlayerSelection;
   import com.riotgames.pvpnet.cap.model.CapPositions;
   import com.riotgames.pvpnet.cap.model.CapRole;
   import com.riotgames.pvpnet.cap.model.CapRoles;
   import com.riotgames.pvpnet.cap.model.core.CapModel;
   import com.riotgames.pvpnet.cap.util.CapModelUtil;
   import com.riotgames.pvpnet.cap.util.CapRoleUtil;
   import com.riotgames.pvpnet.cap.util.LcdsProxyMessageActionDataUtil;
   import com.riotgames.pvpnet.invite.model.InviteGroup;
   
   public class CapGroupCreatedV3Action extends LcdsProxyMessageAction
   {
      
      public static const METHOD_NAME:String = "groupCreatedV3";
      
      public static const GROUP_ID_KEY:String = "groupId";
      
      public static const SLOT_IDS_KEY:String = "slotIds";
      
      public static const MIN_PREMADE_SIZE_KEY:String = "minPremadeSize";
      
      public static const TTL_KEY:String = "groupTtlSecs";
      
      public static const SOLO_SPEC_ROLES_KEY:String = "soloSpecRoles";
      
      public static const INITIAL_CHAMPION_ID_KEY:String = "initialChampionId";
      
      public static const INITIAL_ROLE_KEY:String = "initialRole";
      
      public static const INITIAL_POSITION_KEY:String = "initialPosition";
      
      public static const UNSELECTED:String = "UNSELECTED";
      
      protected var _model:CapModel;
      
      private var inviteGroup:InviteGroup;
      
      private var lobbyTimerController:CapLobbyTimerController;
      
      public function CapGroupCreatedV3Action(param1:CapModel, param2:IDecode, param3:CapLobbyTimerController, param4:InviteGroup, param5:String = null)
      {
         this.lobbyTimerController = param3;
         this.inviteGroup = param4;
         super(METHOD_NAME,param2,param5);
         this._model = param1;
      }
      
      private function getChampionForId(param1:int) : Champion
      {
         var _loc2_:Champion = null;
         for each(_loc2_ in this._model.availableChampions)
         {
            if(_loc2_.championId == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      private function processGroupId(param1:Object) : void
      {
         this._model.groupId = param1[GROUP_ID_KEY];
         this.inviteGroup.groupId = this._model.groupId;
      }
      
      private function processInitialSpec(param1:Object) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Champion = null;
         if(Boolean(param1[INITIAL_CHAMPION_ID_KEY]) && param1[INITIAL_CHAMPION_ID_KEY] > -1)
         {
            _loc2_ = Number(param1[INITIAL_CHAMPION_ID_KEY]);
            _loc3_ = this.getChampionForId(_loc2_);
            if(_loc3_)
            {
               this._model.localPlayerSelection.champion = _loc3_;
            }
         }
         if(Boolean(param1[INITIAL_ROLE_KEY]) && param1[INITIAL_ROLE_KEY] != UNSELECTED)
         {
            this._model.localPlayerSelection.role = CapRoles[param1[INITIAL_ROLE_KEY]];
         }
         if(Boolean(param1[INITIAL_POSITION_KEY]) && param1[INITIAL_POSITION_KEY] != UNSELECTED)
         {
            this._model.localPlayerSelection.position = CapPositions[param1[INITIAL_POSITION_KEY]];
         }
      }
      
      private function processSlotIds(param1:Object) : void
      {
         var _loc3_:Number = NaN;
         var _loc4_:CapPlayerSelection = null;
         var _loc2_:Array = param1[SLOT_IDS_KEY];
         for each(_loc3_ in _loc2_)
         {
            if(_loc3_ != this._model.localPlayerSelection.slotId)
            {
               _loc4_ = CapModelUtil.getFirstUnslottedTeammatePlayerSelection(this._model.playerSelections);
               if(_loc4_)
               {
                  _loc4_.slotId = _loc3_;
               }
               else
               {
                  logger.error("Unable to process slot - invalid group size detected.");
               }
            }
         }
         CapModelUtil.refreshCollection(this._model);
      }
      
      private function processSoloSpecRoles(param1:Object) : void
      {
         var _loc3_:String = null;
         var _loc4_:CapRole = null;
         var _loc5_:CapPlayerSelection = null;
         var _loc2_:Array = param1[SOLO_SPEC_ROLES_KEY];
         while(this._model.speccableRoles.length)
         {
            this._model.speccableRoles.pop();
         }
         for each(_loc3_ in _loc2_)
         {
            _loc4_ = CapRoleUtil.getRoleByID(this._model.allRoles,_loc3_);
            if(_loc4_ == CapRoles.ANY)
            {
               this._model.speccableRoles.unshift(_loc4_);
            }
            else
            {
               this._model.speccableRoles.push(_loc4_);
            }
         }
         if(CapRoleUtil.hasAnyRole(this._model.speccableRoles))
         {
            for each(_loc5_ in this._model.playerSelections.source)
            {
               if(!_loc5_.isLocalPlayer && !_loc5_.isInvitedPlayer)
               {
                  _loc5_.advertisedRole = CapRoles.ANY;
               }
            }
         }
         this._model.speccableRoles.sort(CapRoles.roleCompareFunction);
      }
      
      override protected function doDecode(param1:Object) : void
      {
         LcdsProxyMessageActionDataUtil.validate(param1,[GROUP_ID_KEY,SLOT_IDS_KEY,MIN_PREMADE_SIZE_KEY]);
         this._model.minPremadeSize = param1[MIN_PREMADE_SIZE_KEY];
         this.processGroupId(param1);
         this.processSlotIds(param1);
         this.processGroupTtl(param1);
         this.processSoloSpecRoles(param1);
         this.processInitialSpec(param1);
      }
      
      private function processGroupTtl(param1:Object) : void
      {
         this.lobbyTimerController.startTimerFromSeconds(param1[TTL_KEY]);
      }
   }
}

