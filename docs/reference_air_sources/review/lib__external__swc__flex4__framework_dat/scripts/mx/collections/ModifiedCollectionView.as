package mx.collections
{
   import flash.events.Event;
   import flash.utils.Dictionary;
   import mx.collections.errors.CollectionViewError;
   import mx.core.mx_internal;
   import mx.events.CollectionEvent;
   import mx.events.CollectionEventKind;
   import mx.events.PropertyChangeEvent;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   
   use namespace mx_internal;
   
   [ResourceBundle("collections")]
   public class ModifiedCollectionView implements ICollectionView
   {
      
      mx_internal static const VERSION:String = "4.6.0.23201";
      
      public static const REMOVED:String = "removed";
      
      public static const ADDED:String = "added";
      
      public static const REPLACED:String = "replaced";
      
      public static const REPLACEMENT:String = "replacement";
      
      private var resourceManager:IResourceManager = ResourceManager.getInstance();
      
      private var list:ICollectionView;
      
      private var deltaLength:int = 0;
      
      private var deltas:Array = [];
      
      private var removedItems:Dictionary = new Dictionary(true);
      
      private var addedItems:Dictionary = new Dictionary(true);
      
      private var replacedItems:Dictionary = new Dictionary(true);
      
      private var replacementItems:Dictionary = new Dictionary(true);
      
      private var itemWrappersByIndex:Array = [];
      
      private var itemWrappersByCollectionMod:Dictionary = new Dictionary(true);
      
      private var _showPreserved:Boolean = false;
      
      public function ModifiedCollectionView(list:ICollectionView)
      {
         super();
         this.list = list;
      }
      
      public function get length() : int
      {
         return this.list.length + (this._showPreserved ? this.deltaLength : 0);
      }
      
      public function get filterFunction() : Function
      {
         return null;
      }
      
      public function set filterFunction(value:Function) : void
      {
      }
      
      public function disableAutoUpdate() : void
      {
      }
      
      public function createCursor() : IViewCursor
      {
         var internalCursor:IViewCursor = this.list.createCursor();
         var current:Object = internalCursor.current;
         return new ModifiedCollectionViewCursor(this,internalCursor,current);
      }
      
      public function contains(item:Object) : Boolean
      {
         return false;
      }
      
      public function get sort() : ISort
      {
         return null;
      }
      
      public function set sort(value:ISort) : void
      {
      }
      
      public function itemUpdated(item:Object, property:Object = null, oldValue:Object = null, newValue:Object = null) : void
      {
      }
      
      public function refresh() : Boolean
      {
         return false;
      }
      
      public function enableAutoUpdate() : void
      {
      }
      
      public function hasEventListener(type:String) : Boolean
      {
         return false;
      }
      
      public function willTrigger(type:String) : Boolean
      {
         return false;
      }
      
      public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false) : void
      {
      }
      
      public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false) : void
      {
      }
      
      public function dispatchEvent(event:Event) : Boolean
      {
         return false;
      }
      
      mx_internal function getBookmark(mcvCursor:ModifiedCollectionViewCursor) : ModifiedCollectionViewBookmark
      {
         var message:String = null;
         var index:int = mcvCursor.mx_internal::currentIndex;
         if(index < 0 || index > this.length)
         {
            message = this.resourceManager.getString("collections","invalidIndex",[index]);
            throw new CollectionViewError(message);
         }
         var value:Object = mcvCursor.current;
         return new ModifiedCollectionViewBookmark(value,this,0,index,mcvCursor.internalCursor.bookmark,mcvCursor.internalIndex);
      }
      
      mx_internal function getBookmarkIndex(bookmark:CursorBookmark) : int
      {
         var message:String = null;
         if(!(bookmark is ModifiedCollectionViewBookmark) || ModifiedCollectionViewBookmark(bookmark).view != this)
         {
            message = this.resourceManager.getString("collections","bookmarkNotFound");
            throw new CollectionViewError(message);
         }
         var bm:ModifiedCollectionViewBookmark = ModifiedCollectionViewBookmark(bookmark);
         return bm.index;
      }
      
      mx_internal function getWrappedItemUsingCursor(mcvCursor:ModifiedCollectionViewCursor, newIndex:int) : Object
      {
         var mod0:CollectionModification = null;
         var itemWrapper:Object = null;
         var adjustedIndex:int = newIndex;
         var item:Object = null;
         var cm:CollectionModification = null;
         var isReplacement:Boolean = false;
         for(var j:int = 0; j < this.deltas.length; j++)
         {
            mod0 = this.deltas[j];
            if(adjustedIndex < mod0.index)
            {
               break;
            }
            if(mod0.modificationType == CollectionModification.REPLACE)
            {
               if(adjustedIndex == mod0.index && mod0.showOldReplace && this._showPreserved)
               {
                  cm = mod0;
                  break;
               }
               if(adjustedIndex == mod0.index + 1 && mod0.showOldReplace && mod0.showNewReplace && this._showPreserved)
               {
                  adjustedIndex--;
                  isReplacement = true;
                  break;
               }
               if(adjustedIndex == mod0.index && (!mod0.showOldReplace && mod0.showNewReplace || !this._showPreserved))
               {
                  isReplacement = true;
                  break;
               }
               adjustedIndex -= mod0.modCount;
            }
            else if(this.isActive(mod0))
            {
               if(adjustedIndex == mod0.index && mod0.isRemove)
               {
                  cm = mod0;
                  break;
               }
               if(adjustedIndex >= mod0.index)
               {
                  adjustedIndex -= mod0.modCount;
               }
            }
         }
         if(Boolean(cm))
         {
            item = cm.item;
         }
         else
         {
            mcvCursor.internalCursor.seek(CursorBookmark.CURRENT,adjustedIndex - mcvCursor.internalIndex);
            item = mcvCursor.internalCursor.current;
            mcvCursor.internalIndex = adjustedIndex;
         }
         if(Boolean(mod0) && Boolean(adjustedIndex == mod0.index) && mod0.modificationType == CollectionModification.ADD)
         {
            itemWrapper = this.getUniqueItemWrapper(item,mod0,adjustedIndex);
         }
         else
         {
            itemWrapper = this.getUniqueItemWrapper(item,cm,adjustedIndex);
         }
         return itemWrapper;
      }
      
      public function get showPreservedState() : Boolean
      {
         return this._showPreserved;
      }
      
      public function set showPreservedState(show:Boolean) : void
      {
         this._showPreserved = show;
      }
      
      public function getSemantics(itemWrapper:ItemWrapper) : String
      {
         if(Boolean(this.removedItems[itemWrapper]))
         {
            return ModifiedCollectionView.REMOVED;
         }
         if(Boolean(this.addedItems[itemWrapper]))
         {
            return ModifiedCollectionView.ADDED;
         }
         if(Boolean(this.replacedItems[itemWrapper]))
         {
            return ModifiedCollectionView.REPLACED;
         }
         if(Boolean(this.replacementItems[itemWrapper]))
         {
            return ModifiedCollectionView.REPLACEMENT;
         }
         return null;
      }
      
      public function processCollectionEvent(event:CollectionEvent, startItemIndex:int, endItemIndex:int) : void
      {
         switch(event.kind)
         {
            case CollectionEventKind.ADD:
               this.integrateAddedElements(event,startItemIndex,endItemIndex);
               break;
            case CollectionEventKind.REMOVE:
               this.integrateRemovedElements(event,startItemIndex,endItemIndex);
               break;
            case CollectionEventKind.REPLACE:
               this.integrateReplacedElements(event,startItemIndex,endItemIndex);
         }
      }
      
      public function removeItem(itemWrapper:ItemWrapper) : void
      {
         var mod:CollectionModification = this.removedItems[itemWrapper] as CollectionModification;
         if(!mod)
         {
            mod = this.replacedItems[itemWrapper] as CollectionModification;
            if(Boolean(mod))
            {
               delete this.replacedItems[itemWrapper];
               mod.stopShowingReplacedValue();
               --this.deltaLength;
               if(mod.modCount == 0)
               {
                  this.removeModification(mod);
               }
            }
         }
         else if(this.removeModification(mod))
         {
            delete this.removedItems[itemWrapper];
            --this.deltaLength;
         }
      }
      
      public function addItem(itemWrapper:ItemWrapper) : void
      {
         var mod:CollectionModification = this.addedItems[itemWrapper] as CollectionModification;
         if(!mod)
         {
            mod = this.replacementItems[itemWrapper] as CollectionModification;
            if(Boolean(mod))
            {
               mod.startShowingReplacementValue();
               ++this.deltaLength;
               if(mod.modCount == 0)
               {
                  this.removeModification(mod);
               }
            }
         }
         else if(this.removeModification(mod))
         {
            ++this.deltaLength;
         }
      }
      
      private function isActive(mod:CollectionModification) : Boolean
      {
         return this._showPreserved;
      }
      
      private function removeModification(mod:CollectionModification) : Boolean
      {
         for(var i:int = 0; i < this.deltas.length; i++)
         {
            if(this.deltas[i] == mod)
            {
               this.deltas.splice(i,1);
               return true;
            }
         }
         return false;
      }
      
      private function integrateRemovedElements(event:CollectionEvent, startItemIndex:int, endItemIndex:int) : void
      {
         var mod:CollectionModification = null;
         var newMod:CollectionModification = null;
         var i:int = 0;
         var j:int = 0;
         var ignoredElementCount:int = 0;
         var insertCount:int = int(event.items.length);
         var offset:int = 0;
         while(i < this.deltas.length && j < insertCount)
         {
            mod = CollectionModification(this.deltas[i]);
            newMod = new CollectionModification(event.location,event.items[j],CollectionModification.REMOVE);
            this.removedItems[this.getUniqueItemWrapper(event.items[j],newMod,0)] = newMod;
            if(offset != 0)
            {
               mod.index += offset;
            }
            if(mod.isRemove && mod.index <= newMod.index || !mod.isRemove && mod.index < newMod.index)
            {
               i++;
            }
            else
            {
               if(!mod.isRemove && mod.index == newMod.index)
               {
                  this.deltas.splice(i + j,1);
               }
               else
               {
                  this.deltas.splice(i + j,0,newMod);
                  i++;
               }
               offset--;
               j++;
            }
         }
         while(i < this.deltas.length)
         {
            mod = CollectionModification(this.deltas[i++]);
            mod.index += offset;
         }
         while(j < insertCount)
         {
            this.deltas.push(newMod = new CollectionModification(event.location,event.items[j],CollectionModification.REMOVE));
            this.removedItems[this.getUniqueItemWrapper(event.items[j],newMod,0)] = newMod;
            j++;
         }
         this.deltaLength += event.items.length - ignoredElementCount;
      }
      
      private function integrateAddedElements(event:CollectionEvent, startItemIndex:int, endItemIndex:int) : void
      {
         var mod:CollectionModification = null;
         var newMod:CollectionModification = null;
         var i:int = 0;
         var j:int = 0;
         var inserted:Boolean = false;
         var insertCount:int = int(event.items.length);
         var offset:int = 0;
         while(i < this.deltas.length && j < insertCount)
         {
            mod = CollectionModification(this.deltas[i]);
            newMod = new CollectionModification(event.location + j,null,CollectionModification.ADD);
            this.addedItems[this.getUniqueItemWrapper(event.items[j],newMod,0)] = newMod;
            if(mod.isRemove && mod.index <= newMod.index || !mod.isRemove && mod.index < newMod.index)
            {
               i++;
            }
            else
            {
               this.deltas.splice(i + j,0,newMod);
               offset++;
               j++;
               i++;
            }
         }
         while(i < this.deltas.length)
         {
            mod = CollectionModification(this.deltas[i++]);
            mod.index += offset;
         }
         while(j < insertCount)
         {
            this.deltas.push(newMod = new CollectionModification(event.location + j,null,CollectionModification.ADD));
            this.addedItems[this.getUniqueItemWrapper(event.items[j],newMod,0)] = newMod;
            j++;
         }
         this.deltaLength -= event.items.length;
      }
      
      private function integrateReplacedElements(event:CollectionEvent, startItemIndex:int, endItemIndex:int) : void
      {
         var oldItem:Object = null;
         var newItem:Object = null;
         var mod:CollectionModification = null;
         var newMod:CollectionModification = null;
         var i:int = 0;
         var j:int = 0;
         var inserted:Boolean = false;
         var insertCount:int = int(event.items.length);
         var offset:int = 0;
         while(i < this.deltas.length && j < insertCount)
         {
            oldItem = PropertyChangeEvent(event.items[j]).oldValue;
            newItem = PropertyChangeEvent(event.items[j]).newValue;
            mod = CollectionModification(this.deltas[i]);
            newMod = new CollectionModification(event.location + j,oldItem,CollectionModification.REPLACE);
            if(mod.isRemove && mod.index <= newMod.index || !mod.isRemove && mod.index < newMod.index)
            {
               i++;
            }
            else if((mod.modificationType == CollectionModification.ADD || mod.modificationType == CollectionModification.REPLACE) && mod.index == newMod.index)
            {
               i++;
               j++;
            }
            else
            {
               this.deltas.splice(i + j,0,newMod);
               this.replacedItems[this.getUniqueItemWrapper(oldItem,newMod,event.location + j)] = newMod;
               this.replacementItems[this.getUniqueItemWrapper(newItem,newMod,event.location + j,true)] = newMod;
               j++;
               i++;
            }
         }
         while(j < insertCount)
         {
            oldItem = PropertyChangeEvent(event.items[j]).oldValue;
            newItem = PropertyChangeEvent(event.items[j]).newValue;
            this.deltas.push(newMod = new CollectionModification(event.location + j,oldItem,CollectionModification.REPLACE));
            this.replacedItems[this.getUniqueItemWrapper(oldItem,newMod,event.location + j)] = newMod;
            this.replacementItems[this.getUniqueItemWrapper(newItem,newMod,event.location + j,true)] = newMod;
            j++;
         }
      }
      
      private function getUniqueItemWrapper(item:Object, mod:CollectionModification, index:int, isReplacement:Boolean = false) : Object
      {
         if(Boolean(mod) && (mod.isRemove || mod.modificationType == CollectionModification.REPLACE && !isReplacement))
         {
            if(!this.itemWrappersByCollectionMod[mod])
            {
               this.itemWrappersByCollectionMod[mod] = new ItemWrapper(item);
            }
            return this.itemWrappersByCollectionMod[mod];
         }
         if(Boolean(mod) && mod.modificationType == CollectionModification.ADD)
         {
            index = mod.index;
         }
         if(!this.itemWrappersByIndex[index])
         {
            this.itemWrappersByIndex[index] = new ItemWrapper(item);
         }
         return this.itemWrappersByIndex[index];
      }
   }
}

