package com.riotgames.pvpnet.matchhistoryiron.newmatchhistory.model
{
   public class MatchHistoryGameTimeline
   {
      
      public var frameInterval:Number;
      
      public var frames:Vector.<MatchHistoryGameTimelineFrame> = new Vector.<MatchHistoryGameTimelineFrame>();
      
      public var events:Vector.<MatchHistoryGameTimelineFrameEvent> = new Vector.<MatchHistoryGameTimelineFrameEvent>();
      
      public function MatchHistoryGameTimeline()
      {
         super();
      }
   }
}

