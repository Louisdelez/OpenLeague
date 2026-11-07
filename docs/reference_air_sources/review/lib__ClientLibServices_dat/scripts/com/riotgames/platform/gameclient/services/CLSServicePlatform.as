package com.riotgames.platform.gameclient.services
{
   public interface CLSServicePlatform
   {
      
      function getMyLeaguePositions(param1:Function) : void;
      
      function getLeagueForTeam(param1:String, param2:String, param3:Function) : void;
      
      function get cache() : ILeagueCache;
      
      function getMasterLeague(param1:String, param2:Function) : void;
      
      function updateTeamDecayMessageLastShown(param1:String, param2:String) : void;
      
      function getMasterLeagueTopX(param1:String, param2:int, param3:Function) : void;
      
      function getMyLeaguePositionsAndProgress(param1:Function) : void;
      
      function getAllMyLeagues(param1:Function) : void;
      
      function getAllLeaguesForPlayer(param1:Number, param2:Function) : void;
      
      function getChallengerLeague(param1:String, param2:Function) : void;
      
      function getLeaguesForTeam(param1:String, param2:Function) : void;
      
      function updateMyDecayMessageLastShown(param1:String) : void;
      
      function getLeaguesForPlayer(param1:Number, param2:String, param3:Function) : void;
   }
}

