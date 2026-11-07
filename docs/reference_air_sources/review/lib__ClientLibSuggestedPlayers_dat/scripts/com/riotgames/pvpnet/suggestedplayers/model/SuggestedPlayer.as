package com.riotgames.pvpnet.suggestedplayers.model
{
   public class SuggestedPlayer
   {
      
      public static const REASON_PREVIOUS_PREMADE:int = 1;
      
      public static const REASON_ONLINE_FRIEND:int = 2;
      
      public static const REASON_FRIEND_OF_FRIEND:int = 3;
      
      public static const REASON_HONORED:int = 4;
      
      public static const REASON_VICTORIOUS_COMRADE:int = 5;
      
      public static const REASON_LEGACY_PLAY_AGAIN:int = 9999;
      
      public var summonerName:String;
      
      public var commonFriendName:String;
      
      public var commonFriendId:Number;
      
      public var suggestionReason:int;
      
      public var visible:Boolean = true;
      
      public var declined:Boolean = false;
      
      public var invited:Boolean = false;
      
      public function SuggestedPlayer()
      {
         super();
      }
   }
}

