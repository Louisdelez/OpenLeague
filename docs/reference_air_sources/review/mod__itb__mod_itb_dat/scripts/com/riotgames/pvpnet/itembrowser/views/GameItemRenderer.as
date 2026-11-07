package com.riotgames.pvpnet.itembrowser.views
{
   import blix.assets.proxy.BitmapProxy;
   import blix.assets.proxy.SpriteProxy;
   import blix.assets.proxy.TextFieldProxy;
   import blix.components.button.ButtonX;
   import blix.components.renderer.IItemRenderer;
   import blix.components.timeline.StatefulView;
   import blix.components.tooltip.unassignToolTip;
   import blix.context.IContext;
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import blix.view.behaviors.ScalingTransformBehavior;
   import com.riotgames.gameItems.model.GameItem;
   import com.riotgames.platform.common.ImagePackLookup;
   import com.riotgames.pvpnet.itembrowser.controller.ItemBrowserController;
   import com.riotgames.pvpnet.tips.TipsProviderProxy;
   import com.riotgames.pvpnet.tips.config.ToolTipConfig;
   import com.riotgames.rust.drag.DragBehavior;
   import flash.desktop.Clipboard;
   import flash.desktop.NativeDragManager;
   import flash.desktop.NativeDragOptions;
   import flash.display.BitmapData;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class GameItemRenderer extends ButtonX implements IItemRenderer
   {
      
      private var _index:uint;
      
      private var _backgroundSizer:SpriteProxy;
      
      private var _iconContainer:SpriteProxy;
      
      protected var _rightClicked:Signal = new Signal();
      
      protected var _customToolTipConfig:ToolTipConfig;
      
      private var _iconSizer:SpriteProxy;
      
      public var toolTipEnabled:Boolean = true;
      
      private var _itemBrowserController:ItemBrowserController;
      
      protected var dragBehavior:DragBehavior;
      
      private var _iconBitmap:BitmapProxy;
      
      protected var _model:GameItem;
      
      private var _isNavigatorRenderer:Boolean;
      
      protected var _selectionBackground:StatefulView;
      
      private var _nameText:TextFieldProxy;
      
      private var _costText:TextFieldProxy;
      
      public function GameItemRenderer(param1:IContext, param2:String = "GameItemRenderer", param3:Boolean = false)
      {
         super(param1);
         this._isNavigatorRenderer = param3;
         this._itemBrowserController = getDependency(ItemBrowserController);
         addEventListener(MouseEvent.CLICK,this.handleMouseClick);
         addEventListener(MouseEvent.RIGHT_CLICK,this.handleRightClick);
         this.setDoubleClickEnabled(true);
         addEventListener(MouseEvent.DOUBLE_CLICK,this.handleDoubleClick);
         setLinkage(param2);
         this.dragBehavior = new DragBehavior(this);
         this.dragBehavior.getDragBegin().add(this.dragBeginHandler);
         this._customToolTipConfig = new ToolTipConfig();
         this._customToolTipConfig.showDelay = 200;
         this._customToolTipConfig.gap = this._isNavigatorRenderer ? new Point(25,-10) : new Point(5,0);
      }
      
      public function getModel() : GameItem
      {
         return this._model;
      }
      
      public function setIndex(param1:uint) : void
      {
         this._index = param1;
      }
      
      override protected function updateLayout(param1:Number, param2:Number) : Rectangle
      {
         this._selectionBackground.setExplicitSize(this._backgroundSizer.getWidth(),this._backgroundSizer.getHeight());
         this._iconBitmap.setExplicitSize(this._iconSizer.getWidth(),this._iconSizer.getHeight());
         return _asset.getBounds(null);
      }
      
      override public function setCurrentState(param1:String) : void
      {
         super.setCurrentState(param1);
         this._selectionBackground.setCurrentState(getCurrentState());
      }
      
      public function getIndex() : uint
      {
         return this._index;
      }
      
      override public function destroy() : void
      {
         this._rightClicked.removeAll();
         this.setModel(null);
         super.destroy();
      }
      
      override public function getData() : *
      {
         return this.getModel();
      }
      
      protected function handleRightClick(param1:MouseEvent) : void
      {
         this._rightClicked.dispatch(this._model);
         this._itemBrowserController.itemSetsBehaviorTracker.incrementItemSets_UserRightClicked_Count_InASession();
      }
      
      public function getRightClicked() : ISignal
      {
         return this._rightClicked;
      }
      
      private function handleMouseClick(param1:MouseEvent) : void
      {
         if(this._itemBrowserController)
         {
            this._itemBrowserController.setActiveItem(this._model);
            this._itemBrowserController.itemSetsBehaviorTracker.incrementItemSets_UserLeftClicked_Count_InASession();
         }
      }
      
      override public function setData(param1:*) : void
      {
         this.setModel(param1);
      }
      
      private function handleDoubleClick(param1:MouseEvent) : void
      {
         this._itemBrowserController.itemSetsBehaviorTracker.incrementItemSets_UserDoubleClicked_Count_InASession();
      }
      
      protected function dragBeginHandler(param1:DragBehavior, param2:Boolean, param3:Boolean, param4:Boolean) : void
      {
         var _loc5_:GameItemRenderer = null;
         var _loc6_:Point = null;
         var _loc7_:BitmapData = null;
         var _loc8_:Clipboard = null;
         var _loc9_:NativeDragOptions = null;
         if(this._model != null && this._model.icon != null)
         {
            if(this._model.specialRecipe > 1)
            {
               return;
            }
            _loc5_ = new GameItemRenderer(this,"GameItemRenderer");
            _loc5_.toolTipEnabled = false;
            _loc5_.setMouseEnabled(false);
            _loc5_.setMouseChildren(false);
            _loc5_.setModel(this._model);
            addChild(_loc5_);
            _loc6_ = _loc5_.setExplicitSize(NaN,NaN);
            _loc7_ = new BitmapData(_loc6_.x,_loc6_.y);
            _loc7_.draw(_loc5_.getAsset());
            _loc8_ = new Clipboard();
            _loc8_.setData(GameItem.DATA_FORMAT,this._model);
            _loc9_ = new NativeDragOptions();
            _loc9_.allowCopy = true;
            _loc9_.allowLink = false;
            _loc9_.allowMove = true;
            NativeDragManager.doDrag(getInteractiveAsset(),_loc8_,_loc7_,new Point(-_loc7_.width / 2,-_loc7_.height / 2),_loc9_);
            removeChild(_loc5_);
            _loc5_.destroy();
            this._itemBrowserController.itemSetsBehaviorTracker.incrementItemSets_UserDragAndDropTotal_Count_InASession();
         }
      }
      
      override protected function createChildren() : void
      {
         this._iconSizer = new SpriteProxy(this);
         setTimelineChildByName("iconSizer",this._iconSizer);
         this._backgroundSizer = new SpriteProxy(this);
         setTimelineChildByName("sizer",this._backgroundSizer);
         this._iconContainer = new SpriteProxy(this);
         setTimelineChildByName("itemContainer",this._iconContainer);
         this._selectionBackground = new StatefulView(this);
         setTimelineChildByName("selectionBackground",this._selectionBackground);
         this._selectionBackground.setTransformBehavior(new ScalingTransformBehavior());
         this._iconBitmap = new BitmapProxy(this);
         var _loc1_:ScalingTransformBehavior = new ScalingTransformBehavior();
         _loc1_.setMaintainAspectRatio(true);
         this._iconBitmap.setTransformBehavior(_loc1_);
         this._iconBitmap.setSmoothing(true);
         this._iconContainer.addChild(this._iconBitmap);
         this._nameText = new TextFieldProxy(this);
         setTimelineChildByName("nameText",this._nameText);
         this._costText = new TextFieldProxy(this);
         setTimelineChildByName("costText",this._costText);
         this._iconContainer.getLayoutInvalidated().add(invalidateLayout);
      }
      
      public function setModel(param1:GameItem) : void
      {
         if(this._model != param1)
         {
            if(this._model != null)
            {
               unassignToolTip(this);
            }
            this._model = param1;
            if(this._model != null)
            {
               if(this._model.icon != null)
               {
                  this._iconBitmap.setBitmapData(ImagePackLookup.instance.getBitmapData("e_" + this._model.icon.substring(0,this._model.icon.length - 4)));
               }
               this._nameText.setText(this._model.name);
               if(this._model.specialRecipe > 1)
               {
                  this._costText.setText("*");
               }
               else
               {
                  this._costText.setText(String(this._model.totalPrice));
               }
               if(this.toolTipEnabled)
               {
                  TipsProviderProxy.instance.assignCustomToolTip(this,this._model,ItemBrowserTooltipView,this._customToolTipConfig);
               }
            }
            else
            {
               this._nameText.setText("");
               this._costText.setText("");
               this._iconBitmap.setBitmapData(null);
            }
         }
      }
   }
}

