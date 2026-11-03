package com.riotgames.platform.gameclient.domain.invite
{
   import flash.utils.getQualifiedClassName;
   import mx.logging.ILogger;
   import mx.logging.Log;
   
   public class InviteParticipantState
   {
      
      private static const LOGGER:ILogger = Log.getLogger(getQualifiedClassName(InviteParticipantState).replace(/::/,"."));
      
      public static const OWNER:String = "OWNER";
      
      public static const CREATOR:String = "CREATOR";
      
      public static const PENDING:String = "PENDING";
      
      public static const ACCEPTED:String = "ACCEPTED";
      
      public static const REJECTED:String = "REJECTED";
      
      public static const JOINED:String = "JOINED";
      
      public static const REJECTED_FULL:String = "REJECTED-FULL";
      
      public static const QUIT:String = "QUIT";
      
      public static const CANCEL:String = "CANCEL";
      
      public static const UNKNOWN:String = "UNKNOWN";
      
      private static const MEMBER_STATES:Array = [OWNER,CREATOR,ACCEPTED,JOINED];
      
      public function InviteParticipantState()
      {
         super();
         throw new Error("Cannot create an instance of this class.");
      }
      
      public static function isMemberState(param1:String) : Boolean
      {
         return MEMBER_STATES.indexOf(param1) != -1;
      }
      
      public static function fromPlatformInviteeState(param1:String) : String
      {
         switch(param1)
         {
            case "CREATOR":
               return CREATOR;
            case "PENDING":
               return PENDING;
            case "DECLINED":
               return REJECTED;
            case "ACCEPTED":
               return ACCEPTED;
            case "ACCEPT_FAILED":
               return REJECTED_FULL;
            case "JOINED":
               return JOINED;
            case "QUIT":
               return QUIT;
            case "KICKED":
               return CANCEL;
            case "BANNED":
               return CANCEL;
            default:
               LOGGER.error("Unknown InviteeState: {0}",param1);
               return UNKNOWN;
         }
      }
   }
}

