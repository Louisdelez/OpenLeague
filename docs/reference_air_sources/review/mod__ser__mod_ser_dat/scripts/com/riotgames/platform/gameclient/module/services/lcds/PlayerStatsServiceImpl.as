package com.riotgames.platform.gameclient.module.services.lcds
{
   import com.riotgames.platform.common.exception.PlatformException;
   import com.riotgames.platform.gameclient.domain.rankedTeams.TeamId;
   import com.riotgames.platform.gameclient.exception.GameException;
   import com.riotgames.platform.gameclient.services.PlayerStatsService;
   import flash.utils.Dictionary;
   
   public class PlayerStatsServiceImpl extends BaseLcdsService implements PlayerStatsService
   {
      
      public function PlayerStatsServiceImpl()
      {
         super();
      }
      
      public function processEloQuestionaire(param1:String, param2:Function, param3:Function) : void
      {
         invokeServiceWithoutSession("playerStatsService","processEloQuestionaire",[param1],param2,param3);
      }
      
      public function getAggregatedStats(param1:Number, param2:String, param3:int, param4:Function, param5:Function) : void
      {
         invokeServiceWithoutSession("playerStatsService","getAggregatedStats",[param1,param2,param3],param4,param5);
      }
      
      public function getTeamAggregatedStats(param1:TeamId, param2:Function, param3:Function, param4:Function) : void
      {
         invokeServiceWithoutSession("playerStatsService","getTeamAggregatedStats",[param1],param2,param3,this.getErrorMap(param4));
      }
      
      private function getErrorMap(param1:Function) : Dictionary
      {
         var _loc2_:Dictionary = new Dictionary();
         _loc2_[GameException] = param1;
         _loc2_[PlatformException] = param1;
         return _loc2_;
      }
      
      public function getTeamEndOfGameStats(param1:TeamId, param2:Number, param3:Function, param4:Function, param5:Function) : void
      {
         invokeServiceWithoutSession("playerStatsService","getTeamEndOfGameStats",[param1,param2],param3,param4,this.getErrorMap(param5));
      }
      
      public function retrievePlayerStatsByAccountId(param1:Number, param2:int, param3:Function, param4:Function) : void
      {
         return invokeServiceWithoutSession("playerStatsService","retrievePlayerStatsByAccountId",[param1,param2],param3,param4);
      }
      
      public function getRecentGames(param1:Number, param2:Function, param3:Function) : void
      {
         invokeServiceWithoutSession("playerStatsService","getRecentGames",[param1],param2,param3);
      }
      
      public function retrieveTopPlayedChampions(param1:Number, param2:String, param3:Function, param4:Function) : void
      {
         invokeServiceWithoutSession("playerStatsService","retrieveTopPlayedChampions",[param1,param2],param3,param4);
      }
   }
}

