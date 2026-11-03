package com.riotgames.platform.gameclient.domain.game
{
   import mx.collections.ArrayCollection;
   
   public class GameMutator
   {
      
      public static const REROLL:String = "ReRoll";
      
      public function GameMutator()
      {
         super();
      }
      
      public static function hasMutator(param1:ArrayCollection, param2:String) : Boolean
      {
         return param1 != null && Boolean(param1.contains(param2));
      }
   }
}

