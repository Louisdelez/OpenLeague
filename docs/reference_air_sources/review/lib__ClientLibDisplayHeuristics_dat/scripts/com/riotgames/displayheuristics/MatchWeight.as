package com.riotgames.displayheuristics
{
   public class MatchWeight
   {
      
      public var matchScore:Number;
      
      public var mismatchScore:Number;
      
      public function MatchWeight(param1:Number = 0, param2:Number = NaN)
      {
         super();
         if(isNaN(param2))
         {
            param2 = DisplayHeuristicsConfig.STARTING_MISMATCH_SCORE;
         }
         this.matchScore = param1;
         this.mismatchScore = param2;
      }
      
      public function getConfidence() : Number
      {
         return this.matchScore / (this.mismatchScore + this.matchScore);
      }
      
      public function toString() : String
      {
         return "[MatchWeight matchScore=" + this.matchScore + " mismatchScore=" + this.mismatchScore + "]";
      }
   }
}

