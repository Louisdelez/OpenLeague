package com.riotgames.platform.gameclient.championselection.enum
{
   public class ChampionSelectState
   {
      
      public static var tutorialPickOverride:Boolean = false;
      
      public static const CHAMPION_SELECT_STATE_INACTIVESELF:String = "inactiveSelf";
      
      public static const CHAMPION_SELECT_STATE_INACTIVEOTHER:String = "inactiveOther";
      
      public static const CHAMPION_SELECT_STATE_ACTIVESELF:String = "activeSelf";
      
      public static const CHAMPION_SELECT_STATE_ACTIVEOTHER:String = "activeOther";
      
      public function ChampionSelectState()
      {
         super();
         throw new Error("This is a static enum class.");
      }
   }
}

