package com.riotgames.platform.gameclient.domain.game
{
   public class QueueType
   {
      
      public static const NONE:String = "NONE";
      
      public static const NORMAL:String = "NORMAL";
      
      public static const NORMAL_3x3:String = "NORMAL_3x3";
      
      public static const BOT:String = "BOT";
      
      public static const BOT_3x3:String = "BOT_3x3";
      
      public static const ARAM_UNRANKED_1x1:String = "ARAM_UNRANKED_1x1";
      
      public static const ARAM_UNRANKED_2x2:String = "ARAM_UNRANKED_2x2";
      
      public static const ARAM_UNRANKED_3x3:String = "ARAM_UNRANKED_3x3";
      
      public static const ARAM_UNRANKED_5x5:String = "ARAM_UNRANKED_5x5";
      
      public static const ARAM_UNRANKED_6x6:String = "ARAM_UNRANKED_6x6";
      
      public static const RANKED_SOLO_1x1:String = "RANKED_SOLO_1x1";
      
      public static const RANKED_SOLO_3x3:String = "RANKED_SOLO_3x3";
      
      public static const RANKED_SOLO_5x5:String = "RANKED_SOLO_5x5";
      
      public static const RANKED_PREMADE_3x3:String = "RANKED_PREMADE_3x3";
      
      public static const RANKED_PREMADE_5x5:String = "RANKED_PREMADE_5x5";
      
      public static const RANKED_TEAM_3x3:String = "RANKED_TEAM_3x3";
      
      public static const RANKED_TEAM_5x5:String = "RANKED_TEAM_5x5";
      
      public static const DOMINION_UNRANKED:String = "ODIN_UNRANKED";
      
      public static const DOMINION_RANKED_SOLO:String = "ODIN_RANKED_SOLO";
      
      public static const DOMINION_RANKED_PREMADE:String = "ODIN_RANKED_PREMADE";
      
      public static const CAP5x5:String = "CAP5x5";
      
      public static const CAP1x1:String = "CAP1x1";
      
      public static const FEATURED:String = "FEATURED";
      
      public static const FEATURED_BOT:String = "FEATURED_BOT";
      
      public static const URF_BOT:String = "URF_BOT";
      
      public static const NIGHTMARE_BOT:String = "NIGHTMARE_BOT";
      
      public function QueueType()
      {
         super();
         throw new Error("Cannot create an instance of this class.");
      }
      
      public static function isAspirationalQueue(param1:String) : Boolean
      {
         var _loc2_:Boolean = true;
         if(param1 == "RANKED_TEAM_3x3" || param1 == "RANKED_TEAM_5x5")
         {
            _loc2_ = false;
         }
         return _loc2_;
      }
      
      public static function isCoopVsAI(param1:String) : Boolean
      {
         return param1 == null ? false : param1 == BOT || param1 == BOT_3x3 || param1 == FEATURED_BOT || param1 == URF_BOT || param1 == NIGHTMARE_BOT;
      }
   }
}

