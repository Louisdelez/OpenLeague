package com.riotgames.pvpnet.matchhistoryiron.newmatchhistory.model
{
   import flash.geom.Point;
   
   public class MatchHistoryGameTimelineFrameEvent
   {
      
      public var type:String;
      
      public var participantId:int;
      
      public var timestamp:Number;
      
      public var itemId:int;
      
      public var wardType:String;
      
      public var creatorId:int;
      
      public var killerId:int;
      
      public var monsterType:String;
      
      public var position:Point;
      
      public var assistingParticipantIds:Vector.<int> = new Vector.<int>();
      
      public var victimId:int;
      
      public var laneType:String;
      
      public var teamId:int;
      
      public var towerType:String;
      
      public function MatchHistoryGameTimelineFrameEvent()
      {
         super();
      }
   }
}

