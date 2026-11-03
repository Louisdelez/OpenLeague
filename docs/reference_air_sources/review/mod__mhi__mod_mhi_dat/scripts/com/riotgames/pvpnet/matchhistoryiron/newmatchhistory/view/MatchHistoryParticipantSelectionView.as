package com.riotgames.pvpnet.matchhistoryiron.newmatchhistory.view
{
   import blix.assets.proxy.SpriteProxy;
   import blix.components.list.DataGroup;
   import blix.components.list.RendererFactory;
   import blix.components.list.SelectionBehavior;
   import blix.context.IContext;
   import blix.ds.ListX;
   import blix.layout.LayoutContainer;
   import blix.layout.algorithms.HorizontalLayout;
   import blix.layout.algorithms.VirtualizedHorizontalLayout;
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import com.riotgames.pvpnet.matchhistoryiron.newmatchhistory.model.MatchHistoryGame;
   import com.riotgames.pvpnet.matchhistoryiron.newmatchhistory.model.MatchHistoryGameParticipant;
   import com.riotgames.pvpnet.matchhistoryiron.newmatchhistory.model.NewMatchHistoryModel;
   import flash.display.Sprite;
   import flash.geom.Rectangle;
   
   public class MatchHistoryParticipantSelectionView extends SpriteProxy
   {
      
      private var _model:NewMatchHistoryModel;
      
      private var _currentGame:MatchHistoryGame;
      
      private var _blueParticipants:DataGroup;
      
      private var _purpleParticipants:DataGroup;
      
      private var _participantsLayoutContainer:LayoutContainer;
      
      private var _blueParticipantsDataProvider:ListX;
      
      private var _blueSelectionBehavior:SelectionBehavior;
      
      private var _purpleParticipantsDataProvider:ListX;
      
      private var _purpleSelectionBehavior:SelectionBehavior;
      
      private var _blueRendererFactory:RendererFactory;
      
      private var _purpleRendererFactory:RendererFactory;
      
      private var _participantSelectionChanged:Signal = new Signal();
      
      private var _selections:Vector.<Object>;
      
      public function MatchHistoryParticipantSelectionView(param1:IContext, param2:Sprite = null)
      {
         super(param1,param2);
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
         var _loc1_:HorizontalLayout = new HorizontalLayout();
         _loc1_.setGap(9);
         var _loc2_:VirtualizedHorizontalLayout = new VirtualizedHorizontalLayout();
         _loc2_.setGap(2);
         this._blueRendererFactory = new RendererFactory(MatchHistoryParticipantSelectionRenderer,[this]);
         this._purpleRendererFactory = new RendererFactory(MatchHistoryParticipantSelectionRenderer,[this]);
         this._blueParticipantsDataProvider = new ListX();
         this._purpleParticipantsDataProvider = new ListX();
         this._blueParticipants = new DataGroup(this,this._blueParticipantsDataProvider,this._blueRendererFactory,new Sprite());
         this._blueParticipants.setLayoutAlgorithm(_loc2_);
         addChild(this._blueParticipants);
         this._purpleParticipants = new DataGroup(this,this._purpleParticipantsDataProvider,this._purpleRendererFactory,new Sprite());
         this._purpleParticipants.setLayoutAlgorithm(_loc2_);
         addChild(this._purpleParticipants);
         this._participantsLayoutContainer = new LayoutContainer(this);
         this._participantsLayoutContainer.setLayoutAlgorithm(_loc1_);
         this._participantsLayoutContainer.addElement(this._blueParticipants);
         this._participantsLayoutContainer.addElement(this._purpleParticipants);
         this._blueSelectionBehavior = new SelectionBehavior(this._blueRendererFactory,this._blueParticipantsDataProvider);
         this._blueSelectionBehavior.getSelectedItemsChanged().add(this.handleSelectionsChanged);
         this._blueSelectionBehavior.allowMultipleSelection = true;
         this._blueSelectionBehavior.autoMultipleSelection = true;
         this._purpleSelectionBehavior = new SelectionBehavior(this._purpleRendererFactory,this._purpleParticipantsDataProvider);
         this._purpleSelectionBehavior.getSelectedItemsChanged().add(this.handleSelectionsChanged);
         this._purpleSelectionBehavior.allowMultipleSelection = true;
         this._purpleSelectionBehavior.autoMultipleSelection = true;
         super.createChildren();
      }
      
      private function handleSelectionsChanged() : void
      {
         this._selections = this._blueSelectionBehavior.getSelectedItems().concat(this._purpleSelectionBehavior.getSelectedItems());
         this._participantSelectionChanged.dispatch();
      }
      
      public function setSelectedParticipant(param1:MatchHistoryGameParticipant) : void
      {
         if(param1.teamId == 100)
         {
            this._blueSelectionBehavior.setSelectedItem(param1);
            this._purpleSelectionBehavior.setSelectedItem(null);
         }
         else
         {
            this._blueSelectionBehavior.setSelectedItem(null);
            this._purpleSelectionBehavior.setSelectedItem(param1);
         }
      }
      
      public function getSelectedParticipants() : Vector.<Object>
      {
         return this._selections;
      }
      
      public function getSelectedParticipantsChanged() : ISignal
      {
         return this._participantSelectionChanged;
      }
      
      private function updateView() : void
      {
         var _loc1_:Array = null;
         var _loc2_:Array = null;
         var _loc3_:MatchHistoryGameParticipant = null;
         if(this._currentGame)
         {
            _loc1_ = new Array();
            _loc2_ = new Array();
            for each(_loc3_ in this._currentGame.participants)
            {
               if(_loc3_.teamId == 100)
               {
                  _loc1_.push(_loc3_);
               }
               else
               {
                  _loc2_.push(_loc3_);
               }
            }
            this._blueParticipantsDataProvider.setSource(_loc1_);
            this._purpleParticipantsDataProvider.setSource(_loc2_);
         }
         else
         {
            this._blueSelectionBehavior.setSelectedItems(null);
            this._purpleSelectionBehavior.setSelectedItems(null);
         }
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
            this._currentGame.getTimelineRetrievedChanged().add(this.handleDetailsPopulatedChanged);
         }
      }
      
      private function removeGameListeners() : void
      {
         if(this._currentGame)
         {
            this._currentGame.getTimelineRetrievedChanged().remove(this.handleDetailsPopulatedChanged);
         }
      }
      
      private function handleDetailsPopulatedChanged() : void
      {
         this.updateView();
      }
      
      override protected function updateLayout(param1:Number, param2:Number) : Rectangle
      {
         this._blueParticipants.setExplicitSize(NaN,NaN);
         this._purpleParticipants.setExplicitSize(NaN,NaN);
         return super.updateLayout(param1,param2);
      }
   }
}

