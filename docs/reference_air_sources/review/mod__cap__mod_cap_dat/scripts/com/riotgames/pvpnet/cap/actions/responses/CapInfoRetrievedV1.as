package com.riotgames.pvpnet.cap.actions.responses
{
   import com.riotgames.platform.common.provider.IInventory;
   import com.riotgames.platform.common.services.lcdsproxy.responses.LcdsProxyMessageAction;
   import com.riotgames.platform.common.utils.decode.IDecode;
   import com.riotgames.platform.gameclient.domain.Champion;
   import com.riotgames.platform.gameclient.domain.Spell;
   import com.riotgames.pvpnet.cap.model.CapDemandedSpec;
   import com.riotgames.pvpnet.cap.model.CapPositions;
   import com.riotgames.pvpnet.cap.model.CapRoles;
   import com.riotgames.pvpnet.cap.model.core.CapModel;
   import com.riotgames.pvpnet.cap.util.LcdsProxyMessageActionDataUtil;
   import com.riotgames.pvpnet.model.SpellSelection;
   
   public class CapInfoRetrievedV1 extends LcdsProxyMessageAction
   {
      
      public static const METHOD_NAME:String = "infoRetrievedV1";
      
      public static const CHAMPION_IDS_KEY:String = "championIds";
      
      public static const CHAMPION_SKIN_IDS_KEY:String = "skinIds";
      
      public static const SPELL_IDS_KEY:String = "spellIds";
      
      public static const DEMAND_INFO_KEY:String = "demandInfo";
      
      public static const CAPTAIN_STARVED_KEY:String = "areCaptainsStarved";
      
      public static const SOLOS_STARVED_KEY:String = "solosInDemand";
      
      public static const CPR_ADJUSTMENT_ENABLED_KEY:String = "cprAdjustmentEnabled";
      
      public static const ADJUSTED_CHAMPION_IDS_KEY:String = "adjustedChampionIds";
      
      public static const ADJUSTED_ROLES_KEY:String = "adjustedRoles";
      
      public static const ADJUSTED_POSITIONS_KEY:String = "adjustedPositions";
      
      public static const DEFAULT_SPELLS_KEY:String = "initialSpellIds";
      
      private var _providedRoleMmaBonusIds:Vector.<String> = new Vector.<String>();
      
      private var _providedChampionsIds:Vector.<Number> = new Vector.<Number>();
      
      private var _providedSpellIds:Vector.<Number> = new Vector.<Number>();
      
      protected var _inventory:IInventory;
      
      protected var _model:CapModel;
      
      private var _providedPositionMmaBonusIds:Vector.<String> = new Vector.<String>();
      
      private var _providedChampionSkinIds:Vector.<Number> = new Vector.<Number>();
      
      private var _providedChampionMmaBonusIds:Vector.<Number> = new Vector.<Number>();
      
      public function CapInfoRetrievedV1(param1:CapModel, param2:IInventory, param3:IDecode, param4:String = null)
      {
         super(METHOD_NAME,param3,param4);
         this._model = param1;
         this._inventory = param2;
      }
      
      private function decodeInventory(param1:Object) : void
      {
         var _loc3_:Number = NaN;
         var _loc4_:Array = null;
         var _loc5_:Number = NaN;
         var _loc6_:Array = null;
         var _loc7_:Number = NaN;
         var _loc2_:Array = param1[CHAMPION_IDS_KEY];
         for each(_loc3_ in _loc2_)
         {
            this._providedChampionsIds.push(_loc3_);
         }
         _loc4_ = param1[CHAMPION_SKIN_IDS_KEY];
         for each(_loc5_ in _loc4_)
         {
            this._providedChampionSkinIds.push(_loc5_);
         }
         _loc6_ = param1[SPELL_IDS_KEY];
         for each(_loc7_ in _loc6_)
         {
            this._providedSpellIds.push(_loc7_);
         }
      }
      
      override protected function doDecode(param1:Object) : void
      {
         LcdsProxyMessageActionDataUtil.validate(param1,[CHAMPION_IDS_KEY,SPELL_IDS_KEY,ADJUSTED_CHAMPION_IDS_KEY,ADJUSTED_ROLES_KEY,ADJUSTED_POSITIONS_KEY,DEFAULT_SPELLS_KEY,CPR_ADJUSTMENT_ENABLED_KEY]);
         this.decodeInventory(param1);
         this.setupSpells(this._providedSpellIds);
         this.setupDefaultSpells(param1);
         this.setupChampions(this._providedChampionsIds);
         this.setupMmaBonus(param1);
         this.setupDemandBoard(param1);
      }
      
      private function setupDemandBoard(param1:Object) : void
      {
         var _loc4_:Object = null;
         var _loc5_:CapDemandedSpec = null;
         if(!param1[DEMAND_INFO_KEY])
         {
            return;
         }
         var _loc2_:Object = param1[DEMAND_INFO_KEY];
         this._model.captainsDemanded = _loc2_[CAPTAIN_STARVED_KEY];
         var _loc3_:Object = _loc2_[SOLOS_STARVED_KEY];
         var _loc6_:Array = [];
         for each(_loc4_ in _loc3_)
         {
            _loc5_ = new CapDemandedSpec();
            _loc5_.role = CapRoles[_loc4_.role];
            _loc5_.position = CapPositions[_loc4_.position];
            _loc6_.push(_loc5_);
         }
         this._model.demandedSpecs = _loc6_;
      }
      
      private function setupSpells(param1:Vector.<Number>) : void
      {
         var _loc4_:Number = NaN;
         this._model.allSpells.removeAll();
         var _loc2_:Spell = null;
         var _loc3_:SpellSelection = null;
         for each(_loc4_ in param1)
         {
            _loc2_ = this.getSpellForId(_loc4_);
            if(_loc2_ != null)
            {
               _loc3_ = new SpellSelection(_loc2_,true,false);
               this._model.allSpells.addItem(_loc3_);
            }
         }
      }
      
      private function getChampionForId(param1:Number) : Champion
      {
         return this._inventory.championIdMapping[param1];
      }
      
      protected function setupChampions(param1:Vector.<Number>) : void
      {
         var _loc3_:Number = NaN;
         this._model.availableChampions.removeAll();
         var _loc2_:Champion = null;
         for each(_loc3_ in param1)
         {
            _loc2_ = this.getChampionForId(_loc3_);
            if(_loc2_ != null)
            {
               this._model.availableChampions.addItem(_loc2_);
            }
         }
      }
      
      private function getSpellForId(param1:Number) : Spell
      {
         return this._inventory.spellDictionary[param1];
      }
      
      private function setupDefaultSpells(param1:Object) : void
      {
         var _loc2_:Array = param1[DEFAULT_SPELLS_KEY];
         this._model.localPlayerSelection.spell1 = this.getSpellForId(_loc2_[0]);
         this._model.localPlayerSelection.spell2 = this.getSpellForId(_loc2_[1]);
      }
      
      private function setupMmaBonus(param1:Object) : void
      {
         var _loc3_:Number = NaN;
         var _loc4_:Array = null;
         var _loc5_:String = null;
         var _loc6_:Array = null;
         var _loc7_:String = null;
         this._model.localPlayerSelection.mmaBonus.bonusAllowed = param1[CPR_ADJUSTMENT_ENABLED_KEY];
         var _loc2_:Array = param1[ADJUSTED_CHAMPION_IDS_KEY];
         for each(_loc3_ in _loc2_)
         {
            this._model.mmaChampionBonusIds.push(_loc3_);
         }
         _loc4_ = param1[ADJUSTED_POSITIONS_KEY];
         for each(_loc5_ in _loc4_)
         {
            this._model.mmaPositionBonusIds.push(_loc5_);
         }
         _loc6_ = param1[ADJUSTED_ROLES_KEY];
         for each(_loc7_ in _loc6_)
         {
            this._model.mmaRoleBonusIds.push(_loc7_);
         }
      }
   }
}

