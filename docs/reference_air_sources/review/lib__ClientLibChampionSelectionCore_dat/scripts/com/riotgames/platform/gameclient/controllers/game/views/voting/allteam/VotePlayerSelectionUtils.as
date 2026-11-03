package com.riotgames.platform.gameclient.controllers.game.views.voting.allteam
{
   import com.riotgames.platform.gameclient.controllers.game.enums.MenuStates;
   import com.riotgames.platform.gameclient.controllers.game.model.PlayerSelection;
   import com.riotgames.platform.gameclient.domain.game.ChampionVoteInfo;
   import com.riotgames.platform.gameclient.domain.game.GameState;
   
   public class VotePlayerSelectionUtils
   {
      
      public function VotePlayerSelectionUtils()
      {
         super();
      }
      
      public static function getWinningChampionId(param1:PlayerSelection, param2:String) : int
      {
         if(param2 == GameState.POST_CHAMPION_SELECTION)
         {
            if(param1 != null && param1.champion != null)
            {
               return param1.champion.championId;
            }
         }
         return 0;
      }
      
      public static function getChampionVoteInfo(param1:PlayerSelection, param2:String, param3:String) : ChampionVoteInfo
      {
         var _loc4_:ChampionVoteInfo = null;
         if(param1 != null && param1.champion != null)
         {
            _loc4_ = new ChampionVoteInfo();
            _loc4_.championID = param1.champion.championId;
            _loc4_.lockedIn = param2 == GameState.POST_CHAMPION_SELECTION || param2 == GameState.CHAMPION_SELECTION && param3 != MenuStates.SMALL_MENU_STATE_ACTIVE;
            return _loc4_;
         }
         return null;
      }
   }
}

