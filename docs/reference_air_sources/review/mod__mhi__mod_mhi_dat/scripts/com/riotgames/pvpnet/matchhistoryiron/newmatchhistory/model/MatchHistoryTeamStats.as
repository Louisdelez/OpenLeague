package com.riotgames.pvpnet.matchhistoryiron.newmatchhistory.model
{
   import com.riotgames.platform.gameclient.domain.Champion;
   
   public class MatchHistoryTeamStats
   {
      
      public var bans:Vector.<Champion> = new Vector.<Champion>();
      
      public var baronKills:int;
      
      public var dominionVictoryScore:int;
      
      public var dragonKills:int;
      
      public var firstBaron:Boolean;
      
      public var firstBlood:Boolean;
      
      public var firstDragon:Boolean;
      
      public var firstInhibitor:Boolean;
      
      public var firstTower:Boolean;
      
      public var inhibitorKills:int;
      
      public var teamId:int;
      
      public var towerKills:int;
      
      public var vilemawKills:int;
      
      public var win:String;
      
      public function MatchHistoryTeamStats()
      {
         super();
      }
   }
}

