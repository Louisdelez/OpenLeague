package com.riotgames.platform.gameclient.utils
{
   import com.riotgames.platform.common.provider.IInventoryController;
   import com.riotgames.platform.gameclient.Models.ChampionListPresentationModel;
   import com.riotgames.platform.gameclient.domain.Champion;
   import com.riotgames.platform.gameclient.domain.IChampionFilter;
   import com.riotgames.platform.gameclient.views.summoner.stats.ChampionSummaryStatsData;
   import mx.utils.ObjectUtil;
   
   public class ChampionListUtil
   {
      
      private static var _championSummaryStats:Array;
      
      private static var _championList:ChampionListPresentationModel;
      
      private static var _inventoryController:IInventoryController;
      
      public function ChampionListUtil()
      {
         var _loc1_:Array = null;
         var _loc2_:IChampionFilter = null;
         super();
         _championSummaryStats = [];
         if(Boolean(_inventoryController))
         {
            _loc1_ = _inventoryController.createSearchTags();
            _loc2_ = _inventoryController.createChampionFilter(_loc1_);
         }
         _championList = new ChampionListPresentationModel(true,_loc2_);
      }
      
      public static function reset() : void
      {
         var _loc1_:Array = null;
         var _loc2_:IChampionFilter = null;
         if(Boolean(_inventoryController))
         {
            _loc1_ = _inventoryController.createSearchTags();
            _loc2_ = _inventoryController.createChampionFilter(_loc1_);
         }
         _championList = new ChampionListPresentationModel(true,_loc2_);
         _championList.customFilterFunction = filterChampionsByGames;
         _championList.customSortFunction = sortChampionByGames;
         _championList.championsList = _inventoryController.inventory.champions;
         _championList.refreshSortedList();
      }
      
      public static function sortChampionByGames(param1:Champion, param2:Champion, param3:Array = null) : int
      {
         var _loc4_:Number = 0;
         var _loc5_:Number = 0;
         var _loc6_:ChampionSummaryStatsData = _championSummaryStats[param1.championId];
         if(Boolean(_loc6_))
         {
            _loc4_ = _loc6_.totalGames;
         }
         _loc6_ = _championSummaryStats[param2.championId];
         if(Boolean(_loc6_))
         {
            _loc5_ = _loc6_.totalGames;
         }
         return ObjectUtil.numericCompare(_loc4_,_loc5_) * -1;
      }
      
      public static function filterChampionsByGames(param1:Champion) : Boolean
      {
         if(!_championSummaryStats)
         {
            return false;
         }
         var _loc2_:ChampionSummaryStatsData = _championSummaryStats[param1.championId];
         if(!_loc2_)
         {
            return false;
         }
         return _loc2_.totalGames > 0;
      }
      
      public static function set championSummaryStats(param1:Array) : void
      {
         _championSummaryStats = param1;
      }
      
      public static function get championList() : ChampionListPresentationModel
      {
         return _championList;
      }
      
      public static function set inventoryController(param1:IInventoryController) : void
      {
         _inventoryController = param1;
      }
   }
}

