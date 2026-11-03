package mx.controls.treeClasses
{
   import flash.events.EventDispatcher;
   import flash.utils.Dictionary;
   import mx.collections.CursorBookmark;
   import mx.collections.ICollectionView;
   import mx.collections.IViewCursor;
   import mx.core.mx_internal;
   import mx.events.CollectionEvent;
   import mx.events.CollectionEventKind;
   
   use namespace mx_internal;
   
   [ExcludeClass]
   public class HierarchicalViewCursor extends EventDispatcher implements IViewCursor
   {
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      private var itemToUID:Function;
      
      private var openNodes:Object;
      
      private var collection:HierarchicalCollectionView;
      
      private var childIndexStack:Array = [];
      
      private var parentNodes:Array = [];
      
      private var _currentDepth:int = 1;
      
      private var model:ICollectionView;
      
      private var dataDescriptor:ITreeDataDescriptor;
      
      private var more:Boolean;
      
      private var currentIndex:int = 0;
      
      private var modelCursor:IViewCursor;
      
      private var childNodes:Object = [];
      
      private var currentChildIndex:int = 0;
      
      public function HierarchicalViewCursor(collection:HierarchicalCollectionView, model:ICollectionView, dataDescriptor:ITreeDataDescriptor, itemToUID:Function, openNodes:Object)
      {
         super();
         this.collection = collection;
         this.model = model;
         this.dataDescriptor = dataDescriptor;
         this.itemToUID = itemToUID;
         this.openNodes = openNodes;
         collection.addEventListener(CollectionEvent.COLLECTION_CHANGE,collectionChangeHandler,false,0,true);
         modelCursor = model.createCursor();
         if(model.length > 1)
         {
            more = true;
         }
         else
         {
            more = false;
         }
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
         var nodeParents:Array = getParentStack(node);
         var curParents:Array = getParentStack(currentNode);
         while(Boolean(nodeParents.length) && Boolean(curParents.length))
         {
            nodeParent = nodeParents.shift();
            curParent = curParents.shift();
            if(nodeParent != curParent)
            {
               sameParent = collection.getParentItem(nodeParent);
               if(sameParent != null && dataDescriptor.isBranch(sameParent,model) && dataDescriptor.hasChildren(sameParent,model))
               {
                  childNodes = dataDescriptor.getChildren(sameParent,model);
               }
               else
               {
                  childNodes = model;
               }
               n = childNodes.length;
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
         childNodes = model;
         n = childNodes.length;
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
      
      public function findFirst(values:Object) : Boolean
      {
         return findAny(values);
      }
      
      public function remove() : Object
      {
         return null;
      }
      
      public function get afterLast() : Boolean
      {
         return currentIndex >= collection.length && current == null;
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
         parentStack = getParentStack(current);
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
            if(event.location <= currentIndex)
            {
               currentIndex += n;
               isBefore = true;
            }
            for(i = 0; i < n; i++)
            {
               node = event.items[i];
               if(isBefore)
               {
                  nodeParent = collection.getParentItem(node);
                  if(nodeParent == parent)
                  {
                     ++currentChildIndex;
                  }
                  else if(parentTable[nodeParent] != null)
                  {
                     ++childIndexStack[parentTable[nodeParent]];
                  }
               }
            }
         }
         else if(event.kind == CollectionEventKind.REMOVE)
         {
            n = int(event.items.length);
            if(event.location <= currentIndex)
            {
               if(event.location + n >= currentIndex)
               {
                  newIndex = event.location;
                  moveToFirst();
                  seek(CursorBookmark.FIRST,newIndex);
                  for(i = 0; i < n; i++)
                  {
                     node = event.items[i];
                     delete collection.parentMap[itemToUID(node)];
                  }
                  return;
               }
               currentIndex -= n;
               isBefore = true;
            }
            for(i = 0; i < n; i++)
            {
               node = event.items[i];
               if(isBefore)
               {
                  nodeParent = collection.getParentItem(node);
                  if(nodeParent == parent)
                  {
                     --currentChildIndex;
                  }
                  else if(parentTable[nodeParent] != null)
                  {
                     --childIndexStack[parentTable[nodeParent]];
                  }
               }
               delete collection.parentMap[itemToUID(node)];
            }
         }
      }
      
      public function get view() : ICollectionView
      {
         return model;
      }
      
      public function get bookmark() : CursorBookmark
      {
         return new CursorBookmark(currentIndex.toString());
      }
      
      public function insert(item:Object) : void
      {
      }
      
      private function getParentStack(node:Object) : Array
      {
         var nodeParents:Array = [];
         var obj:Object = collection.getParentItem(node);
         while(obj != null)
         {
            nodeParents.unshift(obj);
            obj = collection.getParentItem(obj);
         }
         return nodeParents;
      }
      
      public function get currentDepth() : int
      {
         return _currentDepth;
      }
      
      private function isItemVisible(node:Object) : Boolean
      {
         var parentNode:Object = collection.getParentItem(node);
         while(parentNode != null)
         {
            if(openNodes[itemToUID(parentNode)] == null)
            {
               return false;
            }
            parentNode = collection.getParentItem(parentNode);
         }
         return true;
      }
      
      public function moveToLast() : void
      {
         var previousChildNodes:Object = null;
         childNodes = [];
         childIndexStack = [];
         _currentDepth = 1;
         parentNodes = [];
         var emptyBranch:Boolean = false;
         modelCursor.seek(CursorBookmark.LAST,0);
         var currentNode:Object = modelCursor.current;
         while(Boolean(openNodes[itemToUID(currentNode)]) && Boolean(dataDescriptor.isBranch(currentNode,model)) && dataDescriptor.hasChildren(currentNode,model))
         {
            previousChildNodes = childNodes;
            childNodes = dataDescriptor.getChildren(currentNode,model);
            if(!(childNodes != null && childNodes.length > 0))
            {
               childNodes = previousChildNodes;
               break;
            }
            parentNodes.push(currentNode);
            childIndexStack.push(currentChildIndex);
            currentNode = childNodes[childNodes.length - 1];
            currentChildIndex = childNodes.length - 1;
            ++_currentDepth;
         }
         currentIndex = collection.length - 1;
      }
      
      public function movePrevious() : Boolean
      {
         var grandParent:Object = null;
         var previousChildNodes:Object = null;
         var currentNode:Object = current;
         if(currentNode == null)
         {
            return false;
         }
         if(Boolean(parentNodes) && parentNodes.length > 0)
         {
            if(currentChildIndex == 0)
            {
               currentNode = parentNodes.pop();
               currentChildIndex = childIndexStack.pop();
               grandParent = parentNodes[parentNodes.length - 1];
               if(grandParent != null && dataDescriptor.isBranch(grandParent,model) && dataDescriptor.hasChildren(grandParent,model))
               {
                  childNodes = dataDescriptor.getChildren(grandParent,model);
               }
               else
               {
                  childNodes = [];
               }
               --_currentDepth;
               --currentIndex;
               return true;
            }
            try
            {
               currentNode = childNodes[--currentChildIndex];
            }
            catch(e:RangeError)
            {
               return false;
            }
         }
         else
         {
            more = modelCursor.movePrevious();
            if(!more)
            {
               currentIndex = -1;
               currentNode = null;
               return false;
            }
            currentNode = modelCursor.current;
         }
         while(true)
         {
            if(!(Boolean(openNodes[itemToUID(currentNode)]) && Boolean(dataDescriptor.isBranch(currentNode,model)) && dataDescriptor.hasChildren(currentNode,model)))
            {
               break;
            }
            previousChildNodes = childNodes;
            childNodes = dataDescriptor.getChildren(currentNode,model);
            if(childNodes.length <= 0)
            {
               childNodes = previousChildNodes;
               break;
            }
            childIndexStack.push(currentChildIndex);
            parentNodes.push(currentNode);
            currentChildIndex = childNodes.length - 1;
            currentNode = childNodes[currentChildIndex];
            ++_currentDepth;
         }
         --currentIndex;
         return true;
      }
      
      public function moveNext() : Boolean
      {
         var uid:String;
         var previousChildNodes:Object = null;
         var grandParent:Object = null;
         var currentNode:Object = current;
         if(currentNode == null)
         {
            return false;
         }
         uid = itemToUID(currentNode);
         if(!collection.parentMap.hasOwnProperty(uid))
         {
            collection.parentMap[uid] = parentNodes[parentNodes.length - 1];
         }
         if(Boolean(openNodes[uid]) && Boolean(dataDescriptor.isBranch(currentNode,model)) && dataDescriptor.hasChildren(currentNode,model))
         {
            previousChildNodes = childNodes;
            childNodes = dataDescriptor.getChildren(currentNode,model);
            if(childNodes.length > 0)
            {
               childIndexStack.push(currentChildIndex);
               parentNodes.push(currentNode);
               currentChildIndex = 0;
               currentNode = childNodes[0];
               ++currentIndex;
               ++_currentDepth;
               return true;
            }
            childNodes = previousChildNodes;
         }
         while(true)
         {
            if(childNodes != null && childNodes.length > 0 && currentChildIndex >= Math.max(childNodes.length - 1,0))
            {
               if(childIndexStack.length < 1 && !more)
               {
                  currentNode = null;
                  ++currentIndex;
                  _currentDepth = 1;
                  return false;
               }
               currentNode = parentNodes.pop();
               grandParent = parentNodes[parentNodes.length - 1];
               if(grandParent != null && dataDescriptor.isBranch(grandParent,model) && dataDescriptor.hasChildren(grandParent,model))
               {
                  childNodes = dataDescriptor.getChildren(grandParent,model);
               }
               else
               {
                  childNodes = [];
               }
               currentChildIndex = childIndexStack.pop();
               --_currentDepth;
               continue;
            }
            if(childIndexStack.length == 0)
            {
               _currentDepth = 1;
               more = modelCursor.moveNext();
               if(more)
               {
                  currentNode = modelCursor.current;
                  break;
               }
               _currentDepth = 1;
               ++currentIndex;
               currentNode = null;
               return false;
            }
            try
            {
               currentNode = childNodes[++currentChildIndex];
               break;
            }
            catch(e:RangeError)
            {
               return false;
            }
         }
         ++currentIndex;
         return true;
      }
      
      public function get index() : int
      {
         return currentIndex;
      }
      
      public function findLast(values:Object) : Boolean
      {
         var o:Object = null;
         var matches:Boolean = false;
         var p:String = null;
         seek(CursorBookmark.LAST);
         var done:Boolean = false;
         while(!done)
         {
            o = current;
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
            done = movePrevious();
         }
         return false;
      }
      
      public function get beforeFirst() : Boolean
      {
         return currentIndex <= collection.length && current == null;
      }
      
      public function get current() : Object
      {
         try
         {
            if(childIndexStack.length == 0)
            {
               return modelCursor.current;
            }
            return childNodes[currentChildIndex];
         }
         catch(e:RangeError)
         {
         }
         return null;
      }
      
      public function findAny(values:Object) : Boolean
      {
         var o:Object = null;
         var matches:Boolean = false;
         var p:String = null;
         seek(CursorBookmark.FIRST);
         var done:Boolean = false;
         while(!done)
         {
            o = dataDescriptor.getData(current);
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
            done = moveNext();
         }
         return false;
      }
      
      private function moveToFirst() : void
      {
         childNodes = [];
         modelCursor.seek(CursorBookmark.FIRST,0);
         if(model.length > 1)
         {
            more = true;
         }
         else
         {
            more = false;
         }
         currentChildIndex = 0;
         parentNodes = [];
         childIndexStack = [];
         currentIndex = 0;
         _currentDepth = 1;
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
            value = currentIndex;
         }
         else if(bookmark == CursorBookmark.LAST)
         {
            value = collection.length - 1;
         }
         else
         {
            value = int(bookmark.value);
         }
         value = Math.max(Math.min(value + offset,collection.length),0);
         var dc:int = Math.abs(currentIndex - value);
         var de:int = Math.abs(collection.length - value);
         var movedown:Boolean = true;
         if(dc < value)
         {
            if(de < dc)
            {
               moveToLast();
               if(de == 0)
               {
                  moveNext();
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
               movedown = currentIndex < value;
               value = dc;
               if(currentIndex == collection.length)
               {
                  value--;
                  moveToLast();
               }
            }
         }
         else if(de < value)
         {
            moveToLast();
            if(de == 0)
            {
               moveNext();
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
            moveToFirst();
         }
         if(movedown)
         {
            while(Boolean(value) && value > 0)
            {
               moveNext();
               value--;
            }
         }
         else
         {
            while(Boolean(value) && value > 0)
            {
               movePrevious();
               value--;
            }
         }
      }
   }
}

