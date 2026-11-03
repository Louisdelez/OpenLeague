package com.riotgames.platform.gameclient.application
{
   public class Version
   {
      
      public static var CURRENT_VERSION:String = "4.20.14_11_18_18_52";
      
      public function Version()
      {
         super();
      }
      
      public function getVersion() : String
      {
         return Version.CURRENT_VERSION;
      }
   }
}

