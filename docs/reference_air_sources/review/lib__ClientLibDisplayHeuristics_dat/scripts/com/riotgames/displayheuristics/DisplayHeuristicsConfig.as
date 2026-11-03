package com.riotgames.displayheuristics
{
   public class DisplayHeuristicsConfig
   {
      
      public static const STOP_WORDS:Vector.<String> = new Vector.<String>(0);
      
      public static const STARTING_MISMATCH_SCORE:Number = 1;
      
      public static const WORD_EXACT_POSITION:Number = 1;
      
      public static const WORD_FUTURE_POSITION:Number = 0.95;
      
      public static const WORD_PAST_POSITION:Number = 0.9;
      
      public static const MATCHING_SEGMENT_SCORE:Number = 20;
      
      public static const MISSING_SEGMENT_SCORE:Number = 5;
      
      public static const MISSING_SEGMENT_AFTER_LAST_LOOSE_SCORE:Number = 40;
      
      public static const MISSING_WORD_SCORE:Number = 3;
      
      public static const WORD_FOUND_SCORE:Number = 10;
      
      public static const WORD_NOT_FOUND_SCORE:Number = Number.POSITIVE_INFINITY;
      
      public static const LONG_SEGMENT_LENGTH:uint = 6;
      
      public static const MEDIUM_SEGMENT_LENGTH:uint = 4;
      
      public static const SHORT_SEGMENT_LENGTH:uint = 2;
      
      public static const TRIVIAL_SEGMENT_LENGTH:uint = 1;
      
      public static const LONG_SEGMENT_WEIGHT:Number = 1;
      
      public static const MEDIUM_SEGMENT_WEIGHT:Number = 0.9;
      
      public static const SHORT_SEGMENT_WEIGHT:Number = 0.8;
      
      public static const TRIVIAL_SEGMENT_WEIGHT:Number = 0.1;
      
      public function DisplayHeuristicsConfig()
      {
         super();
      }
   }
}

