package com.riotgames.landing.featuredgames
{
   import blix.assets.proxy.FeaturedGamesSlider.FeaturedGameAsset;
   import blix.components.text.Text;
   import blix.components.timeline.StatefulView;
   import blix.components.timeline.TimelineAnimation;
   import blix.context.IContext;
   import blix.signals.Signal;
   import blix.util.string.padNumber;
   import com.riotgames.landing.FeaturedGame;
   import flash.events.Event;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   
   public class FeaturedGameItem extends StatefulView
   {
      
      private var _title:Text;
      
      private var _model:FeaturedGame;
      
      private var _queueType:Text;
      
      private var _gameTime:Text;
      
      private var _background:StatefulView;
      
      public const OVER_STATE:String = "over";
      
      public const SHOW_STATE:String = "show";
      
      public const HIDE_STATE:String = "hide";
      
      public const NEXT_STATE:String = "next";
      
      private var _teamOne:TeamThumbs;
      
      private var _teamTwo:TeamThumbs;
      
      private var _summonerNames:SummonerNames;
      
      private var _teamOneSmall:TeamThumbs;
      
      private var _teamTwoSmall:TeamThumbs;
      
      private var _gameTimeValue:int;
      
      public var nextReadySignal:Signal = new Signal();
      
      public var showReadySignal:Signal = new Signal();
      
      public function FeaturedGameItem(param1:IContext)
      {
         super(param1);
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         var _loc1_:IResourceManager = ResourceManager.getInstance();
         var _loc2_:FeaturedGameAsset = new FeaturedGameAsset();
         this._title = new Text(this);
         setTimelineChild(_loc2_.titleAsset,this._title);
         this._title.setText(_loc1_.getString("LandingPage","featuredGames.title"));
         this._queueType = new Text(this);
         setTimelineChild(_loc2_.queueTypeAsset,this._queueType);
         this._gameTime = new Text(this);
         setTimelineChild(_loc2_.gameTimeAsset,this._gameTime);
         this._teamOne = new TeamThumbs(this);
         setTimelineChild(_loc2_.teamOneAsset,this._teamOne);
         this._teamTwo = new TeamThumbs(this);
         setTimelineChild(_loc2_.teamTwoAsset,this._teamTwo);
         this._teamOneSmall = new TeamThumbs(this);
         setTimelineChild(_loc2_.teamOneSmallAsset,this._teamOneSmall);
         this._teamTwoSmall = new TeamThumbs(this);
         setTimelineChild(_loc2_.teamTwoSmallAsset,this._teamTwoSmall);
         this._summonerNames = new SummonerNames(this);
         setTimelineChild(_loc2_.summonerNamesAsset,this._summonerNames);
         this._background = new StatefulView(this);
         setTimelineChild(_loc2_.backgroundAsset,this._background);
         this._background.stop();
         this.hide();
         getAssetChanged().add(this.setupListeners);
      }
      
      private function setupListeners() : void
      {
         if(getAsset())
         {
            getTransitionAnimation(this.SHOW_STATE,this.NEXT_STATE).getCompleted().add(this.nextReadySignal.dispatch);
            getStateAnimation(this.SHOW_STATE).getCompleted().add(this.showReadySignal.dispatch);
         }
      }
      
      public function setModel(param1:FeaturedGame) : void
      {
         var _loc3_:IResourceManager = null;
         var _loc4_:Number = NaN;
         if(this._model == param1)
         {
            return;
         }
         if(this._model != null)
         {
            this._queueType.setText(null);
            this._gameTime.setText(null);
            this._teamOne.setTeamPlayers(null,0);
            this._teamTwo.setTeamPlayers(null,0);
            this._teamOneSmall.setTeamPlayers(null,0);
            this._teamTwoSmall.setTeamPlayers(null,0);
            this._summonerNames.setData(null);
         }
         this._model = param1;
         if(this._model != null)
         {
            _loc3_ = ResourceManager.getInstance();
            this._queueType.setText(_loc3_.getString("LandingPage","featuredGames." + this._model.queueType));
            _logger.logDebug("Game Length: " + this._model.gameStartTime);
            _logger.logDebug("Cache Age: " + this._model.cacheAge * 1000);
            _logger.logDebug("Download Time: " + this._model.downloadTime);
            _loc4_ = new Date().time;
            _logger.logDebug("Current Time: " + _loc4_);
            this._gameTimeValue = this._model.gameStartTime + this._model.cacheAge * 1000 + Math.max(_loc4_ - this._model.downloadTime,0);
            this._gameTime.setText(this.getExplicitTimeString(new Date(this._gameTimeValue)));
            this._teamOne.setTeamPlayers(this._model.participants,100);
            this._teamTwo.setTeamPlayers(this._model.participants,200);
            this._teamOneSmall.setTeamPlayers(this._model.participants,100);
            this._teamTwoSmall.setTeamPlayers(this._model.participants,200);
            this._summonerNames.setData(this._model.participants);
         }
         var _loc2_:TimelineAnimation = getCurrentTimelineAnimation();
         if(getCurrentState() != this.OVER_STATE)
         {
            this.show();
         }
      }
      
      private function getExplicitTimeString(param1:Date) : String
      {
         var _loc2_:String = padNumber(param1.minutesUTC,2) + ":" + padNumber(param1.secondsUTC,2);
         if(param1.hoursUTC > 0)
         {
            _loc2_ = padNumber(param1.hoursUTC,2) + ":" + _loc2_;
         }
         return _loc2_;
      }
      
      public function showOver(param1:Event = null) : void
      {
         setCurrentState(this.OVER_STATE);
      }
      
      public function show() : void
      {
         setCurrentState(this.SHOW_STATE);
      }
      
      public function hide() : void
      {
         setCurrentState(this.HIDE_STATE);
      }
      
      public function gotoNextState() : void
      {
         setCurrentState(this.NEXT_STATE);
      }
   }
}

