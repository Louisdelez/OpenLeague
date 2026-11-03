package org.igniterealtime.xiff.events
{
   import flash.events.Event;
   
   public class RoomEvent extends Event
   {
      
      public static const SUBJECT_CHANGE:String = "subjectChange";
      
      public static const GROUP_MESSAGE:String = "groupMessage";
      
      public static const PRIVATE_MESSAGE:String = "privateMessage";
      
      public static const ROOM_JOIN:String = "roomJoin";
      
      public static const ROOM_LEAVE:String = "roomLeave";
      
      public static const ROOM_DESTROYED:String = "roomDestroyed";
      
      public static const AFFILIATIONS:String = "affiliations";
      
      public static const ADMIN_ERROR:String = "adminError";
      
      public static const PASSWORD_ERROR:String = "passwordError";
      
      public static const REGISTRATION_REQ_ERROR:String = "registrationReqError";
      
      public static const BANNED_ERROR:String = "bannedError";
      
      public static const MAX_USERS_ERROR:String = "maxUsersError";
      
      public static const LOCKED_ERROR:String = "lockedError";
      
      public static const USER_JOIN:String = "userJoin";
      
      public static const USER_DEPARTURE:String = "userDeparture";
      
      public static const USER_KICKED:String = "userKicked";
      
      public static const USER_BANNED:String = "userBanned";
      
      public static const NICK_CONFLICT:String = "nickConflict";
      
      public static const CONFIGURE_ROOM:String = "configureForm";
      
      public static const DECLINED:String = "declined";
      
      private var _subject:String;
      
      private var _data:*;
      
      private var _errorCondition:String;
      
      private var _errorMessage:String;
      
      private var _errorType:String;
      
      private var _errorCode:Number;
      
      private var _errorInThisRoom:Boolean;
      
      private var _nickname:String;
      
      private var _from:String;
      
      private var _reason:String;
      
      public function RoomEvent(param1:String, param2:Boolean = false, param3:Boolean = false)
      {
         super(param1,param2,param3);
      }
      
      public function set subject(param1:String) : void
      {
         this._subject = param1;
      }
      
      public function get subject() : String
      {
         return this._subject;
      }
      
      public function set data(param1:*) : void
      {
         this._data = param1;
      }
      
      public function get data() : *
      {
         return this._data;
      }
      
      public function set errorCondition(param1:String) : void
      {
         this._errorCondition = param1;
      }
      
      public function get errorCondition() : String
      {
         return this._errorCondition;
      }
      
      public function set errorMessage(param1:String) : void
      {
         this._errorMessage = param1;
      }
      
      public function get errorMessage() : String
      {
         return this._errorMessage;
      }
      
      public function set errorType(param1:String) : void
      {
         this._errorType = param1;
      }
      
      public function get errorType() : String
      {
         return this._errorType;
      }
      
      public function set errorCode(param1:Number) : void
      {
         this._errorCode = param1;
      }
      
      public function get errorCode() : Number
      {
         return this._errorCode;
      }
      
      public function set nickname(param1:String) : void
      {
         this._nickname = param1;
      }
      
      public function set errorInThisRoom(param1:Boolean) : void
      {
         this._errorInThisRoom = param1;
      }
      
      public function get errorInThisRoom() : Boolean
      {
         return this._errorInThisRoom;
      }
      
      public function get nickname() : String
      {
         return this._nickname;
      }
      
      public function set from(param1:String) : void
      {
         this._from = param1;
      }
      
      public function get from() : String
      {
         return this._from;
      }
      
      public function set reason(param1:String) : void
      {
         this._reason = param1;
      }
      
      public function get reason() : String
      {
         return this._reason;
      }
   }
}

