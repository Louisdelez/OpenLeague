package com.riotgames.pvpnet.matchhistoryiron.enum
{
   import com.riotgames.platform.common.utils.RiotResourceLoader;
   
   public class EMatchHistoryLocalization
   {
      
      public static const BUNDLE_ID:String = "MatchHistory";
      
      public static const COMMON_BUNDLE_ID:String = "MatchHistory";
      
      public static const MATCH_HISTORY:String = "MATCH_HISTORY";
      
      public static const XP_LABEL:String = "XP_LABEL";
      
      public static const IP_LABEL:String = "IP_LABEL";
      
      public static const EXPIRATION_LABEL:String = "EXPIRATION_LABEL";
      
      public static const EXPIRED_LABEL:String = "EXPIRED_LABEL";
      
      public static const TEAM_VERSUS:String = "TEAM_VERSUS";
      
      public static const GAME_VICTORY:String = "GAME_VICTORY";
      
      public static const GAME_DEFEAT:String = "GAME_DEFEAT";
      
      public static const GAME_LEAVER:String = "GAME_LEAVER";
      
      public static const GAME_INVALID:String = "GAME_INVALID";
      
      public static const MAP_NAME_PREFIX:String = "displayname";
      
      public static const LAST_MATCHES:String = "LAST_MATCHES";
      
      public static const GAME_TYPE_PREFIX:String = "GAME_TYPE_";
      
      public static const THOUSAND:String = "THOUSAND";
      
      public static const SUMMONER_IS_YOU:String = "SUMMONER_IS_YOU";
      
      public static const TOOL_TIP_KILL:String = "TOOL_TIP_KILL";
      
      public static const TOOL_TIP_DEATH:String = "TOOL_TIP_DEATH";
      
      public static const TOOL_TIP_ASSIST:String = "TOOL_TIP_ASSIST";
      
      public static const TOOL_TIP_GOLD:String = "TOOL_TIP_GOLD";
      
      public static const TOOL_TIP_TIME:String = "TOOL_TIP_TIME";
      
      public static const TOOL_TIP_REPLAY:String = "TOOL_TIP_REPLAY";
      
      public static const TOOL_TIP_MINION:String = "TOOL_TIP_MINION";
      
      public static const TOOL_TIP_DOMINION_SCORE:String = "TOOL_TIP_DOMINION_SCORE";
      
      public static const TOOL_TIP_DOMINION_CAPTURE:String = "TOOL_TIP_DOMINION_CAPTURE";
      
      public static const TOOL_TIP_DOMINION_NEUTRALIZE:String = "TOOL_TIP_DOMINION_NEUTRALIZE";
      
      public static const LEGACY_GAME_TYPE_PREFIX:String = "summonerProfile_recentGame_";
      
      public static const STAT_CONTAINER_TITLE:String = "STAT_CONTAINER_TITLE";
      
      public static const LEGACY_XP_LABEL:String = "summonerProfile_recentGame_earnedXP";
      
      public static const LEGACY_IP_LABEL:String = "summonerProfile_recentGame_earnedIP";
      
      public static const INSTRUCTION_LABEL:String = "summonerProfile_profile_recentMatchesInstructions";
      
      public static const SHARE_MATCH_HISTORY_TITLE1:String = "SHARE_MATCH_HISTORY_TITLE1";
      
      public static const SHARE_MATCH_HISTORY_TITLE2:String = "SHARE_MATCH_HISTORY_TITLE2";
      
      public static const SHARE_MATCH_HISTORY_DESC:String = "SHARE_MATCH_HISTORY_DESC";
      
      public static const SHARE_MATCH_HISTORY_BULLET1:String = "SHARE_MATCH_HISTORY_BULLET1";
      
      public static const SHARE_MATCH_HISTORY_BULLET2:String = "SHARE_MATCH_HISTORY_BULLET2";
      
      public static const SHARE_MATCH_HISTORY_BULLET3:String = "SHARE_MATCH_HISTORY_BULLET3";
      
      public static const SHARE_MATCH_HISTORY_DIRECTIONS:String = "SHARE_MATCH_HISTORY_DIRECTIONS";
      
      public static const SHARE_MATCH_HISTORY_BUTTON_TEXT:String = "SHARE_MATCH_HISTORY_BUTTON_TEXT";
      
      public static const SHARE_MATCH_HISTORY_BUTTON_TEXT_SHORT:String = "SHARE_MATCH_HISTORY_BUTTON_TEXT_SHORT";
      
      public static const GAME_CLICK_DESCRIPTION_TEXT:String = "GAME_CLICK_DESCRIPTION";
      
      public function EMatchHistoryLocalization()
      {
         super();
      }
      
      public static function getLocalizedString(param1:String, param2:Array = null) : String
      {
         return RiotResourceLoader.getResourceString(EMatchHistoryLocalization.BUNDLE_ID,param1,"**" + param1,param2);
      }
   }
}