import flash.events.EventDispatcher;
import mx.collections.CursorBookmark;
import mx.collections.ICollectionView;
import mx.collections.IViewCursor;
import mx.collections.ModifiedCollectionView;
import mx.collections.errors.CollectionViewError;
import mx.collections.errors.CursorError;
import mx.collections.errors.ItemPendingError;
import mx.core.mx_internal;
import mx.events.FlexEvent;
import mx.resources.IResourceManager;
import mx.resources.ResourceManager;

use namespace mx_internal;

[ResourceBundle("collections")]
[Event(name="cursorUpdate",type="mx.events.FlexEvent")]
class ModifiedCollectionViewCursor extends EventDispatcher implements IViewCursor
{
   
   private static const BEFORE_FIRST_INDEX:int = -1;
   
   private static const AFTER_LAST_INDEX:int = -2;
   
   private var _view:ModifiedCollectionView;
   
   public var internalCursor:IViewCursor;
   
   mx_internal var currentIndex:int;
   
   public var internalIndex:int;
   
   private var currentValue:Object;
   
   private var invalid:Boolean;
   
   private var resourceManager:IResourceManager;
   
   public function ModifiedCollectionViewCursor(view:ModifiedCollectionView, cursor:IViewCursor, current:Object)
   {
      this.resourceManager = ResourceManager.getInstance();
      super();
      this._view = view;
      this.internalCursor = cursor;
      if(cursor.beforeFirst && !current)
      {
         this.internalIndex = BEFORE_FIRST_INDEX;
      }
      else if(cursor.afterLast && !current)
      {
         this.internalIndex = AFTER_LAST_INDEX;
      }
      else
      {
         this.internalIndex = 0;
      }
      this.mx_internal::currentIndex = view.length > 0 ? 0 : int(AFTER_LAST_INDEX);
      if(this.mx_internal::currentIndex == 0)
      {
         try
         {
            this.setCurrent(current,false);
         }
         catch(e:ItemPendingError)
         {
            mx_internal::currentIndex = BEFORE_FIRST_INDEX;
            setCurrent(null,false);
         }
      }
   }
   
