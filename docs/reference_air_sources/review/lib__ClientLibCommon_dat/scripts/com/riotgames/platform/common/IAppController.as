package com.riotgames.platform.common
{
   import com.riotgames.platform.gameclient.domain.game.GameMap;
   
   public interface IAppController
   {
      
      function logoutSessionExpired() : void;
      
      function set shutdownLawActive(param1:Boolean) : void;
      
      function handleExit() : void;
      
      function get hasLogoutCompleted() : Boolean;
      
      function getMapByName(param1:String) : GameMap;
      
      function logMemorySnapshot() : void;
      
      function logout(param1:Boolean = true) : void;
      
      function get reportTracker() : IReportTracker;
      
      function initializeAppController() : void;
      
      function restore() : void;
      
      function minimizeToTray() : void;
      
      function onSummonerRenamed(param1:Boolean = false) : void;
      
      function get shutdownLawActive() : Boolean;
      
      function getLastInterestingMaestroMessage() : String;
      
      function getGameMap(param1:Number) : GameMap;
      
      function shutdownConnections() : void;
      
      function get firstLogin() : Boolean;
      
      function onSummonerCreated() : void;
      
      function registerGameCrashCallbacks() : void;
      
      function removeGameCrashCallbacks() : void;
      
      function home() : void;
   }
}

