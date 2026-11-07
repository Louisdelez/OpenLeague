package com.riotgames.platform.gameclient.contextAlert
{
   public class AlertParameters
   {
      
      public static const ARROW_STATE_NO_ARROW:String = "noArrow";
      
      public static const ARROW_STATE_TOP_LEFT:String = "TL";
      
      public static const ARROW_STATE_TOP_MIDDLE:String = "TM";
      
      public static const ARROW_STATE_TOP_RIGHT:String = "TR";
      
      public static const ARROW_STATE_LEFT_TOP:String = "LT";
      
      public static const ARROW_STATE_RIGHT_TOP:String = "RT";
      
      public static const ARROW_STATE_BOTTOM_LEFT:String = "BL";
      
      public static const ARROW_STATE_BOTTOM_MIDDLE:String = "BM";
      
      public static const ARROW_STATE_BOTTOM_RIGHT:String = "BR";
      
      public static const ARROW_STATE_TOP_EDGE:String = "TE";
      
      public var location:String = "default";
      
      public var message:String;
      
      public var title:String;
      
      public var requiresThickChromeState:Boolean = true;
      
      public function AlertParameters()
      {
         super();
      }
   }
}