   public function get view() : ICollectionView
   {
      this.checkValid();
      return this._view;
   }
   
   [Bindable("cursorUpdate")]
   public function get current() : Object
   {
      this.checkValid();
      return this.currentValue;
   }
   
   [Bindable("cursorUpdate")]
   public function get bookmark() : CursorBookmark
   {
      this.checkValid();
      if(this.view.length == 0 || Boolean(this.beforeFirst))
      {
         return CursorBookmark.FIRST;
      }
      if(this.afterLast)
      {
         return CursorBookmark.LAST;
      }
      return ModifiedCollectionView(this.view).getBookmark(this);
   }
   
   [Bindable("cursorUpdate")]
   public function get beforeFirst() : Boolean
   {
      this.checkValid();
      return this.mx_internal::currentIndex == BEFORE_FIRST_INDEX || this.view.length == 0;
   }
   
   [Bindable("cursorUpdate")]
   public function get afterLast() : Boolean
   {
      this.checkValid();
      return this.mx_internal::currentIndex == AFTER_LAST_INDEX || this.view.length == 0;
   }
   
   public function findAny(values:Object) : Boolean
   {
      return false;
   }
   
   public function findFirst(values:Object) : Boolean
   {
      return false;
   }
   
   public function findLast(values:Object) : Boolean
   {
      return false;
   }
   
