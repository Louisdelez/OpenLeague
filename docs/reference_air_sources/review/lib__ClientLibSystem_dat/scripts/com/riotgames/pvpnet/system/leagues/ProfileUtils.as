package com.riotgames.pvpnet.system.leagues
{
   public class ProfileUtils
   {
      
      public static const MIN_RANKED_GAMES_FOR_RANKING:uint = 5;
      
      public static const MIN_RANKED_GAMES_FOR_LEAGUES:Object = {
         "RANKED_SOLO_5x5":10,
         "RANKED_TEAM_5x5":5,
         "RANKED_TEAM_3x3":5
      };
      
      private static var _competitiveRegion:String = "none";
      
      public function ProfileUtils()
      {
         super();
      }
      
      public static function set competitiveRegion(param1:String) : void
      {
         if(_competitiveRegion != param1)
         {
            _competitiveRegion = param1.toLowerCase();
         }
      }
      
      public static function getTakedownsMedal(param1:Number) : LeagueTier
      {
         if(param1 >= 10000)
         {
            return LeagueTier.DIAMOND;
         }
         if(param1 >= 5000)
         {
            return LeagueTier.PLATINUM;
         }
         if(param1 >= 2500)
         {
            return LeagueTier.GOLD;
         }
         if(param1 >= 500)
         {
            return LeagueTier.SILVER;
         }
         if(param1 >= 100)
         {
            return LeagueTier.BRONZE;
         }
         return LeagueTier.NULL;
      }
      
      public static function getMinionKillsMedal(param1:Number) : LeagueTier
      {
         if(param1 >= 200000)
         {
            return LeagueTier.DIAMOND;
         }
         if(param1 >= 100000)
         {
            return LeagueTier.PLATINUM;
         }
         if(param1 >= 50000)
         {
            return LeagueTier.GOLD;
         }
         if(param1 >= 10000)
         {
            return LeagueTier.SILVER;
         }
         if(param1 >= 2000)
         {
            return LeagueTier.BRONZE;
         }
         return LeagueTier.NULL;
      }
      
      public static function getTowersDestroyedMedal(param1:Number) : LeagueTier
      {
         if(param1 >= 500)
         {
            return LeagueTier.DIAMOND;
         }
         if(param1 >= 200)
         {
            return LeagueTier.PLATINUM;
         }
         if(param1 >= 100)
         {
            return LeagueTier.GOLD;
         }
         if(param1 >= 25)
         {
            return LeagueTier.SILVER;
         }
         if(param1 >= 5)
         {
            return LeagueTier.BRONZE;
         }
         return LeagueTier.NULL;
      }
      
      public static function getPointsCappedMedal(param1:Number) : LeagueTier
      {
         if(param1 >= 5000)
         {
            return LeagueTier.DIAMOND;
         }
         if(param1 >= 1000)
         {
            return LeagueTier.PLATINUM;
         }
         if(param1 >= 500)
         {
            return LeagueTier.GOLD;
         }
         if(param1 >= 250)
         {
            return LeagueTier.SILVER;
         }
         if(param1 >= 100)
         {
            return LeagueTier.BRONZE;
         }
         return LeagueTier.NULL;
      }
      
      public static function getNormalWinsMedal(param1:Number) : LeagueTier
      {
         if(param1 >= 600)
         {
            return LeagueTier.DIAMOND;
         }
         if(param1 >= 300)
         {
            return LeagueTier.PLATINUM;
         }
         if(param1 >= 100)
         {
            return LeagueTier.GOLD;
         }
         if(param1 >= 25)
         {
            return LeagueTier.SILVER;
         }
         if(param1 >= 5)
         {
            return LeagueTier.BRONZE;
         }
         return LeagueTier.NULL;
      }
   }
}

