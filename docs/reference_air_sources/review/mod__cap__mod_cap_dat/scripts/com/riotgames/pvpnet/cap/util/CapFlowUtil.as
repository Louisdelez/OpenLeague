package com.riotgames.pvpnet.cap.util
{
   import com.riotgames.pvpnet.cap.model.core.CapModel;
   
   public class CapFlowUtil
   {
      
      public function CapFlowUtil()
      {
         super();
         throw new Error("This is a static utility class.  Do not instantiate");
      }
      
      public static function isGroupie(param1:CapModel) : Boolean
      {
         return isInvitee(param1) || isSolo(param1);
      }
      
      public static function isSolo(param1:CapModel) : Boolean
      {
         return !param1.localPlayerSelection.isCaptain && !isInvitee(param1);
      }
      
      public static function isInvitee(param1:CapModel) : Boolean
      {
         return param1.localPlayerSelection.isInvitedPlayer;
      }
      
      public static function isInAGroup(param1:CapModel) : Boolean
      {
         return Boolean(param1.groupId);
      }
      
      public static function isCaptain(param1:CapModel) : Boolean
      {
         return param1.localPlayerSelection.isCaptain;
      }
   }
}

