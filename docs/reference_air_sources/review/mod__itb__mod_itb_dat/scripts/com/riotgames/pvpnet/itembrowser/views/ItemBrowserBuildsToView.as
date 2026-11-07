package com.riotgames.pvpnet.itembrowser.views
{
   import blix.assets.proxy.SpriteProxy;
   import blix.context.IContext;
   import blix.layout.LayoutContainerView;
   import blix.layout.algorithms.HorizontalLayout;
   import blix.layout.vo.HorizontalAlign;
   import blix.layout.vo.MinMax;
   import blix.layout.vo.SizeConstraints;
   import blix.layout.vo.VerticalAlign;
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import blix.view.behaviors.ScalingTransformBehavior;
   import com.riotgames.gameItems.model.GameItem;
   import flash.display.Sprite;
   import flash.geom.Matrix;
   import flash.geom.Rectangle;
   
   public class ItemBrowserBuildsToView extends SpriteProxy
   {
      
      private var _layout:LayoutContainerView;
      
      private var _model:GameItem;
      
      private var _horizontalLayout:HorizontalLayout;
      
      private var _buildsToRenderers:Vector.<GameItemRenderer>;
      
      private var _sizer:SpriteProxy;
      
      private var _itemRightClick:Signal = new Signal();
      
      private var _rendererContainer:SpriteProxy;
      
      public function ItemBrowserBuildsToView(param1:IContext)
      {
         super(param1);
      }
      
      private function drawBuildsToItems() : void
      {
         var _loc1_:GameItemRenderer = null;
         var _loc2_:GameItem = null;
         for each(_loc1_ in this._buildsToRenderers)
         {
            this._layout.removeElement(_loc1_);
            _loc1_.destroy();
         }
         this._buildsToRenderers = new Vector.<GameItemRenderer>();
         if(Boolean(this._model) && Boolean(this._model.buildsTo) && this._model.buildsTo.length > 0)
         {
            for each(_loc2_ in this._model.buildsTo)
            {
               _loc1_ = new GameItemRenderer(this);
               _loc1_.setModel(_loc2_);
               _loc1_.getRightClicked().add(this.handleRightClick);
               this._buildsToRenderers.push(_loc1_);
               this._layout.addElement(_loc1_);
            }
         }
      }
      
      public function setModel(param1:GameItem) : void
      {
         if(param1 != this._model)
         {
            this._model = param1;
            if(this._model != null)
            {
               this.drawBuildsToItems();
            }
         }
      }
      
      override protected function updateLayout(param1:Number, param2:Number) : Rectangle
      {
         this._rendererContainer.setTransformMatrix(new Matrix());
         this._layout.setExplicitSize(this._sizer.getWidth(),this._sizer.getHeight());
         this._layout.setExplicitPosition(0,0);
         this._rendererContainer.setExplicitSize(this._sizer.getWidth(),this._sizer.getHeight());
         this._rendererContainer.setExplicitPosition(0,0);
         return super.updateLayout(param1,param2);
      }
      
      private function handleRightClick(param1:GameItem) : void
      {
         this._itemRightClick.dispatch(param1);
      }
      
      public function getItemRightClick() : ISignal
      {
         return this._itemRightClick;
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this._rendererContainer = new SpriteProxy(this,new Sprite());
         addChild(this._rendererContainer);
         this._layout = new LayoutContainerView(this);
         this._layout.setAsset(new Sprite());
         this._horizontalLayout = new HorizontalLayout();
         this._horizontalLayout.setGap(3);
         this._layout.setLayoutAlgorithm(this._horizontalLayout);
         this._layout.getLayoutInvalidated().add(this._rendererContainer.invalidateLayout);
         var _loc1_:ScalingTransformBehavior = new ScalingTransformBehavior();
         _loc1_.setMaintainAspectRatio(true);
         _loc1_.setHorizontalAlign(HorizontalAlign.CENTER);
         _loc1_.setVerticalAlign(VerticalAlign.MIDDLE);
         _loc1_.setScalePercentConstraints(new SizeConstraints(new MinMax(0.4,1),new MinMax(0.4,1)));
         this._rendererContainer.setTransformBehavior(_loc1_);
         this._rendererContainer.getLayoutInvalidated().add(invalidateLayout);
         this._rendererContainer.addChild(this._layout);
         this._sizer = new SpriteProxy(this);
         this._sizer.getLayoutInvalidated().add(invalidateLayout);
         setTimelineChildByName("sizer",this._sizer);
      }
   }
}

