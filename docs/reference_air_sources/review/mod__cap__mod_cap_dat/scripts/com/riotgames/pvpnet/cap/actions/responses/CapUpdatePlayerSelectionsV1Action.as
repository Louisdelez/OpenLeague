package com.riotgames.pvpnet.cap.actions.responses
{
   import com.riotgames.platform.common.provider.IInventoryController;
   import com.riotgames.platform.common.services.lcdsproxy.responses.LcdsProxyMessageAction;
   import com.riotgames.platform.common.utils.decode.IDecode;
   import com.riotgames.platform.gameclient.domain.Champion;
   import com.riotgames.platform.gameclient.domain.ChampionSkin;
   import com.riotgames.platform.gameclient.domain.Spell;
   import com.riotgames.pvpnet.cap.model.CapPlayerSelection;
   import com.riotgames.pvpnet.cap.model.CapPositions;
   import com.riotgames.pvpnet.cap.model.CapRoles;
   import com.riotgames.pvpnet.cap.model.core.CapModel;
   import com.riotgames.pvpnet.cap.util.CapModelUtil;
   
   public class CapUpdatePlayerSelectionsV1Action extends LcdsProxyMessageAction
   {
      
      public static const UPDATE_SPELLS_METHOD_NAME:String = "spellsPickedV1";
      
      public static const CHAMPION_PICKED_METHOD_NAME:String = "championPickedV1";
      
      public static const SKIN_PICKED_METHOD_NAME:String = "skinPickedV1";
      
      public static const ROLE_PICKED_METHOD_NAME:String = "roleSpecifiedV1";
      
      public static const POSITION_PICKED_METHOD_NAME:String = "positionSpecifiedV1";
      
      public static const ADVERTISED_ROLE_PICKED_METHOD_NAME:String = "advertisedRoleSpecifiedV1";
      
      public static const ADVERTISED_POSITION_PICKED_METHOD_NAME:String = "advertisedPositionSpecifiedV1";
      
      public static const SLOTS_KEY:String = "slots";
      
      public static const SLOT_ID_KEY:String = "slotId";
      
      public static const SLOT_STATUS_KEY:String = "status";
      
      public static const SUMMONER_ICON_ID_KEY:String = "summonerIconId";
      
      public static const SUMMONER_NAME_KEY:String = "summonerName";
      
      public static const SPELL_1_ID_KEY:String = "spell1Id";
      
      public static const SPELL_2_ID_KEY:String = "spell2Id";
      
      public static const ADVERTISED_ROLE_KEY:String = "advertisedRole";
      
      public static const ADVERTISED_POSITION_KEY:String = "advertisedPosition";
      
      public static const ROLE_KEY:String = "role";
      
      public static const POSITION_KEY:String = "position";
      
      public static const CHAMPION_ID_KEY:String = "championId";
      
      public static const SKIN_ID_KEY:String = "skinId";
      
      protected var _inventoryController:IInventoryController;
      
      protected var _model:CapModel;
      
      protected var _localPlayerSelection:CapPlayerSelection;
      
      public function CapUpdatePlayerSelectionsV1Action(param1:String, param2:CapModel, param3:IDecode, param4:IInventoryController)
      {
         super("",param3,param1);
         this._model = param2;
         this._localPlayerSelection = param2.localPlayerSelection;
         this._inventoryController = param4;
      }
      
      protected function updatePlayerSelection(param1:CapPlayerSelection, param2:Object) : void
      {
         var _loc3_:String = null;
         var _loc4_:* = undefined;
         param1.errorText = null;
         for(_loc3_ in param2)
         {
            _loc4_ = param2[_loc3_];
            switch(_loc3_)
            {
               case SLOT_STATUS_KEY:
                  param1.isCandidate = _loc4_ != CapPlayerSelection.POPULATED_STATUS;
                  break;
               case SLOT_ID_KEY:
                  param1.slotId = _loc4_;
                  break;
               case SUMMONER_ICON_ID_KEY:
                  param1.summonerIconId = _loc4_;
                  break;
               case SUMMONER_NAME_KEY:
                  param1.summonerName = _loc4_;
                  param1.currentState = CapPlayerSelection.ACCEPTED_STATE;
                  break;
               case SPELL_1_ID_KEY:
                  param1.spell1 = this.getSpellById(_loc4_);
                  break;
               case SPELL_2_ID_KEY:
                  param1.spell2 = this.getSpellById(_loc4_);
                  break;
               case ADVERTISED_ROLE_KEY:
                  param1.advertisedRole = CapRoles[_loc4_];
                  break;
               case ADVERTISED_POSITION_KEY:
                  param1.position = CapPositions[_loc4_];
               case ROLE_KEY:
                  param1.role = CapRoles[_loc4_];
                  this.validateRendererState(param1);
                  break;
               case POSITION_KEY:
                  param1.position = CapPositions[_loc4_];
                  this.validateRendererState(param1);
                  break;
               case CHAMPION_ID_KEY:
                  this.updateForChampionSelection(param1,this.getChampionById(_loc4_));
                  break;
               case SKIN_ID_KEY:
                  this._model.localPlayerSelection.skin = this.getSkinById(_loc4_,this._model.localPlayerSelection.champion);
                  this._model.selectingSkin = false;
            }
            param1.visible = true;
         }
      }
      
      protected function updateForChampionSelection(param1:CapPlayerSelection, param2:Champion) : void
      {
         this._model.pendingChampionSelection = null;
         param1.champion = param2;
         if(param2)
         {
            param1.skin = param2.defaultSkin;
         }
      }
      
      private function getSpellById(param1:Number) : Spell
      {
         return this._inventoryController.getSpellById(param1);
      }
      
      private function getSkinById(param1:Number, param2:Champion) : ChampionSkin
      {
         return this._inventoryController.getSkinById(param1,param2);
      }
      
      private function getChampionById(param1:Number) : Champion
      {
         return this._inventoryController.getChampionById(param1);
      }
      
      private function validateRendererState(param1:CapPlayerSelection) : void
      {
         if(param1.currentState == CapPlayerSelection.CHOOSE_ROLE_STATE)
         {
            if(Boolean(param1.advertisedRole) && Boolean(param1.position))
            {
               param1.currentState = CapPlayerSelection.CHOSEN_ROLE_STATE;
            }
         }
      }
      
      override protected function doDecode(param1:Object) : void
      {
         var _loc3_:Object = null;
         var _loc4_:Number = NaN;
         var _loc5_:CapPlayerSelection = null;
         var _loc2_:Array = param1.hasOwnProperty(SLOTS_KEY) ? param1[SLOTS_KEY] : [param1];
         for each(_loc3_ in _loc2_)
         {
            _loc4_ = Number(_loc3_[SLOT_ID_KEY]);
            _loc5_ = CapModelUtil.getPlayerSelectionSlotById(this._model,_loc4_);
            if(!_loc5_ && (_loc5_ = CapModelUtil.getFirstUnslottedTeammatePlayerSelection(this._model.playerSelections)) == null)
            {
               logger.error("Unable to process slot information - no more available slots!");
               return;
            }
            this.updatePlayerSelection(_loc5_,_loc3_);
         }
         CapModelUtil.refreshCollection(this._model);
      }
   }
}

