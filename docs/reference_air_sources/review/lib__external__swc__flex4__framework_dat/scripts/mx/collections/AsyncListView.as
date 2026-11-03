package mx.collections
{
   import flash.events.Event;
   import flash.utils.getQualifiedClassName;
   import mx.collections.errors.ItemPendingError;
   import mx.core.mx_internal;
   import mx.events.CollectionEvent;
   import mx.events.CollectionEventKind;
   import mx.events.PropertyChangeEvent;
   import mx.events.PropertyChangeEventKind;
   import mx.utils.OnDemandEventDispatcher;
   
   use namespace mx_internal;
   
   [Event(name="collectionChange",type="mx.events.CollectionEvent")]
   public class AsyncListView extends OnDemandEventDispatcher implements IList
   {
      
      private var _list:IList;
      
      private var oldLength:int = -1;
      
      private var _createPendingItemFunction:Function;
      
      private var _createFailedItemFunction:Function;
      
      private const pendingResponders:Array = new Array();
      
      private const failedItems:Array = new Array();
      
      public function AsyncListView(list:IList = null)
      {
         this._createPendingItemFunction = this.defaultCreatePendingItemFunction;
         this._createFailedItemFunction = this.defaultCreateFailedItemFunction;
         super();
         this.list = list;
      }
      
      [Bindable("listChanged")]
      [Inspectable(category="General")]
      public function get list() : IList
      {
         return this._list;
      }
      
      public function set list(value:IList) : void
      {
         if(this._list == value)
         {
            return;
         }
         this.deleteAllPendingResponders();
         this.oldLength = -1;
         if(Boolean(this._list))
         {
            this._list.removeEventListener(CollectionEvent.COLLECTION_CHANGE,this.handleCollectionChangeEvent);
         }
         this._list = value;
         if(Boolean(this._list))
         {
            this._list.addEventListener(CollectionEvent.COLLECTION_CHANGE,this.handleCollectionChangeEvent,false,0,true);
            this.oldLength = this._list.length;
         }
         dispatchEvent(new Event("listChanged"));
         dispatchEvent(new CollectionEvent(CollectionEvent.COLLECTION_CHANGE,false,false,CollectionEventKind.RESET));
      }
      
      private function deleteAllPendingResponders() : void
      {
         var responder:ListItemResponder = null;
         for each(responder in this.pendingResponders)
         {
            if(Boolean(responder))
            {
               responder.index = -1;
            }
         }
         this.pendingResponders.length = 0;
         this.failedItems.length = 0;
      }
      
      private function isValidCollectionEvent(ce:CollectionEvent) : Boolean
      {
         if(this.oldLength < 0)
         {
            return true;
         }
         var location:int = ce.location;
         switch(ce.kind)
         {
            case CollectionEventKind.ADD:
               if(location < 0 || location > this.oldLength)
               {
                  return false;
               }
               break;
            case CollectionEventKind.REMOVE:
            case CollectionEventKind.REPLACE:
            case CollectionEventKind.MOVE:
               if(location < 0 || location >= this.oldLength)
               {
                  return false;
               }
         }
         this.oldLength = this.length;
         return true;
      }
      
      private function handleCollectionChangeEvent(ce:CollectionEvent) : void
      {
         if(!this.isValidCollectionEvent(ce))
         {
            return;
         }
         switch(ce.kind)
         {
            case CollectionEventKind.REPLACE:
            case CollectionEventKind.UPDATE:
               this.deletePendingResponders(ce);
               break;
            case CollectionEventKind.MOVE:
               this.movePendingResponders(ce);
               break;
            case CollectionEventKind.ADD:
               this.shiftPendingRespondersRight(ce);
               break;
            case CollectionEventKind.REMOVE:
               this.shiftPendingRespondersLeft(ce);
               break;
            case CollectionEventKind.RESET:
            case CollectionEventKind.REFRESH:
               this.deleteAllPendingResponders();
         }
         dispatchEvent(ce);
      }
      
      private function deletePendingResponder(index:int) : Object
      {
         if(index < 0 || index >= this.pendingResponders.length)
         {
            return null;
         }
         var pendingResponder:ListItemResponder = this.pendingResponders[index];
         if(Boolean(pendingResponder))
         {
            delete this.pendingResponders[index];
            ListItemResponder(pendingResponder).index = -1;
            return pendingResponder.item;
         }
         return null;
      }
      
      private function deletePendingResponders(ce:CollectionEvent) : void
      {
         var item:Object = null;
         var index:int = ce.location;
         for each(item in ce.items)
         {
            this.deletePendingResponder(index);
            delete this.failedItems[index];
            index += 1;
         }
      }
      
      private function movePendingResponders(ce:CollectionEvent) : void
      {
         var item:Object = null;
         var pendingResponder:ListItemResponder = null;
         var failedItem:* = undefined;
         var fromIndex:int = ce.oldLocation;
         var toIndex:int = ce.location;
         for each(item in ce.items)
         {
            pendingResponder = this.pendingResponders[fromIndex];
            if(Boolean(pendingResponder))
            {
               delete this.pendingResponders[fromIndex];
               ListItemResponder(pendingResponder).index = toIndex;
               this.deletePendingResponder(toIndex);
               this.pendingResponders[toIndex] = pendingResponder;
            }
            failedItem = this.failedItems[fromIndex];
            if(failedItem !== undefined)
            {
               delete this.failedItems[fromIndex];
               this.failedItems[toIndex] = failedItem;
            }
            fromIndex += 1;
            toIndex += 1;
         }
      }
      
      private function shiftPendingRespondersRight(ce:CollectionEvent) : void
      {
         var responder:ListItemResponder = null;
         var index:int = 0;
         var failedItem:* = undefined;
         var delta:int = int(ce.items.length);
         var startIndex:int = ce.location;
         var pendingRespondersCopy:Array = this.sparseCopy(this.pendingResponders);
         this.pendingResponders.length = 0;
         for each(responder in pendingRespondersCopy)
         {
            if(responder.index >= startIndex)
            {
               responder.index += delta;
            }
            this.pendingResponders[responder.index] = responder;
         }
         for(index = this.failedItems.length - 1; index >= startIndex; index--)
         {
            failedItem = this.failedItems[index];
            if(failedItem !== undefined)
            {
               delete this.failedItems[index];
               this.failedItems[index + delta] = failedItem;
            }
         }
      }
      
      private function shiftPendingRespondersLeft(ce:CollectionEvent) : void
      {
         var delta:int = 0;
         var responder:ListItemResponder = null;
         var failedItemsLength:int = 0;
         var index:int = 0;
         var failedItem:* = undefined;
         delta = int(ce.items.length);
         var startIndex:int = ce.location + delta;
         var pendingRespondersCopy:Array = this.sparseCopy(this.pendingResponders);
         this.pendingResponders.length = 0;
         for each(responder in pendingRespondersCopy)
         {
            if(responder.index >= startIndex)
            {
               responder.index -= delta;
            }
            this.pendingResponders[responder.index] = responder;
         }
         failedItemsLength = int(this.failedItems.length);
         for(index = startIndex; index < failedItemsLength; index++)
         {
            failedItem = this.failedItems[index];
            if(failedItem !== undefined)
            {
               delete this.failedItems[index];
               this.failedItems[index - delta] = failedItem;
            }
         }
      }
      
      private function sparseCopy(a:Array) : Array
      {
         var item:* = undefined;
         var r:Array = new Array();
         var index:int = 0;
         for each(item in a)
         {
            if(item !== undefined)
            {
               r[index++] = item;
            }
         }
         return r;
      }
      
      private function defaultCreatePendingItemFunction(index:int, ipe:ItemPendingError) : Object
      {
         return null;
      }
      
      public function get createPendingItemFunction() : Function
      {
         return this._createPendingItemFunction;
      }
      
      public function set createPendingItemFunction(value:Function) : void
      {
         this._createPendingItemFunction = value;
      }
      
      private function defaultCreateFailedItemFunction(index:int, info:Object) : Object
      {
         return null;
      }
      
      public function get createFailedItemFunction() : Function
      {
         return this._createFailedItemFunction;
      }
      
      public function set createFailedItemFunction(value:Function) : void
      {
         this._createFailedItemFunction = value;
      }
      
      mx_internal function pendingRequestSucceeded(index:int, info:Object) : void
      {
         delete this.pendingResponders[index];
      }
      
      mx_internal function pendingRequestFailed(index:int, info:Object) : void
      {
         var pce:PropertyChangeEvent = null;
         var ce:CollectionEvent = null;
         delete this.pendingResponders[index];
         if(this.createFailedItemFunction === null)
         {
            return;
         }
         var item:Object = this.createFailedItemFunction(index,info);
         this.failedItems[index] = item;
         var hasCollectionListener:Boolean = hasEventListener(CollectionEvent.COLLECTION_CHANGE);
         var hasPropertyListener:Boolean = hasEventListener(PropertyChangeEvent.PROPERTY_CHANGE);
         if(hasCollectionListener || hasPropertyListener)
         {
            pce = new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE);
            pce.kind = PropertyChangeEventKind.UPDATE;
            pce.oldValue = null;
            pce.newValue = item;
            pce.property = index;
         }
         if(hasCollectionListener)
         {
            ce = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE);
            ce.kind = CollectionEventKind.REPLACE;
            ce.location = index;
            ce.items.push(pce);
            dispatchEvent(ce);
         }
         if(hasPropertyListener)
         {
            dispatchEvent(pce);
         }
      }
      
      [Bindable("collectionChange")]
      public function get length() : int
      {
         try
         {
            return Boolean(this.list) ? this.list.length : 0;
         }
         catch(ignore:ItemPendingError)
         {
         }
         return 0;
      }
      
      public function addItem(item:Object) : void
      {
         if(Boolean(this.list))
         {
            try
            {
               this.list.addItem(item);
            }
            catch(ignore:ItemPendingError)
            {
            }
         }
      }
      
      public function addItemAt(item:Object, index:int) : void
      {
         if(Boolean(this.list))
         {
            try
            {
               this.list.addItemAt(item,index);
            }
            catch(ignore:ItemPendingError)
            {
            }
         }
      }
      
      public function getItemAt(index:int, prefetch:int = 0) : Object
      {
         var failedItem:*;
         var pendingResponder:ListItemResponder;
         var item:Object = null;
         var createPendingItem:Function = null;
         var responder:ListItemResponder = null;
         if(!this.list)
         {
            return null;
         }
         failedItem = this.failedItems[index];
         if(failedItem !== undefined)
         {
            return failedItem;
         }
         pendingResponder = this.pendingResponders[index];
         if(Boolean(pendingResponder))
         {
            return pendingResponder.item;
         }
         item = null;
         try
         {
            return this.list.getItemAt(index,prefetch);
         }
         catch(ipe:ItemPendingError)
         {
            createPendingItem = createPendingItemFunction;
            if(createPendingItem !== null)
            {
               item = createPendingItem(index,ipe);
            }
            responder = new ListItemResponder(this,index,item);
            pendingResponders[index] = responder;
            ipe.addResponder(responder);
         }
         return item;
      }
      
      public function getItemIndex(item:Object) : int
      {
         var responder:ListItemResponder = null;
         var failedItemIndex:int = this.failedItems.indexOf(item);
         if(failedItemIndex != -1)
         {
            return failedItemIndex;
         }
         for each(responder in this.pendingResponders)
         {
            if(Boolean(responder) && responder.item === item)
            {
               return responder.index;
            }
         }
         return Boolean(this.list) ? this.list.getItemIndex(item) : -1;
      }
      
      public function itemUpdated(item:Object, property:Object = null, oldValue:Object = null, newValue:Object = null) : void
      {
         if(Boolean(this.list))
         {
            this.list.itemUpdated(item,property,oldValue,newValue);
         }
      }
      
      public function removeAll() : void
      {
         if(Boolean(this.list))
         {
            this.list.removeAll();
         }
      }
      
      public function removeItemAt(index:int) : Object
      {
         var actualItem:Object = null;
         if(!this.list)
         {
            return null;
         }
         var failedItem:* = this.failedItems[index];
         delete this.failedItems[index];
         var pendingItem:Object = this.deletePendingResponder(index);
         try
         {
            actualItem = this.list.removeItemAt(index);
            if(failedItem !== undefined)
            {
               return failedItem;
            }
            return Boolean(pendingItem) ? pendingItem : actualItem;
         }
         catch(ipe:ItemPendingError)
         {
         }
         return failedItem !== undefined ? failedItem : pendingItem;
      }
      
      public function setItemAt(item:Object, index:int) : Object
      {
         if(!this.list)
         {
            return null;
         }
         var failedItem:* = this.failedItems[index];
         var pendingResponder:ListItemResponder = this.pendingResponders[index];
         var setItemValue:Object = null;
         try
         {
            setItemValue = this.list.setItemAt(item,index);
         }
         catch(ignore:ItemPendingError)
         {
         }
         if(failedItem !== undefined)
         {
            return failedItem;
         }
         return Boolean(pendingResponder) ? pendingResponder.item : setItemValue;
      }
      
      public function toArray() : Array
      {
         if(!this.list)
         {
            return [];
         }
         var a:Array = new Array(this.list.length);
         for(var i:int = 0; i < a.length; i++)
         {
            a[i] = this.getItemAt(i);
         }
         return a;
      }
      
      public function toString() : String
      {
         var nRequests:int = 0;
         var responder:ListItemResponder = null;
         var s:String = getQualifiedClassName(this);
         if(Boolean(this.list))
         {
            nRequests = 0;
            for each(responder in this.pendingResponders)
            {
               if(Boolean(responder))
               {
                  nRequests += 1;
               }
            }
            s += " length=" + this.length + ", " + nRequests + " pending requests";
         }
         else
         {
            s += " no list";
         }
         return s;
      }
   }
}

import mx.collections.AsyncListView;
import mx.core.mx_internal;
import mx.rpc.IResponder;

use namespace mx_internal;

class ListItemResponder implements IResponder
{
   
   private var asyncListView:AsyncListView;
   
   public var index:int = -1;
   
   public var item:Object = null;
   
   public function ListItemResponder(asyncListView:AsyncListView, index:int, item:Object)
   {
      super();
      this.asyncListView = asyncListView;
      this.index = index;
      this.item = item;
   }
   
   public function result(info:Object) : void
   {
      if(this.index != -1)
      {
         this.asyncListView.mx_internal::pendingRequestSucceeded(this.index,info);
      }
   }
   
   public function fault(info:Object) : void
   {
      if(this.index != -1)
      {
         this.asyncListView.mx_internal::pendingRequestFailed(this.index,info);
      }
   }
}
