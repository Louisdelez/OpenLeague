package com.riotgames.pvpnet.system.leagues
{
   import com.riotgames.pvpnet.system.leagues.configuration.LeagueConfig;
   
   public class LeagueTier
   {
      
      private static const PRSRVD_PROVISIONAL:LeagueTier = new LeagueTier("PRSRVD_PROVISIONAL");
      
      public static const NULL:LeagueTier = new LeagueTier("NULL");
      
      public static const PROVISIONAL:LeagueTier = new LeagueTier("PROVISIONAL");
      
      public static const BRONZE:LeagueTier = new LeagueTier("BRONZE");
      
      public static const SILVER:LeagueTier = new LeagueTier("SILVER");
      
      public static const GOLD:LeagueTier = new LeagueTier("GOLD");
      
      public static const PLATINUM:LeagueTier = new LeagueTier("PLATINUM");
      
      public static const DIAMOND:LeagueTier = new LeagueTier("DIAMOND");
      
      public static const MASTER:LeagueTier = new LeagueTier("MASTER");
      
      public static const CHALLENGER:LeagueTier = new LeagueTier("CHALLENGER");
      
      private static const LOWEST_TO_HIGHEST_WITH_MASTER:Array = [BRONZE,SILVER,GOLD,PLATINUM,DIAMOND,MASTER,CHALLENGER];
      
      private static const LOWEST_TO_HIGHEST_NO_MASTER:Array = [BRONZE,SILVER,GOLD,PLATINUM,DIAMOND,CHALLENGER];
      
      private var _value:String;
      
      public function LeagueTier(param1:String)
      {
         super();
         this._value = param1;
      }
      
      private static function get lowestToHighest() : Array
      {
         if(LeagueConfig.isMasterTierEnabled())
         {
            return LOWEST_TO_HIGHEST_WITH_MASTER;
         }
         return LOWEST_TO_HIGHEST_NO_MASTER;
      }
      
      public static function values(param1:LeagueSortOrder) : Array
      {
         if(param1 == LeagueSortOrder.ASCENDING)
         {
            return lowestToHighest.concat();
         }
         if(param1 == LeagueSortOrder.DESCENDING)
         {
            return lowestToHighest.concat().reverse();
         }
         return null;
      }
      
      public static function valueOf(param1:String) : LeagueTier
      {
         if(CHALLENGER.value() == param1)
         {
            return CHALLENGER;
         }
         if(MASTER.value() == param1)
         {
            return MASTER;
         }
         if(DIAMOND.value() == param1)
         {
            return DIAMOND;
         }
         if(PLATINUM.value() == param1)
         {
            return PLATINUM;
         }
         if(GOLD.value() == param1)
         {
            return GOLD;
         }
         if(SILVER.value() == param1)
         {
            return SILVER;
         }
         if(BRONZE.value() == param1)
         {
            return BRONZE;
         }
         if(PROVISIONAL.value() == param1)
         {
            return PROVISIONAL;
         }
         if(PRSRVD_PROVISIONAL.value() == param1)
         {
            return PROVISIONAL;
         }
         return NULL;
      }
      
      public function value() : String
      {
         return this._value;
      }
      
      public function isApex() : Boolean
      {
         return this == CHALLENGER || this == MASTER;
      }
      
      public function isBelow(param1:LeagueTier) : Boolean
      {
         return lowestToHighest.indexOf(this) < lowestToHighest.indexOf(param1);
      }
      
      public function next() : LeagueTier
      {
         if(this == PROVISIONAL)
         {
            return PROVISIONAL;
         }
         if(this == NULL)
         {
            return NULL;
         }
         var _loc1_:int = lowestToHighest.indexOf(this);
         if(_loc1_ < 0)
         {
            return NULL;
         }
         var _loc2_:* = Math.min(_loc1_ + 1,lowestToHighest.length - 1);
         return lowestToHighest[_loc2_];
      }
      
      public function previous() : LeagueTier
      {
         if(this == PROVISIONAL)
         {
            return PROVISIONAL;
         }
         if(this == NULL)
         {
            return NULL;
         }
         var _loc1_:int = lowestToHighest.indexOf(this);
         if(_loc1_ < 0)
         {
            return NULL;
         }
         var _loc2_:* = Math.max(_loc1_ - 1,0);
         return lowestToHighest[_loc2_];
      }
   }
}

