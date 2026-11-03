package com.riotgames.pvpnet.game.variants
{
   import com.riotgames.platform.common.utils.RiotResourceLoader;
   import com.riotgames.platform.gameclient.domain.PlayerParticipantStatsSummary;
   import com.riotgames.platform.gameclient.domain.game.GameMap;
   import com.riotgames.platform.gameclient.domain.gameconfig.GameTypeConfig;
   import com.riotgames.pvpnet.game.controllers.practice.PracticeGameParameters;
   import com.riotgames.pvpnet.game.domain.MutatorsConfiguration;
   import com.riotgames.util.string.RiotStringUtil;
   import mx.collections.ArrayCollection;
   import mx.resources.ResourceManager;
   
   internal class FeaturedGameFlowVariant extends BaseGameFlowVariant implements GameFlowVariant
   {
      
      internal var _gameKey:String;
      
      internal var _identifyingGameMode:String;
      
      internal var _identifyingGameMutator:String;
      
      public function FeaturedGameFlowVariant()
      {
         super();
      }
      
      internal function initializeKey(param1:String, param2:String, param3:String) : void
      {
         this._gameKey = param1;
         _key = param2 != null ? param2 : param3;
         this._identifyingGameMode = param2;
         this._identifyingGameMutator = param3;
      }
      
      public function isEnabled() : Boolean
      {
         var _loc1_:Boolean = false;
         if(!RiotStringUtil.isEmpty(this._identifyingGameMutator))
         {
            _loc1_ = MutatorsConfiguration.isConfigurationEnabled(MutatorsConfiguration.ENABLED_MUTATORS,this._identifyingGameMutator);
         }
         else if(!RiotStringUtil.isEmpty(this._identifyingGameMode))
         {
            _loc1_ = MutatorsConfiguration.isConfigurationEnabled(MutatorsConfiguration.ENABLED_MODES,this._identifyingGameMode);
         }
         return _loc1_;
      }
      
      public function showsAssociatedSpellsInProfile() : Boolean
      {
         return false;
      }
      
      public function getGameFlowName() : String
      {
         return RiotResourceLoader.getString(this._gameKey + "_game_mode_name");
      }
      
      public function getGameFlowColor() : uint
      {
         return FeaturedGameFlowConstants.COLOR_FEATURED_TEXT;
      }
      
      public function getGameFlowOptionsColor(param1:Boolean) : uint
      {
         if(!param1)
         {
            return FeaturedGameFlowConstants.COLOR_FEATURED_TEXT;
         }
         return 14540253;
      }
      
      public function showsGameFlowOptionsStar() : Boolean
      {
         return true;
      }
      
      public function getGameFlowQueueTitleIcon() : String
      {
         return null;
      }
      
      public function canAddBotsToCustomGame() : Boolean
      {
         return false;
      }
      
      public function getArrangedTeamLobbyGameNameHint() : String
      {
         return RiotResourceLoader.getString("practiceGame_gameType_hint",null,[this.getGameFlowName()]) + "</font>";
      }
      
      public function getGameModeForMap(param1:int) : String
      {
         if(this._identifyingGameMode != null)
         {
            return this._identifyingGameMode;
         }
         return StandardGameFlowVariant.getDefaultGameModeForMap(param1);
      }
      
      public function getJoinGameLobbyTitle() : String
      {
         return RiotResourceLoader.getString("practiceGame_createOrJoinGame_lobbyTitleFeatured",null,[this.getGameFlowName()]);
      }
      
      public function showsJoinGameLobbyItem(param1:GameFlowVariant) : Boolean
      {
         return _key == BaseGameFlowVariant(param1).key;
      }
      
      public function supportsBattleBoost() : Boolean
      {
         return false;
      }
      
      public function getGameResultOverrideText(param1:String, param2:String) : String
      {
         var _loc3_:String = ResourceManager.getInstance().getString(param1,param2 + "_" + _key);
         if(!RiotStringUtil.isEmpty(_loc3_))
         {
            return _loc3_;
         }
         return ResourceManager.getInstance().getString(param1,param2);
      }
      
      public function showsEndOfGameLevelUpAlertForUnlockedGameMode() : Boolean
      {
         return false;
      }
      
      public function getEndOfGameProfileIcon(param1:PlayerParticipantStatsSummary) : int
      {
         return param1.profileIconId;
      }
      
      public function getEndOfGameCoOpVsAiText(param1:String) : String
      {
         return RiotResourceLoader.getString("practiceGame_gameMode_COOP_VS_AI_GAME") + " (" + RiotResourceLoader.getString("game_flow_mm_pve_difficulty_" + param1.toLowerCase() + "_title") + ")";
      }
      
      public function getEndOfGameCoOpVsAiIcon(param1:String) : String
      {
         return null;
      }
      
      public function showPointsInfo() : Boolean
      {
         return false;
      }
      
      public function useClassicKDATooltip() : Boolean
      {
         return true;
      }
      
      public function getNexusFinalHealthTooltip() : String
      {
         return "";
      }
      
      public function showStatCategory(param1:String) : Boolean
      {
         return true;
      }
      
      public function getGameStatsType(param1:int) : String
      {
         if(GameMap.HOWLING_ABYSS == param1)
         {
            return GameStatsType.ARAM;
         }
         if(GameMap.CRYSTAL_SCAR_ID == param1)
         {
            return GameStatsType.DOMINION;
         }
         return GameStatsType.CLASSIC;
      }
      
      public function createPracticeGameParameters() : PracticeGameParameters
      {
         var _loc1_:PracticeGameParameters = new PracticeGameParameters(this._gameKey);
         _loc1_.overriddenGamePickIds = new ArrayCollection([GameTypeConfig.PICK_ID_BLIND_PICK]);
         _loc1_.overriddenGameTitle = RiotResourceLoader.getString("custom_" + this._gameKey + "_game_mode_title");
         _loc1_.overriddenGameDescription = RiotResourceLoader.getString("custom_" + this._gameKey + "_game_mode_description");
         if(this._identifyingGameMode != null)
         {
            _loc1_.gameMode = this._identifyingGameMode;
         }
         else if(this._identifyingGameMutator != null)
         {
            _loc1_.gameMutators = [this._identifyingGameMutator];
         }
         return _loc1_;
      }
   }
}

