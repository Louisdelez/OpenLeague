package com.riotgames.pvpnet.cap.factory
{
   import com.riotgames.platform.common.session.Session;
   import com.riotgames.platform.gameclient.domain.Champion;
   import com.riotgames.platform.gameclient.domain.Summoner;
   import com.riotgames.platform.gameclient.domain.SummonerLevel;
   import com.riotgames.pvpnet.cap.model.CapDemandBoardMetrics;
   import com.riotgames.pvpnet.cap.model.CapDemandedSpec;
   import com.riotgames.pvpnet.cap.model.CapPosition;
   import com.riotgames.pvpnet.cap.model.CapRole;
   import com.riotgames.pvpnet.system.config.ClientConfig;
   import mx.utils.StringUtil;
   
   public class CapDemandBoardMetricsFactory
   {
      
      public function CapDemandBoardMetricsFactory()
      {
         super();
      }
      
      protected function getDemandedRoleIds(param1:Array) : String
      {
         var _loc3_:CapDemandedSpec = null;
         var _loc2_:String = "";
         for each(_loc3_ in param1)
         {
            _loc2_ += " " + _loc3_.role.id;
         }
         return StringUtil.trim(_loc2_);
      }
      
      public function createDemandBoardMetrics(param1:Session, param2:ClientConfig, param3:Array, param4:Champion, param5:CapRole, param6:CapPosition, param7:int, param8:Boolean) : CapDemandBoardMetrics
      {
         var _loc9_:CapDemandBoardMetrics = new CapDemandBoardMetrics();
         var _loc10_:Summoner = param1.summoner;
         _loc9_.summonerName = _loc10_.name;
         var _loc11_:SummonerLevel = param1.summonerLevel;
         _loc9_.demandedRoles = this.getDemandedRoleIds(param3);
         _loc9_.demandedPositions = this.getDemandedPositionIds(param3);
         if(param4)
         {
            _loc9_.championID = param4.championId;
         }
         if(param5)
         {
            _loc9_.selectedRole = param5.id;
         }
         if(param6)
         {
            _loc9_.selectedPosition = param6.id;
         }
         _loc9_.slotClicks = param7;
         if(param8)
         {
            _loc9_.endState = CapDemandBoardMetrics.STARTED_SOLO_QUERY_STATE;
         }
         else
         {
            _loc9_.endState = CapDemandBoardMetrics.QUIT_STATE;
         }
         return _loc9_;
      }
      
      protected function getDemandedPositionIds(param1:Array) : String
      {
         var _loc3_:CapDemandedSpec = null;
         var _loc2_:String = "";
         for each(_loc3_ in param1)
         {
            _loc2_ += " " + _loc3_.position.id;
         }
         return StringUtil.trim(_loc2_);
      }
   }
}

