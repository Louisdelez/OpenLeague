package com.riotgames.pvpnet.matchhistoryiron.newmatchhistory.action
{
   import com.riotgames.pvpnet.matchhistoryiron.newmatchhistory.MatchHistoryParser;
   import com.riotgames.pvpnet.matchhistoryiron.newmatchhistory.model.MatchHistoryGame;
   import com.riotgames.pvpnet.matchhistoryiron.newmatchhistory.model.MatchHistoryGameParticipant;
   import com.riotgames.pvpnet.matchhistoryiron.newmatchhistory.model.MatchHistoryGameTimeline;
   import com.riotgames.pvpnet.matchhistoryiron.newmatchhistory.model.MatchHistoryGameTimelineFrame;
   import com.riotgames.pvpnet.matchhistoryiron.newmatchhistory.model.MatchHistoryGameTimelineParticipantFrameStats;
   
   public class GetGameTimelineAction extends MatchHistoryServiceAction
   {
      
      private var _game:MatchHistoryGame;
      
      private var _parser:MatchHistoryParser;
      
      public function GetGameTimelineAction(param1:MatchHistoryGame, param2:MatchHistoryParser)
      {
         super();
         this._game = param1;
         this._parser = param2;
      }
      
      override protected function doInvocation() : void
      {
         if(!this._game || this._game.getRetrievingTimeline() || !this._game.gameId || this._game.getTimelineRetrieved())
         {
            abort();
            return;
         }
         this._game.setRetrievingTimeline(true);
         super.doInvocation();
      }
      
      override protected function buildEndpointURL(param1:String) : String
      {
         return param1 + "/stats/game/" + this._game.platformId + "/" + this._game.gameId + "/timeline";
      }
      
      override protected function parseData(param1:String) : Object
      {
         return this._parser.getGameTimeline(param1);
      }
      
      override protected function handleData(param1:Object) : void
      {
         var _loc3_:MatchHistoryGameParticipant = null;
         var _loc4_:Number = NaN;
         var _loc5_:int = 0;
         var _loc6_:MatchHistoryGameTimelineFrame = null;
         var _loc7_:String = null;
         var _loc8_:MatchHistoryGameTimelineParticipantFrameStats = null;
         var _loc2_:MatchHistoryGameTimeline = param1 as MatchHistoryGameTimeline;
         this._game.timeline = _loc2_;
         for each(_loc3_ in this._game.participants)
         {
            _loc3_.timeline.frameStats = new Vector.<MatchHistoryGameTimelineParticipantFrameStats>();
         }
         _loc4_ = _loc2_.frameInterval;
         _loc5_ = 0;
         for each(_loc6_ in _loc2_.frames)
         {
            for(_loc7_ in _loc6_.participantFrames)
            {
               _loc8_ = _loc6_.participantFrames[_loc7_];
               _loc8_.actualTimestamp = _loc6_.timeStamp;
               _loc8_.intervalTimestamp = _loc5_ * _loc4_;
               MatchHistoryGameParticipant(this._game.participantsDict[_loc7_]).timeline.frameStats.push(_loc8_);
            }
            _loc5_++;
         }
         this._game.setTimelineRetrieved(true);
      }
      
      override protected function onCompleted() : void
      {
         this._game.setRetrievingTimeline(false);
         super.onCompleted();
      }
      
      override protected function onAborted() : void
      {
         this._game.setRetrievingTimeline(false);
         super.onAborted();
      }
      
      override protected function onErred(param1:Error) : void
      {
         this._game.setRetrievingTimeline(false);
         super.onErred(param1);
      }
   }
}

