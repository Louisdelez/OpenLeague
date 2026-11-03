package com.riotgames.pvpnet.system.leagues
{
   import com.riotgames.platform.common.utils.RiotResourceLoader;
   import com.riotgames.platform.gameclient.domain.*;
   import com.riotgames.platform.gameclient.domain.systemstates.TeamRewardQaulificationVO;
   import com.riotgames.platform.gameclient.services.ILeagueCache;
   
   public class LeagueCache implements ILeagueCache
   {
      
      public static const TOTAL_RANKS:uint = 5;
      
      private var _myLeagues:Vector.<LeagueListDTO> = new Vector.<LeagueListDTO>();
      
      private var _myTeamLeagues:Vector.<LeagueListDTO> = new Vector.<LeagueListDTO>();
      
      private var _myLeagueStandings:Vector.<LeagueItemDTO> = new Vector.<LeagueItemDTO>();
      
      private var _teamQualificationsMap:Object;
      
      private var _demotionWarningsMap:Object;
      
      public function LeagueCache()
      {
         super();
      }
      
      public static function getTierForIconReward(param1:int) : LeagueTier
      {
         switch(param1)
         {
            case 2:
               return LeagueTier.GOLD;
            case 3:
               return LeagueTier.PLATINUM;
            case 4:
               return LeagueTier.DIAMOND;
            case 6:
               return LeagueTier.MASTER;
            case 5:
               return LeagueTier.CHALLENGER;
            default:
               return LeagueTier.NULL;
         }
      }
      
      public static function getIconRewardForTier(param1:LeagueTier) : int
      {
         switch(param1)
         {
            case LeagueTier.GOLD:
               return 2;
            case LeagueTier.PLATINUM:
               return 3;
            case LeagueTier.DIAMOND:
               return 4;
            case LeagueTier.MASTER:
               return 6;
            case LeagueTier.CHALLENGER:
               return 5;
            default:
               return -1;
         }
      }
      
      public static function valueToTier(param1:int) : LeagueTier
      {
         var _loc2_:Array = LeagueTier.values(LeagueSortOrder.ASCENDING);
         if(param1 < 0 || param1 >= _loc2_.length)
         {
            return LeagueTier.NULL;
         }
         return _loc2_[param1];
      }
      
      public static function tierToValue(param1:LeagueTier) : int
      {
         if(!param1)
         {
            return -1;
         }
         var _loc2_:Array = LeagueTier.values(LeagueSortOrder.ASCENDING);
         return _loc2_.indexOf(param1);
      }
      
      public static function rankToValue(param1:LeagueRank) : int
      {
         if(!param1)
         {
            return -1;
         }
         var _loc2_:Array = LeagueRank.values(LeagueSortOrder.ASCENDING);
         return _loc2_.indexOf(param1);
      }
      
      public function addLeague(param1:LeagueListDTO, param2:Boolean = false) : void
      {
         param1.name = this.parseLeagueName(param1.name);
         if(!param2)
         {
            this._myLeagues.push(param1);
         }
         this._myTeamLeagues.push(param1);
         this._myLeagues.sort(this.leagueCompare);
      }
      
      public function parseLeagueName(param1:String) : String
      {
         var _loc2_:RegExp = /[^A-Za-z]/;
         param1 = param1.split(_loc2_).join("");
         return RiotResourceLoader.getResourceString("LeagueNames",param1,"**" + param1);
      }
      
      public function updatePrescenceData(param1:SummonerLeagueItemsDTO) : void
      {
         this._myLeagueStandings = new Vector.<LeagueItemDTO>();
         var _loc2_:uint = 0;
         while(_loc2_ < param1.summonerLeagues.length)
         {
            this._myLeagueStandings.push(param1.summonerLeagues[_loc2_]);
            _loc2_++;
         }
         this._myLeagueStandings.sort(this.leagueChatCompare);
      }
      
      public function getTopLeagueForChatPrescence() : LeagueItemDTO
      {
         var _loc1_:LeagueItemDTO = null;
         if(this._myLeagueStandings.length > 0)
         {
            _loc1_ = this._myLeagueStandings[0];
         }
         return _loc1_;
      }
      
      public function getLeagueDataFromTeamCache(param1:String, param2:String = null) : LeagueListDTO
      {
         var _loc3_:LeagueListDTO = null;
         var _loc4_:LeagueItemDTO = null;
         for each(_loc3_ in this._myTeamLeagues)
         {
            if(_loc3_.queue == param2 || !param2)
            {
               for each(_loc4_ in _loc3_.entries)
               {
                  if(_loc4_.playerOrTeamName == param1)
                  {
                     return _loc3_;
                  }
               }
            }
         }
         return null;
      }
      
      public function getLeaguePointsFromTeamCache(param1:String, param2:String = null) : int
      {
         var _loc3_:LeagueListDTO = null;
         var _loc4_:LeagueItemDTO = null;
         for each(_loc3_ in this._myTeamLeagues)
         {
            if(_loc3_.queue == param2 || !param2)
            {
               for each(_loc4_ in _loc3_.entries)
               {
                  if(_loc4_.playerOrTeamName == param1)
                  {
                     return _loc4_.leaguePoints;
                  }
               }
            }
         }
         return 0;
      }
      
      public function getLeagueDataForQueue(param1:String, param2:String) : LeagueListDTO
      {
         var _loc3_:LeagueListDTO = null;
         for each(_loc3_ in this._myLeagues)
         {
            if(_loc3_.queue == param2 && _loc3_.requestorsName == param1)
            {
               return _loc3_;
            }
         }
         return null;
      }
      
      public function getMyLeagueItemForQueue(param1:String) : LeagueItemDTO
      {
         var _loc2_:LeagueItemDTO = null;
         for each(_loc2_ in this._myLeagueStandings)
         {
            if(_loc2_.queueType == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public function getTierRangeWithinMyTierForQueue(param1:String, param2:Number, param3:String) : Array
      {
         var _loc4_:LeagueTier = LeagueTier.valueOf(param3);
         var _loc5_:LeagueItemDTO = this.getMyLeagueItemForQueue(param1);
         if(Boolean(_loc5_))
         {
            _loc4_ = LeagueTier.valueOf(_loc5_.tier);
         }
         var _loc6_:LeagueTier = _loc4_;
         var _loc7_:LeagueTier = _loc4_;
         var _loc8_:int = 0;
         while(_loc8_ < param2)
         {
            _loc6_ = _loc6_.next();
            _loc7_ = _loc7_.previous();
            _loc8_++;
         }
         return [_loc7_,_loc6_];
      }
      
      public function setDemotionWarningsMap(param1:Object) : void
      {
         this._demotionWarningsMap = param1;
      }
      
      public function getDemotionWarning(param1:String, param2:String) : int
      {
         if(this._demotionWarningsMap != null && this._demotionWarningsMap.hasOwnProperty(param2 + param1))
         {
            return this._demotionWarningsMap[param2 + param1];
         }
         return 0;
      }
      
      public function setTeamQualifications(param1:Object) : void
      {
         this._teamQualificationsMap = param1;
      }
      
      public function getIsQualifiedForRewardsFromTeam(param1:String, param2:String) : TeamRewardQaulificationVO
      {
         var _loc3_:TeamRewardQaulificationVO = new TeamRewardQaulificationVO();
         if(this._teamQualificationsMap != null && this._teamQualificationsMap.hasOwnProperty(param2 + param1))
         {
            _loc3_ = this._teamQualificationsMap[param2 + param1];
         }
         return _loc3_;
      }
      
      public function getLeaguePointsForSummonerOrTeam(param1:String) : int
      {
         var _loc2_:LeagueListDTO = null;
         var _loc3_:LeagueItemDTO = null;
         loop0:
         for each(_loc2_ in this._myLeagues)
         {
            var _loc6_:int = 0;
            var _loc7_:* = _loc2_.entries;
            do
            {
               for each(_loc3_ in _loc7_)
               {
               }
               continue loop0;
            }
            while(_loc3_.playerOrTeamName != param1);
            return _loc3_.leaguePoints;
         }
         return 0;
      }
      
      public function clearData() : void
      {
         this._myLeagues = new Vector.<LeagueListDTO>();
         this._myTeamLeagues = new Vector.<LeagueListDTO>();
      }
      
      public function get myLeagueStandings() : Vector.<LeagueItemDTO>
      {
         return this._myLeagueStandings;
      }
      
      private function leagueCompare(param1:LeagueListDTO, param2:LeagueListDTO) : Number
      {
         var _loc3_:LeagueTier = LeagueTier.valueOf(param1.tier);
         var _loc4_:LeagueTier = LeagueTier.valueOf(param2.tier);
         if(_loc4_.isBelow(_loc3_))
         {
            return -1;
         }
         if(_loc3_.isBelow(_loc4_))
         {
            return 1;
         }
         var _loc5_:LeagueRank = LeagueRank.valueOf(param1.requestorsRank);
         var _loc6_:LeagueRank = LeagueRank.valueOf(param2.requestorsRank);
         if(_loc6_.isBelow(_loc5_))
         {
            return -1;
         }
         return 1;
      }
      
      private function leagueChatCompare(param1:LeagueItemDTO, param2:LeagueItemDTO) : Number
      {
         var _loc3_:LeagueTier = LeagueTier.valueOf(param1.tier);
         var _loc4_:LeagueTier = LeagueTier.valueOf(param2.tier);
         if(_loc4_.isBelow(_loc3_))
         {
            return -1;
         }
         if(_loc3_.isBelow(_loc4_))
         {
            return 1;
         }
         var _loc5_:LeagueRank = LeagueRank.valueOf(param1.rank);
         var _loc6_:LeagueRank = LeagueRank.valueOf(param2.rank);
         if(_loc6_.isBelow(_loc5_))
         {
            return -1;
         }
         return 1;
      }
   }
}

