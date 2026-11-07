package com.riotgames.platform.gameclient.domain.game
{
   import com.riotgames.platform.common.utils.RiotResourceLoader;
   
   public class CompetitiveSeason
   {
      
      private static var _currentSeason:int = 3;
      
      public function CompetitiveSeason()
      {
         super();
      }
      
      public static function set currentSeason(param1:int) : void
      {
         _currentSeason = param1;
      }
      
      public static function get currentSeason() : int
      {
         return _currentSeason;
      }
      
      public static function getLocalizedNameList() : Array
      {
         var _loc1_:Array = [];
         var _loc2_:int = 1;
         while(_loc2_ <= _currentSeason)
         {
            _loc1_[_loc2_ - 1] = RiotResourceLoader.getString("season_name",_loc2_.toString(),[_loc2_.toString()]);
            _loc2_++;
         }
         return _loc1_;
      }
   }
}

