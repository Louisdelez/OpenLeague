package com.riotgames.pvpnet.itembrowser.views
{
   import blix.components.button.ButtonX;
   import blix.components.renderer.IItemRenderer;
   import blix.components.text.Text;
   import blix.components.timeline.StatefulView;
   import blix.context.IContext;
   import com.riotgames.gameItems.model.GameItem;
   import com.riotgames.pvpnet.itembrowser.controller.ItemSetsController;
   import com.riotgames.pvpnet.itembrowser.sets.model.ItemSetItem;
   import flash.desktop.NativeDragManager;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.events.NativeDragEvent;
   import mx.resources.ResourceManager;
   
   public class BlankBlockRenderer extends StatefulView implements IItemRenderer
   {
      
      private var addButton:ButtonX;
      
      private var _data:*;
      
      private var clickInstructions:Text;
      
      private var isDraggingInvalidOver:Boolean = false;
      
      private var _index:uint;
      
      private var isDraggingValidOver:Boolean = false;
      
      private var _itemSetsController:ItemSetsController;
      
      private var dragInstructions:Text;
      
      public function BlankBlockRenderer(param1:IContext, param2:MovieClip = null)
      {
         super(param1,param2);
         this._itemSetsController = getDependency(ItemSetsController);
         setLinkage("itemGroupBlankRenderer");
         setMouseEnabled(true);
         setMouseChildren(false);
         setButtonMode(true);
         setUseHandCursor(true);
         addEventListener(MouseEvent.CLICK,this.clickHandler);
      }
      
      private function handleDragDrop(param1:NativeDragEvent) : void
      {
         var _loc2_:GameItem = null;
         var _loc3_:ItemSetItem = null;
         if(param1.clipboard.hasFormat(GameItem.DATA_FORMAT))
         {
            _loc2_ = param1.clipboard.getData(GameItem.DATA_FORMAT) as GameItem;
            if(_loc2_)
            {
               this._itemSetsController.createBlock(_loc2_);
            }
         }
         else if(param1.clipboard.hasFormat(ItemSetItem.DATA_FORMAT))
         {
            _loc3_ = param1.clipboard.getData(ItemSetItem.DATA_FORMAT) as ItemSetItem;
            if(_loc3_)
            {
               this._itemSetsController.createBlockFromItemSetItem(_loc3_);
            }
         }
         this.isDraggingValidOver = false;
         this.isDraggingInvalidOver = false;
         this.refreshState();
      }
      
      public function setIndex(param1:uint) : void
      {
         this._index = param1;
      }
      
      override protected function createChildren() : void
      {
         this.dragInstructions = new Text(this);
         setTimelineChildByName("dragInstructions",this.dragInstructions);
         this.dragInstructions.setText(ResourceManager.getInstance().getString("itemBrowser","dragInstructions"));
         this.clickInstructions = new Text(this);
         setTimelineChildByName("clickInstructions",this.clickInstructions);
         this.clickInstructions.setText(ResourceManager.getInstance().getString("itemBrowser","clickInstructions"));
         addEventListener(NativeDragEvent.NATIVE_DRAG_ENTER,this.handleDragEnter);
         addEventListener(NativeDragEvent.NATIVE_DRAG_EXIT,this.handleDragExit);
         addEventListener(NativeDragEvent.NATIVE_DRAG_DROP,this.handleDragDrop);
      }
      
      public function getData() : *
      {
         return this._data;
      }
      
      override protected function setMouseIsOver(param1:Boolean) : void
      {
         super.setMouseIsOver(param1);
         this.refreshState();
      }
      
      private function clickHandler(param1:MouseEvent) : void
      {
         this._itemSetsController.createBlock(null);
      }
      
      public function getIndex() : uint
      {
         return this._index;
      }
      
      public function setData(param1:*) : void
      {
         this._data = param1;
      }
      
      private function refreshState() : void
      {
         if(this.isDraggingValidOver)
         {
            setCurrentState("dragOver");
         }
         else if(Boolean(_mouseIsOver) && !this.isDraggingInvalidOver)
         {
            setCurrentState("over");
         }
         else
         {
            setCurrentState("up");
         }
      }
      
      private function handleDragExit(param1:NativeDragEvent) : void
      {
         this.isDraggingValidOver = false;
         this.isDraggingInvalidOver = false;
         this.refreshState();
      }
      
      private function handleDragEnter(param1:NativeDragEvent) : void
      {
         if(Boolean(param1.clipboard.hasFormat(GameItem.DATA_FORMAT)) || Boolean(param1.clipboard.hasFormat(ItemSetItem.DATA_FORMAT)))
         {
            NativeDragManager.acceptDragDrop(getInteractiveAsset());
            this.isDraggingValidOver = true;
         }
         else
         {
            this.isDraggingInvalidOver = true;
         }
         this.refreshState();
      }
   }
}

