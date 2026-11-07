package com.riotgames.pvpnet.game.variants
{
   import com.riotgames.platform.common.utils.RiotResourceLoader;
   import com.riotgames.platform.gameclient.domain.PlayerParticipantStatsSummary;
   import com.riotgames.platform.gameclient.domain.game.GameMap;
   import com.riotgames.platform.gameclient.domain.game.GameMode;
   import com.riotgames.pvpnet.game.controllers.practice.PracticeGameParameters;
   import com.riotgames.pvpnet.game.controllers.practice.PracticeGameParametersFactory;
   import com.riotgames.pvpnet.game.domain.MutatorsConfiguration;
   import mx.resources.ResourceManager;
   
   internal class StandardGameFlowVariant extends BaseGameFlowVariant implements GameFlowVariant
   {
      
      public function StandardGameFlowVariant()
      {
         super();
      }
      
      internal static function getDefaultGameModeForMap(param1:int) : String
      {
         var _loc2_:String = GameMode.CLASSIC;
         switch(param1)
         {
            case GameMap.CRYSTAL_SCAR_ID:
               _loc2_ = GameMode.DOMINION;
               break;
            case GameMap.PROVING_GROUNDS_ARAM_ID:
            case GameMap.HOWLING_ABYSS:
               _loc2_ = GameMode.ARAM;
         }
         return _loc2_;
      }
      
      internal function initializeKey(param1:String) : void
      {
         this._key = param1;
      }
      
      public function isEnabled() : Boolean
      {
         return MutatorsConfiguration.isConfigurationEnabled(MutatorsConfiguration.ENABLED_MODES,GameMode.CLASSIC);
      }
      
      public function showsAssociatedSpellsInProfile() : Boolean
      {
         return true;
      }
      
      public function getGameFlowName() : String
      {
         if(this._gameMode != null)
         {
            return RiotResourceLoader.getString(this._gameMode.toLowerCase() + "_game_mode_name");
         }
         return "";
      }
      
      public function getGameFlowColor() : uint
      {
         return 16777215;
      }
      
      public function getGameFlowOptionsColor(param1:Boolean) : uint
      {
         return 14540253;
      }
      
      public function showsGameFlowOptionsStar() : Boolean
      {
         return false;
      }
      
      public function getGameFlowQueueTitleIcon() : String
      {
         return null;
      }
      
      public function canAddBotsToCustomGame() : Boolean
      {
         return true;
      }
      
      public function getArrangedTeamLobbyGameNameHint() : String
      {
         return null;
      }
      
      public function getGameModeForMap(param1:int) : String
      {
         return getDefaultGameModeForMap(param1);
      }
      
      public function getJoinGameLobbyTitle() : String
      {
         return RiotResourceLoader.getString("practiceGame_createOrJoinGame_lobbyTitleNormal");
      }
      
      public function showsJoinGameLobbyItem(param1:GameFlowVariant) : Boolean
      {
         return !(param1 is FeaturedGameFlowVariant);
      }
      
      public function supportsBattleBoost() : Boolean
      {
         return false;
      }
      
      public function getGameResultOverrideText(param1:String, param2:String) : String
      {
         return ResourceManager.getInstance().getString(param1,param2);
      }
      
      public function showsEndOfGameLevelUpAlertForUnlockedGameMode() : Boolean
      {
         return true;
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
         return GameStatsType.CLASSIC;
      }
      
      public function createPracticeGameParameters() : PracticeGameParameters
      {
         var _loc1_:PracticeGameParameters = new PracticeGameParameters(PracticeGameParametersFactory.CUSTOM_MODE_ID);
         _loc1_.filterFeaturedGamePickModes = true;
         return _loc1_;
      }
   }
}

