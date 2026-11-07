package com.riotgames.platform.gameclient.domain
{
   public class ButtonNameType
   {
      
      public static const LEFT_BUTTON:String = "leftButton";
      
      public static const RIGHT_BUTTON:String = "rightButton";
      
      public static const MINIMIZE_BUTTON:String = "minimizeButton";
      
      public static const DISMISS_BUTTON:String = "dismissButton";
      
      public function ButtonNameType()
      {
         super();
         throw new Error("Cannot create an instance of this class.");
      }
   }
}

