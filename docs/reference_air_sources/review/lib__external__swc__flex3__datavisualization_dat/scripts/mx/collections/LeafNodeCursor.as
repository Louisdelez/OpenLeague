package mx.collections
{
   import flash.events.EventDispatcher;
   import mx.utils.UIDUtil;
   
   public class LeafNodeCursor extends EventDispatcher implements IHierarchicalCollectionViewCursor
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "3.0.0.0";
      
      private var childIndexStack:Array = [];
      
      private var collection:HierarchicalCollectionView;
      
      private var parentNodes:Array = [];
      
      private var _currentDepth:int = 1;
      
      private var model:ICollectionView;
      
      private var hierarchicalData:IHierarchicalData;
      
      private var more:Boolean;
      
      private var currentIndex:int = 0;
      
      private var modelCursor:IViewCursor;
      
      private var childNodes:Object = [];
      
      private var currentChildIndex:int = 0;
      
      public function LeafNodeCursor(collection:HierarchicalCollectionView, model:ICollectionView, hierarchicalData:IHierarchicalData)
      {
         super();
         this.collection = collection;
         this.hierarchicalData = hierarchicalData;
         this.model = model;
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
      
      public function movePrevious() : Boolean
      {
         var flag:Boolean;
         var grandParent:Object = null;
         var previousChildNodes:Object = null;
         var currentNode:Object = current;
         if(!currentNode)
         {
            return false;
         }
         flag = true;
         if(Boolean(parentNodes) && parentNodes.length > 0)
         {
            if(currentChildIndex == 0)
            {
               currentNode = parentNodes.pop();
               currentChildIndex = childIndexStack.pop();
               grandParent = parentNodes[parentNodes.length - 1];
               if(grandParent != null && hierarchicalData.canHaveChildren(grandParent) && hierarchicalData.hasChildren(grandParent))
               {
                  childNodes = collection.getChildren(grandParent);
               }
               else
               {
                  childNodes = [];
               }
               --_currentDepth;
               --currentIndex;
               if(!beforeFirst && (hierarchicalData.canHaveChildren(currentNode) || currentNode is SummaryObject))
               {
                  flag = movePrevious();
               }
               return flag;
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
            if(!(hierarchicalData.canHaveChildren(currentNode) && hierarchicalData.hasChildren(currentNode)))
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
            childIndexStack.push(currentChildIndex);
            parentNodes.push(currentNode);
            currentChildIndex = childNodes.length - 1;
            currentNode = childNodes[currentChildIndex];
            ++_currentDepth;
         }
         --currentIndex;
         if(hierarchicalData.canHaveChildren(currentNode) || currentNode is SummaryObject)
         {
            flag = movePrevious();
         }
         return flag;
      }
      
      public function remove() : Object
      {
         return null;
      }
      
      public function findFirst(values:Object) : Boolean
      {
         return false;
      }
      
      public function get current() : Object
      {
         try
         {
            if(childIndexStack.length == 0)
            {
               if(!(hierarchicalData.canHaveChildren(modelCursor.current) || modelCursor.current is SummaryObject))
               {
                  return modelCursor.current;
               }
               moveNext();
            }
            return childNodes[currentChildIndex];
         }
         catch(e:RangeError)
         {
         }
         return null;
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
         return null;
      }
      
      public function insert(item:Object) : void
      {
      }
      
      public function get currentDepth() : int
      {
         return _currentDepth;
      }
      
      public function get index() : int
      {
         return currentIndex;
      }
      
      public function moveNext() : Boolean
      {
         var uid:String;
         var flag:Boolean;
         var previousChildNodes:Object = null;
         var grandParent:Object = null;
         var currentNode:Object = childIndexStack.length == 0 ? modelCursor.current : current;
         if(!currentNode)
         {
            return false;
         }
         uid = UIDUtil.getUID(currentNode);
         if(!collection.parentMap.hasOwnProperty(uid))
         {
            collection.parentMap[uid] = parentNodes[parentNodes.length - 1];
         }
         flag = true;
         if(hierarchicalData.canHaveChildren(currentNode) && hierarchicalData.hasChildren(currentNode))
         {
            previousChildNodes = childNodes;
            childNodes = collection.getChildren(currentNode);
            if(childNodes.length > 0)
            {
               childIndexStack.push(currentChildIndex);
               parentNodes.push(currentNode);
               currentChildIndex = 0;
               currentNode = childNodes[0];
               ++currentIndex;
               ++_currentDepth;
               if(hierarchicalData.canHaveChildren(currentNode) || currentNode is SummaryObject)
               {
                  flag = moveNext();
               }
               return flag;
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
               if(grandParent != null && hierarchicalData.canHaveChildren(grandParent) && hierarchicalData.hasChildren(grandParent))
               {
                  childNodes = collection.getChildren(grandParent);
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
         if(hierarchicalData.canHaveChildren(currentNode) || currentNode is SummaryObject)
         {
            flag = moveNext();
         }
         return flag;
      }
      
      public function findLast(values:Object) : Boolean
      {
         return false;
      }
      
      public function seek(bookmark:CursorBookmark, offset:int = 0, prefetch:int = 0) : void
      {
      }
      
      public function findAny(values:Object) : Boolean
      {
         return false;
      }
   }
}

