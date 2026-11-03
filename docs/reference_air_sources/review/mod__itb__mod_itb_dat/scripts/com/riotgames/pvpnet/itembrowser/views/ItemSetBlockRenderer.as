package com.riotgames.pvpnet.itembrowser.views
{
   import blix.assets.proxy.DisplayObjectProxy;
   import blix.assets.proxy.IDisplayChild;
   import blix.assets.proxy.IDisplayContainer;
   import blix.assets.proxy.SpriteProxy;
   import blix.components.button.ButtonX;
   import blix.components.renderer.IItemRenderer;
   import blix.components.timeline.StatefulView;
   import blix.context.IContext;
   import blix.layout.LayoutContainer;
   import blix.layout.algorithms.FlowLayout;
   import blix.layout.data.SizeLayoutData;
   import blix.layout.vo.Padding;
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import blix.view.behaviors.ScalingTransformBehavior;
   import com.riotgames.gameItems.model.GameItem;
   import com.riotgames.pvpnet.itembrowser.controller.ItemSetsController;
   import com.riotgames.pvpnet.itembrowser.sets.model.ItemSetBlock;
   import com.riotgames.pvpnet.itembrowser.sets.model.ItemSetItem;
   import com.riotgames.pvpnet.itembrowser.sets.model.ItemSetsModel;
   import com.riotgames.rust.drag.DragBehavior;
   import flash.desktop.Clipboard;
   import flash.desktop.NativeDragActions;
   import flash.desktop.NativeDragManager;
   import flash.desktop.NativeDragOptions;
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.events.NativeDragEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.Dictionary;
   import flash.utils.setTimeout;
   
   public class ItemSetBlockRenderer extends StatefulView implements IItemRenderer
   {
      
      private static const PADDING:int = 10;
      
      private static const GAP:int = 7;
      
      public static var firstTimeDict:Dictionary = new Dictionary(true);
      
      private var _itemSetsModel:ItemSetsModel;
      
      private var layoutPadding:Padding;
      
      private var _deleteButton:ButtonX;
      
      private var insertionIndicator:SpriteProxy;
      
      private var dragBehavior:DragBehavior;
      
      private var _model:ItemSetBlock;
      
      private var gameItemsValidFlag:Boolean;
      
      private var _titleRenderer:ItemSetBlockTitleRenderer;
      
      private var _layout:LayoutContainer;
      
      private var _background:SpriteProxy;
      
      private var _stackableEventInProgress:Boolean = false;
      
      private var _itemClicked:Signal = new Signal();
      
      private var _itemSetsController:ItemSetsController;
      
      private var _index:uint;
      
      private var _gameItemRenderers:Vector.<ItemSetBuildItemRenderer> = new Vector.<ItemSetBuildItemRenderer>();
      
      private var _titleChanging:Boolean = false;
      
      public function ItemSetBlockRenderer(param1:IContext, param2:MovieClip = null, param3:String = "ItemGroupRenderer")
      {
         super(param1,param2);
         this._itemSetsController = getDependency(ItemSetsController);
         setLinkage(param3);
         this.dragBehavior = new DragBehavior(this);
         this.dragBehavior.getDragBegin().add(this.dragBeginHandler);
      }
      
      override public function destroy() : void
      {
         this._itemClicked.removeAll();
         super.destroy();
      }
      
      private function dragOverHandler(param1:NativeDragEvent = null) : void
      {
         var _loc5_:Point = null;
         var _loc6_:ItemSetBuildItemRenderer = null;
         var _loc7_:Rectangle = null;
         if(this._model == null || this._stackableEventInProgress)
         {
            return;
         }
         var _loc2_:int = this.getInsertionIndex();
         this.insertionIndicator.validate();
         var _loc3_:Rectangle = this.insertionIndicator.getScaledBounds();
         var _loc4_:Number = _loc3_.width / 2;
         if(_loc2_ == 0)
         {
            _loc5_ = this._layout.getExplicitPosition();
            this.insertionIndicator.setExplicitPosition(Math.floor(_loc5_.x + this.layoutPadding.left / 2 - _loc4_) + 1,_loc5_.y + this.layoutPadding.top);
         }
         else
         {
            _loc6_ = this._gameItemRenderers[_loc2_ - 1];
            _loc7_ = _loc6_.getScaledBounds();
            this.insertionIndicator.setExplicitPosition(Math.floor(_loc7_.right + GAP / 2 - _loc4_),_loc7_.top);
         }
      }
      
      private function handleTitleTextEdited() : void
      {
         this._titleChanging = true;
         this._itemSetsController.changeBlockTitle(this._model,this._titleRenderer.getText());
         this._titleChanging = false;
      }
      
      private function handleDragDrop(param1:NativeDragEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:GameItem = null;
         var _loc4_:ItemSetItem = null;
         if(this._stackableEventInProgress)
         {
            this._stackableEventInProgress = false;
            return;
         }
         if(this._model == null)
         {
            return;
         }
         if(param1.clipboard.hasFormat(GameItem.DATA_FORMAT))
         {
            _loc3_ = param1.clipboard.getData(GameItem.DATA_FORMAT) as GameItem;
            if(_loc3_)
            {
               _loc2_ = this.getInsertionIndex();
               this._itemSetsController.addGameItemToBlock(this._model,_loc3_,_loc2_);
               this._itemSetsController.itemSetsBehaviorTracker.incrementItemSets_UserDragAndDropSuccess_Count_InASession();
            }
         }
         else if(param1.clipboard.hasFormat(ItemSetItem.DATA_FORMAT))
         {
            _loc4_ = param1.clipboard.getData(ItemSetItem.DATA_FORMAT) as ItemSetItem;
            if(_loc4_)
            {
               _loc2_ = this.getInsertionIndex();
               this._itemSetsController.addItemSetItemToBlock(this._model,_loc4_,_loc2_);
               this._itemSetsController.itemSetsBehaviorTracker.incrementItemSets_UserDragAndDropSuccess_Count_InASession();
            }
         }
      }
      
      public function setIndex(param1:uint) : void
      {
         this._index = param1;
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this._background = new SpriteProxy(this);
         setTimelineChildByName("background",this._background);
         this._background.setTransformBehavior(new ScalingTransformBehavior());
         this._deleteButton = new ButtonX(this);
         setTimelineChildByName("closeButton",this._deleteButton);
         this._deleteButton.addEventListener(MouseEvent.CLICK,this.deleteClickedHandler);
         this._titleRenderer = new ItemSetBlockTitleRenderer(this);
         setTimelineChildByName("itemBlockTitle",this._titleRenderer);
         this._titleRenderer.getTextChanged().add(this.handleTitleTextEdited);
         this._titleRenderer.getIsEditingChanged().add(this.handleTitleEditingChanged);
         this._layout = new LayoutContainer(this);
         var _loc1_:FlowLayout = new FlowLayout();
         _loc1_.setHorizontalGap(GAP);
         _loc1_.setVerticalGap(GAP);
         this.layoutPadding = new Padding();
         this.layoutPadding.bottom = 0;
         this.layoutPadding.top = 0;
         this.layoutPadding.left = 23;
         _loc1_.setPadding(this.layoutPadding);
         this._layout.setLayoutAlgorithm(_loc1_);
         this._layout.getLayoutInvalidated().add(invalidateLayout);
         this.insertionIndicator = new SpriteProxy(this);
         this.insertionIndicator.setLinkage("InsertionIndicator");
         this.insertionIndicator.setVisible(false);
         this.insertionIndicator.setWeight(1);
         addChild(this.insertionIndicator);
         addEventListener(NativeDragEvent.NATIVE_DRAG_ENTER,this.handleDragEnter);
         addEventListener(NativeDragEvent.NATIVE_DRAG_EXIT,this.handleDragExit);
         addEventListener(NativeDragEvent.NATIVE_DRAG_DROP,this.handleDragDrop);
      }
      
      private function handleBlockTitleChanged() : void
      {
         if(Boolean(this._model) && !this._titleChanging)
         {
            this._titleRenderer.setText(this._model.getDisplayName());
         }
      }
      
      private function handleStackableEventInProgressChanged(param1:Boolean) : void
      {
         this._stackableEventInProgress = param1;
         if(this._stackableEventInProgress)
         {
            this.insertionIndicator.setVisible(false);
         }
      }
      
      public function getIndex() : uint
      {
         return this._index;
      }
      
      public function getData() : *
      {
         return this._model;
      }
      
      private function gameItemDragStartHandler(param1:NativeDragEvent) : void
      {
         if(this._model == null)
         {
            return;
         }
         var _loc2_:ItemSetItem = param1.clipboard.getData(ItemSetItem.DATA_FORMAT) as ItemSetItem;
         if(param1.shiftKey)
         {
            param1.dropAction = NativeDragActions.COPY;
         }
         else
         {
            param1.dropAction = NativeDragActions.MOVE;
            if(_loc2_ != null)
            {
               this._itemSetsController.removeItemFromBlock(this._model,_loc2_);
            }
         }
      }
      
      private function handleTitleEditingChanged() : void
      {
         this.dragBehavior.setEnabled(!this._titleRenderer.getIsEditing());
      }
      
      private function deleteClickedHandler(param1:MouseEvent) : void
      {
         this._itemSetsController.deleteBlock(this._model);
      }
      
      private function dragBeginHandler() : void
      {
         if(NativeDragManager.isDragging)
         {
            return;
         }
         var _loc1_:Point = this._titleRenderer.setExplicitSize(NaN,NaN);
         var _loc2_:BitmapData = new BitmapData(_loc1_.x,_loc1_.y);
         _loc2_.draw(this._titleRenderer.getAsset());
         var _loc3_:Clipboard = new Clipboard();
         _loc3_.setData(ItemSetBlock.DATA_FORMAT,this._model);
         var _loc4_:NativeDragOptions = new NativeDragOptions();
         _loc4_.allowCopy = false;
         _loc4_.allowLink = false;
         _loc4_.allowMove = true;
         NativeDragManager.doDrag(getInteractiveAsset(),_loc3_,_loc2_,new Point(0,0),_loc4_);
      }
      
      public function setData(param1:*) : void
      {
         this.setModel(param1);
         if(Boolean(param1) && !(param1 in firstTimeDict))
         {
            firstTimeDict[param1] = true;
         }
      }
      
      private function handleDragEnter(param1:NativeDragEvent) : void
      {
         if(this._model == null || this._model.items.length >= ItemSetBlock.MAX_ITEMS || this._stackableEventInProgress)
         {
            return;
         }
         if(Boolean(param1.clipboard.hasFormat(ItemSetItem.DATA_FORMAT)) || Boolean(param1.clipboard.hasFormat(GameItem.DATA_FORMAT)))
         {
            if(param1.shiftKey)
            {
               param1.dropAction = NativeDragActions.COPY;
            }
            else
            {
               param1.dropAction = NativeDragActions.MOVE;
            }
            NativeDragManager.acceptDragDrop(getInteractiveAsset());
            addEventListener(NativeDragEvent.NATIVE_DRAG_OVER,this.dragOverHandler);
            this.insertionIndicator.setVisible(true);
            this.dragOverHandler();
         }
      }
      
      private function handleDragExit(param1:NativeDragEvent) : void
      {
         if(Boolean(param1.clipboard.hasFormat(GameItem.DATA_FORMAT)) || Boolean(param1.clipboard.hasFormat(ItemSetItem.DATA_FORMAT)))
         {
            this.insertionIndicator.setVisible(false);
            removeEventListener(NativeDragEvent.NATIVE_DRAG_OVER,this.dragOverHandler);
         }
      }
      
      private function gameItemDragComplete(param1:NativeDragEvent) : void
      {
         this._stackableEventInProgress = false;
      }
      
      private function getInsertionIndex() : int
      {
         var _loc4_:ItemSetBuildItemRenderer = null;
         var _loc5_:Rectangle = null;
         var _loc1_:int = 0;
         var _loc2_:Number = Number(getMouseX());
         var _loc3_:Number = Number(getMouseY());
         for each(_loc4_ in this._gameItemRenderers)
         {
            _loc5_ = _loc4_.getScaledBounds();
            if(_loc3_ < _loc5_.top || _loc3_ <= _loc5_.bottom && _loc2_ <= _loc5_.right - _loc5_.width / 2)
            {
               break;
            }
            _loc1_++;
         }
         return _loc1_;
      }
      
      override protected function updateLayout(param1:Number, param2:Number) : Rectangle
      {
         var _loc6_:IDisplayContainer = null;
         var _loc7_:Boolean = false;
         var _loc3_:Point = this._layout.setExplicitSize(this._background.getWidth(),NaN);
         if(firstTimeDict[this.getData()])
         {
            _loc6_ = getParentDisplayContainer();
            _loc7_ = true;
            while(_loc6_ != null)
            {
               if(_loc6_ is DisplayObjectProxy)
               {
                  if(DisplayObjectProxy(_loc6_).getVisible() == false)
                  {
                     _loc7_ = false;
                     break;
                  }
               }
               if(_loc6_ is IDisplayChild)
               {
                  _loc6_ = IDisplayChild(_loc6_).getParentDisplayContainer();
               }
               else
               {
                  _loc6_ = null;
               }
            }
            if(_loc7_)
            {
               if(getLinkage() == "ItemGroupRenderer")
               {
                  this._titleRenderer.startEditing();
               }
               firstTimeDict[this.getData()] = false;
            }
         }
         this._titleRenderer.setExplicitSize(NaN,NaN);
         var _loc4_:Number = Number(this._titleRenderer.getScaledBounds().bottom);
         this._layout.setExplicitPosition(0,_loc4_ + PADDING);
         var _loc5_:Point = this._background.setExplicitSize(NaN,Math.max(_loc3_.y,75) + _loc4_ + PADDING * 2);
         return new Rectangle(0,0,_loc5_.x,_loc5_.y);
      }
      
      public function getItemClicked() : ISignal
      {
         return this._itemClicked;
      }
      
      public function checkForFirstTimeTitleEdit() : void
      {
      }
      
      public function setModel(param1:ItemSetBlock) : void
      {
         if(this._model != param1)
         {
            if(this._model)
            {
               this._model.getItemsChanged().remove(this.invalidateGameItems);
               this._model.getBlockTitleChanged().remove(this.handleBlockTitleChanged);
            }
            this._model = param1;
            if(this._model != null)
            {
               this._titleRenderer.setText(this._model.getDisplayName());
               this._model.getItemsChanged().add(this.invalidateGameItems);
               this._model.getBlockTitleChanged().add(this.handleBlockTitleChanged);
            }
            else
            {
               this._titleRenderer.setText("");
            }
            this.invalidateGameItems();
         }
      }
      
      private function handleItemRightClicked(param1:ItemSetItem) : void
      {
         this._itemSetsController.removeItemFromBlock(this._model,param1);
      }
      
      private function showGameItems() : void
      {
         var _loc1_:ItemSetBuildItemRenderer = null;
         var _loc4_:ItemSetItem = null;
         var _loc5_:ItemSetBuildItemRenderer = null;
         if(this.gameItemsValidFlag)
         {
            return;
         }
         this.gameItemsValidFlag = true;
         var _loc2_:Vector.<ItemSetBuildItemRenderer> = this._gameItemRenderers;
         this._layout.removeAllElements();
         this._gameItemRenderers = new Vector.<ItemSetBuildItemRenderer>();
         var _loc3_:SizeLayoutData = new SizeLayoutData();
         _loc3_.setWidthPercent(0.45);
         for each(_loc4_ in this._model.items)
         {
            _loc5_ = null;
            if(_loc2_.length)
            {
               _loc5_ = _loc2_.shift();
            }
            else
            {
               _loc5_ = new ItemSetBuildItemRenderer(this);
               _loc5_.setItemSetsModel(this._itemSetsModel);
               _loc5_.addEventListener(NativeDragEvent.NATIVE_DRAG_START,this.gameItemDragStartHandler);
               _loc5_.addEventListener(NativeDragEvent.NATIVE_DRAG_COMPLETE,this.gameItemDragComplete);
               _loc5_.getHandlingStackableDragEventChanged().add(this.handleStackableEventInProgressChanged);
               _loc5_.getRightClicked().add(this.handleItemRightClicked);
               addChild(_loc5_);
            }
            this._layout.addElement(_loc5_,_loc3_);
            _loc5_.setItemSetItem(_loc4_);
            this._gameItemRenderers[this._gameItemRenderers.length] = _loc5_;
         }
         for each(_loc1_ in _loc2_)
         {
            removeChild(_loc1_);
            _loc1_.destroy();
         }
      }
      
      public function activate(param1:ItemSetsModel) : void
      {
         var _loc2_:ItemSetBuildItemRenderer = null;
         if(this._itemSetsModel != param1)
         {
            this._itemSetsModel = param1;
            for each(_loc2_ in this._gameItemRenderers)
            {
               _loc2_.setItemSetsModel(this._itemSetsModel);
            }
         }
      }
      
      public function deactivate() : void
      {
      }
      
      public function editBlockTitle() : void
      {
         this._titleRenderer.startEditing();
      }
      
      private function invalidateGameItems() : void
      {
         this.gameItemsValidFlag = false;
         setTimeout(this.showGameItems,1);
      }
   }
}

