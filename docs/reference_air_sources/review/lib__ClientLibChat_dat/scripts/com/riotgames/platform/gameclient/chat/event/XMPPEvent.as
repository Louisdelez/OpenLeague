package com.riotgames.platform.gameclient.chat.event
{
   import flash.events.Event;
   import org.igniterealtime.xiff.data.Message;
   
   public class XMPPEvent extends Event
   {
      
      public static const PERSONAL_MESSAGE:String = "personalMessage";
      
      public static const PRACTICE_GAME_INVITE_ACCEPT:String = "PRACTICE_GAME_INVITE_ACCEPT";
      
      public static const PRACTICE_GAME_INVITE_ACCEPT_ACK:String = "PRACTICE_GAME_INVITE_ACCEPT_ACK";
      
      public static const PRACTICE_GAME_JOIN:String = "PRACTICE_GAME_JOIN";
      
      public static const PRACTICE_GAME_JOIN_ACK:String = "PRACTICE_GAME_JOIN_ACK";
      
      public static const PRACTICE_GAME_OWNER_CHANGED:String = "PRACTICE_GAME_OWNER_CHANGED";
      
      public static const INVITE_STATUS_CHANGED:String = "INVITE_STATUS_CHANGED";
      
      public static const GAME_INVITE_ACCEPTED:String = "GAME_INVITE_ACCEPTED";
      
      public static const GAME_INVITE_ACCEPTED_ACK:String = "GAME_INVITE_ACCEPTED_ACK";
      
      public static const GAME_INVITE_REJECTED:String = "GAME_INVITE_REJECTED";
      
      public static const GAME_INVITE_OWNER_CANCELED:String = "GAME_INVITE_OWNER_CANCELED";
      
      public static const GAME_INVITE_CANCELED:String = "GAME_INVITE_CANCELED";
      
      public static const GAME_FULL_INVITE_REJECTED:String = "GAME_FULL_INVITE_REJECTED";
      
      public static const GAME_INVITE_ALLOW_ENABLED:String = "GAME_INVITE_ALLOW_ENABLED";
      
      public static const GAME_INVITE_ALLOW_DISABLED:String = "GAME_INVITE_ALLOW_DISABLED";
      
      public static const GAME_INVITE_SUGGESTED:String = "GAME_INVITE_SUGGESTED";
      
      public static const GAME_MSG_OUT_OF_SYNC:String = "GAME_MSG_OUT_OF_SYNC";
      
      public static const VERIFY_INVITEE:String = "VERIFY_INVITEE";
      
      public static const VERIFY_INVITEE_ACK:String = "VERIFY_INVITEE_ACK";
      
      public static const VERIFY_INVITEE_NAK:String = "VERIFY_INVITEE_NAK";
      
      public static const VERIFY_INVITEE_RESET:String = "VERIFY_INVITEE_RESET";
      
      public static const CHAMPION_TRADE_REQUESTED:String = "CHAMPION_TRADE_REQUESTED";
      
      public static const RANKED_TEAM_UPDATED:String = "RANKED_TEAM_UPDATED";
      
      public static const GAME_INVITE:String = "GAME_INVITE";
      
      public static const PRACTICE_GAME_INVITE:String = "PRACTICE_GAME_INVITE";
      
      public static const EVENT_INVITE_RECIEVED:String = "EVENT_INVITE_RECIEVED";
      
      private var _message:Message;
      
      public function XMPPEvent(param1:String, param2:Message, param3:Boolean = false, param4:Boolean = false)
      {
         super(param1,param3,param4);
         this._message = param2;
      }
      
      override public function clone() : Event
      {
         return new XMPPEvent(type,this.message,bubbles,cancelable);
      }
      
      public function get message() : Message
      {
         return this._message;
      }
   }
}

