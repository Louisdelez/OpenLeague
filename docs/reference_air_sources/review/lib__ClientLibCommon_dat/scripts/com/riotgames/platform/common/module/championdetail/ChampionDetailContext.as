package com.riotgames.platform.common.module.championdetail
{
   public class ChampionDetailContext
   {
      
      public static const STORE:String = "store";
      
      public static const LANDING_PAGE:String = "landingPage";
      
      public static const CHAMPION_SELECT:String = "championSelect";
      
      public static const SUMMONER_PROFILE:String = "summonerProfile";
      
      public function ChampionDetailContext()
      {
         super();
         throw new Error("This is a static utility class.  Do not instantiate");
      }
   }
}

