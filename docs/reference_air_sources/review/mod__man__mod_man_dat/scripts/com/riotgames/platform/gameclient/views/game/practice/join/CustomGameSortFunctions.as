package com.riotgames.platform.gameclient.views.game.practice.join
{
   import com.riotgames.platform.gameclient.domain.game.practice.PracticeGameSearchResult;
   
   public class CustomGameSortFunctions
   {
      
      public function CustomGameSortFunctions()
      {
         super();
      }
      
      public static function sortByPrivateGame(param1:PracticeGameSearchResult, param2:PracticeGameSearchResult) : int
      {
         if(param1.privateGame == param2.privateGame)
         {
            return sortByGameName(param1,param2);
         }
         if(param1.privateGame)
         {
            return -1;
         }
         return 1;
      }
      
      public static function sortByGameName(param1:PracticeGameSearchResult, param2:PracticeGameSearchResult) : int
      {
         var _loc3_:String = param1.lowerGameName;
         var _loc4_:String = param2.lowerGameName;
         if(_loc3_ < _loc4_)
         {
            return -1;
         }
         if(_loc3_ == _loc4_)
         {
            return 0;
         }
         return 1;
      }
      
      public static function sortByMapName(param1:PracticeGameSearchResult, param2:PracticeGameSearchResult) : int
      {
         if(param1.gameMap.displayName < param2.gameMap.displayName)
         {
            return -1;
         }
         if(param1.gameMap == param2.gameMap)
         {
            return 0;
         }
         return 1;
      }
      
      public static function calcOpenSlotsForPracticeGameSlotSorting(param1:PracticeGameSearchResult) : int
      {
         if(!param1.canLobbySpectate)
         {
            return -1;
         }
         if(param1.spectatorCount >= PracticeGameSearchResult.spectatorSlotLimit)
         {
            return 0;
         }
         return PracticeGameSearchResult.spectatorSlotLimit - param1.spectatorCount;
      }
      
      public static function sortByOwnerName(param1:PracticeGameSearchResult, param2:PracticeGameSearchResult) : int
      {
         var _loc3_:String = param1.lowerOwnerSummonerName;
         var _loc4_:String = param2.lowerOwnerSummonerName;
         if(_loc3_ < _loc4_)
         {
            return -1;
         }
         if(_loc3_ == _loc4_)
         {
            return 0;
         }
         return 1;
      }
      
      public static function sortBySpectatorSlots(param1:PracticeGameSearchResult, param2:PracticeGameSearchResult) : int
      {
         var _loc3_:int = calcOpenSlotsForPracticeGameSlotSorting(param1);
         var _loc4_:int = calcOpenSlotsForPracticeGameSlotSorting(param2);
         if(_loc3_ < _loc4_)
         {
            return -1;
         }
         if(_loc3_ == _loc4_)
         {
            return 0;
         }
         return 1;
      }
      
      public static function sortByNumberOfPlayersAvailable(param1:PracticeGameSearchResult, param2:PracticeGameSearchResult) : int
      {
         if(!param1 || !param1.playersAvailable)
         {
            return -1;
         }
         if(!param2 || !param2.playersAvailable)
         {
            return 1;
         }
         if(param1.maxNumPlayers < param2.maxNumPlayers)
         {
            return -1;
         }
         if(param1.maxNumPlayers == param2.maxNumPlayers)
         {
            if(param1.teamCounts < param2.teamCounts)
            {
               return -1;
            }
            if(param1.teamCounts == param2.teamCounts)
            {
               return 0;
            }
         }
         return 1;
      }
   }
}

