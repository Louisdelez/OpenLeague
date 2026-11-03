package com.riotgames.pvpnet.matchhistoryiron.newmatchhistory.model
{
   public class MatchHistoryGameParticipantTimeline
   {
      
      public var creepsPerMinDeltas:Vector.<MatchHistoryGameParticipantTimelineItem> = new Vector.<MatchHistoryGameParticipantTimelineItem>();
      
      public var csDiffPerMinDeltas:Vector.<MatchHistoryGameParticipantTimelineItem> = new Vector.<MatchHistoryGameParticipantTimelineItem>();
      
      public var damageTakenDiffPerMinDeltas:Vector.<MatchHistoryGameParticipantTimelineItem> = new Vector.<MatchHistoryGameParticipantTimelineItem>();
      
      public var damageTakenPerMinDeltas:Vector.<MatchHistoryGameParticipantTimelineItem> = new Vector.<MatchHistoryGameParticipantTimelineItem>();
      
      public var goldPerMinDeltas:Vector.<MatchHistoryGameParticipantTimelineItem> = new Vector.<MatchHistoryGameParticipantTimelineItem>();
      
      public var lane:String;
      
      public var participantId:int;
      
      public var role:String;
      
      public var xpDiffPerMinDeltas:Vector.<MatchHistoryGameParticipantTimelineItem> = new Vector.<MatchHistoryGameParticipantTimelineItem>();
      
      public var xpPerMinDeltas:Vector.<MatchHistoryGameParticipantTimelineItem> = new Vector.<MatchHistoryGameParticipantTimelineItem>();
      
      public var frameStats:Vector.<MatchHistoryGameTimelineParticipantFrameStats> = new Vector.<MatchHistoryGameTimelineParticipantFrameStats>();
      
      public function MatchHistoryGameParticipantTimeline()
      {
         super();
      }
   }
}

