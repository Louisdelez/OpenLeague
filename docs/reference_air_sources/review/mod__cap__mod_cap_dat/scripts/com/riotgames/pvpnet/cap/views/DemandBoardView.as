package com.riotgames.pvpnet.cap.views
{
   import blix.assets.proxy.SpriteProxy;
   import blix.assets.proxy.TextFieldProxy;
   import blix.components.button.ButtonX;
   import blix.components.button.LabelButtonX;
   import blix.components.list.DataScroller;
   import blix.components.list.RendererFactory;
   import blix.components.list.SelectionBehavior;
   import blix.components.scroll.ScrollPolicy;
   import blix.components.timeline.StatefulView;
   import blix.context.IContext;
   import blix.ds.ListX;
   import blix.layout.LayoutEntry;
   import blix.layout.algorithms.VirtualizedTileLayout;
   import blix.layout.vo.HorizontalAlign;
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import com.riotgames.platform.common.provider.ISoundProvider;
   import com.riotgames.pvpnet.cap.audio.CapAudioKeys;
   import com.riotgames.pvpnet.cap.model.CapDemandedSpec;
   import com.riotgames.pvpnet.cap.model.core.CapModel;
   import com.riotgames.pvpnet.cap.util.CapLocaleUtil;
   import com.riotgames.pvpnet.cap.views.popups.champselect.CapClassicChampSelectPopup;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.ui.Keyboard;
   
   public class DemandBoardView extends StatefulView
   {
      
      private static const STATE_OPEN:String = "opened";
      
      private static const STATE_CLOSED:String = "closed";
      
      private static const STATE_SELECTED_ROLE:String = "selectedRole";
      
      private static const TOP_PADDING_VALUE:uint = 35;
      
      private static const BOTTOM_PADDING_VALUE:uint = 115;
      
      private var _specRenderer:DemandedSpecRenderer;
      
      private var _listData:ListX;
      
      private var _rendererFactory:RendererFactory;
      
      private var _listSizer:SpriteProxy;
      
      private var _specSelected:Signal = new Signal();
      
      private var _collapseButton:ButtonX;
      
      private var _soundProvider:ISoundProvider;
      
      private var _titleText:TextFieldProxy;
      
      private var _model:CapModel;
      
      private var _bottomRule:SpriteProxy;
      
      private var _champSelectPopup:CapClassicChampSelectPopup;
      
      private var _selectChampionButton:LabelButtonX;
      
      private var _list:DataScroller;
      
      private var _selectionBehavior:SelectionBehavior;
      
      public function DemandBoardView(param1:IContext, param2:CapModel)
      {
         this._model = param2;
         this._model.demandedSpecsChanged.add(this.updateDemandedSpecs);
         super(param1);
      }
      
      private function handleChampionChanged() : void
      {
         if(Boolean(this._model.localPlayerSelection.champion) && getCurrentState() == STATE_SELECTED_ROLE)
         {
            this.setCurrentState(STATE_CLOSED);
            this._titleText.setText(CapLocaleUtil.getResourceString("gf_demandboard_title","**Demand board"));
         }
      }
      
      public function get specSelected() : ISignal
      {
         return this._specSelected;
      }
      
      private function onKeyDown(param1:KeyboardEvent) : void
      {
         if(param1.charCode == Keyboard.ESCAPE)
         {
            this.hideChampSelectDialog();
         }
      }
      
      private function handleSpecSelected(param1:CapDemandedSpec) : void
      {
         var _loc2_:uint = 0;
         if(!this._model.localPlayerSelection.champion && Boolean(param1))
         {
            this._titleText.setText(CapLocaleUtil.getResourceString("gf_demandboard_selectedTitle","Select a champion"));
            _loc2_ = uint(this._model.demandedSpecs.indexOf(param1));
            this._specRenderer.setData(param1);
            this._specRenderer.setIndex(_loc2_);
            this._collapseButton.setSelected(true);
            this.setCurrentState(STATE_SELECTED_ROLE);
         }
         ++this._model.numDemandBoardClicks;
         this._specSelected.dispatch();
      }
      
      override public function destroy() : void
      {
         this._model.demandedSpecsChanged.remove(this.updateDemandedSpecs);
         if(getStage())
         {
            getStage().removeEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown);
         }
         super.destroy();
      }
      
      override protected function initializeDependencies() : void
      {
         this._champSelectPopup = getDependency(CapClassicChampSelectPopup);
         this._soundProvider = getDependency(ISoundProvider);
         super.initializeDependencies();
      }
      
      override public function setCurrentState(param1:String) : void
      {
         super.setCurrentState(param1);
         invalidateLayout();
      }
      
      private function updateDemandedSpecs() : void
      {
         this._listData = new ListX(this._model.demandedSpecs);
         this._list.setDataProvider(this._listData);
      }
      
      override protected function createChildren() : void
      {
         this._titleText = new TextFieldProxy(this);
         setTimelineChildByName("titleText",this._titleText);
         this._titleText.setText(CapLocaleUtil.getResourceString("gf_demandboard_title","Demand board"));
         this._listSizer = new SpriteProxy(this);
         setTimelineChildByName("listSizer",this._listSizer);
         this._bottomRule = new SpriteProxy(this);
         setTimelineChildByName("bottomRule",this._bottomRule);
         this._collapseButton = new ButtonX(this);
         setTimelineChildByName("collapseButton",this._collapseButton);
         this._collapseButton.addEventListener(MouseEvent.CLICK,this.handleCollapseButtonClicked);
         this._list = new DataScroller(this);
         setTimelineChildByName("list",this._list);
         this._list.setScrollPolicy(ScrollPolicy.AUTO);
         this._list.mouseDelta = 0.3;
         var _loc1_:VirtualizedTileLayout = new VirtualizedTileLayout();
         _loc1_.setHGap(7);
         _loc1_.setVGap(10);
         _loc1_.setHorizontalAlign(HorizontalAlign.CENTER);
         this._list.setLayoutAlgorithm(_loc1_);
         this.updateDemandedSpecs();
         this._rendererFactory = new RendererFactory(DemandedSpecRenderer,[this]);
         this._rendererFactory.getEntryConstructed().add(this.listenToRenderer);
         this._list.setRendererFactory(this._rendererFactory);
         this._specRenderer = new DemandedSpecRenderer(this);
         setTimelineChildByName("specRenderer",this._specRenderer);
         this._specRenderer.setMouseEnabled(false);
         this._specRenderer.setMouseChildren(false);
         this._selectChampionButton = new LabelButtonX(this);
         setTimelineChildByName("selectChampionButton",this._selectChampionButton);
         this._selectChampionButton.setText(CapLocaleUtil.getResourceString("gf_button_select_champion_label","**Select Champion"));
         this._selectChampionButton.addEventListener(MouseEvent.CLICK,this.handleSelectChampionClicked);
         this._selectionBehavior = new SelectionBehavior(this._rendererFactory,this._listData);
         this._model.localPlayerSelection.championChanged.add(this.handleChampionChanged);
         super.createChildren();
      }
      
      private function listenToRenderer(param1:LayoutEntry, param2:*) : void
      {
         var _loc3_:DemandedSpecRenderer = DemandedSpecRenderer(param1.element);
         _loc3_.getSpecSelected().add(this.handleSpecSelected);
      }
      
      private function handleSelectChampionClicked(param1:MouseEvent) : void
      {
         this._soundProvider.play(CapAudioKeys.CAP_OPEN_WINDOW);
         this._champSelectPopup.championSelectionEnabled = true;
         this._champSelectPopup.show();
         getStage().addEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown,false,0,true);
      }
      
      override protected function updateLayout(param1:Number, param2:Number) : Rectangle
      {
         var _loc3_:Point = this._list.setExplicitSize(this._listSizer.getWidth(),this._listSizer.getHeight());
         this._list.setExplicitPosition(this._listSizer.getX(),this._listSizer.getY());
         var _loc4_:int = this._bottomRule.getY() + this._bottomRule.getHeight();
         return new Rectangle(0,TOP_PADDING_VALUE,_asset.getBounds(null).width,_loc4_ - BOTTOM_PADDING_VALUE);
      }
      
      private function handleCollapseButtonClicked(param1:MouseEvent) : void
      {
         this._collapseButton.setSelected(!this._collapseButton.getSelected());
         this.setCurrentState(this._collapseButton.getSelected() ? STATE_CLOSED : STATE_OPEN);
      }
      
      private function hideChampSelectDialog() : void
      {
         if(getStage())
         {
            getStage().removeEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown);
         }
         this._champSelectPopup.hide();
      }
   }
}

