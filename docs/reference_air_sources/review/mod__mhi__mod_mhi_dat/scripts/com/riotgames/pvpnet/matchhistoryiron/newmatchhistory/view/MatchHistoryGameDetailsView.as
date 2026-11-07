package com.riotgames.pvpnet.matchhistoryiron.newmatchhistory.view
{
   import blix.assets.proxy.SpriteProxy;
   import blix.components.button.LabelButtonX;
   import blix.components.scroll.ScrollArea;
   import blix.components.scroll.ScrollPolicy;
   import blix.components.timeline.StatefulView;
   import blix.context.IContext;
   import blix.layout.algorithms.VerticalLayout;
   import blix.layout.vo.HorizontalAlign;
   import com.riotgames.pvpnet.matchhistoryiron.enum.EMatchHistoryLocalization;
   import com.riotgames.pvpnet.matchhistoryiron.newmatchhistory.controller.NewMatchHistoryController;
   import com.riotgames.pvpnet.matchhistoryiron.newmatchhistory.model.NewMatchHistoryModel;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   
   public class MatchHistoryGameDetailsView extends StatefulView
   {
      
      private var _controller:NewMatchHistoryController;
      
      private var _model:NewMatchHistoryModel;
      
      private var _backButton:LabelButtonX;
      
      private var _scrollAreaSizer:SpriteProxy;
      
      private var _scrollArea:ScrollArea;
      
      private var _headerView:MatchHistoryGameDetailsHeaderView;
      
      private var _scoreboardView:MatchHistoryGameDetailsScoreboardView;
      
      private var _graphView:MatchHistoryDetailsOverTimeView;
      
      public function MatchHistoryGameDetailsView(param1:IContext, param2:MovieClip = null)
      {
         super(param1,param2);
         this._model.getCurrentGameChanged().add(this.handleCurrentGameChanged);
      }
      
      override protected function initializeDependencies() : void
      {
         this._controller = getDependency(NewMatchHistoryController);
         this._model = getDependency(NewMatchHistoryModel);
         super.initializeDependencies();
      }
      
      override protected function createChildren() : void
      {
         this._scrollAreaSizer = new SpriteProxy(this);
         setTimelineChildByName("scrollAreaSizer",this._scrollAreaSizer);
         this._scrollArea = new ScrollArea(this);
         this._scrollArea.setLinkage("ScrollContainer");
         this._scrollArea.setKineticScrolling(true);
         this._scrollArea.setVScrollPolicy(ScrollPolicy.ON);
         addChild(this._scrollArea);
         var _loc1_:VerticalLayout = new VerticalLayout();
         _loc1_.setGap(0);
         _loc1_.setHorizontalAlign(HorizontalAlign.LEFT);
         this._scrollArea.getContents().setLayoutAlgorithm(_loc1_);
         this._headerView = new MatchHistoryGameDetailsHeaderView(this);
         this._scrollArea.getContents().addElement(this._headerView);
         this._scoreboardView = new MatchHistoryGameDetailsScoreboardView(this);
         this._scrollArea.getContents().addElement(this._scoreboardView);
         this._graphView = new MatchHistoryDetailsOverTimeView(this);
         this._scrollArea.getContents().addElement(this._graphView);
         this._backButton = new LabelButtonX(this);
         this._backButton.setText(EMatchHistoryLocalization.getLocalizedString("newMatchHistory_goBack"));
         setTimelineChildByName("backButton",this._backButton);
         this._backButton.addEventListener(MouseEvent.CLICK,this.handleBackButtonClicked);
         super.createChildren();
      }
      
      private function handleBackButtonClicked(param1:MouseEvent) : void
      {
         this._controller.viewGameDetails(null);
      }
      
      private function handleCurrentGameChanged() : void
      {
         if(this._model.getCurrentGame())
         {
            this._scrollArea.getVScrollModel().setValue(0);
         }
      }
      
      override protected function updateLayout(param1:Number, param2:Number) : Rectangle
      {
         this._scrollArea.setExplicitSize(this._scrollAreaSizer.getWidth(),this._scrollAreaSizer.getHeight());
         this._scrollArea.setExplicitPosition(this._scrollAreaSizer.getX(),this._scrollAreaSizer.getY());
         return super.updateLayout(param1,param2);
      }
   }
}

