package com.riotgames.platform.gameclient.views.store
{
   import com.riotgames.platform.gameclient.chat.domain.PresenceStatusData;
   
   public class StoreBuddy
   {
      
      public static const STATUS_OFFLINE:int = 0;
      
      public static const STATUS_ONLINE:int = 1;
      
      public static const SUMMONER_LEVEL_UNKNOWN:int = 0;
      
      public var status:int;
      
      public var realName:String;
      
      public var name:String;
      
      public var summonerId:Number;
      
      public var busyStatus:String;
      
      public var presence:PresenceStatusData;
      
      public var isMutualFriend:Boolean = false;
      
      public function StoreBuddy()
      {
         super();
      }
   }
}

