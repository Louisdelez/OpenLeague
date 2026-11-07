package com.riotgames.pvpnet.matchhistoryiron.newmatchhistory.view
{
   import blix.assets.proxy.SpriteProxy;
   import blix.assets.proxy.TextFieldProxy;
   import blix.components.list.DataGroup;
   import blix.components.list.RendererFactory;
   import blix.components.timeline.StatefulView;
   import blix.context.IContext;
   import blix.ds.ListX;
   import blix.layout.algorithms.VirtualizedVerticalLayout;
   import blix.view.behaviors.ScalingTransformBehavior;
   import com.riotgames.pvpnet.matchhistoryiron.enum.EMatchHistoryLocalization;
   import com.riotgames.pvpnet.matchhistoryiron.newmatchhistory.model.MatchHistoryGame;
   import com.riotgames.pvpnet.matchhistoryiron.newmatchhistory.model.MatchHistoryGameParticipant;
   import com.riotgames.pvpnet.matchhistoryiron.newmatchhistory.model.MatchHistoryTeamStats;
   import com.riotgames.pvpnet.matchhistoryiron.newmatchhistory.model.NewMatchHistoryModel;
   import com.riotgames.pvpnet.system.config.UserPreferencesManager;
   import flash.display.MovieClip;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class MatchHistoryGameDetailsScoreboardView extends StatefulView
   {
      
      private var _model:NewMatchHistoryModel;
      
      private var _currentGame:MatchHistoryGame;
      
      private var _contentContainer:SpriteProxy;
      
      private var _background:SpriteProxy;
      
      private var _blueVictoryText:TextFieldProxy;
      
      private var _blueGoldText:TextFieldProxy;
      
      private var _blueKillsText:TextFieldProxy;
      
      private var _purpleKillsText:TextFieldProxy;
      
      private var _purpleGoldText:TextFieldProxy;
      
      private var _purpleVictoryText:TextFieldProxy;
      
      private var _blueSizer:SpriteProxy;
      
      private var _blueDataGroup:DataGroup;
      
      private var _purpleSizer:SpriteProxy;
      
      private var _purpleDataGroup:DataGroup;
      
      private var _teamStatsFooter:MatchHistoryScoreboardTeamStatsFooter;
      
      private var _blueTeamData:ListX = new ListX();
      
      private var _purpleTeamData:ListX = new ListX();
      
      public function MatchHistoryGameDetailsScoreboardView(param1:IContext, param2:MovieClip = null)
      {
         super(param1,param2);
         getTransitionAnimation("waiting","loaded").getTransitionProgressed().add(invalidateLayout);
         setLinkage("MatchHistoryScoreboard");
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
         this._contentContainer = new SpriteProxy(this);
         setTimelineChildByName("content",this._contentContainer);
         this._background = new SpriteProxy(this);
         this._background.setTransformBehavior(new ScalingTransformBehavior());
         this._contentContainer.setTimelineChildByName("background",this._background);
         this._blueVictoryText = new TextFieldProxy(this);
         this._contentContainer.setTimelineChildByName("blueVictoryText",this._blueVictoryText);
         this._blueGoldText = new TextFieldProxy(this);
         this._contentContainer.setTimelineChildByName("blueGoldText",this._blueGoldText);
         this._blueKillsText = new TextFieldProxy(this);
         this._contentContainer.setTimelineChildByName("blueKillsText",this._blueKillsText);
         this._purpleKillsText = new TextFieldProxy(this);
         this._contentContainer.setTimelineChildByName("purpleKillsText",this._purpleKillsText);
         this._purpleGoldText = new TextFieldProxy(this);
         this._contentContainer.setTimelineChildByName("purpleGoldText",this._purpleGoldText);
         this._purpleVictoryText = new TextFieldProxy(this);
         this._contentContainer.setTimelineChildByName("purpleVictoryText",this._purpleVictoryText);
         this._blueSizer = new SpriteProxy(this);
         this._contentContainer.setTimelineChildByName("blueSizer",this._blueSizer);
         this._purpleSizer = new SpriteProxy(this);
         this._contentContainer.setTimelineChildByName("purpleSizer",this._purpleSizer);
         var _loc1_:VirtualizedVerticalLayout = new VirtualizedVerticalLayout();
         _loc1_.setGap(-1);
         var _loc2_:RendererFactory = new RendererFactory(MatchHistoryScoreboardRenderer,[this,"ScoreboardParticipantBlue"]);
         this._blueDataGroup = new DataGroup(this,this._blueTeamData,_loc2_);
         this._blueDataGroup.setLinkage("ScrollContainer");
         this._blueDataGroup.setLayoutAlgorithm(_loc1_);
         this._blueDataGroup.getLayoutInvalidated().add(invalidateLayout);
         this._contentContainer.addChild(this._blueDataGroup);
         var _loc3_:RendererFactory = new RendererFactory(MatchHistoryScoreboardRenderer,[this,"ScoreboardParticipantPurple"]);
         this._purpleDataGroup = new DataGroup(this,this._purpleTeamData,_loc3_);
         this._purpleDataGroup.setLinkage("ScrollContainer");
         this._purpleDataGroup.setLayoutAlgorithm(_loc1_);
         this._purpleDataGroup.getLayoutInvalidated().add(invalidateLayout);
         this._contentContainer.addChild(this._purpleDataGroup);
         this._teamStatsFooter = new MatchHistoryScoreboardTeamStatsFooter(this);
         this._contentContainer.setTimelineChildByName("teamStatsFooter",this._teamStatsFooter);
         super.createChildren();
      }
      
      override public function setCurrentState(param1:String) : void
      {
         super.setCurrentState(param1);
         invalidateLayout();
      }
      
      private function updateView() : void
      {
         var _loc1_:Vector.<MatchHistoryGameParticipant> = null;
         var _loc2_:Vector.<MatchHistoryGameParticipant> = null;
         var _loc3_:MatchHistoryGameParticipant = null;
         setTransitionsEnabled(UserPreferencesManager.userPrefs.enableAnimations);
         if(Boolean(this._currentGame) && this._currentGame.getDetailsPopulated())
         {
            this.setCurrentState("loaded");
            this._blueGoldText.setText(this.getFormattedGold(this.calculateTeamGold(100)));
            if(MatchHistoryTeamStats(this._currentGame.teams[100]).win == "Win")
            {
               this._blueVictoryText.setText(EMatchHistoryLocalization.getLocalizedString("GAME_VICTORY"));
               this._purpleVictoryText.setText(EMatchHistoryLocalization.getLocalizedString("GAME_DEFEAT"));
            }
            else
            {
               this._blueVictoryText.setText(EMatchHistoryLocalization.getLocalizedString("GAME_DEFEAT"));
               this._purpleVictoryText.setText(EMatchHistoryLocalization.getLocalizedString("GAME_VICTORY"));
            }
            this._blueKillsText.setText(String(this.calculateTeamKills(100)));
            this._purpleGoldText.setText(this.getFormattedGold(this.calculateTeamGold(200)));
            this._purpleKillsText.setText(String(this.calculateTeamKills(200)));
            _loc1_ = new Vector.<MatchHistoryGameParticipant>();
            _loc2_ = new Vector.<MatchHistoryGameParticipant>();
            for each(_loc3_ in this._currentGame.participants)
            {
               if(_loc3_.teamId == 100)
               {
                  _loc1_.push(_loc3_);
               }
               else if(_loc3_.teamId == 200)
               {
                  _loc2_.push(_loc3_);
               }
            }
            this._blueTeamData.setSource(_loc1_);
            this._purpleTeamData.setSource(_loc2_);
         }
         else
         {
            this.setCurrentState("waiting");
            this._blueGoldText.setText("");
            this._blueVictoryText.setText("");
            this._blueKillsText.setText("");
            this._purpleGoldText.setText("");
            this._purpleVictoryText.setText("");
            this._purpleKillsText.setText("");
            this._blueTeamData.setSource(null);
            this._purpleTeamData.setSource(null);
         }
      }
      
      private function calculateTeamGold(param1:int) : int
      {
         var _loc3_:MatchHistoryGameParticipant = null;
         var _loc2_:int = 0;
         for each(_loc3_ in this._currentGame.participants)
         {
            if(_loc3_.teamId == param1)
            {
               _loc2_ += _loc3_.stats.goldEarned;
            }
         }
         return _loc2_;
      }
      
      private function calculateTeamKills(param1:int) : int
      {
         var _loc3_:MatchHistoryGameParticipant = null;
         var _loc2_:int = 0;
         for each(_loc3_ in this._currentGame.participants)
         {
            if(_loc3_.teamId == param1)
            {
               _loc2_ += _loc3_.stats.kills;
            }
         }
         return _loc2_;
      }
      
      private function getFormattedGold(param1:int) : String
      {
         var _loc2_:String = EMatchHistoryLocalization.getLocalizedString(EMatchHistoryLocalization.THOUSAND);
         return Math.round(param1 / 1000).toString() + _loc2_;
      }
      
      private function handleCurrentGameChanged() : void
      {
         this.removeGameListeners();
         this._currentGame = this._model.getCurrentGame();
         this.handleDetailsPopulatedChanged();
         this.addGameListeners();
      }
      
      private function addGameListeners() : void
      {
         if(this._currentGame)
         {
            this._currentGame.getDetailsPopulatedChanged().add(this.handleDetailsPopulatedChanged);
         }
      }
      
      private function removeGameListeners() : void
      {
         if(this._currentGame)
         {
            this._currentGame.getDetailsPopulatedChanged().remove(this.handleDetailsPopulatedChanged);
         }
      }
      
      private function handleDetailsPopulatedChanged() : void
      {
         this.updateView();
      }
      
      override protected function updateLayout(param1:Number, param2:Number) : Rectangle
      {
         var _loc3_:Point = this._blueDataGroup.setExplicitSize(this._blueSizer.getWidth(),NaN);
         this._blueDataGroup.setExplicitPosition(this._blueSizer.getX(),this._blueSizer.getY());
         var _loc4_:Point = this._purpleDataGroup.setExplicitSize(this._purpleSizer.getWidth(),NaN);
         this._purpleDataGroup.setExplicitPosition(this._purpleSizer.getX(),this._purpleSizer.getY());
         this._background.setExplicitSize(NaN,Math.max(_loc3_.y,_loc4_.y) + 83);
         this._teamStatsFooter.setExplicitPosition(NaN,Math.max(_loc3_.y,_loc4_.y) + 44);
         return new Rectangle(this._background.getX(),this._background.getY(),this._background.getWidth(),this._background.getHeight());
      }
   }
}

