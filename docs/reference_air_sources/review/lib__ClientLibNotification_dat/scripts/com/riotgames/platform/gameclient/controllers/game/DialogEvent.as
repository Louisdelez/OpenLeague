package com.riotgames.platform.gameclient.controllers.game
{
   import flash.events.Event;
   
   public class DialogEvent extends Event
   {
      
      public static const EVENT_ON_DIALOG_SHOW:String = "eventDialogShow";
      
      public static const EVENT_ON_DIALOG_CLOSE:String = "eventDialogHide";
      
      public var dialogWindow:Object;
      
      public function DialogEvent(param1:String, param2:Object)
      {
         this.dialogWindow = param2;
         super(param1,false,false);
      }
   }
}

