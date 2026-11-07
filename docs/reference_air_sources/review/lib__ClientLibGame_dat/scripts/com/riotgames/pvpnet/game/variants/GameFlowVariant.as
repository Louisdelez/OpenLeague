package com.riotgames.pvpnet.game.variants
{
   import com.riotgames.platform.gameclient.domain.PlayerParticipantStatsSummary;
   import com.riotgames.pvpnet.game.controllers.practice.PracticeGameParameters;
   
   public interface GameFlowVariant
   {
      
      function isEnabled() : Boolean;
      
      function showsAssociatedSpellsInProfile() : Boolean;
      
      function getGameFlowName() : String;
      
      function getGameFlowColor() : uint;
      
      function getGameFlowOptionsColor(param1:Boolean) : uint;
      
      function showsGameFlowOptionsStar() : Boolean;
      
      function getGameFlowQueueTitleIcon() : String;
      
      function canAddBotsToCustomGame() : Boolean;
      
      function getArrangedTeamLobbyGameNameHint() : String;
      
      function createPracticeGameParameters() : PracticeGameParameters;
      
      function getGameModeForMap(param1:int) : String;
      
      function getJoinGameLobbyTitle() : String;
      
      function showsJoinGameLobbyItem(param1:GameFlowVariant) : Boolean;
      
      function supportsBattleBoost() : Boolean;
      
      function getGameResultOverrideText(param1:String, param2:String) : String;
      
      function getEndOfGameProfileIcon(param1:PlayerParticipantStatsSummary) : int;
      
      function showsEndOfGameLevelUpAlertForUnlockedGameMode() : Boolean;
      
      function getEndOfGameCoOpVsAiText(param1:String) : String;
      
      function getEndOfGameCoOpVsAiIcon(param1:String) : String;
      
      function showPointsInfo() : Boolean;
      
      function useClassicKDATooltip() : Boolean;
      
      function getNexusFinalHealthTooltip() : String;
      
      function showStatCategory(param1:String) : Boolean;
      
      function getGameStatsType(param1:int) : String;
   }
}

