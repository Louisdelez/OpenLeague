package com.riotgames.pvpnet.system.leagues
{
   public class LeagueSortOrder
   {
      
      public static const ASCENDING:LeagueSortOrder = new LeagueSortOrder("ASCENDING");
      
      public static const DESCENDING:LeagueSortOrder = new LeagueSortOrder("DESCENDING");
      
      private var _value:String;
      
      public function LeagueSortOrder(param1:String)
      {
         super();
         this._value = param1;
      }
   }
}

