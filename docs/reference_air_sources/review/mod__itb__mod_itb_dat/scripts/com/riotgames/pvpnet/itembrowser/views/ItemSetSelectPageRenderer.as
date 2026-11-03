package com.riotgames.pvpnet.itembrowser.views
{
   import blix.components.button.LabelButtonX;
   import blix.components.renderer.IDataRenderer;
   import blix.components.renderer.ISelectableRenderer;
   import blix.components.timeline.StatefulView;
   import blix.context.IContext;
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import blix.view.behaviors.ScalingTransformBehavior;
   import com.riotgames.pvpnet.itembrowser.sets.model.ItemSet;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.text.TextFieldAutoSize;
   import mx.resources.ResourceManager;
   
   public class ItemSetSelectPageRenderer extends LabelButtonX implements IDataRenderer, ISelectableRenderer
   {
      
      private var _itemSet:ItemSet;
      
      private var _index:uint;
      
      private var _selectionRequested:Signal = new Signal();
      
      private var _selectionBackground:StatefulView;
      
      private var _mouseDown:Signal = new Signal();
      
      private var _checkBoxBox:StatefulView;
      
      public function ItemSetSelectPageRenderer(param1:IContext)
      {
         super(param1);
         setLinkage("ItemSetSelectPageRenderer");
         setMouseChildren(true);
      }
      
      override protected function updateLayout(param1:Number, param2:Number) : Rectangle
      {
         var _loc3_:Point = textField.setExplicitSize(NaN,NaN);
         textField.setExplicitPosition(NaN,3);
         this._selectionBackground.setExplicitSize(NaN,_loc3_.y + 6);
         this._checkBoxBox.setExplicitPosition(NaN,_loc3_.y / 2 - 7);
         return _asset.getBounds(null);
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         addEventListener(MouseEvent.MOUSE_DOWN,this.handleMouseDown);
         this._selectionBackground = new StatefulView(this);
         setTimelineChildByName("selectionBackground",this._selectionBackground);
         this._selectionBackground.setTransformBehavior(new ScalingTransformBehavior());
         this._checkBoxBox = new StatefulView(this);
         setTimelineChildByName("checkBoxBox",this._checkBoxBox);
         textField.setAutoSize(TextFieldAutoSize.LEFT);
         textField.getLayoutInvalidated().add(invalidateLayout);
         textField.setVerticalScrollEnabled(false);
         textField.setMouseWheelEnabled(false);
         textField.setMouseEnabled(false);
      }
      
      public function getIndex() : uint
      {
         return this._index;
      }
      
      private function updatePageNameDisplay() : void
      {
         var _loc1_:String = this._itemSet.title;
         if(!this._itemSet.getIsGlobalForChampions() && this._itemSet.getAssignedChampions().length > 1)
         {
            _loc1_ += "\n" + ResourceManager.getInstance().getString("itemBrowser","itemSets_champion_association_count",[this._itemSet.getAssignedChampions().length]);
         }
         textField.setText(_loc1_);
      }
      
      override public function setData(param1:*) : void
      {
         this._itemSet = param1;
         this.updatePageNameDisplay();
         super.setData(param1);
      }
      
      private function handleMouseDown(param1:MouseEvent) : void
      {
         this._mouseDown.dispatch(this._itemSet);
         this._selectionRequested.dispatch(this,param1.ctrlKey,param1.shiftKey);
      }
      
      public function getMouseDown() : ISignal
      {
         return this._mouseDown;
      }
      
      override public function setCurrentState(param1:String) : void
      {
         super.setCurrentState(param1);
         this._selectionBackground.setCurrentState(getCurrentState());
         this._checkBoxBox.setCurrentState(getCurrentState());
      }
      
      public function getSelectionRequested() : ISignal
      {
         return this._selectionRequested;
      }
      
      override public function destroy() : void
      {
         removeEventListener(MouseEvent.MOUSE_DOWN,this.handleMouseDown);
         this._mouseDown.removeAll();
         super.destroy();
      }
      
      public function setIndex(param1:uint) : void
      {
         this._index = param1;
      }
   }
}

