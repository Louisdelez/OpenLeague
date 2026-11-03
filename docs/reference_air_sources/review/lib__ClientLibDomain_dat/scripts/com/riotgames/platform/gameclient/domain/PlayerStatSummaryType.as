package com.riotgames.platform.gameclient.domain
{
   import com.riotgames.platform.gameclient.domain.game.QueueType;
   
   public class PlayerStatSummaryType
   {
      
      public static const COOP_VS_AI:String = "CoopVsAI";
      
      public static const UNRANKED:String = "Unranked";
      
      public static const UNRANKED_3x3:String = "Unranked3x3";
      
      public static const RANKED_SOLO_1x1:String = "RankedSolo1x1";
      
      public static const RANKED_SOLO_3x3:String = "RankedSolo3x3";
      
      public static const RANKED_SOLO_5x5:String = "RankedSolo5x5";
      
      public static const RANKED_PREMADE_3x3:String = "RankedPremade3x3";
      
      public static const RANKED_PREMADE_5x5:String = "RankedPremade5x5";
      
      public static const RANKED_TEAM_3x3:String = "RankedTeam3x3";
      
      public static const RANKED_TEAM_5x5:String = "RankedTeam5x5";
      
      public static const DOMINION_UNRANKED:String = "OdinUnranked";
      
      public static const DOMINION_RANKED_SOLO:String = "OdinRankedSolo";
      
      public static const DOMINION_RANKED_PREMADE:String = "odinRankedPremade";
      
      public static const ARAM_SOLO_1x1:String = "AramUnranked1x1";
      
      public static const ARAM_SOLO_2x2:String = "AramUnranked2x2";
      
      public static const ARAM_SOLO_3x3:String = "AramUnranked3x3";
      
      public static const ARAM_SOLO_5x5:String = "AramUnranked5x5";
      
      public static const ARAM_SOLO_6x6:String = "AramUnranked6x6";
      
      public static const CAP5x5:String = "CAP5x5";
      
      public static const CAP1x1:String = "CAP1x1";
      
      public function PlayerStatSummaryType()
      {
         super();
      }
      
      public static function isRanked(param1:String) : Boolean
      {
         return param1.indexOf("Ranked") == 0;
      }
      
      public static function convert(param1:String) : String
      {
         var _loc2_:String = null;
         switch(param1)
         {
            case QueueType.NORMAL:
            case QueueType.BOT:
            case QueueType.BOT_3x3:
               _loc2_ = UNRANKED;
               break;
            case QueueType.NORMAL_3x3:
               _loc2_ = UNRANKED_3x3;
               break;
            case QueueType.RANKED_SOLO_1x1:
               _loc2_ = RANKED_SOLO_1x1;
               break;
            case QueueType.RANKED_SOLO_3x3:
               _loc2_ = RANKED_SOLO_3x3;
               break;
            case QueueType.RANKED_SOLO_5x5:
               _loc2_ = RANKED_SOLO_5x5;
               break;
            case QueueType.RANKED_PREMADE_3x3:
               _loc2_ = RANKED_PREMADE_3x3;
               break;
            case QueueType.RANKED_PREMADE_5x5:
               _loc2_ = RANKED_PREMADE_5x5;
               break;
            case QueueType.RANKED_TEAM_3x3:
               _loc2_ = RANKED_TEAM_3x3;
               break;
            case QueueType.RANKED_TEAM_5x5:
               _loc2_ = RANKED_TEAM_5x5;
               break;
            case QueueType.DOMINION_UNRANKED:
               _loc2_ = DOMINION_UNRANKED;
               break;
            case QueueType.DOMINION_RANKED_SOLO:
               _loc2_ = DOMINION_RANKED_SOLO;
               break;
            case QueueType.DOMINION_RANKED_PREMADE:
               _loc2_ = DOMINION_RANKED_PREMADE;
               break;
            case QueueType.ARAM_UNRANKED_1x1:
               _loc2_ = ARAM_SOLO_1x1;
               break;
            case QueueType.ARAM_UNRANKED_2x2:
               _loc2_ = ARAM_SOLO_2x2;
               break;
            case QueueType.ARAM_UNRANKED_3x3:
               _loc2_ = ARAM_SOLO_3x3;
               break;
            case QueueType.ARAM_UNRANKED_5x5:
               _loc2_ = ARAM_SOLO_5x5;
               break;
            case QueueType.ARAM_UNRANKED_6x6:
               _loc2_ = ARAM_SOLO_6x6;
               break;
            case QueueType.CAP5x5:
               _loc2_ = CAP5x5;
               break;
            case QueueType.CAP1x1:
               _loc2_ = CAP1x1;
         }
         if(_loc2_ == null)
         {
            throw new Error("We didn\'t find a conversion for: " + param1);
         }
         return _loc2_;
      }
   }
}

