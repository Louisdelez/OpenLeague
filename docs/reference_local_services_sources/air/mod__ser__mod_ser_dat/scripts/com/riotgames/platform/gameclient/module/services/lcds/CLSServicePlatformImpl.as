package com.riotgames.platform.gameclient.module.services.lcds
{
   import com.riotgames.platform.common.error.ServerError;
   import com.riotgames.platform.common.utils.ClientErrorCodes;
   import com.riotgames.platform.gameclient.services.CLSServicePlatform;
   import com.riotgames.platform.gameclient.services.ILeagueCache;
   import com.riotgames.pvpnet.system.leagues.LeagueCache;
   import com.riotgames.pvpnet.system.leagues.configuration.LeagueConfig;
   import flash.utils.Dictionary;
   import flash.utils.getQualifiedClassName;
   
   public class CLSServicePlatformImpl extends BaseLcdsService implements CLSServicePlatform
   {
      
      private static var SERVICE_NAME:String = "leaguesServiceProxy";
      
      private static var GET_LEAGUES:String = "getAllMyLeagues";
      
      private static var GET_MY_LEAGUE_POSITIONS_AND_PROGRESS:String = "getMyLeaguePositionsAndProgress";
      
      private static var GET_LEAGUES_FOR_TEAM:String = "getLeaguesForTeam";
      
      private static var GET_LEAGUES_FOR_PLAYER:String = "getAllLeaguesForPlayer";
      
      private static var GET_MY_LEAGUE_POSITIONS:String = "getMyLeaguePositions";
      
      private static var GET_LEAGUE_FOR_PLAYER:String = "getLeagueForPlayer";
      
      private static var GET_LEAGUE_FOR_TEAM:String = "getLeagueForTeam";
      
      private static var GET_MASTER_LEAGUE:String = "getMasterLeague";
      
      private static var GET_MASTER_LEAGUE_TOP_X:String = "getMasterLeagueTopX";
      
      private static var GET_CHALLENGER_LEAGUE:String = "getChallengerLeague";
      
      private static var UPDATE_LAST_DECAY_MESSAGE_SHOWN:String = "updateMyDecayMessageLastShown";
      
      private static var UPDATE_LAST_TEAM_DECAY_MESSAGE_SHOWN:String = "updateTeamDecayMessageLastShown";
      
      private var _leagueCache:LeagueCache = new LeagueCache();
      
      public var errorMap:Dictionary;
      
      public function CLSServicePlatformImpl()
      {
         super();
         this.buildErrorThingy();
      }
      
      public function getMyLeaguePositions(param1:Function) : void
      {
         this.invokeService(null,CLSServicePlatformImpl.GET_MY_LEAGUE_POSITIONS,param1);
      }
      
      public function get cache() : ILeagueCache
      {
         return this._leagueCache;
      }
      
      public function getAllMyLeagues(param1:Function) : void
      {
         this.invokeService(null,CLSServicePlatformImpl.GET_LEAGUES,param1);
      }
      
      public function updateTeamDecayMessageLastShown(param1:String, param2:String) : void
      {
         this.invokeService([param1,param2],CLSServicePlatformImpl.UPDATE_LAST_TEAM_DECAY_MESSAGE_SHOWN,null);
      }
      
      public function getAllLeaguesForPlayer(param1:Number, param2:Function) : void
      {
         this.invokeService([param1],CLSServicePlatformImpl.GET_LEAGUES_FOR_PLAYER,param2);
      }
      
      public function updateMyDecayMessageLastShown(param1:String) : void
      {
         this.invokeService([param1],CLSServicePlatformImpl.UPDATE_LAST_DECAY_MESSAGE_SHOWN,null);
      }
      
      private function invokeService(param1:Array, param2:String, param3:Function) : void
      {
         invokeServiceWithoutSession(CLSServicePlatformImpl.SERVICE_NAME,param2,param1,param3,null,this.errorMap);
      }
      
      public function getLeagueForTeam(param1:String, param2:String, param3:Function) : void
      {
         this.invokeService([param1,param2],CLSServicePlatformImpl.GET_LEAGUE_FOR_TEAM,param3);
      }
      
      private function buildErrorThingy() : void
      {
         this.errorMap = new Dictionary();
         this.errorMap[ServerError.UNEXPECTED_SERVICE_EXCEPTION] = this.onFailure;
         this.errorMap[ClientErrorCodes.REQUEST_TIMEOUT] = this.onFailure;
         this.errorMap[ClientErrorCodes.MESSAGE_SEND] = this.onFailure;
         this.errorMap[ClientErrorCodes.CONNECT_FAILED] = this.onFailure;
      }
      
      public function getMasterLeague(param1:String, param2:Function) : void
      {
         if(LeagueConfig.isMasterTierEnabled())
         {
            this.invokeService([param1],CLSServicePlatformImpl.GET_MASTER_LEAGUE,param2);
         }
      }
      
      public function getMyLeaguePositionsAndProgress(param1:Function) : void
      {
         this.invokeService(null,CLSServicePlatformImpl.GET_MY_LEAGUE_POSITIONS_AND_PROGRESS,param1);
      }
      
      public function getMasterLeagueTopX(param1:String, param2:int, param3:Function) : void
      {
         if(LeagueConfig.isMasterTierEnabled())
         {
            this.invokeService([param1,param2],CLSServicePlatformImpl.GET_MASTER_LEAGUE_TOP_X,param3);
         }
      }
      
      public function getChallengerLeague(param1:String, param2:Function) : void
      {
         this.invokeService([param1],CLSServicePlatformImpl.GET_CHALLENGER_LEAGUE,param2);
      }
      
      private function onFailure(param1:ServerError) : void
      {
         trace("Platform Connection error Result type : " + getQualifiedClassName(param1) + " " + param1.errorCode + " : " + param1.faultEvent.fault.rootCause);
      }
      
      public function getLeaguesForPlayer(param1:Number, param2:String, param3:Function) : void
      {
         this.invokeService([param1,param2],CLSServicePlatformImpl.GET_LEAGUE_FOR_PLAYER,param3);
      }
      
      public function getLeaguesForTeam(param1:String, param2:Function) : void
      {
         this.invokeService([param1],CLSServicePlatformImpl.GET_LEAGUES_FOR_TEAM,param2);
      }
   }
}

