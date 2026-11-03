package com.riotgames.pvpnet.system.leagues
{
   public class LeagueRank
   {
      
      public static const DEFAULT:LeagueRank = new LeagueRank("DEFAULT");
      
      public static const I:LeagueRank = new LeagueRank("I");
      
      public static const II:LeagueRank = new LeagueRank("II");
      
      public static const III:LeagueRank = new LeagueRank("III");
      
      public static const IV:LeagueRank = new LeagueRank("IV");
      
      public static const V:LeagueRank = new LeagueRank("V");
      
      private static const LOWEST_TO_HIGHEST:Array = [V,IV,III,II,I];
      
      private var _value:String;
      
      public function LeagueRank(param1:String)
      {
         super();
         this._value = param1;
      }
      
      public static function valuesFor(param1:LeagueTier, param2:LeagueSortOrder) : Array
      {
         switch(param1)
         {
            case LeagueTier.BRONZE:
            case LeagueTier.SILVER:
            case LeagueTier.GOLD:
            case LeagueTier.PLATINUM:
            case LeagueTier.DIAMOND:
               return values(param2);
            case LeagueTier.MASTER:
            case LeagueTier.CHALLENGER:
               return [I];
            case LeagueTier.NULL:
            case LeagueTier.PROVISIONAL:
         }
         return [DEFAULT];
      }
      
      public static function values(param1:LeagueSortOrder) : Array
      {
         if(param1 == LeagueSortOrder.ASCENDING)
         {
            return LOWEST_TO_HIGHEST.concat();
         }
         if(param1 == LeagueSortOrder.DESCENDING)
         {
            return LOWEST_TO_HIGHEST.concat().reverse();
         }
         return null;
      }
      
      public static function valueOf(param1:String) : LeagueRank
      {
         if(I.value() == param1)
         {
            return I;
         }
         if(II.value() == param1)
         {
            return II;
         }
         if(III.value() == param1)
         {
            return III;
         }
         if(IV.value() == param1)
         {
            return IV;
         }
         if(V.value() == param1)
         {
            return V;
         }
         return DEFAULT;
      }
      
      public function value() : String
      {
         return this._value;
      }
      
      public function isBelow(param1:LeagueRank) : Boolean
      {
         return LOWEST_TO_HIGHEST.indexOf(this) < LOWEST_TO_HIGHEST.indexOf(param1);
      }
      
      public function next() : LeagueRank
      {
         if(this == DEFAULT)
         {
            return DEFAULT;
         }
         var _loc1_:int = LOWEST_TO_HIGHEST.indexOf(this);
         if(_loc1_ < 0)
         {
            return DEFAULT;
         }
         var _loc2_:* = Math.min(_loc1_ + 1,LOWEST_TO_HIGHEST.length - 1);
         return LOWEST_TO_HIGHEST[_loc2_];
      }
      
      public function previous() : LeagueRank
      {
         if(this == DEFAULT)
         {
            return DEFAULT;
         }
         var _loc1_:int = LOWEST_TO_HIGHEST.indexOf(this);
         if(_loc1_ < 0)
         {
            return DEFAULT;
         }
         var _loc2_:* = Math.max(_loc1_ - 1,0);
         return LOWEST_TO_HIGHEST[_loc2_];
      }
   }
}

