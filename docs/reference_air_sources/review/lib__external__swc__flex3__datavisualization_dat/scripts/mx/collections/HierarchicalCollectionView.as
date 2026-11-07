package mx.collections
{
   import flash.events.EventDispatcher;
   import flash.utils.Dictionary;
   import flash.xml.XMLNode;
   import mx.collections.errors.ItemPendingError;
   import mx.core.EventPriority;
   import mx.events.CollectionEvent;
   import mx.events.CollectionEventKind;
   import mx.events.PropertyChangeEvent;
   import mx.utils.IXMLNotifiable;
   import mx.utils.UIDUtil;
   import mx.utils.XMLNotifier;
   
   public class HierarchicalCollectionView extends EventDispatcher implements IHierarchicalCollectionView, IXMLNotifiable
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "3.0.0.0";
      
      private var _openNodes:Object;
      
      private var _filterFunction:Function;
      
      private var childrenMapCache:Dictionary = new Dictionary(true);
      
      private var currentLength:int;
      
      private var parentNode:XML;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var parentMap:Object;
      
      private var hierarchicalData:IHierarchicalData;
      
      private var cursor:HierarchicalCollectionViewCursor;
      
      private var _hasRoot:Boolean;
      
      private var _showRoot:Boolean = true;
      
      private var childrenMap:Dictionary;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var treeData:ICollectionView;
      
      private var _sort:Sort;
      
      public function HierarchicalCollectionView(hierarchicalData:IHierarchicalData = null, argOpenNodes:Object = null)
      {
         super();
         if(Boolean(hierarchicalData))
         {
            initializeCollection(hierarchicalData.getRoot(),hierarchicalData,argOpenNodes);
         }
      }
      
      private function startTrackUpdates(item:Object) : void
      {
         XMLNotifier.getInstance().watchXML(item,this);
      }
      
      public function addChild(parent:Object, newChild:Object) : Boolean
      {
         if(parent == null)
         {
            return addChildAt(parent,newChild,treeData.length);
         }
         return addChildAt(parent,newChild,getChildren(parent).length);
      }
      
      public function collectionChangeHandler(event:CollectionEvent) : void
      {
         var i:int = 0;
         var n:int = 0;
         var location:int = 0;
         var uid:String = null;
         var parent:Object = null;
         var node:Object = null;
         var items:Array = null;
         var convertedEvent:CollectionEvent = null;
         var ce:CollectionEvent = null;
         var j:int = 0;
         if(event is CollectionEvent)
         {
            ce = CollectionEvent(event);
            if(ce.kind == CollectionEventKind.RESET)
            {
               if(Boolean(hierarchicalData))
               {
                  initializeCollection(hierarchicalData.getRoot(),hierarchicalData,openNodes);
               }
               updateLength();
               internalRefresh(false);
               dispatchEvent(event);
            }
            else if(ce.kind == CollectionEventKind.ADD)
            {
               n = int(ce.items.length);
               convertedEvent = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE,false,true,ce.kind);
               convertedEvent.location = getVisibleLocation(ce.location);
               for(i = 0; i < n; i++)
               {
                  node = ce.items[i];
                  if(node is XML)
                  {
                     startTrackUpdates(node);
                  }
                  getVisibleNodes(node,null,convertedEvent.items);
               }
               currentLength += convertedEvent.items.length;
               dispatchEvent(convertedEvent);
            }
            else if(ce.kind == CollectionEventKind.REMOVE)
            {
               n = int(ce.items.length);
               convertedEvent = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE,false,true,ce.kind);
               convertedEvent.location = getVisibleLocation(ce.location);
               for(i = 0; i < n; i++)
               {
                  node = ce.items[i];
                  if(node is XML)
                  {
                     stopTrackUpdates(node);
                  }
                  getVisibleNodes(node,null,convertedEvent.items);
               }
               currentLength -= convertedEvent.items.length;
               dispatchEvent(convertedEvent);
            }
            else if(ce.kind == CollectionEventKind.UPDATE)
            {
               dispatchEvent(event);
            }
            else if(ce.kind == CollectionEventKind.REPLACE)
            {
               n = int(ce.items.length);
               convertedEvent = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE,false,true,CollectionEventKind.REMOVE);
               for(i = 0; i < n; i++)
               {
                  node = ce.items[i].oldValue;
                  if(node is XML)
                  {
                     stopTrackUpdates(node);
                  }
                  getVisibleNodes(node,null,convertedEvent.items);
               }
               j = 0;
               for(i = 0; i < n; i++)
               {
                  node = ce.items[i].oldValue;
                  while(convertedEvent.items[j] != node)
                  {
                     j++;
                  }
                  convertedEvent.items.splice(j,1);
               }
               if(Boolean(convertedEvent.items.length))
               {
                  currentLength -= convertedEvent.items.length;
                  dispatchEvent(convertedEvent);
               }
               dispatchEvent(event);
            }
         }
      }
      
      public function nestedCollectionChangeHandler(event:CollectionEvent) : void
      {
         var i:int = 0;
         var n:int = 0;
         var location:int = 0;
         var uid:String = null;
         var parent:Object = null;
         var node:Object = null;
         var items:Array = null;
         var convertedEvent:CollectionEvent = null;
         var ce:CollectionEvent = null;
         var j:int = 0;
         if(event is CollectionEvent)
         {
            ce = CollectionEvent(event);
            if(ce.kind == CollectionEventKind.EXPAND)
            {
               event.stopImmediatePropagation();
            }
            else if(ce.kind == CollectionEventKind.ADD)
            {
               updateLength();
               n = int(ce.items.length);
               convertedEvent = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE,false,true,ce.kind);
               for(i = 0; i < n; i++)
               {
                  node = ce.items[i];
                  if(node is XML)
                  {
                     startTrackUpdates(node);
                  }
                  parent = getParentItem(node);
                  if(parent != null)
                  {
                     getVisibleNodes(node,parent,convertedEvent.items);
                  }
               }
               convertedEvent.location = getVisibleLocationInSubCollection(parent,ce.location);
               dispatchEvent(convertedEvent);
            }
            else if(ce.kind == CollectionEventKind.REMOVE)
            {
               n = int(ce.items.length);
               convertedEvent = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE,false,true,ce.kind);
               for(i = 0; i < n; i++)
               {
                  node = ce.items[i];
                  if(node is XML)
                  {
                     stopTrackUpdates(node);
                  }
                  parent = getParentItem(node);
                  if(parent != null)
                  {
                     getVisibleNodes(node,parent,convertedEvent.items);
                  }
               }
               convertedEvent.location = getVisibleLocationInSubCollection(parent,ce.location);
               currentLength -= convertedEvent.items.length;
               dispatchEvent(convertedEvent);
            }
            else if(ce.kind == CollectionEventKind.UPDATE)
            {
               dispatchEvent(event);
            }
            else if(ce.kind == CollectionEventKind.REPLACE)
            {
               n = int(ce.items.length);
               convertedEvent = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE,false,true,CollectionEventKind.REMOVE);
               for(i = 0; i < n; i++)
               {
                  node = ce.items[i].oldValue;
                  parent = getParentItem(node);
                  if(parent != null)
                  {
                     getVisibleNodes(node,parent,convertedEvent.items);
                  }
               }
               j = 0;
               for(i = 0; i < n; i++)
               {
                  node = ce.items[i].oldValue;
                  if(node is XML)
                  {
                     stopTrackUpdates(node);
                  }
                  while(convertedEvent.items[j] != node)
                  {
                     j++;
                  }
                  convertedEvent.items.splice(j,1);
               }
               if(Boolean(convertedEvent.items.length))
               {
                  currentLength -= convertedEvent.items.length;
                  dispatchEvent(convertedEvent);
               }
               dispatchEvent(event);
            }
            else if(ce.kind == CollectionEventKind.RESET)
            {
               updateLength();
               convertedEvent = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE,false,true,CollectionEventKind.REFRESH);
               dispatchEvent(convertedEvent);
            }
         }
      }
      
      [Inspectable(category="Data",enumeration="true,false",defaultValue="true")]
      public function get showRoot() : Boolean
      {
         return _showRoot;
      }
      
      public function get openNodes() : Object
      {
         return _openNodes;
      }
      
      [Bindable(event="propertyChange")]
      public function set showRoot(value:Boolean) : void
      {
         var oldValue:Object = this.showRoot;
         if(oldValue !== value)
         {
            this._338884225showRoot = value;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"showRoot",oldValue,value));
         }
      }
      
      public function set openNodes(value:Object) : void
      {
         var item:* = undefined;
         var event:CollectionEvent = null;
         if(Boolean(value))
         {
            _openNodes = {};
            for each(item in value)
            {
               _openNodes[UIDUtil.getUID(item)] = item;
            }
         }
         else
         {
            _openNodes = {};
         }
         if(Boolean(hierarchicalData))
         {
            currentLength = calculateLength();
            event = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE);
            event.kind = CollectionEventKind.REFRESH;
            dispatchEvent(event);
         }
      }
      
      private function getVisibleLocation(oldLocation:int) : int
      {
         var newLocation:int = 0;
         newLocation = 0;
         var modelCursor:IViewCursor = treeData.createCursor();
         var i:int = 0;
         while(i < oldLocation && !modelCursor.afterLast)
         {
            newLocation += calculateLength(modelCursor.current,null) + 1;
            try
            {
               modelCursor.moveNext();
            }
            catch(e:ItemPendingError)
            {
               return newLocation;
            }
            i++;
         }
         return newLocation;
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
      
      private function sortCanBeApplied(coll:ICollectionView) : Boolean
      {
         var sf:SortField = null;
         if(sort == null)
         {
            return true;
         }
         var obj:Object = coll.createCursor().current;
         if(!obj || !sort.fields)
         {
            return false;
         }
         for(var i:int = 0; i < sort.fields.length; i++)
         {
            sf = sort.fields[i];
            if(!obj.hasOwnProperty(sf.name))
            {
               return false;
            }
         }
         return true;
      }
      
      public function closeNode(node:Object) : void
      {
         var cursor:IViewCursor = null;
         var uid:String = null;
         var childrenCollection:ICollectionView = childrenMap[node];
         delete _openNodes[UIDUtil.getUID(node)];
         if(Boolean(childrenCollection))
         {
            cursor = childrenCollection.createCursor();
            while(!cursor.afterLast)
            {
               uid = UIDUtil.getUID(cursor.current);
               delete parentMap[uid];
               try
               {
                  cursor.moveNext();
               }
               catch(e:ItemPendingError)
               {
                  break;
               }
            }
         }
         updateLength();
      }
      
      public function get source() : IHierarchicalData
      {
         return hierarchicalData;
      }
      
      public function addChildAt(parent:Object, newChild:Object, index:int) : Boolean
      {
         var cursor:IViewCursor = null;
         var children:ICollectionView = null;
         if(!parent)
         {
            cursor = treeData.createCursor();
         }
         else
         {
            if(!hierarchicalData.canHaveChildren(parent))
            {
               return false;
            }
            children = getChildren(parent);
            cursor = children.createCursor();
         }
         try
         {
            cursor.seek(CursorBookmark.FIRST,index);
         }
         catch(e:ItemPendingError)
         {
            return false;
         }
         cursor.insert(newChild);
         return true;
      }
      
      [Inspectable(category="General")]
      [Bindable("sortChanged")]
      public function get sort() : Sort
      {
         return _sort;
      }
      
      public function contains(item:Object) : Boolean
      {
         var cursor:IViewCursor = createCursor();
         while(!cursor.afterLast)
         {
            if(cursor.current == item)
            {
               return true;
            }
            cursor.moveNext();
         }
         return false;
      }
      
      private function getVisibleLocationInSubCollection(parent:Object, oldLocation:int) : int
      {
         var children:ICollectionView = null;
         var cursor:IViewCursor = null;
         var newLocation:int = oldLocation;
         var target:Object = parent;
         parent = getParentItem(parent);
         while(parent != null)
         {
            children = childrenMap[parent];
            cursor = children.createCursor();
            while(!cursor.afterLast)
            {
               if(cursor.current == target)
               {
                  newLocation++;
                  break;
               }
               newLocation += calculateLength(cursor.current,parent) + 1;
               cursor.moveNext();
            }
            target = parent;
            parent = getParentItem(parent);
         }
         cursor = treeData.createCursor();
         while(!cursor.afterLast)
         {
            if(cursor.current == target)
            {
               newLocation++;
               break;
            }
            newLocation += calculateLength(cursor.current,parent) + 1;
            cursor.moveNext();
         }
         return newLocation;
      }
      
      private function stopTrackUpdates(item:Object) : void
      {
         XMLNotifier.getInstance().unwatchXML(item,this);
      }
      
      public function get hasRoot() : Boolean
      {
         return _hasRoot;
      }
      
      private function updateLength(node:Object = null, parent:Object = null) : void
      {
         currentLength = calculateLength();
      }
      
      public function itemUpdated(item:Object, property:Object = null, oldValue:Object = null, newValue:Object = null) : void
      {
         var event:CollectionEvent = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE);
         event.kind = CollectionEventKind.UPDATE;
         var objEvent:PropertyChangeEvent = new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE);
         objEvent.source = item;
         objEvent.property = property;
         objEvent.oldValue = oldValue;
         objEvent.newValue = newValue;
         event.items.push(objEvent);
         dispatchEvent(event);
      }
      
      public function xmlNotification(currentTarget:Object, type:String, target:Object, value:Object, detail:Object) : void
      {
         var prop:String = null;
         var oldValue:Object = null;
         var newValue:Object = null;
         var children:XMLListCollection = null;
         var location:int = 0;
         var event:CollectionEvent = null;
         var list:XMLListAdapter = null;
         var q:* = undefined;
         var p:* = undefined;
         var xmllist:XMLList = null;
         var oldChildren:XMLListCollection = null;
         var n:int = 0;
         var i:int = 0;
         if(currentTarget === target)
         {
            switch(type)
            {
               case "nodeAdded":
                  for(q in childrenMap)
                  {
                     if(q === currentTarget)
                     {
                        list = childrenMap[q].list as XMLListAdapter;
                        if(Boolean(list) && !list.busy())
                        {
                           if(childrenMap[q] === treeData)
                           {
                              children = treeData as XMLListCollection;
                              if(Boolean(parentNode))
                              {
                                 children.dispatchResetEvent = false;
                                 children.source = parentNode.*;
                                 children.refresh();
                              }
                           }
                           else
                           {
                              children = getChildren(q) as XMLListCollection;
                           }
                           if(Boolean(children))
                           {
                              location = int(value.childIndex());
                              event = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE);
                              event.kind = CollectionEventKind.ADD;
                              event.location = location;
                              event.items = [value];
                              children.dispatchEvent(event);
                           }
                        }
                        break;
                     }
                  }
                  break;
               case "nodeRemoved":
                  for(p in childrenMap)
                  {
                     if(p === currentTarget)
                     {
                        children = childrenMap[p];
                        list = children.list as XMLListAdapter;
                        if(Boolean(list) && !list.busy())
                        {
                           xmllist = children.source as XMLList;
                           if(childrenMap[p] === treeData)
                           {
                              children = treeData as XMLListCollection;
                              if(Boolean(parentNode))
                              {
                                 children.dispatchResetEvent = false;
                                 children.source = parentNode.*;
                                 children.refresh();
                              }
                           }
                           else
                           {
                              oldChildren = children;
                              children = getChildren(p) as XMLListCollection;
                              if(!children)
                              {
                                 oldChildren.addEventListener(CollectionEvent.COLLECTION_CHANGE,nestedCollectionChangeHandler,false,0,true);
                                 event = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE);
                                 event.kind = CollectionEventKind.REMOVE;
                                 event.location = 0;
                                 event.items = [value];
                                 oldChildren.dispatchEvent(event);
                                 oldChildren.removeEventListener(CollectionEvent.COLLECTION_CHANGE,nestedCollectionChangeHandler);
                              }
                           }
                           if(Boolean(children))
                           {
                              n = xmllist.length();
                              for(i = 0; i < n; i++)
                              {
                                 if(xmllist[i] === value)
                                 {
                                    event = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE);
                                    event.kind = CollectionEventKind.REMOVE;
                                    event.location = location;
                                    event.items = [value];
                                    children.dispatchEvent(event);
                                    break;
                                 }
                              }
                           }
                        }
                        break;
                     }
                  }
            }
         }
      }
      
      public function getNodeDepth(node:Object) : int
      {
         var depth:int = 1;
         var parent:Object = getParentItem(node);
         while(Boolean(parent))
         {
            parent = getParentItem(parent);
            depth++;
         }
         depth = hasRoot && !showRoot ? int(depth - 1) : depth;
         return depth < 1 ? 1 : depth;
      }
      
      private function set _338884225showRoot(value:Boolean) : void
      {
         var event:CollectionEvent = null;
         if(_showRoot != value)
         {
            _showRoot = value;
            if(Boolean(hierarchicalData))
            {
               initializeCollection(hierarchicalData.getRoot(),hierarchicalData,openNodes);
               event = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE);
               event.kind = CollectionEventKind.RESET;
               dispatchEvent(event);
            }
         }
      }
      
      public function describeData() : Object
      {
         return null;
      }
      
      public function enableAutoUpdate() : void
      {
         var obj:Object = null;
         treeData.enableAutoUpdate();
         for(obj in childrenMap)
         {
            ICollectionView(childrenMap[obj]).enableAutoUpdate();
         }
      }
      
      public function set sort(value:Sort) : void
      {
         _sort = value;
      }
      
      public function set source(value:IHierarchicalData) : void
      {
         initializeCollection(value.getRoot(),value,openNodes);
      }
      
      public function removeChild(parent:Object, child:Object) : Boolean
      {
         var cursor:IViewCursor = null;
         var children:ICollectionView = null;
         var index:int = 0;
         if(parent == null)
         {
            cursor = treeData.createCursor();
         }
         else
         {
            children = getChildren(parent);
            cursor = children.createCursor();
         }
         while(!cursor.afterLast)
         {
            if(cursor.current == child)
            {
               cursor.remove();
               return true;
            }
            cursor.moveNext();
         }
         return false;
      }
      
      private function initializeCollection(model:Object, hierarchicalData:IHierarchicalData, argOpenNodes:Object = null) : void
      {
         var obj:Object = null;
         parentMap = {};
         childrenMap = new Dictionary(true);
         childrenMapCache = new Dictionary(true);
         if(Boolean(treeData))
         {
            treeData.removeEventListener(CollectionEvent.COLLECTION_CHANGE,collectionChangeHandler,false);
         }
         if(Boolean(this.hierarchicalData))
         {
            this.hierarchicalData.removeEventListener(CollectionEvent.COLLECTION_CHANGE,collectionChangeHandler,false);
         }
         treeData = getCollection(model);
         if(Boolean(treeData))
         {
            _hasRoot = treeData.length == 1;
         }
         var tmpCollection:Object = model;
         if(Boolean(hierarchicalData) && Boolean(!showRoot) && hasRoot)
         {
            obj = treeData.createCursor().current;
            if(hierarchicalData.hasChildren(obj))
            {
               tmpCollection = hierarchicalData.getChildren(obj);
               treeData = getCollection(tmpCollection);
            }
         }
         treeData.addEventListener(CollectionEvent.COLLECTION_CHANGE,collectionChangeHandler,false,EventPriority.DEFAULT_HANDLER,true);
         this.hierarchicalData = hierarchicalData;
         this.hierarchicalData.addEventListener(CollectionEvent.COLLECTION_CHANGE,collectionChangeHandler,false,EventPriority.DEFAULT_HANDLER,true);
         if(Boolean(argOpenNodes))
         {
            _openNodes = argOpenNodes;
         }
         else
         {
            _openNodes = {};
         }
         currentLength = calculateLength();
      }
      
      private function getVisibleNodes(node:Object, parent:Object, nodeArray:Array) : void
      {
         var uid:String;
         var childNodes:ICollectionView = null;
         var cursor:IViewCursor = null;
         nodeArray.push(node);
         uid = UIDUtil.getUID(node);
         parentMap[uid] = parent;
         if(Boolean(openNodes[uid]) && Boolean(hierarchicalData.canHaveChildren(node)) && hierarchicalData.hasChildren(node))
         {
            childNodes = getChildren(node);
            if(childNodes != null)
            {
               cursor = childNodes.createCursor();
               while(!cursor.afterLast)
               {
                  getVisibleNodes(cursor.current,node,nodeArray);
                  try
                  {
                     cursor.moveNext();
                  }
                  catch(e:ItemPendingError)
                  {
                     return;
                  }
               }
            }
         }
      }
      
      public function getParentItem(node:Object) : *
      {
         var uid:String = UIDUtil.getUID(node);
         if(parentMap.hasOwnProperty(uid))
         {
            return parentMap[uid];
         }
         return undefined;
      }
      
      public function refresh() : Boolean
      {
         return internalRefresh(true);
      }
      
      public function set filterFunction(value:Function) : void
      {
         _filterFunction = value;
      }
      
      public function removeChildAt(parent:Object, index:int) : Boolean
      {
         var cursor:IViewCursor = null;
         var children:ICollectionView = null;
         if(!parent)
         {
            cursor = treeData.createCursor();
         }
         else
         {
            children = getChildren(parent);
            cursor = children.createCursor();
         }
         try
         {
            cursor.seek(CursorBookmark.FIRST,index);
         }
         catch(e:ItemPendingError)
         {
            return false;
         }
         if(Boolean(cursor.beforeFirst) || Boolean(cursor.afterLast))
         {
            return false;
         }
         cursor.remove();
         return true;
      }
      
      private function internalRefresh(dispatch:Boolean) : Boolean
      {
         var obj:Object = null;
         var coll:ICollectionView = null;
         var refreshEvent:CollectionEvent = null;
         var needUpdate:Boolean = false;
         if(!(treeData.filterFunction == null && filterFunction == null))
         {
            treeData.filterFunction = filterFunction;
            treeData.refresh();
            needUpdate = true;
         }
         for each(obj in openNodes)
         {
            coll = getChildren(obj);
            if(!(coll.filterFunction == null && filterFunction == null))
            {
               coll.filterFunction = filterFunction;
               coll.refresh();
               needUpdate = true;
            }
         }
         if(needUpdate)
         {
            updateLength();
         }
         if(sortCanBeApplied(treeData) && !(treeData.sort == null && sort == null))
         {
            treeData.sort = sort;
            treeData.refresh();
            dispatch = true;
         }
         for each(obj in openNodes)
         {
            coll = getChildren(obj);
            if(sortCanBeApplied(coll) && !(coll.sort == null && sort == null))
            {
               coll.sort = sort;
               coll.refresh();
               dispatch = true;
            }
         }
         if(dispatch)
         {
            refreshEvent = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE);
            refreshEvent.kind = CollectionEventKind.REFRESH;
            dispatchEvent(refreshEvent);
         }
         return true;
      }
      
      public function get length() : int
      {
         return currentLength;
      }
      
      public function calculateLength(node:Object = null, parent:Object = null) : int
      {
         var length:int = 0;
         var childNodes:ICollectionView = null;
         var modelOffset:int = 0;
         var modelCursor:IViewCursor = null;
         var parNode:* = undefined;
         var uid:String = null;
         var childCursor:IViewCursor = null;
         length = 0;
         modelOffset = 0;
         var firstNode:Boolean = true;
         if(node == null)
         {
            modelCursor = treeData.createCursor();
            if(modelCursor.beforeFirst)
            {
               return treeData.length;
            }
            while(!modelCursor.afterLast)
            {
               node = modelCursor.current;
               if(node is XML)
               {
                  if(firstNode)
                  {
                     firstNode = false;
                     parNode = node.parent();
                     if(Boolean(parNode))
                     {
                        startTrackUpdates(parNode);
                        childrenMap[parNode] = treeData;
                        parentNode = parNode;
                     }
                  }
                  startTrackUpdates(node);
               }
               if(node === null)
               {
                  length += 1;
               }
               else
               {
                  length += calculateLength(node,null) + 1;
               }
               modelOffset++;
               try
               {
                  modelCursor.moveNext();
               }
               catch(e:ItemPendingError)
               {
                  length += treeData.length - modelOffset;
                  return length;
               }
            }
         }
         else
         {
            uid = UIDUtil.getUID(node);
            parentMap[uid] = parent;
            if(Boolean(node != null && openNodes[uid]) && Boolean(hierarchicalData.canHaveChildren(node)) && hierarchicalData.hasChildren(node))
            {
               childNodes = getChildren(node);
               if(childNodes != null)
               {
                  childCursor = childNodes.createCursor();
                  try
                  {
                     childCursor.seek(CursorBookmark.FIRST);
                     while(!childCursor.afterLast)
                     {
                        if(node is XML)
                        {
                           startTrackUpdates(childCursor.current);
                        }
                        length += calculateLength(childCursor.current,node) + 1;
                        modelOffset++;
                        try
                        {
                           childCursor.moveNext();
                        }
                        catch(e:ItemPendingError)
                        {
                           length += childNodes.length - modelOffset;
                           return length;
                        }
                     }
                  }
                  catch(e:ItemPendingError)
                  {
                     length += 1;
                  }
               }
            }
         }
         return length;
      }
      
      public function disableAutoUpdate() : void
      {
         var obj:Object = null;
         treeData.disableAutoUpdate();
         for(obj in childrenMap)
         {
            ICollectionView(childrenMap[obj]).disableAutoUpdate();
         }
      }
      
      public function createCursor() : IViewCursor
      {
         return new HierarchicalCollectionViewCursor(this,treeData,hierarchicalData);
      }
      
      public function openNode(node:Object) : void
      {
         var cursor:IViewCursor;
         var childrenCollection:ICollectionView;
         var uid:String = null;
         _openNodes[UIDUtil.getUID(node)] = node;
         childrenCollection = getChildren(node);
         if(!childrenCollection)
         {
            return;
         }
         if(sortCanBeApplied(childrenCollection) && !(childrenCollection.sort == null && sort == null))
         {
            childrenCollection.sort = this.sort;
         }
         if(!(childrenCollection.filterFunction == null && filterFunction == null))
         {
            childrenCollection.filterFunction = this.filterFunction;
         }
         childrenCollection.refresh();
         cursor = childrenCollection.createCursor();
         while(!cursor.afterLast)
         {
            uid = UIDUtil.getUID(cursor.current);
            parentMap[uid] = node;
            try
            {
               cursor.moveNext();
            }
            catch(e:ItemPendingError)
            {
               break;
            }
         }
         updateLength();
      }
      
      public function getChildren(node:Object) : ICollectionView
      {
         var childArray:Array = null;
         var uid:String = UIDUtil.getUID(node);
         var children:* = hierarchicalData.getChildren(node);
         var childrenCollection:ICollectionView = childrenMapCache[uid];
         if(children is XMLList && Boolean(childrenCollection))
         {
            XMLListCollection(childrenCollection).dispatchResetEvent = false;
            XMLListCollection(childrenCollection).source = children;
            childrenCollection.refresh();
         }
         if(Boolean(childrenCollection))
         {
            childrenMap[node] = childrenCollection;
            return childrenCollection;
         }
         if(!children)
         {
            return null;
         }
         if(children is ICollectionView)
         {
            childrenCollection = ICollectionView(children);
         }
         else if(children is Array)
         {
            childrenCollection = new ArrayCollection(children);
         }
         else if(children is XMLList)
         {
            childrenCollection = new XMLListCollection(children);
         }
         else
         {
            childArray = new Array(children);
            if(childArray != null)
            {
               childrenCollection = new ArrayCollection(childArray);
            }
         }
         childrenMapCache[uid] = childrenCollection;
         var oldChildren:ICollectionView = childrenMap[node];
         if(oldChildren != childrenCollection)
         {
            if(oldChildren != null)
            {
               oldChildren.removeEventListener(CollectionEvent.COLLECTION_CHANGE,nestedCollectionChangeHandler);
            }
            childrenCollection.addEventListener(CollectionEvent.COLLECTION_CHANGE,nestedCollectionChangeHandler,false,0,true);
            childrenMap[node] = childrenCollection;
         }
         return childrenCollection;
      }
      
      [Inspectable(category="General")]
      [Bindable("filterFunctionChanged")]
      public function get filterFunction() : Function
      {
         return _filterFunction;
      }
   }
}

