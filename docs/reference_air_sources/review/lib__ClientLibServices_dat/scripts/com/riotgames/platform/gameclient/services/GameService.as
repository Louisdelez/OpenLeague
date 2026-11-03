package com.riotgames.platform.gameclient.services
{
   import com.riotgames.platform.gameclient.domain.BotParticipant;
   import com.riotgames.platform.gameclient.domain.Champion;
   import com.riotgames.platform.gameclient.domain.ChampionSkin;
   import com.riotgames.platform.gameclient.domain.GameDTO;
   import com.riotgames.platform.gameclient.domain.game.practice.PracticeGameConfig;
   import mx.collections.ArrayCollection;
   
   public interface GameService
   {
      
      function selectBotChampion(param1:Champion, param2:BotParticipant, param3:Function, param4:Function, param5:Function) : void;
      
      function selectChampion(param1:Champion, param2:Function, param3:Function, param4:Function) : void;
      
      function setClientReceivedMaestroMessage(param1:Number, param2:String, param3:Function, param4:Function, param5:Function) : void;
      
      function setClientReceivedGameMessage(param1:Number, param2:String, param3:Function, param4:Function, param5:Function) : void;
      
      function getGameState(param1:GameDTO, param2:Function, param3:Function, param4:Function) : void;
      
      function declineObserverReconnect(param1:Function, param2:Function, param3:Function) : void;
      
      function createTutorialGame(param1:uint, param2:Function, param3:Function, param4:Function) : void;
      
      function championSelectCompleted(param1:Function, param2:Function) : void;
      
      function createGame(param1:PracticeGameConfig, param2:Function, param3:Function, param4:Function) : void;
      
      function getFeaturedGameMetadata(param1:Function, param2:Function, param3:Function) : void;
      
      function switchPlayerToObserver(param1:Number, param2:Function, param3:Function, param4:Function) : void;
      
      function banUserFromGame(param1:Number, param2:Number, param3:Function, param4:Function, param5:Function, param6:Object = null) : void;
      
      function banChampion(param1:int, param2:Function, param3:Function, param4:Function) : void;
      
      function getChampionsForBan(param1:Function, param2:Function) : void;
      
      function joinOrCreateGame(param1:PracticeGameConfig, param2:Function, param3:Function, param4:Function) : void;
      
      function switchObserverToPlayer(param1:Number, param2:Number, param3:Function, param4:Function, param5:Function) : void;
      
      function cancelSelectChampion(param1:Function, param2:Function, param3:Function) : void;
      
      function startChampionSelection(param1:Number, param2:Number, param3:Function, param4:Function, param5:Function) : void;
      
      function switchTeams(param1:Number, param2:Function, param3:Function, param4:Function) : void;
      
      function selectSpells(param1:ArrayCollection, param2:Function, param3:Function, param4:Function) : void;
      
      function quitGame(param1:Function, param2:Function, param3:Function) : void;
      
      function selectChampionSkin(param1:ChampionSkin, param2:Function, param3:Function, param4:Function) : void;
      
      function removeBotChampion(param1:Champion, param2:BotParticipant, param3:Function, param4:Function, param5:Function) : void;
      
      function getGameReconnectionInfo(param1:Function, param2:Function, param3:Function) : void;
      
      function getGame(param1:Number, param2:Function, param3:Function, param4:Function) : void;
      
      function banObserverFromGame(param1:Number, param2:Number, param3:Function, param4:Function, param5:Function, param6:Object = null) : void;
      
      function getPracticeGameForUser(param1:Function, param2:Function) : void;
      
      function getSkinUnlockPrice(param1:String, param2:Function, param3:Function, param4:Function) : void;
      
      function getAvailablePracticeGames(param1:Function, param2:Function) : void;
      
      function unlockSkinsForTeam(param1:String, param2:Function, param3:Function, param4:Function) : void;
      
      function observeGame(param1:Number, param2:String, param3:Function, param4:Function, param5:Function) : void;
      
      function getCurrentTimerForGame(param1:Function, param2:Function, param3:Function) : void;
      
      function getAuditInfo(param1:Function, param2:Function, param3:Array) : void;
      
      function acceptOrDeclinePoppedGame(param1:Boolean, param2:Function, param3:Function, param4:Function) : void;
      
      function joinGame(param1:Number, param2:String, param3:Function, param4:Function, param5:Function) : void;
      
      function spectateGameInProgress(param1:String, param2:Function, param3:Function, param4:Function) : void;
   }
}