   public function insert(item:Object) : void
   {
   }
   
   public function moveNext() : Boolean
   {
      if(this.afterLast)
      {
         return false;
      }
      var tempIndex:int = this.beforeFirst ? 0 : int(this.mx_internal::currentIndex + 1);
      if(tempIndex >= this.view.length)
      {
         tempIndex = int(AFTER_LAST_INDEX);
         this.setCurrent(null);
      }
      else
      {
         this.setCurrent(ModifiedCollectionView(this.view).getWrappedItemUsingCursor(this,tempIndex));
      }
      this.mx_internal::currentIndex = tempIndex;
      return !this.afterLast;
   }
   
   public function movePrevious() : Boolean
   {
      if(this.beforeFirst)
      {
         return false;
      }
      var tempIndex:int = this.afterLast ? int(this.view.length - 1) : int(this.mx_internal::currentIndex - 1);
      if(tempIndex == -1)
      {
         tempIndex = int(BEFORE_FIRST_INDEX);
         this.setCurrent(null);
      }
      else
      {
         this.setCurrent(ModifiedCollectionView(this.view).getWrappedItemUsingCursor(this,tempIndex));
      }
      this.mx_internal::currentIndex = tempIndex;
      return !this.beforeFirst;
   }
   
   public function remove() : Object
   {
      return null;
   }
   
