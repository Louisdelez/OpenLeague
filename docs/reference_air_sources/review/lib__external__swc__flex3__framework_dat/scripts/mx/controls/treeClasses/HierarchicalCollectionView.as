package mx.controls.treeClasses
{
   import flash.events.EventDispatcher;
   import flash.utils.Dictionary;
   import mx.collections.ICollectionView;
   import mx.collections.IViewCursor;
   import mx.collections.Sort;
   import mx.collections.XMLListAdapter;
   import mx.collections.XMLListCollection;
   import mx.collections.errors.ItemPendingError;
   import mx.core.EventPriority;
   import mx.core.mx_internal;
   import mx.events.CollectionEvent;
   import mx.events.CollectionEventKind;
   import mx.events.PropertyChangeEvent;
   import mx.utils.IXMLNotifiable;
   import mx.utils.XMLNotifier;
   
   use namespace mx_internal;
   
   [ExcludeClass]
   public class HierarchicalCollectionView extends EventDispatcher implements ICollectionView, IXMLNotifiable
   {
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      private var itemToUID:Function;
      
      public var openNodes:Object;
      
      private var dataDescriptor:ITreeDataDescriptor;
      
      private var currentLength:int;
      
      private var parentNode:XML;
      
      public var parentMap:Object;
      
      private var cursor:HierarchicalViewCursor;
      
      private var childrenMap:Dictionary;
      
      private var treeData:ICollectionView;
      
      public function HierarchicalCollectionView(model:ICollectionView, treeDataDescriptor:ITreeDataDescriptor, itemToUID:Function, argOpenNodes:Object = null)
      {
         super();
         parentMap = {};
         childrenMap = new Dictionary(true);
         treeData = model;
         treeData.addEventListener(CollectionEvent.COLLECTION_CHANGE,collectionChangeHandler,false,EventPriority.DEFAULT_HANDLER,true);
         addEventListener(CollectionEvent.COLLECTION_CHANGE,expandEventHandler,false,0,true);
         dataDescriptor = treeDataDescriptor;
         this.itemToUID = itemToUID;
         openNodes = argOpenNodes;
         currentLength = calculateLength();
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
            if(ce.kind == CollectionEventKind.mx_internal::EXPAND)
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
      
      public function expandEventHandler(event:CollectionEvent) : void
      {
         var ce:CollectionEvent = null;
         if(event is CollectionEvent)
         {
            ce = CollectionEvent(event);
            if(ce.kind == CollectionEventKind.mx_internal::EXPAND)
            {
               event.stopImmediatePropagation();
               updateLength();
            }
         }
      }
      
      private function updateLength(node:Object = null, parent:Object = null) : void
      {
         currentLength = calculateLength();
      }
      
      private function startTrackUpdates(item:Object) : void
      {
         XMLNotifier.getInstance().watchXML(item,this);
      }
      
      private function getVisibleLocation(oldLocation:int) : int
      {
         var newLocation:int = 0;
         var modelCursor:IViewCursor = treeData.createCursor();
         var i:int = 0;
         while(i < oldLocation && !modelCursor.afterLast)
         {
            newLocation += calculateLength(modelCursor.current,null) + 1;
            modelCursor.moveNext();
            i++;
         }
         return newLocation;
      }
      
      public function describeData() : Object
      {
         return null;
      }
      
      public function get sort() : Sort
      {
         return null;
      }
      
      public function contains(item:Object) : Boolean
      {
         var cursor:IViewCursor = createCursor();
         var done:Boolean = false;
         while(!done)
         {
            if(cursor.current == item)
            {
               return true;
            }
            done = cursor.moveNext();
         }
         return false;
      }
      
      private function stopTrackUpdates(item:Object) : void
      {
         XMLNotifier.getInstance().unwatchXML(item,this);
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
                        break;
                     }
                  }
                  if(!list && target is XML && XML(target).children().length() == 1)
                  {
                     list = (getChildren(target) as XMLListCollection).list as XMLListAdapter;
                  }
                  if(Boolean(list) && !list.busy())
                  {
                     if(childrenMap[q] === treeData)
                     {
                        children = treeData as XMLListCollection;
                        if(Boolean(parentNode))
                        {
                           children.mx_internal::dispatchResetEvent = false;
                           children.source = parentNode.*;
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
                                 children.mx_internal::dispatchResetEvent = false;
                                 children.source = parentNode.*;
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
      
      public function itemUpdated(item:Object, property:Object = null, oldValue:Object = null, newValue:Object = null) : void
      {
         var event:CollectionEvent = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE);
         event.kind = CollectionEventKind.UPDATE;
         var objEvent:PropertyChangeEvent = new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE);
         objEvent.property = property;
         objEvent.oldValue = oldValue;
         objEvent.newValue = newValue;
         event.items.push(objEvent);
         dispatchEvent(event);
      }
      
      public function enableAutoUpdate() : void
      {
      }
      
      public function set sort(value:Sort) : void
      {
      }
      
      public function getParentItem(node:Object) : *
      {
         var uid:String = itemToUID(node);
         if(parentMap.hasOwnProperty(uid))
         {
            return parentMap[uid];
         }
         return undefined;
      }
      
      private function getVisibleNodes(node:Object, parent:Object, nodeArray:Array) : void
      {
         var childNodes:ICollectionView = null;
         var numChildren:int = 0;
         var i:int = 0;
         nodeArray.push(node);
         var uid:String = itemToUID(node);
         parentMap[uid] = parent;
         if(Boolean(openNodes[uid]) && Boolean(dataDescriptor.isBranch(node,treeData)) && dataDescriptor.hasChildren(node,treeData))
         {
            childNodes = getChildren(node);
            if(childNodes != null)
            {
               numChildren = childNodes.length;
               for(i = 0; i < numChildren; i++)
               {
                  getVisibleNodes(childNodes[i],node,nodeArray);
               }
            }
         }
      }
      
      public function refresh() : Boolean
      {
         var event:CollectionEvent = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE);
         event.kind = CollectionEventKind.REFRESH;
         dispatchEvent(event);
         return true;
      }
      
      public function get length() : int
      {
         return currentLength;
      }
      
      public function set filterFunction(value:Function) : void
      {
      }
      
      public function calculateLength(node:Object = null, parent:Object = null) : int
      {
         var length:int = 0;
         var childNodes:ICollectionView = null;
         var modelOffset:int = 0;
         var modelCursor:IViewCursor = null;
         var parNode:* = undefined;
         var uid:String = null;
         var numChildren:int = 0;
         var i:int = 0;
         length = 0;
         var firstNode:Boolean = true;
         if(node == null)
         {
            modelOffset = 0;
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
            uid = itemToUID(node);
            parentMap[uid] = parent;
            if(Boolean(node != null && openNodes[uid]) && Boolean(dataDescriptor.isBranch(node,treeData)) && dataDescriptor.hasChildren(node,treeData))
            {
               childNodes = getChildren(node);
               if(childNodes != null)
               {
                  numChildren = childNodes.length;
                  for(i = 0; i < numChildren; i++)
                  {
                     if(node is XML)
                     {
                        startTrackUpdates(childNodes[i]);
                     }
                     length += calculateLength(childNodes[i],node) + 1;
                  }
               }
            }
         }
         return length;
      }
      
      public function disableAutoUpdate() : void
      {
      }
      
      public function createCursor() : IViewCursor
      {
         return new HierarchicalViewCursor(this,treeData,dataDescriptor,itemToUID,openNodes);
      }
      
      private function getChildren(node:Object) : ICollectionView
      {
         var children:ICollectionView = dataDescriptor.getChildren(node,treeData);
         var oldChildren:ICollectionView = childrenMap[node];
         if(oldChildren != children)
         {
            if(oldChildren != null)
            {
               oldChildren.removeEventListener(CollectionEvent.COLLECTION_CHANGE,nestedCollectionChangeHandler);
            }
            if(Boolean(children))
            {
               children.addEventListener(CollectionEvent.COLLECTION_CHANGE,nestedCollectionChangeHandler,false,0,true);
               childrenMap[node] = children;
            }
            else
            {
               delete childrenMap[node];
            }
         }
         return children;
      }
      
      public function get filterFunction() : Function
      {
         return null;
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
               updateLength();
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
   }
}

