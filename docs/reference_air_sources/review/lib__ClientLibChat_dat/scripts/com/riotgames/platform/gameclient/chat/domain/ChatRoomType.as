package com.riotgames.platform.gameclient.chat.domain
{
   public class ChatRoomType
   {
      
      public static const PREFIX_DELIMITER:String = "~";
      
      public static const PRIVATE:String = "pr";
      
      public static const PUBLIC:String = "pu";
      
      public static const GLOBAL:String = "gl";
      
      public static const RANKED_TEAM:String = "tm";
      
      public static const ARRANGING_GAME:String = "ag";
      
      public static const ARRANGING_PRACTICE:String = "ap";
      
      public static const QUEUED:String = "aq";
      
      public static const CHAMPION_SELECT1:String = "c1";
      
      public static const CHAMPION_SELECT2:String = "c2";
      
      public static const POST_GAME:String = "pg";
      
      public static const CAP:String = "cp";
      
      public static const CTA:String = "cta";
      
      public function ChatRoomType()
      {
         super();
      }
      
      public static function isEnabledAutoJoinOption(param1:String) : Boolean
      {
         return param1 != ChatRoomType.ARRANGING_GAME;
      }
   }
}

