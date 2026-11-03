package com.riotgames.platform.gameclient.domain.invite
{
   public class InviteVerificationState
   {
      
      public static const CLR:String = "CLR";
      
      public static const ACK:String = "ACK";
      
      public static const NAK:String = "NAK";
      
      public function InviteVerificationState()
      {
         super();
         throw new Error("Cannot create an instance of this class.");
      }
   }
}

