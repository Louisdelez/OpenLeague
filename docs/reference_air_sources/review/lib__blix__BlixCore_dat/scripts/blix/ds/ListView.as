package blix.ds
{
   import blix.IDestructible;
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import blix.util.array.ArrayUtils;
   import flash.utils.Proxy;
   import flash.utils.flash_proxy;
   
   use namespace flash_proxy;
   
   public class ListView extends Proxy implements IListX, IDestructible
   {
      
      protected var _reset:Signal = new Signal();
      
      protected var _itemsRemoved:Signal = new Signal();
      
      protected var _itemsAdded:Signal = new Signal();
      
      protected var _itemsUpdated:Signal = new Signal();
      
      protected var _list:IListX;
      
      protected var filterCallback:Function;
      
      protected var sortCompareFunction:Function;
      
      protected var sortFieldNames:Object;
      
      protected var sortOptions:Object;
      
      protected var isUpdating:Boolean;
      
      protected var localIndex:Array;
      
      public function ListView(param1:IListX = null)
      {
         super();
         this.setList(param1);
      }
      
      public function getList() : IListX
      {
         return this._list;
      }
      
      public function setList(param1:IListX) : void
      {
         if(this._list != null)
         {
            this.unwatchList();
         }
         this._list = param1 || new ListX();
         this.watchList();
         this.reset();
      }
      
      public function getSource() : Object
      {
         return this._list.getSource();
      }
      
      public function setSource(param1:Object) : void
      {
         this._list.setSource(param1);
      }
      
      protected function watchList() : void
      {
         this._list.getReset().add(this.listResetHandler);
         this._list.getItemsRemoved().add(this.listItemsRemovedHandler);
         this._list.getItemsAdded().add(this.listItemsAddedHandler);
         this._list.getItemsUpdated().add(this.listItemsUpdatedHandler);
      }
      
      protected function unwatchList() : void
      {
         this._list.getReset().remove(this.listResetHandler);
         this._list.getItemsRemoved().remove(this.listItemsRemovedHandler);
         this._list.getItemsAdded().remove(this.listItemsAddedHandler);
         this._list.getItemsUpdated().remove(this.listItemsUpdatedHandler);
      }
      
      protected function listResetHandler(param1:IListX) : void
      {
         if(this.isUpdating)
         {
            return;
         }
         this.reset();
      }
      
      protected function listItemsRemovedHandler(param1:IListX, param2:Array) : void
      {
         if(this.isUpdating)
         {
            return;
         }
         this.removeItemsFromView(param2);
      }
      
      protected function listItemsAddedHandler(param1:IListX, param2:Array) : void
      {
         if(this.isUpdating)
         {
            return;
         }
         this.addItemsToView(param2);
      }
      
      protected function listItemsUpdatedHandler(param1:IListX, param2:Array) : void
      {
         if(this.isUpdating)
         {
            return;
         }
         this.updateItems(param2);
      }
      
      public function filter(param1:Function) : void
      {
         this.filterCallback = param1;
         this.reset();
      }
      
      public function clearFilter() : void
      {
         this.filterCallback = null;
         this.reset();
      }
      
      public function sort(param1:uint) : void
      {
         this.clearInternalSort();
         this.sortOptions = param1;
         this.reset();
      }
      
      public function sortByField(param1:String, param2:uint = 0) : void
      {
         this.clearInternalSort();
         this.sortFieldNames = param1;
         this.sortOptions = param2;
         this.reset();
      }
      
      public function sortByFields(param1:Array, param2:Array = null) : void
      {
         this.clearInternalSort();
         this.sortFieldNames = param1;
         this.sortOptions = param2;
         this.reset();
      }
      
      public function sortWithCompare(param1:Function) : void
      {
         this.clearInternalSort();
         this.sortCompareFunction = param1;
         this.reset();
      }
      
      public function clearSort() : void
      {
         this.clearInternalSort();
         this.reset();
      }
      
      protected function clearInternalSort() : void
      {
         this.sortCompareFunction = null;
         this.sortFieldNames = null;
         this.sortOptions = null;
      }
      
      public function reset() : void
      {
         this.localIndex = this.applyView(this._list.toArray());
         this._reset.dispatch(this);
      }
      
      protected function applyView(param1:Array) : Array
      {
         var _loc2_:Array = null;
         if(param1.length > 1)
         {
            if(this.sortCompareFunction != null)
            {
               _loc2_ = param1.sort(this.sortCompareFunction);
            }
            else if(this.sortFieldNames != null)
            {
               _loc2_ = param1.sortOn(this.sortFieldNames,this.sortOptions);
            }
            else if(this.sortOptions != null)
            {
               _loc2_ = param1.sort(this.sortOptions);
            }
         }
         if(_loc2_ == null)
         {
            _loc2_ = param1.slice();
         }
         if(this.filterCallback != null)
         {
            _loc2_ = _loc2_.filter(this.filterCallback);
         }
         return _loc2_;
      }
      
      protected function addItemsToView(param1:Array) : void
      {
         var _loc5_:Object = null;
         param1 = this.applyView(param1);
         var _loc2_:uint = param1.length;
         var _loc3_:int = 0;
         var _loc4_:uint = 0;
         while(_loc4_ < _loc2_)
         {
            _loc5_ = param1[_loc4_];
            _loc3_ = this.getLocalInsertionIndex(_loc5_,_loc3_);
            this.localIndex.splice(_loc3_,0,_loc5_);
            _loc4_++;
         }
         this._itemsAdded.dispatch(this,param1);
      }
      
      protected function removeItemsFromView(param1:Array) : void
      {
         var _loc5_:Object = null;
         var _loc2_:uint = param1.length;
         var _loc3_:int = 0;
         var _loc4_:uint = 0;
         while(_loc4_ < _loc2_)
         {
            _loc5_ = param1[_loc4_];
            _loc3_ = this.localIndex.indexOf(_loc5_);
            if(_loc3_ != -1)
            {
               this.localIndex.splice(_loc3_,1);
            }
            _loc4_++;
         }
         this._itemsRemoved.dispatch(this,param1);
      }
      
      public function getReset() : ISignal
      {
         return this._reset;
      }
      
      public function getItemsUpdated() : ISignal
      {
         return this._itemsUpdated;
      }
      
      public function getItemsAdded() : ISignal
      {
         return this._itemsAdded;
      }
      
      public function getItemsRemoved() : ISignal
      {
         return this._itemsRemoved;
      }
      
      public function addItem(param1:Object) : void
      {
         this.addItemAt(param1,this.localIndex.length);
      }
      
      public function addItemAt(param1:Object, param2:int) : void
      {
         var _loc3_:int = 0;
         if(param2 >= this.localIndex.length)
         {
            _loc3_ = int(this._list.getLength());
         }
         else if(this.filterCallback != null || this.sortCompareFunction != null || this.sortFieldNames != null || this.sortOptions != null)
         {
            _loc3_ = this._list.getItemIndex(this.localIndex[param2]);
         }
         else
         {
            _loc3_ = param2;
         }
         this._list.addItemAt(param1,_loc3_);
      }
      
      protected function getLocalInsertionIndex(param1:Object, param2:int = 0, param3:int = -1) : int
      {
         var _loc4_:int = 0;
         var _loc5_:uint = 0;
         var _loc6_:Object = null;
         var _loc7_:Object = null;
         if(this.sortCompareFunction != null)
         {
            return ArrayUtils.findInsertionIndexWithCompare(this.localIndex,param1,this.sortCompareFunction,this.sortOptions as uint,param2,param3);
         }
         if(this.sortFieldNames != null)
         {
            if(this.sortFieldNames is Array)
            {
               return ArrayUtils.findInsertionIndexWithFields(this.localIndex,param1,this.sortFieldNames as Array,this.sortOptions as Array,param2,param3);
            }
            return ArrayUtils.findInsertionIndexWithField(this.localIndex,param1,this.sortFieldNames as String,this.sortOptions as uint,param2,param3);
         }
         if(this.sortOptions != null)
         {
            return ArrayUtils.findInsertionIndex(this.localIndex,param1,this.sortOptions as uint,param2,param3);
         }
         _loc4_ = this._list.getItemIndex(param1,param2);
         if(_loc4_ == -1)
         {
            return this.localIndex.length;
         }
         _loc5_ = this._list.getLength();
         _loc6_ = this._list.getSource();
         while(_loc4_ < _loc5_ - 1)
         {
            _loc7_ = this._list.getItemAt(_loc4_ + 1);
            if(this.filterCallback == null || Boolean(this.filterCallback(_loc7_,_loc4_ + 1,_loc6_)))
            {
               return this.localIndex.indexOf(_loc7_);
            }
            _loc4_++;
         }
         return this.localIndex.length;
      }
      
      public function setItemAt(param1:Object, param2:int) : void
      {
         var _loc3_:Object = this.localIndex[param2];
         if(_loc3_ != null && this._itemsRemoved.getHasListeners())
         {
            this._itemsRemoved.dispatch(this,[_loc3_]);
         }
         if(this.filterCallback == null || this.sortCompareFunction != null || this.sortFieldNames != null || this.sortOptions != null)
         {
            this.isUpdating = true;
            this._list.setItemAt(param1,param2);
            this.localIndex[param2] = param1;
            this.isUpdating = false;
         }
         else
         {
            this.removeItemAt(param2);
            this.addItemAt(param1,param2);
         }
         if(param1 != null && this._itemsAdded.getHasListeners())
         {
            this._itemsAdded.dispatch(this,[param1]);
         }
         this.isUpdating = false;
      }
      
      public function getItemAt(param1:int) : Object
      {
         return this.localIndex[param1];
      }
      
      public function getItemIndex(param1:Object, param2:int = 0) : int
      {
         if(this.filterCallback != null && !this.filterCallback(param1,-1,this._list.getSource()))
         {
            return -1;
         }
         return this.localIndex.indexOf(param1,param2);
      }
      
      public function removeItem(param1:Object) : Boolean
      {
         return this._list.removeItem(param1);
      }
      
      public function removeItemAt(param1:int) : Object
      {
         this.isUpdating = true;
         var _loc2_:Object = this.localIndex[param1];
         this.localIndex.splice(param1,1);
         this._list.removeItem(_loc2_);
         this.isUpdating = false;
         return _loc2_;
      }
      
      public function removeAll() : void
      {
         this._list.removeAll();
      }
      
      public function updateItems(param1:Array) : void
      {
         this.removeItemsFromView(param1);
         this.addItemsToView(param1);
         this._itemsUpdated.dispatch(this,param1);
      }
      
      public function getLength() : uint
      {
         return this.localIndex.length;
      }
      
      public function setLength(param1:uint) : void
      {
         var _loc3_:Object = null;
         this.isUpdating = true;
         var _loc2_:Array = this.localIndex.splice(param1,this.localIndex.length - param1);
         for each(_loc3_ in _loc2_)
         {
            this._list.removeItem(_loc3_);
         }
         this._itemsRemoved.dispatch(this,_loc2_);
         this.isUpdating = false;
      }
      
      public function getIterator(param1:int = -1) : IIterator
      {
         return new Iterator(this,param1);
      }
      
      public function toArray() : Array
      {
         return this.localIndex.slice();
      }
      
      override flash_proxy function hasProperty(param1:*) : Boolean
      {
         return param1 in this.localIndex;
      }
      
      override flash_proxy function deleteProperty(param1:*) : Boolean
      {
         if(param1 in this.localIndex)
         {
            this.setItemAt(null,param1);
            return true;
         }
         return false;
      }
      
      override flash_proxy function callProperty(param1:*, ... rest) : *
      {
         return this.localIndex[param1].apply(null,rest);
      }
      
      override flash_proxy function getProperty(param1:*) : *
      {
         return this.localIndex[param1];
      }
      
      override flash_proxy function setProperty(param1:*, param2:*) : void
      {
         this.setItemAt(param2,param1);
      }
      
      override flash_proxy function nextNameIndex(param1:int) : int
      {
         if(param1 >= this.localIndex.length)
         {
            return 0;
         }
         return param1 + 1;
      }
      
      override flash_proxy function nextName(param1:int) : String
      {
         return String(param1 - 1);
      }
      
      override flash_proxy function nextValue(param1:int) : *
      {
         return this.localIndex[param1 - 1];
      }
      
      public function destroy() : void
      {
         this.unwatchList();
         this._reset.removeAll();
         this._itemsRemoved.removeAll();
         this._itemsAdded.removeAll();
         this._itemsUpdated.removeAll();
         this._list = null;
         this.localIndex = null;
      }
      
      public function toString() : String
      {
         return "[ListView " + String(this.localIndex) + "]";
      }
   }
}

