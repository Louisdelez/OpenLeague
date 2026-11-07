package com.riotgames.platform.gameclient.kudos
{
   import flash.events.Event;
   
   public class KudosDialogFriendlyTeamViewEvent extends Event
   {
      
      public static const CANCEL_BUTTON_CLICKED:String = "cancelButtonClicked";
      
      public static const FRIENDLY_BUTTON_CLICKED:String = "friendlyButtonClicked";
      
      public static const HELPFUL_BUTTON_CLICKED:String = "helpfulButtonClicked";
      
      public static const TEAMWORK_BUTTON_CLICKED:String = "teamworkButtonClicked";
      
      public static const HONORABLE_BUTTON_CLICKED:String = "honorableButtonClicked";
      
      public function KudosDialogFriendlyTeamViewEvent(param1:String, param2:Boolean = false, param3:Boolean = false)
      {
         super(param1,param2,param3);
      }
      
      override public function clone() : Event
      {
         return new KudosDialogFriendlyTeamViewEvent(type,bubbles,cancelable);
      }
   }
}

