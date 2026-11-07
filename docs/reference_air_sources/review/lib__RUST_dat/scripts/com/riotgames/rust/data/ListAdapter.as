package com.riotgames.rust.data
{
   import blix.IDestructible;
   import blix.ds.IIterator;
   import blix.ds.IListX;
   import blix.ds.Iterator;
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import flash.utils.Proxy;
   import flash.utils.flash_proxy;
   import mx.collections.ArrayCollection;
   import mx.collections.IList;
   import mx.events.CollectionEvent;
   import mx.events.CollectionEventKind;
   import mx.events.PropertyChangeEvent;
   
   use namespace flash_proxy;
   
   public class ListAdapter extends Proxy implements IListX, IDestructible
   {
      
      private var _reset:Signal = new Signal();
      
      private var _itemsUpdated:Signal = new Signal();
      
      private var _itemsAdded:Signal = new Signal();
      
      private var _itemsRemoved:Signal = new Signal();
      
      private var mxList:IList;
      
      public function ListAdapter(param1:IList = null)
      {
         super();
         this.setList(param1);
      }
      
      public function getList() : IList
      {
         return this.mxList;
      }
      
      public function setList(param1:IList) : void
      {
         if(this.mxList != null)
         {
            this.mxList.removeEventListener(CollectionEvent.COLLECTION_CHANGE,this.collectionChangeHandler);
         }
         this.mxList = param1 || new ArrayCollection();
         this.mxList.addEventListener(CollectionEvent.COLLECTION_CHANGE,this.collectionChangeHandler,false,0,true);
         this._reset.dispatch(this);
      }
      
      protected function collectionChangeHandler(param1:CollectionEvent) : void
      {
         var _loc2_:Array = null;
         var _loc3_:PropertyChangeEvent = null;
         switch(param1.kind)
         {
            case CollectionEventKind.ADD:
               this._itemsAdded.dispatch(this,param1.items);
               break;
            case CollectionEventKind.MOVE:
               this._itemsRemoved.dispatch(this,param1.items);
               this._itemsAdded.dispatch(this,param1.items);
               break;
            case CollectionEventKind.REFRESH:
               this._reset.dispatch(this);
               break;
            case CollectionEventKind.REMOVE:
               this._itemsRemoved.dispatch(this,param1.items);
               break;
            case CollectionEventKind.REPLACE:
               _loc2_ = [];
               for each(_loc3_ in param1.items)
               {
                  this._itemsRemoved.dispatch(this,[_loc3_.oldValue]);
                  this._itemsAdded.dispatch(this,[_loc3_.newValue]);
               }
               break;
            case CollectionEventKind.RESET:
               this._reset.dispatch(this);
               break;
            case CollectionEventKind.UPDATE:
               _loc2_ = [];
               for each(_loc3_ in param1.items)
               {
                  _loc2_[_loc2_.length] = _loc3_.source;
               }
               this._itemsUpdated.dispatch(this,_loc2_);
         }
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
      
      public function getSource() : Object
      {
         if(Object(this.mxList).hasOwnProperty("source"))
         {
            return this.mxList["source"];
         }
         return null;
      }
      
      public function setSource(param1:Object) : void
      {
         if(Object(this.mxList).hasOwnProperty("source"))
         {
            this.mxList["source"] = param1;
            return;
         }
         throw new Error("Cannot set the source on the wrapped mx list.");
      }
      
      public function addItem(param1:Object) : void
      {
         this.mxList.addItem(param1);
      }
      
      public function addItemAt(param1:Object, param2:int) : void
      {
         this.mxList.addItemAt(param1,param2);
      }
      
      public function setItemAt(param1:Object, param2:int) : void
      {
         this.mxList.setItemAt(param1,param2);
      }
      
      public function getItemAt(param1:int) : Object
      {
         return this.mxList.getItemAt(param1);
      }
      
      public function getItemIndex(param1:Object, param2:int = 0) : int
      {
         return this.mxList.getItemIndex(param1);
      }
      
      public function removeItem(param1:Object) : Boolean
      {
         var _loc2_:int = int(this.mxList.getItemIndex(param1));
         if(_loc2_ == -1)
         {
            return false;
         }
         this.mxList.removeItemAt(_loc2_);
         return true;
      }
      
      public function removeItemAt(param1:int) : Object
      {
         return this.mxList.removeItemAt(param1);
      }
      
      public function removeAll() : void
      {
         this.mxList.removeAll();
      }
      
      public function updateItems(param1:Array) : void
      {
         var _loc2_:Object = null;
         for each(_loc2_ in param1)
         {
            this.mxList.itemUpdated(_loc2_);
         }
      }
      
      public function getLength() : uint
      {
         return this.mxList.length;
      }
      
      public function setLength(param1:uint) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         if(param1 == 0)
         {
            this.mxList.removeAll();
         }
         else
         {
            _loc2_ = this.getLength();
            _loc3_ = param1;
            while(_loc3_ < _loc2_)
            {
               this.mxList.removeItemAt(param1);
               _loc3_++;
            }
         }
      }
      
      public function getIterator(param1:int = -1) : IIterator
      {
         return new Iterator(this,param1);
      }
      
      public function toArray() : Array
      {
         return this.mxList.toArray();
      }
      
      override flash_proxy function hasProperty(param1:*) : Boolean
      {
         return param1 < this.mxList.length;
      }
      
      override flash_proxy function deleteProperty(param1:*) : Boolean
      {
         if(param1 < this.mxList.length)
         {
            this.setItemAt(null,param1);
            return true;
         }
         return false;
      }
      
      override flash_proxy function getProperty(param1:*) : *
      {
         return this.mxList.getItemAt(param1);
      }
      
      override flash_proxy function setProperty(param1:*, param2:*) : void
      {
         this.setItemAt(param2,param1);
      }
      
      override flash_proxy function nextNameIndex(param1:int) : int
      {
         if(param1 >= this.mxList.length)
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
         return this.mxList.getItemAt(param1 - 1);
      }
      
      public function destroy() : void
      {
         this.setList(null);
      }
      
      public function toString() : String
      {
         return "[ListAdapter " + String(this.mxList) + "]";
      }
   }
}

