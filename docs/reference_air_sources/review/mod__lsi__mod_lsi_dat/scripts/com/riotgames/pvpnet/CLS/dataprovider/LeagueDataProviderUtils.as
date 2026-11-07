package com.riotgames.pvpnet.CLS.dataprovider
{
   import com.riotgames.platform.gameclient.domain.LeagueItemDTO;
   import com.riotgames.pvpnet.CLS.views.enums.PromotionSeriesResultsEnum;
   import com.riotgames.pvpnet.system.leagues.LeagueRank;
   
   public class LeagueDataProviderUtils
   {
      
      private static const GAMES_TO_PLAY_DIVISION_ONE:uint = 5;
      
      private static const GAMES_TO_PLAY_LOWER_DIVISIONS:uint = 3;
      
      public function LeagueDataProviderUtils()
      {
         super();
      }
      
      public static function fillMiniSeriesGames(param1:LeagueItemDTO, param2:LeagueRank) : Array
      {
         var _loc6_:uint = 0;
         var _loc7_:String = null;
         var _loc3_:uint = param2 == LeagueRank.I ? GAMES_TO_PLAY_DIVISION_ONE : GAMES_TO_PLAY_LOWER_DIVISIONS;
         var _loc4_:uint = 0;
         var _loc5_:Array = [];
         if(param1.miniSeries != null)
         {
            if(param1.miniSeries.progress != null)
            {
               _loc6_ = 0;
               while(_loc6_ < param1.miniSeries.progress.length)
               {
                  _loc7_ = "";
                  if(param1.miniSeries.progress.charAt(_loc6_) == "W")
                  {
                     _loc5_.push(PromotionSeriesResultsEnum.WIN_RANK_GAME);
                  }
                  else if(param1.miniSeries.progress.charAt(_loc6_) == "L")
                  {
                     _loc5_.push(PromotionSeriesResultsEnum.LOSE_RANK_GAME);
                  }
                  else
                  {
                     _loc5_[_loc6_] = PromotionSeriesResultsEnum.DISABLE_RANK_GAME;
                  }
                  _loc6_++;
               }
            }
            else
            {
               while(_loc6_ < param1.miniSeries.wins)
               {
                  _loc5_.push(PromotionSeriesResultsEnum.WIN_RANK_GAME);
                  _loc4_++;
                  _loc6_++;
               }
               _loc6_ = 0;
               while(_loc6_ < param1.miniSeries.losses)
               {
                  _loc5_.push(PromotionSeriesResultsEnum.LOSE_RANK_GAME);
                  _loc4_++;
                  _loc6_++;
               }
               _loc6_ = _loc4_;
               while(_loc6_ < _loc3_)
               {
                  _loc5_[_loc6_] = PromotionSeriesResultsEnum.DISABLE_RANK_GAME;
                  _loc6_++;
               }
            }
         }
         return _loc5_;
      }
   }
}

