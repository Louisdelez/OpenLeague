package com.riotgames.pvpnet.matchhistoryiron.newmatchhistory.model
{
   public class MatchHistoryRecentGames
   {
      
      public var accountId:Number;
      
      public var gameCount:int = 0;
      
      public var gameIndexBegin:int = 0;
      
      public var gameIndexEnd:int = 0;
      
      public var gameTimestampBegin:Number = 0;
      
      public var gameTimestampEnd:Number = 0;
      
      public var games:Vector.<MatchHistoryGame> = new Vector.<MatchHistoryGame>();
      
      public function MatchHistoryRecentGames()
      {
         super();
      }
   }
}

