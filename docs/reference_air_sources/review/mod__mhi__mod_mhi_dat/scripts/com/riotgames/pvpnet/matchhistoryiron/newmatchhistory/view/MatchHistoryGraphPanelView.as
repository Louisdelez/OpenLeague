package com.riotgames.pvpnet.matchhistoryiron.newmatchhistory.view
{
   import blix.assets.proxy.SpriteProxy;
   import blix.components.timeline.StatefulView;
   import blix.context.IContext;
   import blix.view.behaviors.ScalingTransformBehavior;
   import com.riotgames.pvpnet.matchhistoryiron.enum.EMatchHistoryLocalization;
   import com.riotgames.pvpnet.matchhistoryiron.newmatchhistory.model.MatchHistoryGame;
   import com.riotgames.pvpnet.matchhistoryiron.newmatchhistory.model.MatchHistoryGameParticipant;
   import com.riotgames.pvpnet.matchhistoryiron.newmatchhistory.model.MatchHistoryGameTimelineFrame;
   import com.riotgames.pvpnet.matchhistoryiron.newmatchhistory.model.MatchHistoryGameTimelineParticipantFrameStats;
   import com.riotgames.pvpnet.matchhistoryiron.newmatchhistory.model.NewMatchHistoryModel;
   import flash.display.Graphics;
   import flash.display.Sprite;
   import flash.filters.DropShadowFilter;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class MatchHistoryGraphPanelView extends SpriteProxy
   {
      
      private static const MAX_VERT_LINES:int = 30;
      
      private static const TIME_LABEL_THRESHOLD:int = 25;
      
      private static const MAX_HORZ_LINES:int = 15;
      
      private static const LEFT_MARGIN:int = 37;
      
      private static const BOTTOM_MARGIN:int = 20;
      
      private static const RIGHT_MARGIN:int = 30;
      
      private static const TOP_MARGIN:int = 10;
      
      public static const MODE_TEAM_GOLD_ADVANTAGE:String = "teamGoldAdvantage";
      
      public static const MODE_TEAM_GOLD:String = "teamGold";
      
      public static const MODE_CHAMPION_GOLD:String = "championGold";
      
      public static const MODE_TEAM_SCORE_ADVANTAGE:String = "teamScoreAdvantage";
      
      public static const MODE_TEAM_SCORE:String = "teamScore";
      
      public static const MODE_CHAMPION_SCORE:String = "championScore";
      
      private var _model:NewMatchHistoryModel;
      
      private var _currentGame:MatchHistoryGame;
      
      private var _gridGraphicsProxy:SpriteProxy;
      
      private var _gridGraphicsAsset:Sprite;
      
      private var _gridGraphics:Graphics;
      
      private var _dataFillGraphicsProxy:SpriteProxy;
      
      private var _dataFillGraphicsAsset:Sprite;
      
      private var _dataFillGraphics:Graphics;
      
      private var _dataLineGraphicsProxy:SpriteProxy;
      
      private var _dataLineGraphicsAsset:Sprite;
      
      private var _dataLineGraphics:Graphics;
      
      private var _topGradient:StatefulView;
      
      private var _bottomGradient:StatefulView;
      
      private var _gradientContainer:SpriteProxy;
      
      private var _valueLabels:Vector.<MatchHistoryGraphLabel> = new Vector.<MatchHistoryGraphLabel>();
      
      private var _timeLabels:Vector.<MatchHistoryGraphLabel> = new Vector.<MatchHistoryGraphLabel>();
      
      private var _graphMarkers:Vector.<MatchHistoryGraphMarker> = new Vector.<MatchHistoryGraphMarker>();
      
      private var _graphRect:Rectangle = null;
      
      private var _useObjectiveScore:Boolean = false;
      
      private var _valueFloor:int;
      
      private var _valueCeiling:int;
      
      private var _graphValueRange:int;
      
      private var _floorDemarcation:int;
      
      private var _ceilingDemarcation:int;
      
      private var _valueDemarcations:Vector.<int>;
      
      private var _timeDemarcations:Vector.<int>;
      
      private var _maxTime:int;
      
      private var _dataPoints:Vector.<Point>;
      
      private var _participants:Vector.<Object>;
      
      private var _currentDisplayMode:String = "teamGoldAdvantage";
      
      public function MatchHistoryGraphPanelView(param1:IContext)
      {
         super(param1,new Sprite());
         this._model.getCurrentGameChanged().add(this.handleCurrentGameChanged);
         this.handleCurrentGameChanged();
      }
      
      override protected function initializeDependencies() : void
      {
         this._model = getDependency(NewMatchHistoryModel);
         super.initializeDependencies();
      }
      
      override protected function createChildren() : void
      {
         this._gridGraphicsAsset = new Sprite();
         this._gridGraphicsProxy = new SpriteProxy(this,this._gridGraphicsAsset);
         this._gridGraphics = this._gridGraphicsAsset.graphics;
         addChild(this._gridGraphicsProxy);
         this._dataFillGraphicsAsset = new Sprite();
         this._dataFillGraphicsProxy = new SpriteProxy(this,this._dataFillGraphicsAsset);
         this._dataFillGraphics = this._dataFillGraphicsAsset.graphics;
         addChild(this._dataFillGraphicsProxy);
         this._gradientContainer = new SpriteProxy(this,new Sprite());
         this._gradientContainer.setMask(this._dataFillGraphicsProxy);
         this._gradientContainer.setFilters([new DropShadowFilter(4,90,0,0.25,6,6)]);
         addChild(this._gradientContainer);
         this._topGradient = new StatefulView(this);
         this._topGradient.setLinkage("GradientTop");
         this._topGradient.setTransformBehavior(new ScalingTransformBehavior());
         this._gradientContainer.addChild(this._topGradient);
         this._bottomGradient = new StatefulView(this);
         this._bottomGradient.setLinkage("GradientBottom");
         this._bottomGradient.setTransformBehavior(new ScalingTransformBehavior());
         this._gradientContainer.addChild(this._bottomGradient);
         this._dataLineGraphicsAsset = new Sprite();
         this._dataLineGraphicsProxy = new SpriteProxy(this,this._dataLineGraphicsAsset);
         this._dataLineGraphics = this._dataLineGraphicsAsset.graphics;
         addChild(this._dataLineGraphicsProxy);
         super.createChildren();
      }
      
      public function getGraphDisplayModes() : Array
      {
         var _loc1_:Array = new Array();
         var _loc2_:String = "newMatchHistory_graphOption_";
         _loc1_.push({
            "name":MODE_TEAM_SCORE_ADVANTAGE,
            "label":EMatchHistoryLocalization.getLocalizedString(_loc2_ + MODE_TEAM_SCORE_ADVANTAGE),
            "onObjectiveScoreGames":true,
            "onNonObjectiveScoreGames":false
         });
         _loc1_.push({
            "name":MODE_TEAM_GOLD_ADVANTAGE,
            "label":EMatchHistoryLocalization.getLocalizedString(_loc2_ + MODE_TEAM_GOLD_ADVANTAGE),
            "onObjectiveScoreGames":false,
            "onNonObjectiveScoreGames":true
         });
         _loc1_.push({
            "name":MODE_TEAM_GOLD,
            "label":EMatchHistoryLocalization.getLocalizedString(_loc2_ + MODE_TEAM_GOLD),
            "onObjectiveScoreGames":false,
            "onNonObjectiveScoreGames":true
         });
         _loc1_.push({
            "name":MODE_TEAM_SCORE,
            "label":EMatchHistoryLocalization.getLocalizedString(_loc2_ + MODE_TEAM_SCORE),
            "onObjectiveScoreGames":true,
            "onNonObjectiveScoreGames":false
         });
         _loc1_.push({
            "name":MODE_CHAMPION_SCORE,
            "label":EMatchHistoryLocalization.getLocalizedString(_loc2_ + MODE_CHAMPION_SCORE),
            "onObjectiveScoreGames":true,
            "onNonObjectiveScoreGames":false
         });
         _loc1_.push({
            "name":MODE_CHAMPION_GOLD,
            "label":EMatchHistoryLocalization.getLocalizedString(_loc2_ + MODE_CHAMPION_GOLD),
            "onObjectiveScoreGames":true,
            "onNonObjectiveScoreGames":true
         });
         return _loc1_;
      }
      
      public function setDisplayMode(param1:String) : void
      {
         if(this._currentDisplayMode != param1)
         {
            this._currentDisplayMode = param1;
            this.updateView();
         }
      }
      
      public function setParticipants(param1:Vector.<Object>) : void
      {
         this._participants = param1;
         if(this.showingParticipantData())
         {
            this.updateView();
         }
      }
      
      private function showingObjectiveScore() : Boolean
      {
         return this._currentDisplayMode == MODE_CHAMPION_SCORE || this._currentDisplayMode == MODE_TEAM_SCORE || this._currentDisplayMode == MODE_TEAM_SCORE_ADVANTAGE;
      }
      
      private function showingAdvantage() : Boolean
      {
         return this._currentDisplayMode == MODE_TEAM_GOLD_ADVANTAGE || this._currentDisplayMode == MODE_TEAM_SCORE_ADVANTAGE;
      }
      
      private function showingParticipantData() : Boolean
      {
         return this._currentDisplayMode == MODE_CHAMPION_GOLD || this._currentDisplayMode == MODE_CHAMPION_SCORE;
      }
      
      private function updateView() : void
      {
         var _loc1_:MatchHistoryGraphLabel = null;
         var _loc2_:MatchHistoryGraphMarker = null;
         this._gridGraphics.clear();
         this._dataFillGraphics.clear();
         this._dataLineGraphics.clear();
         for each(_loc1_ in this._valueLabels)
         {
            _loc1_.setVisible(false);
         }
         for each(_loc1_ in this._timeLabels)
         {
            _loc1_.setVisible(false);
         }
         for each(_loc2_ in this._graphMarkers)
         {
            _loc2_.setVisible(false);
         }
         if(!this._graphRect || !this._currentGame || !this._currentGame.getTimelineRetrieved())
         {
            return;
         }
         this.drawGraph();
      }
      
      private function drawGraph() : void
      {
         this.drawGraphBox();
         this.determineValueRange();
         this.determineValueDemarcations();
         this.drawHorizontalLines();
         this.drawVerticalLines();
         this.createValueLabels();
         this.createTimeLabels();
         this.drawData();
      }
      
      private function drawGraphBox() : void
      {
         this._gridGraphics.lineStyle(1);
         this._gridGraphics.beginFill(0,0);
         this._gridGraphics.drawRect(this._graphRect.x,this._graphRect.y,this._graphRect.width,this._graphRect.height);
         this._gridGraphics.endFill();
      }
      
      private function determineValueRange() : void
      {
         var _loc1_:MatchHistoryGameTimelineFrame = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:MatchHistoryGameTimelineParticipantFrameStats = null;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         if(this.showingAdvantage())
         {
            _loc2_ = 0;
            _loc3_ = 0;
            if(this.showingObjectiveScore())
            {
               for each(_loc1_ in this._currentGame.timeline.frames)
               {
                  _loc6_ = Math.abs(this.getTeamObjectiveScoreFromFrame(100,_loc1_) - this.getTeamObjectiveScoreFromFrame(200,_loc1_));
                  if(_loc6_ > _loc2_)
                  {
                     _loc2_ = _loc6_;
                  }
               }
            }
            else
            {
               for each(_loc1_ in this._currentGame.timeline.frames)
               {
                  _loc7_ = Math.abs(this.getTeamGoldTotalFromFrame(100,_loc1_) - this.getTeamGoldTotalFromFrame(200,_loc1_));
                  if(_loc7_ > _loc2_)
                  {
                     _loc2_ = _loc7_;
                  }
               }
            }
            this._valueCeiling = _loc2_;
            this._valueFloor = -_loc2_;
         }
         else if(this.showingParticipantData())
         {
            _loc1_ = this._currentGame.timeline.frames[this._currentGame.timeline.frames.length - 1];
            for each(_loc8_ in _loc1_.participantFrames)
            {
               if(this._currentDisplayMode == MODE_CHAMPION_GOLD)
               {
                  if(_loc8_.totalGold > _loc3_)
                  {
                     _loc3_ = _loc8_.totalGold;
                  }
               }
               else if(_loc8_.dominionScore > _loc3_)
               {
                  _loc3_ = _loc8_.dominionScore;
               }
            }
            this._valueCeiling = _loc3_;
            this._valueFloor = 0;
         }
         else
         {
            if(this.showingObjectiveScore())
            {
               for each(_loc1_ in this._currentGame.timeline.frames)
               {
                  _loc4_ = this.getTeamObjectiveScoreFromFrame(100,_loc1_);
                  _loc5_ = this.getTeamObjectiveScoreFromFrame(200,_loc1_);
                  if(_loc4_ > _loc3_)
                  {
                     _loc3_ = _loc4_;
                  }
                  if(_loc5_ > _loc3_)
                  {
                     _loc3_ = _loc5_;
                  }
               }
            }
            else
            {
               for each(_loc1_ in this._currentGame.timeline.frames)
               {
                  _loc9_ = this.getTeamGoldTotalFromFrame(100,_loc1_);
                  _loc10_ = this.getTeamGoldTotalFromFrame(200,_loc1_);
                  if(_loc9_ > _loc3_)
                  {
                     _loc3_ = _loc9_;
                  }
                  if(_loc10_ > _loc3_)
                  {
                     _loc3_ = _loc10_;
                  }
               }
            }
            this._valueCeiling = _loc3_;
            this._valueFloor = 0;
         }
         if(this._valueCeiling == this._valueFloor)
         {
            ++this._valueCeiling;
            --this._valueFloor;
         }
      }
      
      private function determineValueDemarcations() : void
      {
         var _loc1_:int = 0;
         var _loc3_:int = 0;
         var _loc5_:int = 0;
         this._valueDemarcations = new Vector.<int>();
         var _loc2_:int = int.MAX_VALUE;
         if(this.showingAdvantage())
         {
            _loc1_ = 0;
            _loc3_ = this.showingObjectiveScore() ? 10 : 1000;
            while(_loc2_ > MAX_HORZ_LINES)
            {
               _loc1_ += _loc3_;
               this._ceilingDemarcation = Math.ceil(this._valueCeiling / _loc1_) * _loc1_;
               this._floorDemarcation = Math.ceil((this._valueFloor + 1) / _loc1_) * _loc1_ - _loc1_;
               _loc2_ = (this._ceilingDemarcation - this._floorDemarcation) / _loc1_ + 1;
            }
         }
         else
         {
            this._floorDemarcation = 0;
            _loc5_ = this._valueCeiling - this._valueFloor;
            _loc3_ = this.showingObjectiveScore() ? 25 : 1000;
            while(_loc2_ > MAX_HORZ_LINES)
            {
               _loc1_ += _loc3_;
               _loc2_ = Math.ceil(_loc5_ / _loc1_);
               this._ceilingDemarcation = _loc1_ * _loc2_;
            }
         }
         var _loc4_:int = this._floorDemarcation;
         while(_loc4_ <= this._ceilingDemarcation)
         {
            this._valueDemarcations.push(_loc4_);
            _loc4_ += _loc1_;
         }
         this._graphValueRange = this._ceilingDemarcation - this._floorDemarcation;
      }
      
      private function drawHorizontalLines() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Number = NaN;
         if(this._valueDemarcations)
         {
            for each(_loc1_ in this._valueDemarcations)
            {
               if(_loc1_ == 0)
               {
                  this._gridGraphics.lineStyle(1,0,1);
               }
               else
               {
                  this._gridGraphics.lineStyle(1,0,0.2);
               }
               _loc2_ = this.getVPosForValue(_loc1_);
               this._gridGraphics.moveTo(this._graphRect.x,_loc2_);
               this._gridGraphics.lineTo(this._graphRect.x + this._graphRect.width,_loc2_);
            }
         }
      }
      
      private function drawVerticalLines() : void
      {
         var _loc4_:MatchHistoryGameTimelineFrame = null;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         this._timeDemarcations = new Vector.<int>();
         this._maxTime = this._currentGame.timeline.frameInterval * (this._currentGame.timeline.frames.length - 1);
         var _loc1_:Boolean = false;
         var _loc2_:int = 0;
         var _loc3_:Number = this._currentGame.timeline.frameInterval;
         this._gridGraphics.lineStyle(1,0,0.2);
         for each(_loc4_ in this._currentGame.timeline.frames)
         {
            if(!_loc1_)
            {
               _loc5_ = _loc2_ * _loc3_;
               _loc6_ = this.getHPosForValue(_loc5_);
               this._gridGraphics.moveTo(_loc6_,this._graphRect.y);
               this._gridGraphics.lineTo(_loc6_,this._graphRect.y + this._graphRect.height);
               this._timeDemarcations.push(_loc5_);
            }
            _loc2_++;
            _loc1_ = !_loc1_;
         }
      }
      
      private function createValueLabels() : void
      {
         var _loc2_:MatchHistoryGraphLabel = null;
         var _loc4_:int = 0;
         var _loc1_:int = 0;
         var _loc3_:Boolean = this.showingObjectiveScore();
         for each(_loc4_ in this._valueDemarcations)
         {
            if(this._valueLabels.length >= _loc1_ + 1)
            {
               _loc2_ = this._valueLabels[_loc1_];
            }
            else
            {
               _loc2_ = new MatchHistoryGraphLabel(this);
               this._valueLabels.push(_loc2_);
               addChild(_loc2_);
            }
            if(_loc3_)
            {
               _loc2_.setObjectiveScoreValue(_loc4_);
            }
            else
            {
               _loc2_.setGoldValue(_loc4_);
            }
            _loc2_.setVisible(true);
            _loc2_.setExplicitSize(LEFT_MARGIN,NaN);
            _loc2_.setExplicitPosition(0,this.getVPosForValue(_loc4_) - 14);
            _loc1_++;
         }
      }
      
      private function createTimeLabels() : void
      {
         var _loc2_:MatchHistoryGraphLabel = null;
         var _loc3_:int = 0;
         var _loc1_:int = 0;
         for each(_loc3_ in this._timeDemarcations)
         {
            if(this._timeLabels.length >= _loc1_ + 1)
            {
               _loc2_ = this._timeLabels[_loc1_];
            }
            else
            {
               _loc2_ = new MatchHistoryGraphLabel(this);
               this._timeLabels.push(_loc2_);
               addChild(_loc2_);
            }
            _loc2_.setTimeValue(_loc3_);
            _loc2_.setExplicitPosition(this.getHPosForValue(_loc3_) - _loc2_.getWidth() / 2,this._graphRect.y + this._graphRect.height + 5);
            if(this._timeDemarcations.length > TIME_LABEL_THRESHOLD)
            {
               _loc2_.setVisible(Boolean(_loc1_ % 2));
            }
            else
            {
               _loc2_.setVisible(true);
            }
            _loc1_++;
         }
      }
      
      private function drawData() : void
      {
         var _loc3_:MatchHistoryGraphMarker = null;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Point = null;
         var _loc8_:MatchHistoryGameTimelineFrame = null;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Point = null;
         var _loc12_:int = 0;
         var _loc13_:int = 0;
         var _loc14_:int = 0;
         var _loc15_:int = 0;
         var _loc16_:int = 0;
         var _loc17_:MatchHistoryGameParticipant = null;
         var _loc18_:Boolean = false;
         var _loc19_:MatchHistoryGameTimelineParticipantFrameStats = null;
         var _loc20_:Point = null;
         var _loc21_:Point = null;
         var _loc1_:int = 0;
         var _loc2_:int = this._currentGame.timeline.frameInterval;
         var _loc4_:Boolean = this._currentGame.searchedParticipant.teamId == 100;
         if(this.showingAdvantage())
         {
            this._dataLineGraphics.lineStyle(1);
            this._dataFillGraphics.lineStyle(0,0);
            this._dataFillGraphics.beginFill(16711680,0.5);
            _loc11_ = new Point(this.getHPosForValue(0),this.getVPosForValue(0));
            this._dataLineGraphics.moveTo(_loc11_.x,_loc11_.y);
            this._dataFillGraphics.moveTo(_loc11_.x,_loc11_.y);
            for each(_loc8_ in this._currentGame.timeline.frames)
            {
               if(this._currentDisplayMode == MODE_TEAM_SCORE_ADVANTAGE)
               {
                  _loc9_ = this.getTeamObjectiveScoreFromFrame(100,_loc8_);
                  _loc10_ = this.getTeamObjectiveScoreFromFrame(200,_loc8_);
               }
               else
               {
                  _loc9_ = this.getTeamGoldTotalFromFrame(100,_loc8_);
                  _loc10_ = this.getTeamGoldTotalFromFrame(200,_loc8_);
               }
               _loc6_ = _loc4_ ? _loc9_ - _loc10_ : _loc10_ - _loc9_;
               _loc5_ = _loc1_ * _loc2_;
               _loc12_ = _loc9_ > _loc10_ ? 100 : 200;
               _loc7_ = new Point(this.getHPosForValue(_loc5_),this.getVPosForValue(_loc6_));
               this._dataLineGraphics.lineTo(_loc7_.x,_loc7_.y);
               this._dataFillGraphics.lineTo(_loc7_.x,_loc7_.y);
               _loc3_ = this.getGraphMarkerForIndex(_loc1_);
               _loc3_.setExplicitPosition(_loc7_.x - _loc3_.getWidth() / 2,_loc7_.y - _loc3_.getHeight() / 2);
               _loc3_.setVisible(true);
               _loc3_.setAdvantageValue(_loc12_,_loc6_,_loc5_);
               _loc1_++;
            }
            this._topGradient.setCurrentState(_loc4_ ? "blue" : "purple");
            this._bottomGradient.setCurrentState(_loc4_ ? "purple" : "blue");
            this._dataFillGraphics.lineTo(this.getHPosForValue(this._maxTime),_loc11_.y);
            this._dataFillGraphics.lineTo(_loc11_.x,_loc11_.y);
            this._dataFillGraphics.endFill();
         }
         else if(this.showingParticipantData())
         {
            this._dataLineGraphics.lineStyle(1);
            this._dataFillGraphics.lineStyle(0,0);
            this._dataFillGraphics.beginFill(16711680,0.5);
            _loc13_ = 0;
            _loc14_ = -1;
            _loc15_ = -1;
            _loc16_ = 0;
            for each(_loc17_ in this._participants)
            {
               if(_loc17_.teamId == 100)
               {
                  _loc13_ = ++_loc14_;
               }
               else
               {
                  _loc13_ = ++_loc15_;
               }
               _loc18_ = false;
               for each(_loc19_ in _loc17_.timeline.frameStats)
               {
                  if(this._currentDisplayMode == MODE_CHAMPION_SCORE)
                  {
                     _loc6_ = _loc19_.dominionScore;
                  }
                  else
                  {
                     _loc6_ = _loc19_.totalGold;
                  }
                  _loc5_ = _loc19_.intervalTimestamp;
                  _loc7_ = new Point(this.getHPosForValue(_loc5_),this.getVPosForValue(_loc6_));
                  _loc3_ = this.getGraphMarkerForIndex(_loc16_);
                  _loc3_.setExplicitPosition(_loc7_.x - _loc3_.getWidth() / 2,_loc7_.y - _loc3_.getHeight() / 2);
                  _loc3_.setVisible(true);
                  _loc3_.setParticipantValue(_loc17_,_loc13_,_loc6_,_loc5_);
                  if(!_loc18_)
                  {
                     this._dataLineGraphics.moveTo(_loc7_.x,_loc7_.y);
                     _loc18_ = true;
                  }
                  else
                  {
                     this._dataLineGraphics.lineTo(_loc7_.x,_loc7_.y);
                  }
                  _loc16_++;
               }
            }
         }
         else
         {
            _loc20_ = null;
            _loc21_ = null;
            this._dataLineGraphics.lineStyle(1);
            for each(_loc8_ in this._currentGame.timeline.frames)
            {
               if(this._currentDisplayMode == MODE_TEAM_SCORE)
               {
                  _loc9_ = this.getTeamObjectiveScoreFromFrame(100,_loc8_);
                  _loc10_ = this.getTeamObjectiveScoreFromFrame(200,_loc8_);
               }
               else
               {
                  _loc9_ = this.getTeamGoldTotalFromFrame(100,_loc8_);
                  _loc10_ = this.getTeamGoldTotalFromFrame(200,_loc8_);
               }
               _loc5_ = _loc1_ * _loc2_;
               _loc3_ = this.getGraphMarkerForIndex(_loc1_ * 2);
               _loc7_ = new Point(this.getHPosForValue(_loc5_),this.getVPosForValue(_loc9_));
               _loc3_.setExplicitPosition(_loc7_.x - _loc3_.getWidth() / 2,_loc7_.y - _loc3_.getWidth() / 2);
               _loc3_.setVisible(true);
               _loc3_.setTeamValue(100,_loc9_,_loc5_);
               if(_loc20_)
               {
                  this._dataLineGraphics.moveTo(_loc20_.x,_loc20_.y);
                  this._dataLineGraphics.lineTo(_loc7_.x,_loc7_.y);
               }
               _loc20_ = _loc7_;
               _loc3_ = this.getGraphMarkerForIndex(_loc1_ * 2 + 1);
               _loc7_ = new Point(this.getHPosForValue(_loc5_),this.getVPosForValue(_loc10_));
               _loc3_.setExplicitPosition(_loc7_.x - _loc3_.getWidth() / 2,_loc7_.y - _loc3_.getWidth() / 2);
               _loc3_.setVisible(true);
               _loc3_.setTeamValue(200,_loc10_,_loc5_);
               if(_loc21_)
               {
                  this._dataLineGraphics.moveTo(_loc21_.x,_loc21_.y);
                  this._dataLineGraphics.lineTo(_loc7_.x,_loc7_.y);
               }
               _loc21_ = _loc7_;
               _loc1_++;
            }
         }
         this._gradientContainer.setVisible(this.showingAdvantage());
      }
      
      private function getTeamGoldTotalFromFrame(param1:int, param2:MatchHistoryGameTimelineFrame) : int
      {
         var _loc4_:MatchHistoryGameTimelineParticipantFrameStats = null;
         var _loc3_:int = 0;
         for each(_loc4_ in param2.participantFrames)
         {
            if(MatchHistoryGameParticipant(this._currentGame.participantsDict[_loc4_.participantId]).teamId == param1)
            {
               _loc3_ += _loc4_.totalGold;
            }
         }
         return _loc3_;
      }
      
      private function getTeamObjectiveScoreFromFrame(param1:int, param2:MatchHistoryGameTimelineFrame) : int
      {
         var _loc4_:MatchHistoryGameTimelineParticipantFrameStats = null;
         var _loc3_:int = 0;
         for each(_loc4_ in param2.participantFrames)
         {
            if(MatchHistoryGameParticipant(this._currentGame.participantsDict[_loc4_.participantId]).teamId == param1)
            {
               return _loc4_.teamScore;
            }
         }
         return _loc3_;
      }
      
      private function getVPosForValue(param1:Number) : Number
      {
         var _loc2_:Number = (param1 - this._floorDemarcation) / this._graphValueRange;
         return this._graphRect.height + this._graphRect.y - this._graphRect.height * _loc2_;
      }
      
      private function getHPosForValue(param1:Number) : Number
      {
         var _loc2_:Number = param1 / this._maxTime;
         return this._graphRect.x + _loc2_ * this._graphRect.width;
      }
      
      private function handleCurrentGameChanged() : void
      {
         this.removeGameListeners();
         this._currentGame = this._model.getCurrentGame();
         this.handleTimelinePopulatedChanged();
         this.addGameListeners();
      }
      
      private function getGraphMarkerForIndex(param1:int) : MatchHistoryGraphMarker
      {
         var _loc2_:MatchHistoryGraphMarker = null;
         if(this._graphMarkers.length >= param1 + 1)
         {
            _loc2_ = this._graphMarkers[param1];
         }
         else
         {
            _loc2_ = new MatchHistoryGraphMarker(this);
            this._graphMarkers.push(_loc2_);
            addChild(_loc2_);
         }
         _loc2_.setVisible(false);
         return _loc2_;
      }
      
      private function addGameListeners() : void
      {
         if(this._currentGame)
         {
            this._currentGame.getTimelineRetrievedChanged().add(this.handleTimelinePopulatedChanged);
         }
      }
      
      private function removeGameListeners() : void
      {
         if(this._currentGame)
         {
            this._currentGame.getTimelineRetrievedChanged().remove(this.handleTimelinePopulatedChanged);
         }
      }
      
      private function handleTimelinePopulatedChanged() : void
      {
         this.updateView();
      }
      
      override protected function updateLayout(param1:Number, param2:Number) : Rectangle
      {
         this._graphRect = new Rectangle();
         this._graphRect.x = LEFT_MARGIN;
         this._graphRect.y = TOP_MARGIN;
         this._graphRect.width = param1 - LEFT_MARGIN - RIGHT_MARGIN;
         this._graphRect.height = param2 - BOTTOM_MARGIN - TOP_MARGIN;
         this._topGradient.setExplicitSize(this._graphRect.width,this._graphRect.height / 2);
         this._topGradient.setExplicitPosition(this._graphRect.x,this._graphRect.y);
         this._bottomGradient.setExplicitSize(this._graphRect.width,this._graphRect.height / 2);
         this._bottomGradient.setExplicitPosition(this._graphRect.x,this._graphRect.y + this._graphRect.height / 2);
         this.updateView();
         if(!isNaN(param1) && !isNaN(param2))
         {
            this._gridGraphics.lineStyle(0,0,0);
            this._gridGraphics.beginFill(0,0);
            this._gridGraphics.drawRect(0,0,param1,param2);
            this._gridGraphics.endFill();
         }
         return super.updateLayout(param1,param2);
      }
   }
}

