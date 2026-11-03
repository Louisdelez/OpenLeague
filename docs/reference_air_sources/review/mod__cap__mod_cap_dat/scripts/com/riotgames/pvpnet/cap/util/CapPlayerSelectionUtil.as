package com.riotgames.pvpnet.cap.util
{
   import com.riotgames.pvpnet.cap.model.CapPlayerSelection;
   
   public class CapPlayerSelectionUtil
   {
      
      public function CapPlayerSelectionUtil()
      {
         super();
         throw new Error("This is a static utility class.  Do not instantiate");
      }
      
      public static function isActiveSoloPlayer(param1:CapPlayerSelection) : Boolean
      {
         return param1.isPopulated && definesSoloSpec(param1);
      }
      
      public static function isCaptainSettingUp(param1:CapPlayerSelection) : Boolean
      {
         return param1.visible && param1.currentState == CapPlayerSelection.INTRO_STATE;
      }
      
      public static function determineReadyState(param1:Boolean, param2:CapPlayerSelection, param3:Boolean) : String
      {
         if(param1)
         {
            return CapPlayerSelection.READY_STATE;
         }
         if(param2.isLocalPlayer)
         {
            return param3 ? CapPlayerSelection.ROLE_LOCKED_STATE : CapPlayerSelection.ROLE_POSITION_SELECTED_STATE;
         }
         if(param2.currentState != CapPlayerSelection.FIND_PLAYERS_STATE)
         {
            return CapPlayerSelection.ACCEPTED_STATE;
         }
         return param2.currentState;
      }
      
      public static function isActiveInvitedPlayer(param1:CapPlayerSelection) : Boolean
      {
         return param1.isPopulated && param1.isInvitedPlayer;
      }
      
      public static function definesSoloSpec(param1:CapPlayerSelection) : Boolean
      {
         return !param1.isInvitedPlayer && Boolean(param1.role) && Boolean(param1.position);
      }
   }
}

