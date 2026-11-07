package com.riotgames.platform.common.utils
{
   public class MessageDictionary
   {
      
      public static const CONNECTION_TO_HOST_FAILED:String = "GEN-0001";
      
      public static const REMOTE_SERVICE_REQUEST_TIMED_OUT:String = "GEN-0002";
      
      public static const CONNECTION_FAILED_TITLE:String = "GEN-0003";
      
      public static const UNHANDLED_ERROR:String = "GEN-0004";
      
      public static const UNHANDLED_ERROR_TITLE:String = "GEN-0005";
      
      public static const UNKNOWN_ERROR:String = "GEN-0006";
      
      public static const UNKNOWN_ERROR_TITLE:String = "GEN-0007";
      
      public static const ERROR_SUBMITTING_LOGS:String = "GEN-0008";
      
      public static const SUMMONER_NAME_CONTAINS_OFFENSIVE_WORDS:String = "WF-0001";
      
      public static const GAME_NAME_CONTAINS_OFFENSIVE_WORDS:String = "WF-0002";
      
      public static const PAGE_NAME_CONTAINS_OFFENSIVE_WORDS:String = "WF-0003";
      
      public static const CHAT_STATUS_CONTAINS_OFFENSIVE_WORDS:String = "WF-0004";
      
      public static const SUMMONER_NAME_CONTAINS_INVALID_CHARS:String = "WF-0005";
      
      public static const SUMMONER_NAME_CONTAINS_RESTRICTED_WORDS:String = "WF-0006";
      
      public static const CHAT_ROOM_CONTAINS_OFFENSIVE_WORDS:String = "WF-0007";
      
      public static const NOT_ENOUGH_PLAYERS_TO_START_GAME:String = "PG-0001";
      
      public static const STALE_GAME:String = "PG-0002";
      
      public static const CANNOT_SWITCH_TEAMS:String = "PG-0003";
      
      public static const TEAM_FULL:String = "PG-0004";
      
      public static const CANNOT_SUMMON_CHAMPION:String = "PG-0005";
      
      public static const CANNOT_UNSUMMON_CHAMPION:String = "PG-0006";
      
      public static const CANNOT_SET_USER_SPELL:String = "PG-0007";
      
      public static const GAME_FAILED_TO_START:String = "PG-0019";
      
      public static const GAME_ENDED_IN_ERROR:String = "PG-0023";
      
      public static const PLAYER_BANNED_FROM_GAME:String = "PG-0021";
      
      public static const GAME_CHAMPION_NOT_OWNED:String = "PG-0022";
      
      public static const PRACTICE_GAME_BOT_WITH_BAD_CHAMPION:String = "PG-0024";
      
      public static const PRACTICE_GAME_BOT_WITH_NULL_CHAMPION:String = "PG-0025";
      
      public static const GAME_NO_LONGER_IN_PROGRESS:String = "PG-0026";
      
      public static const PRACTICE_GAME_CANNOT_CREATE_NEED_MORE_PLAYER_SLOTS:String = "PG-0027";
      
      public static const PRACTICE_GAME_CANNOT_SELECT_CHAMP_NEED_MORE_PLAYERS:String = "PG-0028";
      
      public static const PRACTICE_GAME_CANNOT_ADD_BOT_SLOT_NEEDED_FOR_PLAYER:String = "PG-0029";
      
      public static const DRAFT_MODE_GAME_NOT_TURN:String = "PG-0030";
      
      public static const GAME_CHAMPION_BANNED:String = "PG-0031";
      
      public static const CANNOT_SELECT_SKINS_GAME_STARTED:String = "PG-0032";
      
      public static const CANNOT_SELECT_DUPLICATE_SPELLS:String = "PG-0033";
      
      public static const CANNOT_SELECT_DUPLICATE_CAHMPION:String = "PG-0034";
      
      public static const SPECTATING_DISABLED:String = "PG-0036";
      
      public static const PRACTICE_GAME_CANNOT_CREATE_TOO_MANY_PLAYER_SLOTS:String = "PG-0037";
      
      public static const INVITE_ERROR_TITLE:String = "INV-0000";
      
      public static const PLAYER_NOT_FOUND:String = "INV-0001";
      
      public static const PLAYER_NOT_ONLINE:String = "INV-0002";
      
      public static const PLAYER_NOT_AVAILABLE:String = "INV-0003";
      
      public static const NO_MORE_AVAILABLE_BOTS:String = "BOT-0001";
      
      public static const CANNOT_SUMMON_CHAMPION_ALREADY_SUMMONED:String = "championSelection_championTakenBySomeoneLabel";
      
      public static const CANNOT_SUMMON_NOT_YOUR_TURN:String = "PG-0030";
      
      public static const CANNOT_JOIN_QUEUE_ALREADY_IN:String = "matchmaking_joinqueue_already_in";
      
      public function MessageDictionary()
      {
         super();
         throw new Error("Cannot instantiate this class.");
      }
   }
}

