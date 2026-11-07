package com.riotgames.pvpnet.matchhistoryiron.controller.action
{
   import blix.action.BasicAction;
   import com.riotgames.platform.common.provider.IInventoryController;
   import com.riotgames.platform.gameclient.domain.PlayerStat;
   import com.riotgames.platform.gameclient.domain.RawStat;
   import com.riotgames.platform.gameclient.domain.RawStatType;
   import com.riotgames.pvpnet.game.variants.GameFlowVariant;
   import com.riotgames.pvpnet.game.variants.GameFlowVariantFactory;
   import com.riotgames.pvpnet.game.variants.GameStatsType;
   import com.riotgames.pvpnet.matchhistoryiron.model.MatchHistoryStatModel;
   import com.riotgames.pvpnet.matchhistoryiron.model.MatchHistoryStatRendererModel;
   import flash.utils.Dictionary;
   import mx.collections.ArrayCollection;
   import mx.collections.Sort;
   
   public class CreateLegacyGameStatAction extends BasicAction
   {
      
      private var _model:MatchHistoryStatModel;
      
      private var _inventoryController:IInventoryController;
      
      private var _viewableGameStats:Dictionary;
      
      private var _statList:ArrayCollection;
      
      public function CreateLegacyGameStatAction(param1:MatchHistoryStatModel, param2:IInventoryController)
      {
         super(false);
         this._model = param1;
         this._inventoryController = param2;
      }
      
      override protected function doInvocation() : void
      {
         super.doInvocation();
         this.initializeViewableStats();
         this.filtrateStatByPriority();
         this.setGameStat();
         this.setChampionById();
         this.setSpellIcon();
         complete();
      }
      
      private function setSpellIcon() : void
      {
         this._model.spellCast1 = this._inventoryController.getSpellById(this._model.stat.spell1);
         this._model.spellCast2 = this._inventoryController.getSpellById(this._model.stat.spell2);
      }
      
      private function setChampionById() : void
      {
         this._model.champion = this._inventoryController.findChampionById(this._model.stat.championId);
      }
      
      private function setGameStat() : void
      {
         var _loc2_:RawStat = null;
         var _loc1_:ArrayCollection = this._model.stat.rawStats;
         this._model.killScore = this.getStatValue(RawStatType.CHAMPION_KILLS,_loc1_);
         this._model.deathScore = this.getStatValue(RawStatType.DEATHS,_loc1_);
         this._model.assistScore = this.getStatValue(RawStatType.ASSISTS,_loc1_);
         this._model.dominionScore = this.getStatValue(RawStatType.TOTAL_PLAYER_SCORE,_loc1_);
         this._model.dominionRank = this.getStatValue(RawStatType.TOTAL_SCORE_RANK,_loc1_);
         this._model.isVictory = this.getGameResult(_loc1_);
         this._model.goldScore = this.getStatValue(RawStatType.GOLD_EARNED,_loc1_).toString();
         this._model.statRendererModelList = new Vector.<MatchHistoryStatRendererModel>();
         for each(_loc2_ in this._statList)
         {
            this._model.statRendererModelList.push(this.createStatModel(_loc2_));
         }
      }
      
      private function filtrateStatByPriority() : void
      {
         this._statList = this._model.stat.statistics as ArrayCollection;
         this._statList.filterFunction = this.gameStatsFilter;
         var _loc1_:Sort = new Sort();
         _loc1_.compareFunction = this.gameStatsSortFuntion;
         this._statList.sort = _loc1_;
         this._statList.refresh();
      }
      
      private function initializeViewableStats() : void
      {
         this._viewableGameStats = new Dictionary();
         this._viewableGameStats[RawStatType.CHAMPION_KILLS] = true;
         this._viewableGameStats[RawStatType.DEATHS] = true;
         this._viewableGameStats[RawStatType.ASSISTS] = true;
         this._viewableGameStats[RawStatType.MINIONS_KILLED] = true;
         this._viewableGameStats[RawStatType.GOLD_EARNED] = true;
         this._viewableGameStats[RawStatType.LARGEST_KILLING_SPREE] = true;
         this._viewableGameStats[RawStatType.LARGEST_MULTI_KILL] = true;
         this._viewableGameStats[RawStatType.TOTAL_HEAL] = true;
         this._viewableGameStats[RawStatType.TOTAL_DAMAGE_DEALT] = true;
         this._viewableGameStats[RawStatType.TOTAL_DAMAGE_TAKEN] = true;
         var _loc1_:GameFlowVariant = GameFlowVariantFactory.instance.getVariant(this._model.stat.gameMutators,this._model.stat.gameMode);
         var _loc2_:String = _loc1_.getGameStatsType(this._model.stat.gameMapId);
         if(GameStatsType.CLASSIC == _loc2_)
         {
            this._viewableGameStats[RawStatType.FIRST_BLOOD] = true;
            this._viewableGameStats[RawStatType.MAGIC_DAMAGE_DEALT_PLAYER] = true;
            this._viewableGameStats[RawStatType.PHYSICAL_DAMAGE_DEALT_PLAYER] = true;
            this._viewableGameStats[RawStatType.PHYSICAL_DAMAGE_TAKEN] = true;
            this._viewableGameStats[RawStatType.MAGIC_DAMAGE_TAKEN] = true;
            this._viewableGameStats[RawStatType.TOTAL_TIME_SPENT_DEAD] = true;
            this._viewableGameStats[RawStatType.TURRETS_KILLED] = true;
            this._viewableGameStats[RawStatType.BARRACKS_KILLED] = true;
            this._viewableGameStats[RawStatType.NEUTRAL_MINIONS_KILLED] = true;
         }
         else if(GameStatsType.DOMINION == _loc2_)
         {
            this._viewableGameStats[RawStatType.TOTAL_PLAYER_SCORE] = true;
            this._viewableGameStats[RawStatType.TEAM_OBJECTIVE] = true;
            this._viewableGameStats[RawStatType.NODE_CAPTURE] = true;
            this._viewableGameStats[RawStatType.NODE_CAPTURE_ASSIST] = true;
            this._viewableGameStats[RawStatType.NODE_NEUTRALIZE] = true;
            this._viewableGameStats[RawStatType.NODE_NEUTRALIZE_ASSIST] = true;
            this._viewableGameStats[RawStatType.NODE_KILL_OFFENSE] = true;
            this._viewableGameStats[RawStatType.NODE_KILL_DEFENSE] = true;
            this._viewableGameStats[RawStatType.OBJECTIVE_PLAYER_SCORE] = true;
            this._viewableGameStats[RawStatType.COMBAT_PLAYER_SCORE] = true;
         }
         else if(GameStatsType.ARAM == _loc2_)
         {
            this._viewableGameStats[RawStatType.TURRETS_KILLED] = true;
         }
      }
      
      private function createStatModel(param1:RawStat) : MatchHistoryStatRendererModel
      {
         var _loc2_:MatchHistoryStatRendererModel = new MatchHistoryStatRendererModel();
         if(param1 != null)
         {
            _loc2_.statValue = param1.value;
            _loc2_.statName = param1.displayName;
         }
         return _loc2_;
      }
      
      private function getStatValue(param1:String, param2:ArrayCollection) : int
      {
         var _loc3_:RawStat = null;
         var _loc4_:int = 0;
         _loc3_ = RawStat.getRawStat(param1,param2);
         _loc4_ = 0;
         _loc4_ = int(_loc3_.value);
         return _loc3_ != null ? (_loc4_) : (_loc4_);
      }
      
      private function getGameResult(param1:ArrayCollection) : Boolean
      {
         var _loc2_:RawStat = RawStat.getRawStat(RawStatType.WIN,param1);
         if(_loc2_ != null && _loc2_.value > 0)
         {
            return true;
         }
         return false;
      }
      
      private function gameStatsFilter(param1:RawStat) : Boolean
      {
         return this._viewableGameStats[param1.statType] != null;
      }
      
      private function gameStatsSortFuntion(param1:Object, param2:Object, param3:Array = null) : int
      {
         var _loc4_:PlayerStat = new PlayerStat(param1.statTypeName,param1.value);
         var _loc5_:PlayerStat = new PlayerStat(param2.statTypeName,param2.value);
         if(_loc4_.statCategory.priority < _loc5_.statCategory.priority)
         {
            return -1;
         }
         if(_loc4_.statCategory.priority > _loc5_.statCategory.priority)
         {
            return 1;
         }
         if(_loc4_.priority < _loc5_.priority)
         {
            return -1;
         }
         if(_loc4_.priority > _loc5_.priority)
         {
            return 1;
         }
         return 0;
      }
   }
}

