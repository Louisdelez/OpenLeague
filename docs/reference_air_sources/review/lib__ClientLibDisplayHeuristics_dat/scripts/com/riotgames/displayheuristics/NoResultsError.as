package com.riotgames.displayheuristics
{
   public class NoResultsError extends Error
   {
      
      public function NoResultsError(param1:String)
      {
         super("The path \"" + param1 + "\" returned zero results.");
      }
   }
}

