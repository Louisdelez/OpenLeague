package com.riotgames.pvpnet.matchhistoryiron.newmatchhistory.model
{
   import flash.utils.Dictionary;
   
   public class MatchHistoryGameTimelineFrame
   {
      
      public var timeStamp:Number;
      
      public var participantFrames:Dictionary = new Dictionary();
      
      public function MatchHistoryGameTimelineFrame()
      {
         super();
      }
   }
}

