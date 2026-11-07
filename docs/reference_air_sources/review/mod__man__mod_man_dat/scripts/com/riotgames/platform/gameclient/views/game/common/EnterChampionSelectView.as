package com.riotgames.platform.gameclient.views.game.common
{
   import blix.assets.proxy.MovieClipProxy;
   import blix.assets.proxy.SpriteProxy;
   import blix.assets.proxy.TextFieldProxy;
   import blix.components.button.ButtonX;
   import blix.components.timeline.StatefulView;
   import blix.context.IContext;
   import blix.layout.LayoutContainer;
   import blix.layout.algorithms.HorizontalLayout;
   import blix.layout.vo.HorizontalAlign;
   import blix.layout.vo.VerticalAlign;
   import com.riotgames.platform.common.utils.RiotResourceLoader;
   import com.riotgames.platform.gameclient.utils.PieClockGraphicsUtil;
   import flash.display.Graphics;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class EnterChampionSelectView extends StatefulView
   {
      
      private var layoutSizer:SpriteProxy;
      
      private var voteResultsTitle:TextFieldProxy;
      
      private var _initialTimerValue:int;
      
      private var matchDeclined:Boolean = false;
      
      private var voteTimerStartTime:Number = 0;
      
      private var pieTimer:Timer = new Timer(50);
      
      private var matchReadyText:TextFieldProxy;
      
      private var voteData:Array;
      
      private var indicatorContainer:MovieClipProxy;
      
      private var voted:Boolean = false;
      
      private var indicatorCount:int = -1;
      
      private var indicators:Vector.<StatefulView>;
      
      private var declineButton:ButtonX;
      
      private var cancelButton:ButtonX;
      
      private var voteTimerEndTime:Number = 0;
      
      private var currentVoteCount:int = 0;
      
      private var pieProgress:Number = 0;
      
      private var acceptButton:ButtonX;
      
      private var voteTimeRemaining:int = 9;
      
      private var voteResultsSubtitle:TextFieldProxy;
      
      private var indicatorLayoutContainer:LayoutContainer;
      
      private var pieTimerContainer:MovieClipProxy;
      
      private var voteResultsText:TextFieldProxy;
      
      private var voteTimer:Timer;
      
      public function EnterChampionSelectView(param1:IContext, param2:int)
      {
         super(param1);
         setLinkage("EnterChampSelectPrompt");
         this.createEventListeners();
         this._initialTimerValue = param2;
         this.voteTimer = new Timer(1000);
      }
      
      public function removeTimers() : void
      {
         this.removeVoteTimer();
         this.removePieTimer();
      }
      
      override protected function createChildren() : void
      {
         this.matchReadyText = new TextFieldProxy(this);
         this.setTimelineChildByName("enterChampSelect_matchReadyText",this.matchReadyText);
         this.voteResultsTitle = new TextFieldProxy(this);
         this.setTimelineChildByName("enterChampSelect_voteResultTitle",this.voteResultsTitle);
         this.voteResultsSubtitle = new TextFieldProxy(this);
         this.setTimelineChildByName("enterChampSelect_voteResultSubtitle",this.voteResultsSubtitle);
         this.voteResultsText = new TextFieldProxy(this);
         this.setTimelineChildByName("enterChampSelect_voteResultText",this.voteResultsText);
         this.acceptButton = new ButtonX(this);
         this.setTimelineChildByName("voteButtonAccept.buttonAsset",this.acceptButton);
         this.declineButton = new ButtonX(this);
         this.setTimelineChildByName("voteButtonDecline.buttonAsset",this.declineButton);
         this.cancelButton = new ButtonX(this);
         this.setTimelineChildByName("voteButtonCancel.buttonAsset",this.cancelButton);
         this.cancelButton.setVisible(false);
         this.indicatorContainer = new MovieClipProxy(this);
         this.setTimelineChildByName("voteIndicatorContainer",this.indicatorContainer);
         this.pieTimerContainer = new MovieClipProxy(this);
         this.setTimelineChildByName("pieTimerContainer",this.pieTimerContainer);
         this.layoutSizer = new SpriteProxy(this);
         setTimelineChildByName("mySizer",this.layoutSizer);
      }
      
      public function cleanup() : void
      {
         this.removeTimers();
         this.removeEventListeners();
      }
      
      public function updateReadinessIndicatorsIncrementally(param1:String) : void
      {
         var _loc5_:int = 0;
         if(!param1)
         {
            return;
         }
         if(!this.voteData || this.voteData.length != param1.length)
         {
            this.voteData = new Array();
            _loc5_ = 0;
            while(_loc5_ < param1.length)
            {
               this.voteData.push([0,-1]);
               _loc5_++;
            }
            this.setIndicatorCount(param1.length);
            this.currentVoteCount = 0;
         }
         var _loc2_:Array = param1.split("");
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_.length)
         {
            if(_loc2_[_loc3_] != 0)
            {
               if(this.voteData[_loc3_][1] == -1)
               {
                  this.voteData[_loc3_][1] = this.currentVoteCount;
                  ++this.currentVoteCount;
               }
               this.voteData[_loc3_][0] = _loc2_[_loc3_];
            }
            _loc3_++;
         }
         var _loc4_:int = 0;
         while(_loc4_ < this.voteData.length)
         {
            if(this.voteData[_loc4_][1] != -1)
            {
               if(this.voteData[_loc4_][0] == "0")
               {
                  this.indicators[this.voteData[_loc4_][1]].setCurrentState("hasntVoted");
               }
               else if(this.voteData[_loc4_][0] == "1")
               {
                  this.indicators[this.voteData[_loc4_][1]].setCurrentState("acceptVote");
               }
               else if(this.voteData[_loc4_][0] == "2")
               {
                  this.indicators[this.voteData[_loc4_][1]].setCurrentState("declineVote");
                  if(!this.matchDeclined)
                  {
                     this.voteResultsSubtitle.setText(RiotResourceLoader.getString("ecsp_voteResultOtherDeclined"));
                     if(getCurrentState() == "showVoteResults")
                     {
                        setCurrentState("showVoteResultsUpdateAnimation");
                     }
                  }
                  this.matchDeclined = true;
               }
            }
            _loc4_++;
         }
      }
      
      public function showReturningToLobby() : void
      {
         this.voteResultsTitle.setText(RiotResourceLoader.getString("ecsp_returningToTeamLobby"));
         this.indicatorContainer.setVisible(false);
         this.cancelButton.setVisible(true);
         setCurrentState("showVoteResultsUpdate");
      }
      
      private function onAcceptButtonClick(param1:MouseEvent) : void
      {
         this.voted = true;
         this.removeVoteTimer();
         this.toggleVoteIndicatorVisibility(true);
         dispatchEvent(new Event("acceptButtonClicked"));
         if(this.matchDeclined)
         {
            setCurrentState("showVoteResultsUpdate");
         }
         else
         {
            setCurrentState("showVoteResults");
         }
      }
      
      private function onPieTimer(param1:TimerEvent) : void
      {
         var _loc2_:Graphics = this.pieTimerContainer.getGraphics();
         if(_loc2_)
         {
            this.pieProgress = (new Date().getTime() - this.voteTimerStartTime) / (this.voteTimerEndTime - this.voteTimerStartTime);
            if(this.pieProgress <= 1)
            {
               this.drawPieGraphics(_loc2_);
            }
            else
            {
               _loc2_.clear();
               if(this.pieTimer)
               {
                  this.pieTimer.stop();
                  this.pieTimer.removeEventListener(TimerEvent.TIMER,this.onPieTimer);
               }
               this.pieTimer = null;
            }
         }
      }
      
      public function removePieTimer() : void
      {
         if(this.pieTimer)
         {
            this.pieTimer.stop();
            this.pieTimer.removeEventListener(TimerEvent.TIMER,this.onPieTimer);
         }
         this.pieTimer = null;
      }
      
      private function setIndicatorCount(param1:int) : void
      {
         if(!this.indicators || param1 != this.indicators.length)
         {
            this.removeOldReadinessIndicators();
            this.createReadinessIndicators(param1);
         }
      }
      
      private function toggleVoteIndicatorVisibility(param1:Boolean) : void
      {
         var _loc2_:StatefulView = null;
         if(!this.indicators)
         {
            return;
         }
         for each(_loc2_ in this.indicators)
         {
            _loc2_.setVisible(param1);
         }
      }
      
      private function createReadinessIndicators(param1:int) : void
      {
         var _loc4_:StatefulView = null;
         this.indicators = new Vector.<StatefulView>(param1,true);
         this.indicatorLayoutContainer = new LayoutContainer(this.indicatorContainer);
         this.indicatorLayoutContainer.setExplicitSize(368,35);
         var _loc2_:HorizontalLayout = new HorizontalLayout();
         _loc2_.setHorizontalAlign(HorizontalAlign.CENTER);
         _loc2_.setVerticalAlign(VerticalAlign.MIDDLE);
         _loc2_.setGap(5);
         this.indicatorLayoutContainer.setLayoutAlgorithm(_loc2_);
         var _loc3_:int = 0;
         while(_loc3_ < param1)
         {
            _loc4_ = new StatefulView(this);
            _loc4_.setLinkage("VoteIndicator");
            this.indicatorContainer.addChild(_loc4_);
            this.indicatorLayoutContainer.addElement(_loc4_);
            this.indicators[_loc3_] = _loc4_;
            if(getCurrentState() == "votePrompt")
            {
               _loc4_.setVisible(false);
            }
            _loc3_++;
         }
      }
      
      private function removeOldReadinessIndicators() : void
      {
         var _loc1_:StatefulView = null;
         if(!this.indicators)
         {
            return;
         }
         for each(_loc1_ in this.indicators)
         {
            this.indicatorContainer.removeChild(_loc1_);
         }
         this.indicatorLayoutContainer.removeAllElements();
         this.indicatorLayoutContainer = null;
         this.indicators = null;
      }
      
      public function initializeView() : void
      {
         this.voteTimer.addEventListener(TimerEvent.TIMER,this.onVoteTimer,false,0,true);
         this.voteTimer.start();
         this.toggleVoteIndicatorVisibility(false);
         setCurrentState("votePrompt");
         this.voteTimerStartTime = new Date().getTime();
         this.voteTimerEndTime = this.voteTimerStartTime + this._initialTimerValue * 1000;
         this.pieTimer.addEventListener(TimerEvent.TIMER,this.onPieTimer);
         this.pieTimer.start();
      }
      
      private function onVoteTimer(param1:TimerEvent) : void
      {
         if(this.voteTimeRemaining > 0)
         {
            --this.voteTimeRemaining;
         }
         else if(this.voteTimeRemaining == 0)
         {
            if(!this.voted && getCurrentState() != "showVoteResults")
            {
               this.acceptButton.setEnabled(false);
               this.declineButton.setEnabled(false);
               this.matchReadyText.setText(RiotResourceLoader.getString("ecsp_AFKLeavingGame"));
               dispatchEvent(new Event("noButtonClicked"));
               this.setCurrentState("votePromptTimeout");
            }
            this.removeTimers();
         }
      }
      
      public function removeVoteTimer() : void
      {
         if(this.voteTimer)
         {
            this.voteTimer.stop();
            this.voteTimer.removeEventListener(TimerEvent.TIMER,this.onVoteTimer);
         }
         this.voteTimer = null;
      }
      
      private function createEventListeners() : void
      {
         this.acceptButton.addEventListener(MouseEvent.CLICK,this.onAcceptButtonClick);
         this.declineButton.addEventListener(MouseEvent.CLICK,this.onDeclineButtonClick);
         this.cancelButton.addEventListener(MouseEvent.CLICK,this.onCancelButtonClick);
      }
      
      private function drawPieGraphics(param1:Graphics) : void
      {
         PieClockGraphicsUtil.drawPieClockGraphic(param1,this.pieProgress);
      }
      
      private function onDeclineButtonClick(param1:MouseEvent) : void
      {
         this.voted = true;
         this.matchDeclined = true;
         this.removeVoteTimer();
         this.toggleVoteIndicatorVisibility(true);
         dispatchEvent(new Event("declineButtonClicked"));
         this.voteResultsSubtitle.setText(RiotResourceLoader.getString("ecsp_voteResultYouDeclined"));
         setCurrentState("showVoteResultsUpdate");
      }
      
      private function removeEventListeners() : void
      {
         this.acceptButton.removeEventListener(MouseEvent.CLICK,this.onAcceptButtonClick);
         this.declineButton.removeEventListener(MouseEvent.CLICK,this.onDeclineButtonClick);
         this.cancelButton.removeEventListener(MouseEvent.CLICK,this.onCancelButtonClick);
      }
      
      private function onCancelButtonClick(param1:MouseEvent) : void
      {
         dispatchEvent(new Event("cancelButtonClicked"));
      }
   }
}

