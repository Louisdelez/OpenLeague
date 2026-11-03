package com.riotgames.pvpnet.itembrowser.views
{
   import blix.assets.proxy.TextFieldProxy;
   import blix.components.timeline.StatefulView;
   import blix.context.IContext;
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import com.riotgames.gameItems.model.GameItem;
   import com.riotgames.pvpnet.itembrowser.controller.ItemBrowserController;
   import com.riotgames.pvpnet.itembrowser.controller.ItemSetsController;
   import com.riotgames.pvpnet.itembrowser.sets.model.ItemSet;
   import com.riotgames.pvpnet.itembrowser.sets.model.ItemSetChampion;
   import com.riotgames.pvpnet.itembrowser.sets.model.ItemSetItem;
   import com.riotgames.pvpnet.itembrowser.sets.model.ItemSetsModel;
   import com.riotgames.rust.drag.DragBehavior;
   import flash.desktop.Clipboard;
   import flash.desktop.NativeDragManager;
   import flash.desktop.NativeDragOptions;
   import flash.display.BitmapData;
   import flash.events.MouseEvent;
   import flash.events.NativeDragEvent;
   import flash.geom.Point;
   
   public class ItemSetBuildItemRenderer extends GameItemRenderer
   {
      
      private static const WARNING_STATE_NONE:String = "noBorder";
      
      private static const WARNING_STATE_YELLOW:String = "yellowBorder";
      
      private static const WARNING_STATE_RED:String = "redBorder";
      
      private var _itemSetItem:ItemSetItem;
      
      private var _itemSetsModel:ItemSetsModel;
      
      private var _stackIndicator:StatefulView;
      
      private var _stackIndicatorText:TextFieldProxy;
      
      private var _itemBrowserController:ItemBrowserController;
      
      private var _itemSetsController:ItemSetsController;
      
      private var _warningBorder:StatefulView;
      
      private var _activeItemSet:ItemSet;
      
      private var _handlingStackableDragEventChanged:Signal = new Signal();
      
      private var _handlingStackableEvent:Boolean = false;
      
      public function ItemSetBuildItemRenderer(param1:IContext)
      {
         super(param1,"ItemSetBuildItemRenderer");
         this._itemSetsController = getDependency(ItemSetsController);
         this._itemBrowserController = getDependency(ItemBrowserController);
      }
      
      public function setItemSetItem(param1:ItemSetItem) : void
      {
         super.setModel(param1.getGameItem());
         this.removeItemSetItemListeners();
         this._itemSetItem = param1;
         this.addItemSetItemListeners();
         this.updateStackText();
         this.updateWarningState();
      }
      
      private function removeActiveItemSetListeners() : void
      {
         if(this._activeItemSet)
         {
            this._activeItemSet.getAssignedChampionsChanged().remove(this.updateWarningState);
            this._activeItemSet.getAssignedMapsChanged().remove(this.updateWarningState);
            this._activeItemSet.getIsGlobalForChampionsChanged().remove(this.updateWarningState);
            this._activeItemSet.getIsGlobalForMapsChanged().remove(this.updateWarningState);
         }
      }
      
      override public function setData(param1:*) : void
      {
         this.setItemSetItem(param1 as ItemSetItem);
      }
      
      private function updateStackText() : void
      {
         if(this._itemSetItem.getStacks() > 1)
         {
            this._stackIndicator.setVisible(true);
            this._stackIndicatorText.setText(String(this._itemSetItem.getStacks()));
         }
         else
         {
            this._stackIndicator.setVisible(false);
            this._stackIndicatorText.setText("");
         }
      }
      
      private function removeItemSetItemListeners() : void
      {
         if(this._itemSetItem)
         {
            this._itemSetItem.getStacksChanged().remove(this.updateStackText);
         }
      }
      
      override public function destroy() : void
      {
         this._handlingStackableDragEventChanged.dispatch(false);
         this._handlingStackableDragEventChanged.removeAll();
         this.removeItemSetsModelListeners();
         this.removeActiveItemSetListeners();
         this.removeItemSetItemListeners();
         super.destroy();
      }
      
      public function setItemSetsModel(param1:ItemSetsModel) : void
      {
         if(this._itemSetsModel != param1)
         {
            this.removeItemSetsModelListeners();
            this._itemSetsModel = param1;
            this.handleActiveItemSetChanged();
            this.addItemSetsModelListeners();
         }
      }
      
      private function handleDragDrop(param1:NativeDragEvent) : void
      {
         var _loc2_:ItemSetItem = null;
         if(this._handlingStackableEvent)
         {
            if(param1.clipboard.hasFormat(GameItem.DATA_FORMAT))
            {
               this._itemSetsController.changeItemStackCount(this._itemSetItem,1);
            }
            else if(param1.clipboard.hasFormat(ItemSetItem.DATA_FORMAT))
            {
               _loc2_ = param1.clipboard.getData(ItemSetItem.DATA_FORMAT) as ItemSetItem;
               this._itemSetsController.changeItemStackCount(this._itemSetItem,_loc2_.getStacks());
            }
            this._handlingStackableEvent = false;
         }
         setCurrentState("normal");
      }
      
      private function updateWarningState() : void
      {
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         if(!this._activeItemSet || !_model)
         {
            return;
         }
         var _loc1_:Boolean = false;
         var _loc2_:Boolean = false;
         var _loc3_:Boolean = false;
         var _loc4_:Boolean = false;
         if(!this._activeItemSet.getIsGlobalForMaps())
         {
            _loc6_ = 0;
            for each(_loc7_ in _model.restrictedMapIDs)
            {
               if(this._activeItemSet.getAssignedMaps().indexOf(_loc7_) != -1)
               {
                  _loc2_ = true;
                  _loc6_++;
               }
            }
            _loc8_ = int(this._activeItemSet.getAssignedMaps().length);
            if(_loc8_ > 0 && _loc8_ == _loc6_)
            {
               _loc1_ = true;
            }
         }
         else
         {
            _loc2_ = _model.restrictedMapIDs.length > 0;
         }
         var _loc5_:ItemSetChampion = _model.requiredChampion ? this._itemSetsModel.skinNameToChampionDictionary[_model.requiredChampion] : null;
         if(!this._activeItemSet.getIsGlobalForChampions())
         {
            if(_loc5_)
            {
               if(this._activeItemSet.getAssignedChampions().indexOf(_loc5_.getChampionID()) == -1)
               {
                  _loc3_ = true;
               }
               else if(this._activeItemSet.getAssignedChampions().length > 1)
               {
                  _loc4_ = true;
               }
            }
         }
         else if(_loc5_)
         {
            _loc4_ = true;
         }
         if(_loc1_ || _loc3_)
         {
            this._warningBorder.setCurrentState(WARNING_STATE_RED);
         }
         else if(_loc2_ || _loc4_)
         {
            this._warningBorder.setCurrentState(WARNING_STATE_YELLOW);
         }
         else
         {
            this._warningBorder.setCurrentState(WARNING_STATE_NONE);
         }
      }
      
      private function addActiveItemSetListeners() : void
      {
         if(this._activeItemSet)
         {
            this._activeItemSet.getAssignedChampionsChanged().add(this.updateWarningState);
            this._activeItemSet.getAssignedMapsChanged().add(this.updateWarningState);
            this._activeItemSet.getIsGlobalForChampionsChanged().add(this.updateWarningState);
            this._activeItemSet.getIsGlobalForMapsChanged().add(this.updateWarningState);
         }
      }
      
      private function handleActiveItemSetChanged() : void
      {
         if(this._activeItemSet != this._itemSetsModel.getActiveItemSet())
         {
            this.removeActiveItemSetListeners();
            this._activeItemSet = this._itemSetsModel.getActiveItemSet();
            this.updateWarningState();
            this.addActiveItemSetListeners();
         }
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this._warningBorder = new StatefulView(this);
         setTimelineChildByName("warningBorder",this._warningBorder);
         this._warningBorder.setCurrentState(WARNING_STATE_NONE);
         this._stackIndicator = new StatefulView(this);
         setTimelineChildByName("itemStackIndicator",this._stackIndicator);
         this._stackIndicator.setCurrentState("normal");
         this._stackIndicator.setVisible(false);
         this._stackIndicatorText = new TextFieldProxy(this);
         this._stackIndicator.setTimelineChildByName("textField",this._stackIndicatorText);
         this._stackIndicatorText.setText("");
         addEventListener(NativeDragEvent.NATIVE_DRAG_ENTER,this.handleDragEnterOrOver);
         addEventListener(NativeDragEvent.NATIVE_DRAG_EXIT,this.handleDragExit);
         addEventListener(NativeDragEvent.NATIVE_DRAG_DROP,this.handleDragDrop);
         addEventListener(NativeDragEvent.NATIVE_DRAG_OVER,this.handleDragEnterOrOver);
         setCurrentState("normal");
      }
      
      private function testIfThisCanStackWithItem(param1:GameItem) : Boolean
      {
         if(this._itemSetItem.getStacks() == this._itemSetItem.getGameItem().stacks)
         {
            return false;
         }
         if(this._itemSetItem.getGameItem().id != param1.id)
         {
            return false;
         }
         return true;
      }
      
      override public function getData() : *
      {
         return this._itemSetItem;
      }
      
      override protected function dragBeginHandler(param1:DragBehavior, param2:Boolean, param3:Boolean, param4:Boolean) : void
      {
         var _loc5_:GameItemRenderer = null;
         var _loc6_:Point = null;
         var _loc7_:BitmapData = null;
         var _loc8_:Clipboard = null;
         var _loc9_:NativeDragOptions = null;
         if(Boolean(this._itemSetItem) && Boolean(this._itemSetItem.getGameItem()) && Boolean(this._itemSetItem.getGameItem().icon))
         {
            if(_model.specialRecipe > 1)
            {
               return;
            }
            _loc5_ = new GameItemRenderer(this,"GameItemRenderer");
            _loc5_.toolTipEnabled = false;
            _loc5_.setMouseEnabled(false);
            _loc5_.setMouseChildren(false);
            _loc5_.setModel(_model);
            addChild(_loc5_);
            _loc6_ = _loc5_.setExplicitSize(NaN,NaN);
            _loc7_ = new BitmapData(_loc6_.x,_loc6_.y);
            _loc7_.draw(_loc5_.getAsset());
            _loc8_ = new Clipboard();
            _loc8_.setData(ItemSetItem.DATA_FORMAT,this._itemSetItem);
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
      
      override protected function handleRightClick(param1:MouseEvent) : void
      {
         _rightClicked.dispatch(this._itemSetItem);
         this._itemBrowserController.itemSetsBehaviorTracker.incrementItemSets_UserRightClicked_Count_InASession();
      }
      
      private function removeItemSetsModelListeners() : void
      {
         if(this._itemSetsModel)
         {
            this._itemSetsModel.getActiveItemSetChanged().remove(this.handleActiveItemSetChanged);
         }
      }
      
      private function addItemSetItemListeners() : void
      {
         if(this._itemSetItem)
         {
            this._itemSetItem.getStacksChanged().add(this.updateStackText);
         }
      }
      
      private function handleDragEnterOrOver(param1:NativeDragEvent) : void
      {
         var _loc3_:ItemSetItem = null;
         var _loc2_:Boolean = false;
         if(param1.clipboard.hasFormat(GameItem.DATA_FORMAT))
         {
            _loc2_ = this.testIfThisCanStackWithItem(param1.clipboard.getData(GameItem.DATA_FORMAT) as GameItem);
         }
         else if(param1.clipboard.hasFormat(ItemSetItem.DATA_FORMAT))
         {
            _loc3_ = param1.clipboard.getData(ItemSetItem.DATA_FORMAT) as ItemSetItem;
            _loc2_ = this.testIfThisCanStackWithItem(_loc3_.getGameItem());
         }
         if(_loc2_)
         {
            this._handlingStackableEvent = true;
            this._handlingStackableDragEventChanged.dispatch(true);
            setCurrentState("canStack");
            NativeDragManager.acceptDragDrop(getInteractiveAsset());
         }
      }
      
      public function getHandlingStackableDragEventChanged() : ISignal
      {
         return this._handlingStackableDragEventChanged;
      }
      
      public function getItemSetItem() : ItemSetItem
      {
         return this._itemSetItem;
      }
      
      private function handleDragExit(param1:NativeDragEvent) : void
      {
         if(this._handlingStackableEvent)
         {
            this._handlingStackableEvent = false;
            this._handlingStackableDragEventChanged.dispatch(false);
         }
         setCurrentState("normal");
      }
      
      private function addItemSetsModelListeners() : void
      {
         if(this._itemSetsModel)
         {
            this._itemSetsModel.getActiveItemSetChanged().add(this.handleActiveItemSetChanged);
         }
      }
   }
}

