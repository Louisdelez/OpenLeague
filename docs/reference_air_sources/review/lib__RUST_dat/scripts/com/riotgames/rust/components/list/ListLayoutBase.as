package com.riotgames.rust.components.list
{
   import blix.components.renderer.IDataRenderer;
   import blix.signals.ISignal;
   import blix.signals.Signal;
   
   public class ListLayoutBase
   {
      
      protected var _allowMultiSelection:Boolean = true;
      
      protected var view:ListViewBehavior;
      
      protected var _data:Array;
      
      protected var selectionChanged:Signal;
      
      protected var activeItems:Array = [];
      
      protected var selectedIndexes:Array = [];
      
      protected var lastSelectionAnchor:int = -1;
      
      public function ListLayoutBase(param1:ListViewBehavior, param2:Signal = null)
      {
         super();
         this.view = param1;
         this.view.viewReady.add(this.resetLayout);
         this.view.render.add(this.doLayout);
         this.selectionChanged = param2 || new Signal();
      }
      
      public function get allowMultiSelection() : Boolean
      {
         return this._allowMultiSelection;
      }
      
      public function set allowMultiSelection(param1:Boolean) : void
      {
         this._allowMultiSelection = param1;
      }
      
      public function doLayout() : void
      {
      }
      
      public function set data(param1:Array) : void
      {
         this._data = param1;
         this.selectedIndexes = [];
         this.lastSelectionAnchor = -1;
         this.resetLayout();
      }
      
      public function get data() : Array
      {
         return this._data;
      }
      
      public function resetLayout() : void
      {
         var _loc1_:IDataRenderer = null;
         for each(_loc1_ in this.activeItems)
         {
            this.view.removeItem(_loc1_);
         }
         this.activeItems = [];
         this.view.invalidateRender();
      }
      
      protected function addItem(param1:int, param2:Number) : IDataRenderer
      {
         var _loc4_:IListSelectable = null;
         var _loc3_:IDataRenderer = this.view.getItem(this.data[param1]);
         this.activeItems[param1] = _loc3_;
         this.view.addItem(_loc3_,param2);
         if(_loc3_ is IListSelectable)
         {
            _loc4_ = _loc3_ as IListSelectable;
            _loc4_.selectSignal.add(this.onSelectItem);
            _loc4_.toggleSelectSignal.add(this.onToggleSelectItem);
            _loc4_.selectToSignal.add(this.onSelectToItem);
            if(this.selectedIndexes[param1] != null)
            {
               _loc4_.setSelected(true);
            }
            else
            {
               _loc4_.setSelected(false);
            }
         }
         return _loc3_;
      }
      
      protected function removeItem(param1:int) : void
      {
         var _loc3_:IListSelectable = null;
         var _loc2_:IDataRenderer = this.activeItems[param1];
         if(Boolean(_loc2_))
         {
            this.view.removeItem(_loc2_);
            delete this.activeItems[param1];
            if(_loc2_ is IListSelectable)
            {
               _loc3_ = _loc2_ as IListSelectable;
               _loc3_.selectSignal.remove(this.onSelectItem);
               _loc3_.toggleSelectSignal.remove(this.onToggleSelectItem);
               _loc3_.selectToSignal.remove(this.onSelectToItem);
            }
         }
      }
      
      public function getSelectionChanged() : ISignal
      {
         return this.selectionChanged;
      }
      
      protected function onSelectItem(param1:IListSelectable) : void
      {
         this.setSelectedIndex(this.getIndexForItem(param1));
         this.selectionChanged.dispatch(this);
      }
      
      protected function onToggleSelectItem(param1:IListSelectable) : void
      {
         var _loc2_:int = 0;
         if(this.allowMultiSelection)
         {
            _loc2_ = this.getIndexForItem(param1);
            if(this.selectedIndexes[_loc2_] != null)
            {
               delete this.selectedIndexes[_loc2_];
               param1.setSelected(false);
            }
            else
            {
               this.selectedIndexes[_loc2_] = _loc2_;
               param1.setSelected(true);
            }
            this.lastSelectionAnchor = _loc2_;
         }
         else
         {
            this.onSelectItem(param1);
         }
         this.selectionChanged.dispatch(this);
      }
      
      protected function onSelectToItem(param1:IListSelectable) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         if(this.allowMultiSelection && this.lastSelectionAnchor >= 0)
         {
            _loc2_ = this.getIndexForItem(param1);
            _loc3_ = Math.min(this.lastSelectionAnchor,_loc2_);
            _loc4_ = Math.max(this.lastSelectionAnchor,_loc2_);
            _loc5_ = _loc3_;
            while(_loc5_ <= _loc4_)
            {
               this.selectedIndexes[_loc5_] = _loc5_;
               param1 = this.activeItems[_loc5_] as IListSelectable;
               if(Boolean(param1))
               {
                  param1.setSelected(true);
               }
               _loc5_++;
            }
            this.lastSelectionAnchor = _loc2_;
         }
         else
         {
            this.onSelectItem(param1);
         }
         this.selectionChanged.dispatch(this);
      }
      
      public function setSelectedIndex(param1:int) : void
      {
         var _loc2_:IListSelectable = null;
         var _loc3_:int = 0;
         for each(_loc3_ in this.selectedIndexes)
         {
            _loc2_ = this.activeItems[_loc3_] as IListSelectable;
            if(Boolean(_loc2_))
            {
               _loc2_.setSelected(false);
            }
         }
         this.selectedIndexes = [];
         this.selectedIndexes[param1] = param1;
         _loc2_ = this.activeItems[param1] as IListSelectable;
         if(Boolean(_loc2_))
         {
            _loc2_.setSelected(true);
         }
         this.lastSelectionAnchor = param1;
      }
      
      public function getSelectedIndex() : int
      {
         var _loc1_:int = 0;
         if(this.selectedIndexes[this.lastSelectionAnchor] != null)
         {
            return this.lastSelectionAnchor;
         }
         var _loc2_:int = 0;
         var _loc3_:* = this.selectedIndexes;
         for each(_loc1_ in _loc3_)
         {
            return _loc1_;
         }
         return -1;
      }
      
      public function setSelectedIndexes(param1:Array) : void
      {
         var _loc2_:IListSelectable = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         for each(_loc3_ in this.selectedIndexes)
         {
            _loc2_ = this.activeItems[_loc3_] as IListSelectable;
            if(Boolean(_loc2_))
            {
               _loc2_.setSelected(false);
            }
         }
         this.selectedIndexes = [];
         for each(_loc4_ in param1)
         {
            this.selectedIndexes[_loc4_] = _loc4_;
            _loc2_ = this.activeItems[_loc3_] as IListSelectable;
            if(Boolean(_loc2_))
            {
               _loc2_.setSelected(true);
            }
         }
      }
      
      public function getSelectedIndexes() : Array
      {
         var _loc2_:int = 0;
         var _loc1_:Array = [];
         for each(_loc2_ in this.selectedIndexes)
         {
            _loc1_.push(_loc2_);
         }
         return _loc1_;
      }
      
      protected function getIndexForItem(param1:Object) : int
      {
         var _loc2_:* = undefined;
         for(_loc2_ in this.activeItems)
         {
            if(this.activeItems[_loc2_] == param1)
            {
               return _loc2_;
            }
         }
         return -1;
      }
      
      protected function get layoutHelper() : IListLayoutHelper
      {
         return this.view.layoutHelper;
      }
   }
}

