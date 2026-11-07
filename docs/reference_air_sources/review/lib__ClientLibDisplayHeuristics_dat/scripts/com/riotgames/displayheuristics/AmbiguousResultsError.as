package com.riotgames.displayheuristics
{
   public class AmbiguousResultsError extends Error
   {
      
      public function AmbiguousResultsError(param1:String)
      {
         super("The path \"" + param1 + "\" is ambiguous and returned more than 1 result.");
      }
   }
}

