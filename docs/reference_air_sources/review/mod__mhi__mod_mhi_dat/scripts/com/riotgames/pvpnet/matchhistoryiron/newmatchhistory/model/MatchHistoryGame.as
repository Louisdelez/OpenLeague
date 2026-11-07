package com.riotgames.pvpnet.matchhistoryiron.newmatchhistory.model
{
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import com.riotgames.platform.gameclient.domain.game.GameQueueConfig;
   import flash.utils.Dictionary;
   
   public class MatchHistoryGame
   {
      
      public var gameCreation:Number = 0;
      
      public var gameDuration:Number = 0;
      
      public var gameId:Number = 0;
      
      public var gameMode:String;
      
      public var gameType:String;
      
      public var gameVersion:String = "";
      
      public var mapId:int = 0;
      
      public var participants:Vector.<MatchHistoryGameParticipant> = new Vector.<MatchHistoryGameParticipant>();
      
      public var participantsDict:Dictionary = new Dictionary();
      
      public var platformId:String = "";
      
      public var queueId:int;
      
      public var queue:GameQueueConfig;
      
      public var seasonId:int = 0;
      
      public var teams:Dictionary = null;
      
      public var timeline:MatchHistoryGameTimeline;
      
      public var searchedParticipant:MatchHistoryGameParticipant = null;
      
      private var _retrievingDetails:Boolean = false;
      
      private var _retrievingDetailsChanged:Signal = new Signal();
      
      private var _detailsPopulated:Boolean = false;
      
      private var _detailsPopulatedChanged:Signal = new Signal();
      
      private var _retrievingTimeline:Boolean = false;
      
      private var _retrievingTimelineChanged:Signal = new Signal();
      
      private var _timelineRetrieved:Boolean = false;
      
      private var _timelineRetrievedChanged:Signal = new Signal();
      
      public function MatchHistoryGame()
      {
         super();
      }
      
      public function getRetrievingDetails() : Boolean
      {
         return this._retrievingDetails;
      }
      
      public function setRetrievingDetails(param1:Boolean) : void
      {
         if(param1 != this._retrievingDetails)
         {
            this._retrievingDetails = param1;
            this._retrievingDetailsChanged.dispatch();
         }
      }
      
      public function getRetrievingDetailsChanged() : ISignal
      {
         return this._retrievingDetailsChanged;
      }
      
      public function getDetailsPopulated() : Boolean
      {
         return this._detailsPopulated;
      }
      
      public function setDetailsPopulated(param1:Boolean) : void
      {
         if(param1 != this._detailsPopulated)
         {
            this._detailsPopulated = param1;
            this._detailsPopulatedChanged.dispatch();
         }
      }
      
      public function getDetailsPopulatedChanged() : ISignal
      {
         return this._detailsPopulatedChanged;
      }
      
      public function getRetrievingTimeline() : Boolean
      {
         return this._retrievingTimeline;
      }
      
      public function setRetrievingTimeline(param1:Boolean) : void
      {
         if(param1 != this._retrievingTimeline)
         {
            this._retrievingTimeline = param1;
            this._retrievingTimelineChanged.dispatch();
         }
      }
      
      public function getRetrievingTimelimeChanged() : ISignal
      {
         return this._retrievingTimelineChanged;
      }
      
      public function getTimelineRetrieved() : Boolean
      {
         return this._timelineRetrieved;
      }
      
      public function setTimelineRetrieved(param1:Boolean) : void
      {
         if(param1 != this._timelineRetrieved)
         {
            this._timelineRetrieved = param1;
            this._timelineRetrievedChanged.dispatch();
         }
      }
      
      public function getTimelineRetrievedChanged() : ISignal
      {
         return this._timelineRetrievedChanged;
      }
   }
}

