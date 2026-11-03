package mx.collections
{
   import flash.events.EventDispatcher;
   import flash.utils.Dictionary;
   import mx.collections.errors.ChildItemPendingError;
   import mx.collections.errors.ItemPendingError;
   import mx.events.CollectionEvent;
   import mx.events.CollectionEventKind;
   import mx.events.FlexEvent;
   import mx.utils.UIDUtil;
   
   public class HierarchicalCollectionViewCursor extends EventDispatcher implements IHierarchicalCollectionViewCursor
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "3.0.0.0";
      
      private var collection:HierarchicalCollectionView;
      
      private var childIndexStack:Array = [];
      
      private var parentNodes:Array = [];
      
      private var _currentDepth:int = 1;
      
      private var model:ICollectionView;
      
      private var hierarchicalData:IHierarchicalData;
      
      private var more:Boolean;
      
      private var currentIndex:int = 0;
      
      private var modelCursor:IViewCursor;
      
      private var childNodes:ICollectionView;
      
      private var currentChildBookmark:CursorBookmark = CursorBookmark.FIRST;
      
      public function HierarchicalCollectionViewCursor(collection:HierarchicalCollectionView, model:ICollectionView, hierarchicalData:IHierarchicalData)
      {
         super();
         this.collection = collection;
         this.hierarchicalData = hierarchicalData;
         this.model = model;
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
      
      public function get current() : Object
      {
         var childCursor:IViewCursor = null;
         if(childIndexStack.length == 0)
         {
            return modelCursor.current;
         }
         childCursor = childNodes.createCursor();
         try
         {
            childCursor.seek(currentChildBookmark);
            return childCursor.current;
         }
         catch(e:ItemPendingError)
         {
            return null;
         }
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
         var tmpChildnodes:ICollectionView = null;
         var childCursor:IViewCursor = null;
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
                  tmpChildnodes = collection.getChildren(nodeParent);
                  if(nodeParent == parent)
                  {
                     if(Boolean(tmpChildnodes))
                     {
                        childCursor = tmpChildnodes.createCursor();
                        try
                        {
                           childCursor.seek(currentChildBookmark);
                           childCursor.moveNext();
                           currentChildBookmark = childCursor.bookmark;
                        }
                        catch(e:ItemPendingError)
                        {
                        }
                     }
                  }
                  else if(parentTable[nodeParent] != null)
                  {
                     if(Boolean(tmpChildnodes))
                     {
                        childCursor = tmpChildnodes.createCursor();
                        try
                        {
                           childCursor.seek(currentChildBookmark);
                           childCursor.moveNext();
                           currentChildBookmark = childCursor.bookmark;
                        }
                        catch(e:ItemPendingError)
                        {
                        }
                        childIndexStack[parentTable[nodeParent]] = currentChildBookmark;
                     }
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
                  newIndex = int(event.location);
                  moveToFirst();
                  seek(CursorBookmark.FIRST,newIndex);
                  for(i = 0; i < n; i++)
                  {
                     node = event.items[i];
                     delete collection.parentMap[UIDUtil.getUID(node)];
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
                  tmpChildnodes = collection.getChildren(nodeParent);
                  if(nodeParent == parent)
                  {
                     if(Boolean(tmpChildnodes))
                     {
                        childCursor = tmpChildnodes.createCursor();
                        try
                        {
                           childCursor.seek(currentChildBookmark);
                           childCursor.movePrevious();
                           currentChildBookmark = childCursor.bookmark;
                        }
                        catch(e:ItemPendingError)
                        {
                        }
                     }
                  }
                  else if(parentTable[nodeParent] != null)
                  {
                     if(Boolean(tmpChildnodes))
                     {
                        childCursor = tmpChildnodes.createCursor();
                        try
                        {
                           childCursor.seek(currentChildBookmark);
                           childCursor.movePrevious();
                           currentChildBookmark = childCursor.bookmark;
                        }
                        catch(e:ItemPendingError)
                        {
                        }
                        childIndexStack[parentTable[nodeParent]] = currentChildBookmark;
                     }
                  }
               }
               delete collection.parentMap[UIDUtil.getUID(node)];
            }
         }
         else if(event.kind == CollectionEventKind.RESET)
         {
            model = collection.treeData;
            modelCursor = model.createCursor();
            collection.dispatchEvent(new FlexEvent(FlexEvent.CURSOR_UPDATE));
         }
      }
      
      public function remove() : Object
      {
         var obj:Object = current;
         var parent:Object = collection.getParentItem(current);
         collection.removeChild(parent,current);
         return obj;
      }
      
      public function get beforeFirst() : Boolean
      {
         return currentIndex <= collection.length && current == null;
      }
      
      public function get afterLast() : Boolean
      {
         return currentIndex >= collection.length && current == null;
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
         var parent:Object = collection.getParentItem(current);
         collection.addChildAt(parent,item,currentIndex);
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
            if(collection.openNodes[UIDUtil.getUID(parentNode)] == null)
            {
               return false;
            }
            parentNode = collection.getParentItem(parentNode);
         }
         return true;
      }
      
      public function get index() : int
      {
         return currentIndex;
      }
      
      public function moveToLast() : void
      {
         var currentNode:Object;
         var emptyBranch:Boolean;
         var previousChildNodes:ICollectionView = null;
         var childCursor:IViewCursor = null;
         childNodes = null;
         childIndexStack = [];
         _currentDepth = 1;
         parentNodes = [];
         emptyBranch = false;
         modelCursor.seek(CursorBookmark.LAST,0);
         currentNode = modelCursor.current;
         while(Boolean(collection.openNodes[UIDUtil.getUID(currentNode)]) && Boolean(hierarchicalData.canHaveChildren(currentNode)) && hierarchicalData.hasChildren(currentNode))
         {
            previousChildNodes = childNodes;
            childNodes = collection.getChildren(currentNode);
            if(!(childNodes != null && childNodes.length > 0))
            {
               childNodes = previousChildNodes;
               break;
            }
            childCursor = childNodes.createCursor();
            try
            {
               childCursor.seek(CursorBookmark.LAST);
            }
            catch(e:ItemPendingError)
            {
               break;
            }
            parentNodes.push(currentNode);
            childIndexStack.push(currentChildBookmark);
            currentNode = childCursor.current;
            currentChildBookmark = CursorBookmark.LAST;
            try
            {
               childCursor.movePrevious();
               if(childCursor.bookmark == CursorBookmark.FIRST)
               {
                  currentChildBookmark = CursorBookmark.FIRST;
               }
            }
            catch(e:ItemPendingError)
            {
            }
            ++_currentDepth;
         }
         currentIndex = collection.length - 1;
      }
      
      public function movePrevious() : Boolean
      {
         var childCursor:IViewCursor = null;
         var grandParent:Object = null;
         var previousChildNodes:ICollectionView = null;
         var uid:String = null;
         var currentNode:Object = current;
         if(currentNode == null)
         {
            return false;
         }
         if(Boolean(parentNodes) && parentNodes.length > 0)
         {
            if(currentChildBookmark == CursorBookmark.FIRST)
            {
               currentNode = parentNodes.pop();
               currentChildBookmark = childIndexStack.pop();
               grandParent = parentNodes[parentNodes.length - 1];
               if(grandParent != null && hierarchicalData.canHaveChildren(grandParent) && hierarchicalData.hasChildren(grandParent))
               {
                  childNodes = collection.getChildren(grandParent);
               }
               else
               {
                  childNodes = null;
               }
               --_currentDepth;
               --currentIndex;
               return true;
            }
            try
            {
               childCursor = childNodes.createCursor();
               childCursor.seek(currentChildBookmark);
               childCursor.movePrevious();
               currentChildBookmark = childCursor.bookmark;
               currentNode = childCursor.current;
               try
               {
                  childCursor.movePrevious();
                  if(childCursor.bookmark == CursorBookmark.FIRST)
                  {
                     currentChildBookmark = CursorBookmark.FIRST;
                  }
               }
               catch(e:ItemPendingError)
               {
               }
            }
            catch(e:ItemPendingError)
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
            if(!(Boolean(collection.openNodes[UIDUtil.getUID(currentNode)]) && Boolean(hierarchicalData.canHaveChildren(currentNode)) && hierarchicalData.hasChildren(currentNode)))
            {
               break;
            }
            previousChildNodes = childNodes;
            childNodes = collection.getChildren(currentNode);
            if(childNodes.length <= 0)
            {
               childNodes = previousChildNodes;
               break;
            }
            childIndexStack.push(currentChildBookmark);
            parentNodes.push(currentNode);
            if(childNodes.length == 1)
            {
               currentChildBookmark = CursorBookmark.FIRST;
            }
            else
            {
               currentChildBookmark = CursorBookmark.LAST;
            }
            childCursor = childNodes.createCursor();
            childCursor.seek(currentChildBookmark);
            currentNode = childCursor.current;
            ++_currentDepth;
         }
         if(Boolean(currentNode))
         {
            uid = UIDUtil.getUID(currentNode);
            if(!collection.parentMap.hasOwnProperty(uid))
            {
               collection.parentMap[uid] = parentNodes[parentNodes.length - 1];
            }
         }
         --currentIndex;
         return true;
      }
      
      public function moveNext() : Boolean
      {
         var uid:String;
         var childCursor:IViewCursor = null;
         var previousChildNodes:ICollectionView = null;
         var grandParent:Object = null;
         var currentNode:Object = current;
         if(currentNode == null)
         {
            return false;
         }
         uid = UIDUtil.getUID(currentNode);
         if(Boolean(collection.openNodes[uid]) && Boolean(hierarchicalData.canHaveChildren(currentNode)) && hierarchicalData.hasChildren(currentNode))
         {
            previousChildNodes = childNodes;
            childNodes = collection.getChildren(currentNode);
            if(childNodes.length > 0)
            {
               childIndexStack.push(currentChildBookmark);
               parentNodes.push(currentNode);
               currentChildBookmark = CursorBookmark.FIRST;
               childCursor = childNodes.createCursor();
               try
               {
                  currentNode = childCursor.current;
               }
               catch(e:ItemPendingError)
               {
                  currentNode = null;
                  throw new ChildItemPendingError(e.message);
               }
               ++currentIndex;
               ++_currentDepth;
               return true;
            }
            childNodes = previousChildNodes;
         }
         while(true)
         {
            if(Boolean(childNodes))
            {
               childCursor = childNodes.createCursor();
               try
               {
                  childCursor.seek(currentChildBookmark);
                  childCursor.moveNext();
               }
               catch(e:ItemPendingError)
               {
                  childCursor.seek(CursorBookmark.FIRST);
               }
            }
            if(!(childNodes != null && childNodes.length > 0 && (childCursor.bookmark == CursorBookmark.LAST || Boolean(childCursor.afterLast))))
            {
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
                  childCursor = childNodes.createCursor();
                  childCursor.seek(currentChildBookmark);
                  childCursor.moveNext();
                  currentChildBookmark = childCursor.bookmark;
                  currentNode = childCursor.current;
                  break;
               }
               catch(ipe:ItemPendingError)
               {
                  currentNode = parentNodes.pop();
                  grandParent = parentNodes[parentNodes.length - 1];
                  if(grandParent != null && hierarchicalData.canHaveChildren(grandParent) && hierarchicalData.hasChildren(grandParent))
                  {
                     childNodes = collection.getChildren(grandParent);
                  }
                  else
                  {
                     childNodes = null;
                  }
                  currentChildBookmark = childIndexStack.pop();
                  --_currentDepth;
                  if(childIndexStack.length == 0)
                  {
                     _currentDepth = 1;
                     more = modelCursor.moveNext();
                     if(more)
                     {
                        currentNode = modelCursor.current;
                        throw new ChildItemPendingError(ipe.message);
                     }
                     _currentDepth = 1;
                     ++currentIndex;
                     currentNode = null;
                     return false;
                  }
                  break;
               }
               break;
            }
            if(childIndexStack.length < 1 && !more)
            {
               currentNode = null;
               ++currentIndex;
               _currentDepth = 1;
               return false;
            }
            currentNode = parentNodes.pop();
            grandParent = parentNodes[parentNodes.length - 1];
            if(grandParent != null && hierarchicalData.canHaveChildren(grandParent) && hierarchicalData.hasChildren(grandParent))
            {
               childNodes = collection.getChildren(grandParent);
            }
            else
            {
               childNodes = null;
            }
            currentChildBookmark = childIndexStack.pop();
            --_currentDepth;
         }
         if(Boolean(currentNode))
         {
            uid = UIDUtil.getUID(currentNode);
            if(!collection.parentMap.hasOwnProperty(uid))
            {
               collection.parentMap[uid] = parentNodes[parentNodes.length - 1];
            }
         }
         ++currentIndex;
         return true;
      }
      
      private function isNodeBefore(node:Object, currentNode:Object) : Boolean
      {
         var curParents:Array;
         var nodeParents:Array;
         var i:int = 0;
         var tmpChildNodes:ICollectionView = null;
         var sameParent:Object = null;
         var cursor:IViewCursor = null;
         var child:Object = null;
         var nodeParent:Object = null;
         var curParent:Object = null;
         if(currentNode == null)
         {
            return false;
         }
         nodeParents = getParentStack(node);
         curParents = getParentStack(currentNode);
         while(Boolean(nodeParents.length) && Boolean(curParents.length))
         {
            nodeParent = nodeParents.shift();
            curParent = curParents.shift();
            if(nodeParent != curParent)
            {
               sameParent = collection.getParentItem(nodeParent);
               if(sameParent != null && hierarchicalData.canHaveChildren(sameParent) && hierarchicalData.hasChildren(sameParent))
               {
                  tmpChildNodes = collection.getChildren(sameParent);
               }
               else
               {
                  tmpChildNodes = model;
               }
               cursor = tmpChildNodes.createCursor();
               try
               {
                  cursor.seek(CursorBookmark.FIRST,i);
                  child = cursor.current;
               }
               catch(e:ItemPendingError)
               {
                  return false;
               }
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
         tmpChildNodes = model;
         cursor = tmpChildNodes.createCursor();
         while(!cursor.afterLast)
         {
            child = cursor.current;
            if(child == currentNode)
            {
               return false;
            }
            if(child == node)
            {
               return true;
            }
            cursor.moveNext();
         }
         return false;
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
      
      public function findAny(values:Object) : Boolean
      {
         var o:Object = null;
         var matches:Boolean = false;
         var p:String = null;
         seek(CursorBookmark.FIRST);
         var done:Boolean = false;
         while(!done)
         {
            o = hierarchicalData.getData(current);
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
         childNodes = null;
         modelCursor.seek(CursorBookmark.FIRST,0);
         if(model.length > 1)
         {
            more = true;
         }
         else
         {
            more = false;
         }
         currentChildBookmark = CursorBookmark.FIRST;
         parentNodes = [];
         childIndexStack = [];
         currentIndex = 0;
         _currentDepth = 1;
      }
      
      public function findFirst(values:Object) : Boolean
      {
         return findAny(values);
      }
   }
}

