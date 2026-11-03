package com.riotgames.pvpnet.matchhistoryiron.newmatchhistory.model
{
   import com.riotgames.platform.gameclient.domain.Champion;
   import com.riotgames.platform.gameclient.domain.Spell;
   
   public class MatchHistoryGameParticipant
   {
      
      public var player:MatchHistoryPlayer;
      
      public var participantId:int = -1;
      
      public var champion:Champion;
      
      public var skinId:int;
      
      public var spell1:Spell;
      
      public var spell2:Spell;
      
      public var stats:MatchHistoryGameParticipantStats;
      
      public var teamId:int = 0;
      
      public var timeline:MatchHistoryGameParticipantTimeline;
      
      public function MatchHistoryGameParticipant()
      {
         super();
      }
   }
}

