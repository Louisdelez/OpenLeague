package com.riotgames.pvpnet.matchhistoryiron.legacyviews
{
   import blix.components.list.DataScroller;
   import blix.components.list.RendererFactory;
   import blix.components.scroll.ScrollPolicy;
   import blix.context.IContext;
   import blix.ds.IListX;
   import blix.ds.ListX;
   import blix.layout.LayoutEntry;
   import blix.layout.algorithms.VirtualizedVerticalLayout;
   import blix.layout.vo.Padding;
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import com.riotgames.pvpnet.matchhistoryiron.legacyviews.renderer.MatchHistoryLegacyGameRenderer;
   import com.riotgames.pvpnet.matchhistoryiron.model.MatchHistoryModel;
   import com.riotgames.pvpnet.matchhistoryiron.model.MatchHistoryStatModel;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class MatchHistoryGameDataGroupLegacyView extends DataScroller
   {
      
      private var _model:MatchHistoryModel;
      
      private var _onGameClicked:Signal = new Signal();
      
      private var _selectedGameStatModel:MatchHistoryStatModel;
      
      private var _rendererFactory:RendererFactory;
      
      private var _size:Point = new Point();
      
      public function MatchHistoryGameDataGroupLegacyView(param1:IContext, param2:String)
      {
         this._rendererFactory = new RendererFactory(MatchHistoryLegacyGameRenderer,[this,param2]);
         super(param1,null,this._rendererFactory);
      }
      
      override public function destroy() : void
      {
         super.destroy();
         this._onGameClicked = null;
         _scrollModel = null;
      }
      
      public function setModel(param1:MatchHistoryModel) : void
      {
         this._model = param1;
         this._model.onUpdateSignal.add(this.onModelUpdated);
         if(this._model.isInitialized)
         {
            this.onModelUpdated();
         }
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         var _loc1_:VirtualizedVerticalLayout = new VirtualizedVerticalLayout();
         _loc1_.setPadding(new Padding(0));
         _loc1_.setGap(0);
         setLayoutAlgorithm(_loc1_);
         dataGroup.setMouseEnabled(false);
         dataGroupBottom.setMouseEnabled(false);
         this.setRendererFactoryEvent();
         getAssetChanged().addOnce(this.onAssetLoaded);
         setScrollPolicy(ScrollPolicy.OFF);
      }
      
      private function onAssetLoaded() : void
      {
         this._size.x = this.getWidth();
         this._size.y = this.getHeight();
      }
      
      private function setRendererFactoryEvent() : void
      {
         this._rendererFactory.getEntryActivated().add(this.onEntryActivated);
         this._rendererFactory.getEntryDeactivated().add(this.onEntryDeactivated);
      }
      
      private function onEntryActivated(param1:LayoutEntry, param2:*) : void
      {
         (param1.element as MatchHistoryLegacyGameRenderer).addEventListener(MouseEvent.CLICK,this.onGameRendererClicked);
      }
      
      private function onEntryDeactivated(param1:LayoutEntry) : void
      {
         (param1.element as MatchHistoryLegacyGameRenderer).removeEventListener(MouseEvent.CLICK,this.onGameRendererClicked);
      }
      
      private function onModelUpdated() : void
      {
         this.populateCollection();
         invalidateLayout();
      }
      
      private function populateCollection() : void
      {
         var _loc1_:Array = new Array();
         var _loc2_:int = int(this._model.recentGameList.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc1_.push(this._model.recentGameList[_loc3_]);
            _loc3_++;
         }
         var _loc4_:IListX = new ListX(_loc1_);
         setDataProvider(_loc4_);
      }
      
      private function selectFirstGame() : void
      {
         if(this._model.recentGameList.length > 0)
         {
            this._selectedGameStatModel = this._model.recentGameList[0];
            this._onGameClicked.dispatch(this._selectedGameStatModel);
         }
      }
      
      override protected function updateLayout(param1:Number, param2:Number) : Rectangle
      {
         if(_scrollModel.getMax() <= 0)
         {
            setScrollPolicy(ScrollPolicy.OFF);
         }
         else
         {
            setScrollPolicy(ScrollPolicy.ON);
         }
         return super.updateLayout(param1,param2);
      }
      
      private function onGameRendererClicked(param1:MouseEvent) : void
      {
         var _loc2_:MatchHistoryLegacyGameRenderer = param1.target as MatchHistoryLegacyGameRenderer;
         this._onGameClicked.dispatch(_loc2_.getData());
      }
      
      public function get onGameClicked() : ISignal
      {
         return this._onGameClicked;
      }
   }
}