   public function seek(bookmark:CursorBookmark, offset:int = 0, prefetch:int = 0) : void
   {
      var newIndex:int;
      var newCurrent:Object;
      var message:String = null;
      var mcvBookmark:ModifiedCollectionViewBookmark = null;
      this.checkValid();
      if(this.view.length == 0)
      {
         this.mx_internal::currentIndex = AFTER_LAST_INDEX;
         this.setCurrent(null,false);
         return;
      }
      newIndex = int(this.mx_internal::currentIndex);
      if(bookmark == CursorBookmark.FIRST)
      {
         newIndex = 0;
         this.internalIndex = 0;
         this.internalCursor.seek(CursorBookmark.FIRST);
      }
      else if(bookmark == CursorBookmark.LAST)
      {
         newIndex = this.view.length - 1;
         this.internalCursor.seek(CursorBookmark.LAST);
      }
      else if(bookmark != CursorBookmark.CURRENT)
      {
         try
         {
            mcvBookmark = bookmark as ModifiedCollectionViewBookmark;
            newIndex = ModifiedCollectionView(this.view).getBookmarkIndex(bookmark);
            if(!mcvBookmark || newIndex < 0)
            {
               this.setCurrent(null);
               message = this.resourceManager.getString("collections","bookmarkInvalid");
               throw new CursorError(message);
            }
            this.internalIndex = mcvBookmark.internalIndex;
            this.internalCursor.seek(mcvBookmark.internalBookmark);
         }
         catch(bmError:CollectionViewError)
         {
            message = resourceManager.getString("collections","bookmarkInvalid");
            throw new CursorError(message);
         }
      }
      newIndex += offset;
      newCurrent = null;
      if(newIndex >= this.view.length)
      {
         this.mx_internal::currentIndex = AFTER_LAST_INDEX;
      }
      else if(newIndex < 0)
      {
         this.mx_internal::currentIndex = BEFORE_FIRST_INDEX;
      }
      else
      {
         newCurrent = ModifiedCollectionView(this.view).getWrappedItemUsingCursor(this,newIndex);
         this.mx_internal::currentIndex = newIndex;
      }
      this.setCurrent(newCurrent);
   }
   
