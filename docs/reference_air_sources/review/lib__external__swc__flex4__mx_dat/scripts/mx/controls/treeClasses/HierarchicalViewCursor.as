package mx.controls.treeClasses
{
   import flash.events.EventDispatcher;
   import flash.utils.Dictionary;
   import mx.collections.CursorBookmark;
   import mx.collections.ICollectionView;
   import mx.collections.IViewCursor;
   import mx.events.CollectionEvent;
   import mx.events.CollectionEventKind;
   
   [ExcludeClass]
   public class HierarchicalViewCursor extends EventDispatcher implements IViewCursor
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      private var dataDescriptor:ITreeDataDescriptor;
      
      private var currentIndex:int = 0;
      
      private var currentChildIndex:int = 0;
      
      private var _currentDepth:int = 1;
      
      private var childNodes:Object = [];
      
      private var parentNodes:Array = [];
      
      private var childIndexStack:Array = [];
      
      private var model:ICollectionView;
      
      private var collection:HierarchicalCollectionView;
      
      private var openNodes:Object;
      
      private var more:Boolean;
      
      private var modelCursor:IViewCursor;
      
      private var itemToUID:Function;
      
      public function HierarchicalViewCursor(collection:HierarchicalCollectionView, model:ICollectionView, dataDescriptor:ITreeDataDescriptor, itemToUID:Function, openNodes:Object)
      {
         super();
         this.collection = collection;
         this.model = model;
         this.dataDescriptor = dataDescriptor;
         this.itemToUID = itemToUID;
         this.openNodes = openNodes;
         collection.addEventListener(CollectionEvent.COLLECTION_CHANGE,this.collectionChangeHandler,false,0,true);
         this.modelCursor = model.createCursor();
         if(model.length > 1)
         {
            this.more = true;
         }
         else
         {
            this.more = false;
         }
      }
      
      public function get index() : int
      {
         return this.currentIndex;
      }
      
      public function get bookmark() : CursorBookmark
      {
         return new CursorBookmark(this.currentIndex.toString());
      }
      
      public function get current() : Object
      {
         try
         {
            if(this.childIndexStack.length == 0)
            {
               return this.modelCursor.current;
            }
            return this.childNodes[this.currentChildIndex];
         }
         catch(e:RangeError)
         {
         }
         return null;
      }
      
      public function get currentDepth() : int
      {
         return this._currentDepth;
      }
      
      public function get beforeFirst() : Boolean
      {
         return this.currentIndex <= this.collection.length && this.current == null;
      }
      
      public function get afterLast() : Boolean
      {
         return this.currentIndex >= this.collection.length && this.current == null;
      }
      
      public function get view() : ICollectionView
      {
         return this.model;
      }
      
      private function isItemVisible(node:Object) : Boolean
      {
         var parentNode:Object = this.collection.getParentItem(node);
         while(parentNode != null)
         {
            if(this.openNodes[this.itemToUID(parentNode)] == null)
            {
               return false;
            }
            parentNode = this.collection.getParentItem(parentNode);
         }
         return true;
      }
      
      private function getParentStack(node:Object) : Array
      {
         var nodeParents:Array = [];
         var obj:Object = this.collection.getParentItem(node);
         while(obj != null)
         {
            nodeParents.unshift(obj);
            obj = this.collection.getParentItem(obj);
         }
         return nodeParents;
      }
      
      private function isNodeBefore(node:Object, currentNode:Object) : Boolean
      {
         var n:int = 0;
         var i:int = 0;
         var childNodes:ICollectionView = null;
         var sameParent:Object = null;
         var nodeParent:Object = null;
         var curParent:Object = null;
         var child:Object = null;
         if(currentNode == null)
         {
            return false;
         }
         var nodeParents:Array = this.getParentStack(node);
         var curParents:Array = this.getParentStack(currentNode);
         while(Boolean(nodeParents.length) && Boolean(curParents.length))
         {
            nodeParent = nodeParents.shift();
            curParent = curParents.shift();
            if(nodeParent != curParent)
            {
               sameParent = this.collection.getParentItem(nodeParent);
               if(sameParent != null && this.dataDescriptor.isBranch(sameParent,this.model) && this.dataDescriptor.hasChildren(sameParent,this.model))
               {
                  childNodes = this.dataDescriptor.getChildren(sameParent,this.model);
               }
               else
               {
                  childNodes = this.model;
               }
               n = int(childNodes.length);
               child = childNodes[i];
               if(child == curParent)
               {
                  return false;
               }
               if(child == nodeParent)
               {
                  return true;
               }
            }
         }
         if(Boolean(nodeParents.length))
         {
            node = nodeParents.shift();
         }
         if(Boolean(curParents.length))
         {
            currentNode = curParents.shift();
         }
         childNodes = this.model;
         n = int(childNodes.length);
         for(i = 0; i < n; i++)
         {
            child = childNodes[i];
            if(child == currentNode)
            {
               return false;
            }
            if(child == node)
            {
               return true;
            }
         }
         return false;
      }
      
      public function findAny(values:Object) : Boolean
      {
         var o:Object = null;
         var matches:Boolean = false;
         var p:String = null;
         this.seek(CursorBookmark.FIRST);
         var done:Boolean = false;
         while(!done)
         {
            o = this.dataDescriptor.getData(this.current);
            matches = true;
            for(p in values)
            {
               if(o[p] != values[p])
               {
                  matches = false;
                  break;
               }
            }
            if(matches)
            {
               return true;
            }
            done = this.moveNext();
         }
         return false;
      }
      
      public function findFirst(values:Object) : Boolean
      {
         return this.findAny(values);
      }
      
      public function findLast(values:Object) : Boolean
      {
         var o:Object = null;
         var matches:Boolean = false;
         var p:String = null;
         this.seek(CursorBookmark.LAST);
         var done:Boolean = false;
         while(!done)
         {
            o = this.current;
            matches = true;
            for(p in values)
            {
               if(o[p] != values[p])
               {
                  matches = false;
                  break;
               }
            }
            if(matches)
            {
               return true;
            }
            done = this.movePrevious();
         }
         return false;
      }
      
      public function moveNext() : Boolean
      {
         var uid:String;
         var previousChildNodes:Object = null;
         var grandParent:Object = null;
         var currentNode:Object = this.current;
         if(currentNode == null)
         {
            return false;
         }
         uid = this.itemToUID(currentNode);
         if(!this.collection.parentMap.hasOwnProperty(uid))
         {
            this.collection.parentMap[uid] = this.parentNodes[this.parentNodes.length - 1];
         }
         if(Boolean(this.openNodes[uid]) && Boolean(this.dataDescriptor.isBranch(currentNode,this.model)) && this.dataDescriptor.hasChildren(currentNode,this.model))
         {
            previousChildNodes = this.childNodes;
            this.childNodes = this.dataDescriptor.getChildren(currentNode,this.model);
            if(this.childNodes.length > 0)
            {
               this.childIndexStack.push(this.currentChildIndex);
               this.parentNodes.push(currentNode);
               this.currentChildIndex = 0;
               currentNode = this.childNodes[0];
               ++this.currentIndex;
               ++this._currentDepth;
               return true;
            }
            this.childNodes = previousChildNodes;
         }
         while(true)
         {
            if(this.childNodes != null && this.childNodes.length > 0 && this.currentChildIndex >= Math.max(this.childNodes.length - 1,0))
            {
               if(this.childIndexStack.length < 1 && !this.more)
               {
                  currentNode = null;
                  ++this.currentIndex;
                  this._currentDepth = 1;
                  return false;
               }
               currentNode = this.parentNodes.pop();
               grandParent = this.parentNodes[this.parentNodes.length - 1];
               if(grandParent != null && this.dataDescriptor.isBranch(grandParent,this.model) && this.dataDescriptor.hasChildren(grandParent,this.model))
               {
                  this.childNodes = this.dataDescriptor.getChildren(grandParent,this.model);
               }
               else
               {
                  this.childNodes = [];
               }
               this.currentChildIndex = this.childIndexStack.pop();
               --this._currentDepth;
               continue;
            }
            if(this.childIndexStack.length == 0)
            {
               this._currentDepth = 1;
               this.more = this.modelCursor.moveNext();
               if(this.more)
               {
                  currentNode = this.modelCursor.current;
                  break;
               }
               this._currentDepth = 1;
               ++this.currentIndex;
               currentNode = null;
               return false;
            }
            try
            {
               currentNode = this.childNodes[++this.currentChildIndex];
               break;
            }
            catch(e:RangeError)
            {
               return false;
            }
         }
         ++this.currentIndex;
         return true;
      }
      
      public function movePrevious() : Boolean
      {
         var grandParent:Object = null;
         var previousChildNodes:Object = null;
         var currentNode:Object = this.current;
         if(currentNode == null)
         {
            return false;
         }
         if(Boolean(this.parentNodes) && this.parentNodes.length > 0)
         {
            if(this.currentChildIndex == 0)
            {
               currentNode = this.parentNodes.pop();
               this.currentChildIndex = this.childIndexStack.pop();
               grandParent = this.parentNodes[this.parentNodes.length - 1];
               if(grandParent != null && this.dataDescriptor.isBranch(grandParent,this.model) && this.dataDescriptor.hasChildren(grandParent,this.model))
               {
                  this.childNodes = this.dataDescriptor.getChildren(grandParent,this.model);
               }
               else
               {
                  this.childNodes = [];
               }
               --this._currentDepth;
               --this.currentIndex;
               return true;
            }
            try
            {
               currentNode = this.childNodes[--this.currentChildIndex];
            }
            catch(e:RangeError)
            {
               return false;
            }
         }
         else
         {
            this.more = this.modelCursor.movePrevious();
            if(!this.more)
            {
               this.currentIndex = -1;
               currentNode = null;
               return false;
            }
            currentNode = this.modelCursor.current;
         }
         while(true)
         {
            if(!(Boolean(this.openNodes[this.itemToUID(currentNode)]) && Boolean(this.dataDescriptor.isBranch(currentNode,this.model)) && this.dataDescriptor.hasChildren(currentNode,this.model)))
            {
               break;
            }
            previousChildNodes = this.childNodes;
            this.childNodes = this.dataDescriptor.getChildren(currentNode,this.model);
            if(this.childNodes.length <= 0)
            {
               this.childNodes = previousChildNodes;
               break;
            }
            this.childIndexStack.push(this.currentChildIndex);
            this.parentNodes.push(currentNode);
            this.currentChildIndex = this.childNodes.length - 1;
            currentNode = this.childNodes[this.currentChildIndex];
            ++this._currentDepth;
         }
         --this.currentIndex;
         return true;
      }
      
      public function seek(bookmark:CursorBookmark, offset:int = 0, prefetch:int = 0) : void
      {
         var value:int = 0;
         if(bookmark == CursorBookmark.FIRST)
         {
            value = 0;
         }
         else if(bookmark == CursorBookmark.CURRENT)
         {
            value = this.currentIndex;
         }
         else if(bookmark == CursorBookmark.LAST)
         {
            value = this.collection.length - 1;
         }
         else
         {
            value = int(bookmark.value);
         }
         value = Math.max(Math.min(value + offset,this.collection.length),0);
         var dc:int = Math.abs(this.currentIndex - value);
         var de:int = Math.abs(this.collection.length - value);
         var movedown:Boolean = true;
         if(dc < value)
         {
            if(de < dc)
            {
               this.moveToLast();
               if(de == 0)
               {
                  this.moveNext();
                  value = 0;
               }
               else
               {
                  value = de - 1;
               }
               movedown = false;
            }
            else
            {
               movedown = this.currentIndex < value;
               value = dc;
               if(this.currentIndex == this.collection.length)
               {
                  value--;
                  this.moveToLast();
               }
            }
         }
         else if(de < value)
         {
            this.moveToLast();
            if(de == 0)
            {
               this.moveNext();
               value = 0;
            }
            else
            {
               value = de - 1;
            }
            movedown = false;
         }
         else
         {
            this.moveToFirst();
         }
         if(movedown)
         {
            while(Boolean(value) && value > 0)
            {
               this.moveNext();
               value--;
            }
         }
         else
         {
            while(Boolean(value) && value > 0)
            {
               this.movePrevious();
               value--;
            }
         }
      }
      
      private function moveToFirst() : void
      {
         this.childNodes = [];
         this.modelCursor.seek(CursorBookmark.FIRST,0);
         if(this.model.length > 1)
         {
            this.more = true;
         }
         else
         {
            this.more = false;
         }
         this.currentChildIndex = 0;
         this.parentNodes = [];
         this.childIndexStack = [];
         this.currentIndex = 0;
         this._currentDepth = 1;
      }
      
      public function moveToLast() : void
      {
         var previousChildNodes:Object = null;
         this.childNodes = [];
         this.childIndexStack = [];
         this._currentDepth = 1;
         this.parentNodes = [];
         var emptyBranch:Boolean = false;
         this.modelCursor.seek(CursorBookmark.LAST,0);
         var currentNode:Object = this.modelCursor.current;
         while(Boolean(this.openNodes[this.itemToUID(currentNode)]) && Boolean(this.dataDescriptor.isBranch(currentNode,this.model)) && this.dataDescriptor.hasChildren(currentNode,this.model))
         {
            previousChildNodes = this.childNodes;
            this.childNodes = this.dataDescriptor.getChildren(currentNode,this.model);
            if(!(this.childNodes != null && this.childNodes.length > 0))
            {
               this.childNodes = previousChildNodes;
               break;
            }
            this.parentNodes.push(currentNode);
            this.childIndexStack.push(this.currentChildIndex);
            currentNode = this.childNodes[this.childNodes.length - 1];
            this.currentChildIndex = this.childNodes.length - 1;
            ++this._currentDepth;
         }
         this.currentIndex = this.collection.length - 1;
      }
      
      public function insert(item:Object) : void
      {
      }
      
      public function remove() : Object
      {
         return null;
      }
      
      public function collectionChangeHandler(event:CollectionEvent) : void
      {
         var i:int = 0;
         var n:int = 0;
         var node:Object = null;
         var nodeParent:Object = null;
         var parent:Object = null;
         var parentStack:Array = null;
         var parentTable:Dictionary = null;
         var newIndex:int = 0;
         var isBefore:Boolean = false;
         parentStack = this.getParentStack(this.current);
         parentTable = new Dictionary();
         n = int(parentStack.length);
         for(i = 0; i < n - 1; i++)
         {
            parentTable[parentStack[i]] = i + 1;
         }
         parent = parentStack[parentStack.length - 1];
         if(event.kind == CollectionEventKind.ADD)
         {
            n = int(event.items.length);
            if(event.location <= this.currentIndex)
            {
               this.currentIndex += n;
               isBefore = true;
            }
            for(i = 0; i < n; i++)
            {
               node = event.items[i];
               if(isBefore)
               {
                  nodeParent = this.collection.getParentItem(node);
                  if(nodeParent == parent)
                  {
                     ++this.currentChildIndex;
                  }
                  else if(parentTable[nodeParent] != null)
                  {
                     ++this.childIndexStack[parentTable[nodeParent]];
                  }
               }
            }
         }
         else if(event.kind == CollectionEventKind.REMOVE)
         {
            n = int(event.items.length);
            if(event.location <= this.currentIndex)
            {
               if(event.location + n >= this.currentIndex)
               {
                  newIndex = int(event.location);
                  this.moveToFirst();
                  this.seek(CursorBookmark.FIRST,newIndex);
                  for(i = 0; i < n; i++)
                  {
                     node = event.items[i];
                     delete this.collection.parentMap[this.itemToUID(node)];
                  }
                  return;
               }
               this.currentIndex -= n;
               isBefore = true;
            }
            for(i = 0; i < n; i++)
            {
               node = event.items[i];
               if(isBefore)
               {
                  nodeParent = this.collection.getParentItem(node);
                  if(nodeParent == parent)
                  {
                     --this.currentChildIndex;
                  }
                  else if(parentTable[nodeParent] != null)
                  {
                     --this.childIndexStack[parentTable[nodeParent]];
                  }
               }
               delete this.collection.parentMap[this.itemToUID(node)];
            }
         }
      }
   }
}

