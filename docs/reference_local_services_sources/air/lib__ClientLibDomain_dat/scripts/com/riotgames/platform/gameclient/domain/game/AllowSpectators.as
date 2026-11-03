package com.riotgames.platform.gameclient.domain.game
{
   public class AllowSpectators
   {
      
      public static const NONE:String = "NONE";
      
      public static const LOBBY_ONLY:String = "LOBBYONLY";
      
      public static const DROP_IN_ONLY:String = "DROPINONLY";
      
      public static const ALL:String = "ALL";
      
      public function AllowSpectators()
      {
         super();
      }
      
      public static function isValid(param1:String) : Boolean
      {
         if(param1 == NONE || param1 == LOBBY_ONLY || param1 == DROP_IN_ONLY || param1 == ALL)
         {
            return true;
         }
         return false;
      }
   }
}