   private function checkValid() : void
   {
      var message:String = null;
      if(this.invalid)
      {
         message = this.resourceManager.getString("collections","invalidCursor");
         throw new CursorError(message);
      }
   }
   
   private function setCurrent(value:Object, dispatch:Boolean = true) : void
   {
      this.currentValue = value;
      if(dispatch)
      {
         dispatchEvent(new FlexEvent(FlexEvent.CURSOR_UPDATE));
      }
   }
}

class ModifiedCollectionViewBookmark extends CursorBookmark
{
   
   mx_internal var index:int;
   
   mx_internal var view:ModifiedCollectionView;
   
   mx_internal var viewRevision:int;
   
   mx_internal var internalBookmark:CursorBookmark;
   
   mx_internal var internalIndex:int;
   
   public function ModifiedCollectionViewBookmark(value:Object, view:ModifiedCollectionView, viewRevision:int, index:int, internalBookmark:CursorBookmark, internalIndex:int)
   {
      super(value);
      this.mx_internal::view = view;
      this.mx_internal::viewRevision = viewRevision;
      this.mx_internal::index = index;
      this.mx_internal::internalBookmark = internalBookmark;
      this.mx_internal::internalIndex = internalIndex;
   }
   
   override public function getViewIndex() : int
   {
      return this.mx_internal::view.mx_internal::getBookmarkIndex(this);
   }
}

class CollectionModification
{
   
   public static const REMOVE:String = "remove";
   
   public static const ADD:String = "add";
   
   public static const REPLACE:String = "replace";
   
   public var index:int;
   
   public var item:Object = null;
   
   public var modificationType:String = null;
   
   private var _modCount:int = 0;
   
   public var showOldReplace:Boolean = true;
   
   public var showNewReplace:Boolean = false;
   
   public function CollectionModification(index:int, item:Object, modificationType:String)
   {
      super();
      this.index = index;
      this.modificationType = modificationType;
      if(modificationType != CollectionModification.ADD)
      {
         this.item = item;
      }
      if(modificationType == CollectionModification.REMOVE)
      {
         this._modCount = 1;
      }
      else if(modificationType == CollectionModification.ADD)
      {
         this._modCount = -1;
      }
   }
   
   public function get isRemove() : Boolean
   {
      return this.modificationType == CollectionModification.REMOVE;
   }
   
   public function startShowingReplacementValue() : void
   {
      this.showNewReplace = true;
      ++this._modCount;
   }
   
   public function stopShowingReplacedValue() : void
   {
      this.showOldReplace = false;
      --this._modCount;
   }
   
   public function get modCount() : int
   {
      return this._modCount;
   }
}
