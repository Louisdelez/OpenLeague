package com.riotgames.pvpnet.chrome.model
{
   public class ChromeGameState
   {
      
      public static const NONE:ChromeGameState = new ChromeGameState("none");
      
      public static const ARRANGING:ChromeGameState = new ChromeGameState("arranging");
      
      public static const MATCHING:ChromeGameState = new ChromeGameState("matching");
      
      public static const SPECTATING:ChromeGameState = new ChromeGameState("spectating");
      
      public static const CUSTOM_GAME:ChromeGameState = new ChromeGameState("custom_game");
      
      public static const CAP:ChromeGameState = new ChromeGameState("cap");
      
      public var value:String;
      
      public function ChromeGameState(param1:String)
      {
         super();
         this.value = param1;
      }
   }
}

