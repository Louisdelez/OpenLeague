package com.riotgames.pvpnet.cap.factory.response
{
   import com.riotgames.platform.common.provider.IInventoryController;
   import com.riotgames.platform.common.services.lcdsproxy.responses.LcdsProxyMessageAction;
   import com.riotgames.platform.common.utils.decode.IDecode;
   import com.riotgames.platform.gameclient.domain.Spell;
   import com.riotgames.pvpnet.cap.controllers.ICapController;
   import com.riotgames.pvpnet.cap.model.CapPlayerSelection;
   import com.riotgames.pvpnet.cap.model.core.CapModel;
   import com.riotgames.pvpnet.cap.util.CapLocaleUtil;
   import com.riotgames.pvpnet.cap.util.CapModelUtil;
   
   public class CapUpdatePlayerSpellSelectionsV1Action extends LcdsProxyMessageAction
   {
      
      public static const UPDATE_SPELLS_METHOD_NAME:String = "spellsPickedV1";
      
      public static const SLOTS_KEY:String = "slots";
      
      public static const SLOT_ID_KEY:String = "slotId";
      
      public static const SPELL_1_ID_KEY:String = "spell1Id";
      
      public static const SPELL_2_ID_KEY:String = "spell2Id";
      
      protected var _inventoryController:IInventoryController;
      
      protected var _model:CapModel;
      
      protected var _capController:ICapController;
      
      protected var _localPlayerSelection:CapPlayerSelection;
      
      public function CapUpdatePlayerSpellSelectionsV1Action(param1:String, param2:CapModel, param3:IDecode, param4:IInventoryController, param5:ICapController)
      {
         super("",param3,param1);
         this._model = param2;
         this._localPlayerSelection = param2.localPlayerSelection;
         this._inventoryController = param4;
         this._capController = param5;
      }
      
      private function getSpellById(param1:Number) : Spell
      {
         return this._inventoryController.getSpellById(param1);
      }
      
      private function spellsAreIdentical(param1:Spell, param2:Spell, param3:CapPlayerSelection) : Boolean
      {
         if(!param3.spell1 || !param3.spell2)
         {
            return false;
         }
         return param1.spellId == param3.spell1.spellId && param2.spellId == param3.spell2.spellId;
      }
      
      protected function updatePlayerSpells(param1:CapPlayerSelection, param2:Object) : void
      {
         var _loc3_:Spell = null;
         var _loc4_:Spell = null;
         var _loc5_:String = null;
         var _loc6_:* = undefined;
         param1.errorText = null;
         for(_loc5_ in param2)
         {
            _loc6_ = param2[_loc5_];
            switch(_loc5_)
            {
               case SPELL_1_ID_KEY:
                  _loc3_ = this.getSpellById(_loc6_);
                  break;
               case SPELL_2_ID_KEY:
                  _loc4_ = this.getSpellById(_loc6_);
            }
         }
         if(!this.spellsAreSwapped(_loc3_,_loc4_,param1) && !this.spellsAreIdentical(_loc3_,_loc4_,param1))
         {
            this.unreadyGroup(param1);
         }
         param1.spell1 = _loc3_;
         param1.spell2 = _loc4_;
         param1.visible = true;
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
            this.updatePlayerSpells(_loc5_,_loc3_);
         }
         CapModelUtil.refreshCollection(this._model);
      }
      
      private function spellsAreSwapped(param1:Spell, param2:Spell, param3:CapPlayerSelection) : Boolean
      {
         if(!param3.spell1 || !param3.spell2)
         {
            return false;
         }
         return param1.spellId == param3.spell2.spellId && param2.spellId == param3.spell1.spellId;
      }
      
      private function unreadyGroup(param1:CapPlayerSelection) : void
      {
         var _loc3_:CapPlayerSelection = null;
         var _loc4_:Boolean = false;
         var _loc2_:Boolean = false;
         for each(_loc3_ in CapModelUtil.getAllAvailablePlayerSelections(this._model))
         {
            if(_loc3_.isReady)
            {
               _loc3_.isReady = false;
               _loc4_ = CapModelUtil.isFullPremadeGroup(this._model);
               if(_loc3_.isLocalPlayer)
               {
                  _loc3_.currentState = !_loc4_ ? CapPlayerSelection.ROLE_LOCKED_STATE : CapPlayerSelection.ROLE_POSITION_SELECTED_STATE;
               }
               else if(_loc3_.currentState == CapPlayerSelection.READY_STATE)
               {
                  _loc3_.currentState = CapPlayerSelection.ACCEPTED_STATE;
               }
               _loc2_ = true;
            }
         }
         if(_loc2_)
         {
            this._capController.displayStatusMessage(CapLocaleUtil.getResourceString("gf_status_message_player_property_change_unready",param1.summonerName + " is not ready.",[param1.summonerName]));
         }
      }
   }
}

