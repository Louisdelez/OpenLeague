package mx.collections
{
   import flash.events.TimerEvent;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   import flash.xml.XMLNode;
   import mx.collections.errors.ItemPendingError;
   import mx.events.CollectionEvent;
   import mx.events.CollectionEventKind;
   import mx.utils.UIDUtil;
   
   [DefaultProperty("grouping")]
   public class GroupingCollection extends HierarchicalData implements IGroupingCollection
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "3.0.0.0";
      
      private var async:Boolean = false;
      
      private var treeCursor:IViewCursor;
      
      private var childrenArray:Array;
      
      private var currentGroupLabels:Array;
      
      private var hView:ICollectionView;
      
      private var flatCursor:IViewCursor;
      
      private var currentGroups:Array;
      
      private var fieldCount:int;
      
      private var summaryPresent:Boolean;
      
      private var prepared:Boolean = false;
      
      private var currentPosition:CursorBookmark = CursorBookmark.FIRST;
      
      private var currentData:Object;
      
      public var summaries:Array;
      
      protected var timer:Timer;
      
      private var flatView:ICollectionView;
      
      protected var parentMap:Object;
      
      private var gf:Array;
      
      private var _grouping:Grouping;
      
      private var oldSort:Sort;
      
      private var _sourceCol:ICollectionView;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var optimizeSummaries:Boolean = false;
      
      private var newCollection:ArrayCollection;
      
      private var currentIndices:Array;
      
      private var objectSummaryMap:Dictionary;
      
      private var itemIndex:int;
      
      public function GroupingCollection()
      {
         super();
         newCollection = new ArrayCollection();
         super.source = newCollection;
         objectSummaryMap = new Dictionary(false);
         parentMap = {};
      }
      
      public function cancelRefresh() : void
      {
         if(Boolean(timer))
         {
            timer.stop();
            timer = null;
            cleanUp();
         }
      }
      
      private function removeSummary(parent:Object, depth:int) : void
      {
         var children:ICollectionView = this.getChildren(parent) as ArrayCollection;
         if(!children)
         {
            return;
         }
         removeItemAndSummaries(super.source as ICollectionView,children.createCursor().current);
      }
      
      private function updateParentMap(parent:Object, node:Object) : void
      {
         var uid:String = UIDUtil.getUID(node);
         parentMap[uid] = parent;
      }
      
      private function collectionChangeHandler(event:CollectionEvent) : void
      {
         var obj:Object = null;
         var summaryCalculated:Boolean = false;
         var oldValue:Object = null;
         var newValue:Object = null;
         if(!grouping)
         {
            return;
         }
         var i:int = 0;
         var j:int = 0;
         if(event.kind == CollectionEventKind.UPDATE)
         {
            for(i = 0; i < event.items.length; i++)
            {
               obj = event.items[i].source;
               if(obj)
               {
                  for(j = 0; j < grouping.fields.length; j++)
                  {
                     if(event.items[i].property == grouping.fields[j].name)
                     {
                        summaryCalculated = true;
                        updateSummary(obj,true);
                        addItem(obj);
                        break;
                     }
                  }
                  if(!summaryCalculated)
                  {
                     updateSummary(obj);
                  }
               }
            }
         }
         if(event.kind == CollectionEventKind.ADD)
         {
            for(i = 0; i < event.items.length; i++)
            {
               obj = event.items[i];
               addItem(obj);
            }
         }
         if(event.kind == CollectionEventKind.REMOVE)
         {
            for(i = 0; i < event.items.length; i++)
            {
               obj = event.items[i];
               updateSummary(obj,true);
            }
         }
         if(event.kind == CollectionEventKind.REPLACE)
         {
            for(i = 0; i < event.items.length; i++)
            {
               oldValue = event.items[i].oldValue;
               newValue = event.items[i].newValue;
               updateSummary(oldValue,true);
               addItem(newValue);
            }
         }
         regenerateRootSummaries();
      }
      
      public function set grouping(value:Grouping) : void
      {
         _grouping = value;
      }
      
      private function getSummaries(parent:Object, depth:int) : void
      {
         var summaryRow:SummaryRow = null;
         var j:int = 0;
         var summaryField:SummaryField = null;
         var summary:Number = NaN;
         var label:String = null;
         var calculateSummaries:Boolean = false;
         var hd:HierarchicalData = null;
         var hColl:ICollectionView = null;
         var hCursor:IViewCursor = null;
         if(depth > grouping.fields.length - 1)
         {
            return;
         }
         var children:ICollectionView = this.getChildren(parent) as ArrayCollection;
         if(!children || children.length == 0)
         {
            return;
         }
         var summaries:Array = grouping.fields[depth].summaries;
         if(!summaries)
         {
            return;
         }
         var summaryObj:Array = [];
         for(var i:int = 0; i < summaries.length; i++)
         {
            summaryRow = summaries[i];
            summaryObj[i] = summaryRow.summaryObjectFunction != null ? summaryRow.summaryObjectFunction() : new SummaryObject();
            for(j = 0; j < summaryRow.fields.length; j++)
            {
               summaryField = summaryRow.fields[j];
               summary = 0;
               label = Boolean(summaryField.label) ? summaryField.label : summaryField.dataField;
               calculateSummaries = true;
               if(optimizeSummaries)
               {
                  if(depth == grouping.fields.length - 1)
                  {
                     calculateSummaries = true;
                  }
                  else
                  {
                     calculateSummaries = false;
                     summary = getSummaryFromMap(parent,label,summaryField.operation);
                  }
               }
               if(calculateSummaries)
               {
                  hd = new HierarchicalData(children);
                  hd.childrenField = this.childrenField;
                  hColl = new HierarchicalCollectionView(hd,{});
                  hCursor = new LeafNodeCursor(HierarchicalCollectionView(hColl),hColl,hd);
                  if(summaryField.summaryFunction != null)
                  {
                     summary = summaryField.summaryFunction(hCursor,summaryField.dataField,summaryField.operation);
                  }
                  else
                  {
                     summary = summaryUtil(hCursor,summaryField.dataField,summaryField.operation);
                  }
               }
               summaryObj[i][label] = summary;
            }
            if(objectSummaryMap[parent] == undefined)
            {
               objectSummaryMap[parent] = [];
            }
            objectSummaryMap[parent].push(summaryObj[i]);
         }
         insertSummary(parent,summaryObj,summaries);
      }
      
      public function get grouping() : Grouping
      {
         return _grouping;
      }
      
      private function createGroupsAndInsertItem(coll:ICollectionView, node:Object, depth:int = 0) : void
      {
         var parent:Object = null;
         var dataField:String = null;
         var value:String = null;
         var obj:Object = null;
         for(var i:int = depth; i < grouping.fields.length; i++)
         {
            dataField = grouping.fields[i].name;
            value = getDataLabel(node,grouping.fields[i]);
            if(!value)
            {
               return;
            }
            if(grouping.fields[i].groupingObjectFunction != null)
            {
               obj = grouping.fields[i].groupingObjectFunction(value);
            }
            else if(grouping.groupingObjectFunction != null)
            {
               obj = grouping.groupingObjectFunction(value);
            }
            else
            {
               obj = {};
            }
            obj[childrenField] = new ArrayCollection();
            obj[grouping.label] = value;
            if(coll is IList)
            {
               IList(coll).addItem(obj);
               parent = parent != null ? parent : getParent(coll.createCursor().current);
               updateParentMap(parent,obj);
               coll = getChildren(obj) as ICollectionView;
               parent = obj;
               if(i == grouping.fields.length - 1)
               {
                  IList(coll).addItem(node);
                  updateParentMap(obj,node);
                  break;
               }
            }
         }
      }
      
      override public function getChildren(node:Object) : Object
      {
         var uid:String = null;
         var cursor:IViewCursor = null;
         var children:Object = super.getChildren(node);
         if(children != null)
         {
            if(!(children is ICollectionView))
            {
               return null;
            }
            cursor = ICollectionView(children).createCursor();
            while(!cursor.afterLast)
            {
               uid = UIDUtil.getUID(cursor.current);
               parentMap[uid] = node;
               cursor.moveNext();
            }
         }
         return children;
      }
      
      private function generateRootSummaries(flatData:Boolean = false) : void
      {
         var summaryRow:SummaryRow = null;
         var j:int = 0;
         var summaryField:SummaryField = null;
         var summary:Number = NaN;
         var label:String = null;
         var cursor:IViewCursor = null;
         var current:Object = null;
         var temp:Number = NaN;
         var hd:HierarchicalData = null;
         var hColl:ICollectionView = null;
         var hCursor:IViewCursor = null;
         var coll:ICollectionView = super.source as ICollectionView;
         if(flatData)
         {
            coll = coll.createCursor().current as ICollectionView;
         }
         var summaryObj:Array = [];
         for(var i:int = 0; i < summaries.length; i++)
         {
            summaryRow = summaries[i];
            if(coll.length > 0)
            {
               summaryObj[i] = summaryRow.summaryObjectFunction != null ? summaryRow.summaryObjectFunction() : new SummaryObject();
               for(j = 0; j < summaryRow.fields.length; j++)
               {
                  summaryField = summaryRow.fields[j];
                  summary = 0;
                  label = Boolean(summaryField.label) ? summaryField.label : summaryField.dataField;
                  cursor = coll.createCursor();
                  if(flatData)
                  {
                     while(!cursor.afterLast)
                     {
                        current = cursor.current;
                        temp = current.hasOwnProperty(label) ? Number(current[label]) : 0;
                        if(summaryField.operation == "SUM" || summaryField.operation == "COUNT")
                        {
                           summary += temp;
                        }
                        else if(summaryField.operation == "MAX")
                        {
                           summary = temp;
                        }
                        else if(summaryField.operation == "MIN")
                        {
                           summary = temp;
                        }
                        cursor.moveNext();
                     }
                  }
                  else if(!optimizeSummaries)
                  {
                     hd = new HierarchicalData(coll);
                     hd.childrenField = this.childrenField;
                     hColl = new HierarchicalCollectionView(hd,{});
                     hCursor = new LeafNodeCursor(HierarchicalCollectionView(hColl),hColl,hd);
                     if(summaryField.summaryFunction != null)
                     {
                        summary = summaryField.summaryFunction(hCursor,summaryField.dataField,summaryField.operation);
                     }
                     else
                     {
                        summary = summaryUtil(hCursor,summaryField.dataField,summaryField.operation);
                     }
                  }
                  else
                  {
                     summary = getSummaryFromCursor(cursor,summaryField.dataField,summaryField.operation);
                  }
                  summaryObj[i][label] = summary;
               }
               if(objectSummaryMap[coll] == undefined)
               {
                  objectSummaryMap[coll] = [];
               }
               objectSummaryMap[coll].push(summaryObj[i]);
            }
         }
         insertRootSummary(summaryObj);
      }
      
      private function updateSummary(node:Object, removeItem:Boolean = false) : void
      {
         var parentNodes:Array = null;
         var i:int = 0;
         var coll:ICollectionView = super.source as ICollectionView;
         if(summaryPresent || removeItem)
         {
            parentNodes = removeItemAndSummaries(coll,node,removeItem);
         }
         if(summaryPresent && Boolean(parentNodes))
         {
            for(i = parentNodes.length - 1; i >= 0; i--)
            {
               getSummaries(parentNodes[i],i);
            }
         }
      }
      
      private function initialize() : void
      {
         currentData = null;
         currentGroups = [];
         currentGroupLabels = [];
         currentIndices = [];
         childrenArray = null;
      }
      
      protected function getParent(node:Object) : *
      {
         var uid:String = UIDUtil.getUID(node);
         if(parentMap.hasOwnProperty(uid))
         {
            return parentMap[uid];
         }
         return undefined;
      }
      
      override public function get source() : Object
      {
         return _sourceCol;
      }
      
      private function getCollection(value:Object) : ICollectionView
      {
         var xl:XMLList = null;
         var tmp:Array = null;
         if(typeof value == "string")
         {
            value = new XML(value);
         }
         else if(value is XMLNode)
         {
            value = new XML(XMLNode(value).toString());
         }
         else if(value is XMLList)
         {
            value = new XMLListCollection(value as XMLList);
         }
         if(value is XML)
         {
            xl = new XMLList();
            xl += value;
            return new XMLListCollection(xl);
         }
         if(value is ICollectionView)
         {
            return ICollectionView(value);
         }
         if(value is Array)
         {
            return new ArrayCollection(value as Array);
         }
         if(value is Object)
         {
            tmp = [];
            tmp.push(value);
            return new ArrayCollection(tmp);
         }
         return new ArrayCollection();
      }
      
      private function removeItemAndSummaries(coll:ICollectionView, node:Object, removeItem:Boolean = false) : Array
      {
         var index:int = 0;
         var addParent:Boolean = false;
         var children:ICollectionView = null;
         var uid:String = null;
         var temp:Array = null;
         var i:int = 0;
         var parentNodes:Array = [];
         var parent:Object = getParent(node);
         while(Boolean(parent))
         {
            addParent = true;
            children = getChildren(parent) as ArrayCollection;
            if(Boolean(children))
            {
               if(children.contains(node))
               {
                  if(children is IList)
                  {
                     if(removeItem)
                     {
                        index = int(IList(children).getItemIndex(node));
                        if(index != -1)
                        {
                           IList(children).removeItemAt(index);
                           uid = UIDUtil.getUID(node);
                           if(Boolean(parentMap[uid]))
                           {
                              delete parentMap[uid];
                           }
                        }
                     }
                     if(Boolean(objectSummaryMap[parent]))
                     {
                        temp = objectSummaryMap[parent];
                        for(i = 0; i < temp.length; i++)
                        {
                           index = int(IList(children).getItemIndex(temp[i]));
                           if(index != -1)
                           {
                              IList(children).removeItemAt(index);
                           }
                        }
                        delete objectSummaryMap[parent];
                     }
                     if(removeItem)
                     {
                        if(children.length == 0 && getParent(parent) != null)
                        {
                           addParent = false;
                        }
                        else
                        {
                           removeItem = false;
                        }
                     }
                  }
               }
               if(addParent)
               {
                  parentNodes.push(parent);
               }
               node = parent;
               parent = getParent(parent);
               if(!parent)
               {
                  if(parentNodes.length == 1)
                  {
                     if((getChildren(parentNodes[0]) as ICollectionView).length == 0 && coll is IList)
                     {
                        index = int(IList(coll).getItemIndex(node));
                        if(index != -1)
                        {
                           IList(coll).removeItemAt(index);
                           return null;
                        }
                     }
                  }
                  return parentNodes.reverse();
               }
            }
         }
         return null;
      }
      
      private function applyFunctionForParentNodes(coll:ICollectionView, func:Function, depth:int = 0) : void
      {
         var masterCursor:IViewCursor = null;
         var child:Object = null;
         var childCursor:IViewCursor = null;
         var current:Object = null;
         if(coll.length > 0)
         {
            masterCursor = coll.createCursor();
            while(!masterCursor.afterLast)
            {
               child = getChildren(masterCursor.current);
               if(child is ArrayCollection)
               {
                  childCursor = ArrayCollection(child).createCursor();
                  while(!childCursor.afterLast)
                  {
                     current = childCursor.current;
                     if(this.hasChildren(current))
                     {
                        applyFunctionForParentNodes(child as ArrayCollection,func,depth + 1);
                        break;
                     }
                     childCursor.moveNext();
                  }
               }
               func(masterCursor.current,depth);
               masterCursor.moveNext();
            }
         }
      }
      
      private function getSummaryFromCursor(cursor:IViewCursor, label:String, operation:String) : Number
      {
         var temp:Array = null;
         var i:int = 0;
         var result:Number = 0;
         while(!cursor.afterLast)
         {
            temp = objectSummaryMap[cursor.current];
            for(i = 0; i < temp.length; i++)
            {
               if(Boolean(temp[i]) && Boolean(temp[i].hasOwnProperty(label)))
               {
                  if(operation == "SUM" || operation == "COUNT")
                  {
                     result += temp[i][label];
                  }
                  else if(operation == "MAX")
                  {
                     result = result < temp[i][label] ? Number(temp[i][label]) : result;
                  }
                  else if(operation == "MIN")
                  {
                     result = result > temp[i][label] ? Number(temp[i][label]) : result;
                  }
               }
            }
            cursor.moveNext();
         }
         return result;
      }
      
      override public function set source(value:Object) : void
      {
         if(Boolean(_sourceCol))
         {
            _sourceCol.removeEventListener(CollectionEvent.COLLECTION_CHANGE,collectionChangeHandler);
         }
         if(!value)
         {
            _sourceCol = null;
            return;
         }
         _sourceCol = getCollection(value);
         if(_sourceCol is ICollectionView)
         {
            _sourceCol.addEventListener(CollectionEvent.COLLECTION_CHANGE,collectionChangeHandler);
         }
      }
      
      private function regenerateRootSummaries() : void
      {
         var index:int = 0;
         if(!summaries)
         {
            return;
         }
         var coll:ICollectionView = super.source as ICollectionView;
         if(!grouping)
         {
            coll = coll.createCursor().current as ICollectionView;
         }
         var summaryObj:Array = objectSummaryMap[coll];
         if(!summaryObj || !(coll is IList))
         {
            return;
         }
         for(var n:int = 0; n < summaryObj.length; n++)
         {
            index = int(IList(coll).getItemIndex(summaryObj[n]));
            if(index != -1)
            {
               IList(coll).removeItemAt(index);
            }
         }
         delete objectSummaryMap[coll];
         generateRootSummaries(grouping == null);
      }
      
      private function removeAllSummaries() : void
      {
         applyFunctionForParentNodes(super.source as ICollectionView,removeSummary);
      }
      
      private function summaryUtil(iterator:IViewCursor, dataField:String, operation:String) : Number
      {
         var once:Boolean = false;
         var count:int = 0;
         if(!iterator)
         {
            return 0;
         }
         var result:Number = 0;
         var temp:Number = 0;
         if(operation == "SUM" || operation == "COUNT" || operation == "AVG")
         {
            count = 0;
            while(!iterator.afterLast)
            {
               if(iterator.current.hasOwnProperty(dataField))
               {
                  count++;
                  result += Number(iterator.current[dataField]);
               }
               iterator.moveNext();
            }
            if(operation == "SUM")
            {
               return result;
            }
            if(operation == "COUNT")
            {
               return count;
            }
            if(operation == "AVG")
            {
               return result / count;
            }
         }
         else
         {
            if(operation == "MIN")
            {
               while(!iterator.afterLast)
               {
                  temp = iterator.current.hasOwnProperty(dataField) ? Number(iterator.current[dataField]) : 0;
                  if(!once)
                  {
                     result = temp;
                     once = true;
                  }
                  if(temp < result)
                  {
                     result = temp;
                  }
                  iterator.moveNext();
               }
               return result;
            }
            if(operation == "MAX")
            {
               while(!iterator.afterLast)
               {
                  temp = iterator.current.hasOwnProperty(dataField) ? Number(iterator.current[dataField]) : 0;
                  if(!once)
                  {
                     result = temp;
                     once = true;
                  }
                  if(temp > result)
                  {
                     result = temp;
                  }
                  iterator.moveNext();
               }
               return result;
            }
         }
         return 0;
      }
      
      private function getSummaryFromMap(parent:Object, label:String, operation:String) : Number
      {
         var cursor:IViewCursor = (getChildren(parent) as ArrayCollection).createCursor();
         return getSummaryFromCursor(cursor,label,operation);
      }
      
      private function insertSummary(parent:Object, summaryObj:Array, summaries:Array) : void
      {
         var summaryRow:SummaryRow = null;
         var children:IList = null;
         var str:String = null;
         for(var i:int = 0; i < summaries.length; i++)
         {
            summaryRow = summaries[i];
            if(summaryRow.summaryPlacement.indexOf("group") != -1)
            {
               for(str in summaryObj[i])
               {
                  parent[str] = summaryObj[i][str];
               }
            }
            if(summaryRow.summaryPlacement.indexOf("first") != -1)
            {
               children = getChildren(parent) as ArrayCollection;
               if(Boolean(children))
               {
                  children.addItemAt(summaryObj[i],0);
               }
            }
            if(summaryRow.summaryPlacement.indexOf("last") != -1)
            {
               children = getChildren(parent) as ArrayCollection;
               if(Boolean(children))
               {
                  children.addItem(summaryObj[i]);
               }
            }
         }
      }
      
      private function cleanUp() : void
      {
         source.sort = oldSort;
         source.refresh();
         prepared = false;
         currentPosition = CursorBookmark.FIRST;
         oldSort = null;
         flatCursor = null;
         treeCursor = null;
      }
      
      private function makeGroupedCollection() : Boolean
      {
         var groupingField:GroupingField = null;
         var sortField:SortField = null;
         var fields:Array = [];
         for(var i:int = 0; i < grouping.fields.length; i++)
         {
            groupingField = grouping.fields[i];
            sortField = new SortField(groupingField.name,groupingField.caseInsensitive,groupingField.descending,groupingField.numeric);
            sortField.compareFunction = groupingField.compareFunction;
            fields.push(sortField);
         }
         oldSort = source.sort;
         source.sort = new Sort();
         if(grouping.compareFunction != null)
         {
            source.sort.compareFunction = grouping.compareFunction;
         }
         source.sort.fields = fields;
         var refreshed:Boolean = Boolean(source.refresh());
         if(!refreshed)
         {
            return refreshed;
         }
         if(async)
         {
            timer = new Timer(1);
            timer.addEventListener(TimerEvent.TIMER,timerHandler);
            timer.start();
            return true;
         }
         return buildGroups();
      }
      
      private function getDataLabel(data:Object, field:GroupingField) : String
      {
         if(field.groupingFunction != null)
         {
            return field.groupingFunction(data,field);
         }
         return data.hasOwnProperty(field.name) ? data[field.name] : "Not Available";
      }
      
      private function checkForParentExistence(coll:ICollectionView, node:Object, depth:int) : Object
      {
         var current:Object = null;
         var cursor:IViewCursor = coll.createCursor();
         var label:String = getDataLabel(node,grouping.fields[depth]);
         while(!cursor.afterLast)
         {
            current = cursor.current;
            if(current.hasOwnProperty(grouping.label) && current[grouping.label] == label)
            {
               return current;
            }
            cursor.moveNext();
         }
         return null;
      }
      
      override public function getRoot() : Object
      {
         return super.source;
      }
      
      public function refresh(async:Boolean = false) : Boolean
      {
         var resetEvent:CollectionEvent = null;
         var grouped:Boolean = false;
         this.async = async;
         if(!grouping || grouping.fields.length < 1)
         {
            super.source = source;
            resetEvent = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE);
            resetEvent.kind = CollectionEventKind.RESET;
            dispatchEvent(resetEvent);
            return true;
         }
         super.source = newCollection;
         resetEvent = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE);
         resetEvent.kind = CollectionEventKind.RESET;
         dispatchEvent(resetEvent);
         parentMap = {};
         objectSummaryMap = new Dictionary(false);
         summaryPresent = false;
         for(var i:int = 0; i < grouping.fields.length; i++)
         {
            if(Boolean(GroupingField(grouping.fields[i]).summaries))
            {
               summaryPresent = true;
               break;
            }
         }
         if(Boolean(source) && Boolean(grouping))
         {
            grouped = makeGroupedCollection();
         }
         return grouped;
      }
      
      private function timerHandler(event:TimerEvent) : void
      {
         if(buildGroups())
         {
            timer.stop();
            timer = null;
         }
      }
      
      private function addItem(node:Object, depth:int = 0) : void
      {
         var obj:Object = null;
         var coll:ICollectionView = super.source as ICollectionView;
         var parent:Object = null;
         var i:int = 0;
         while(i < grouping.fields.length)
         {
            obj = checkForParentExistence(coll,node,i);
            if(!obj)
            {
               break;
            }
            parent = obj;
            if(Boolean(parent))
            {
               coll = getChildren(parent) as ICollectionView;
               i++;
            }
         }
         if(Boolean(parent))
         {
            coll = getChildren(parent) as ICollectionView;
            if(i <= grouping.fields.length - 1)
            {
               createGroupsAndInsertItem(coll,node,i);
               updateSummary(node);
               return;
            }
            if(coll is IList)
            {
               IList(coll).addItem(node);
               updateParentMap(parent,node);
               updateSummary(node);
            }
         }
         else
         {
            createGroupsAndInsertItem(super.source as ICollectionView,node);
            updateSummary(node);
         }
      }
      
      private function buildGroups() : Boolean
      {
         var _openItems:Object = null;
         var hierarchicalData:IHierarchicalData = null;
         var i:int = 0;
         var groupingField:String = null;
         var label:String = null;
         var refreshEvent:CollectionEvent = null;
         if(!prepared)
         {
            _openItems = {};
            initialize();
            newCollection.removeAll();
            if((source as ICollectionView).length == 0)
            {
               return false;
            }
            hierarchicalData = new HierarchicalData(newCollection);
            HierarchicalData(hierarchicalData).childrenField = childrenField;
            hView = new HierarchicalCollectionView(hierarchicalData,_openItems);
            treeCursor = hView.createCursor();
            flatView = source as ICollectionView;
            flatCursor = flatView.createCursor();
            gf = grouping.fields;
            fieldCount = gf.length;
            if(Boolean(gf))
            {
               prepared = true;
               if(async)
               {
                  return false;
               }
            }
            if(async)
            {
               return true;
            }
         }
         flatCursor.seek(currentPosition);
         while(!flatCursor.afterLast && currentPosition != CursorBookmark.LAST)
         {
            currentData = flatCursor.current;
            for(i = 0; i < fieldCount; i++)
            {
               groupingField = gf[i].name;
               label = getDataLabel(currentData,gf[i]);
               if(label != currentGroupLabels[i])
               {
                  if(Boolean(childrenArray) && Boolean(childrenArray.length))
                  {
                     ArrayCollection(currentGroups[fieldCount - 1][childrenField]).source = childrenArray;
                     childrenArray = [];
                  }
                  currentGroupLabels.splice(i + 1);
                  currentGroups.splice(i + 1);
                  currentIndices.splice(i + 1);
                  currentGroupLabels[i] = label;
                  if(gf[i].groupingObjectFunction != null)
                  {
                     currentGroups[i] = gf[i].groupingObjectFunction(label);
                  }
                  else if(grouping.groupingObjectFunction != null)
                  {
                     currentGroups[i] = grouping.groupingObjectFunction(label);
                  }
                  else
                  {
                     currentGroups[i] = {};
                  }
                  currentGroups[i][childrenField] = new ArrayCollection();
                  currentGroups[i][grouping.label] = currentGroupLabels[i];
                  itemIndex = currentIndices[i - 1];
                  IHierarchicalCollectionView(hView).addChild(currentGroups[i - 1],currentGroups[i]);
                  currentIndices[i - 1] = ++itemIndex;
               }
               if(i == fieldCount - 1)
               {
                  itemIndex = currentIndices[i];
                  if(!childrenArray)
                  {
                     childrenArray = [];
                  }
                  childrenArray.push(currentData);
                  currentIndices[i] = ++itemIndex;
               }
            }
            try
            {
               flatCursor.moveNext();
               currentPosition = flatCursor.bookmark;
               if(async)
               {
                  return false;
               }
            }
            catch(pending:ItemPendingError)
            {
               cleanUp();
               pending.addResponder(new ItemResponder(function(data:Object, token:Object = null):void
               {
                  makeGroupedCollection();
               },function(info:Object, token:Object = null):void
               {
               }));
            }
         }
         if(currentPosition == CursorBookmark.LAST)
         {
            if(Boolean(childrenArray) && Boolean(childrenArray.length))
            {
               ArrayCollection(currentGroups[fieldCount - 1][childrenField]).source = childrenArray;
            }
            applyFunctionForParentNodes(super.source as ICollectionView,getSummaries);
            if(Boolean(source) && Boolean(summaries))
            {
               if(!super.source)
               {
                  super.source = new ArrayCollection([source]) as Object;
               }
               generateRootSummaries(grouping == null);
            }
            refreshEvent = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE);
            refreshEvent.kind = CollectionEventKind.REFRESH;
            dispatchEvent(refreshEvent);
            cleanUp();
            return true;
         }
         return true;
      }
      
      private function insertRootSummary(summaryObj:Array) : void
      {
         var summaryRow:SummaryRow = null;
         var coll:ICollectionView = super.source as ICollectionView;
         if(!grouping)
         {
            coll = coll.createCursor().current as ICollectionView;
         }
         if(!(coll is IList))
         {
            return;
         }
         for(var i:int = 0; i < summaryObj.length; i++)
         {
            summaryRow = summaries[i];
            if(summaryRow.summaryPlacement.indexOf("first") != -1)
            {
               IList(coll).addItemAt(summaryObj[i],0);
            }
            if(summaryRow.summaryPlacement.indexOf("last") != -1)
            {
               IList(coll).addItem(summaryObj[i]);
            }
         }
      }
   }
}

