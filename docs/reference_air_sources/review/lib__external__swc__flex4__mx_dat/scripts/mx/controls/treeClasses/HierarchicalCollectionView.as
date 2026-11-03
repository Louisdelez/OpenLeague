package mx.controls.treeClasses
{
   import flash.events.EventDispatcher;
   import flash.utils.Dictionary;
   import mx.collections.ICollectionView;
   import mx.collections.ISort;
   import mx.collections.IViewCursor;
   import mx.collections.XMLListAdapter;
   import mx.collections.XMLListCollection;
   import mx.collections.errors.ItemPendingError;
   import mx.core.EventPriority;
   import mx.events.CollectionEvent;
   import mx.events.CollectionEventKind;
   import mx.events.PropertyChangeEvent;
   import mx.utils.IXMLNotifiable;
   import mx.utils.XMLNotifier;
   
   [ExcludeClass]
   public class HierarchicalCollectionView extends EventDispatcher implements ICollectionView, IXMLNotifiable
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      private var dataDescriptor:ITreeDataDescriptor;
      
      private var treeData:ICollectionView;
      
      private var cursor:HierarchicalViewCursor;
      
      private var currentLength:int;
      
      public var openNodes:Object;
      
      public var parentMap:Object;
      
      private var parentNode:XML;
      
      private var childrenMap:Dictionary;
      
      private var itemToUID:Function;
      
      public function HierarchicalCollectionView(model:ICollectionView, treeDataDescriptor:ITreeDataDescriptor, itemToUID:Function, argOpenNodes:Object = null)
      {
         super();
         this.parentMap = {};
         this.childrenMap = new Dictionary(true);
         this.treeData = model;
         this.treeData.addEventListener(CollectionEvent.COLLECTION_CHANGE,this.collectionChangeHandler,false,EventPriority.DEFAULT_HANDLER,true);
         addEventListener(CollectionEvent.COLLECTION_CHANGE,this.expandEventHandler,false,0,true);
         this.dataDescriptor = treeDataDescriptor;
         this.itemToUID = itemToUID;
         this.openNodes = argOpenNodes;
         this.currentLength = this.calculateLength();
      }
      
      public function get filterFunction() : Function
      {
         return null;
      }
      
      public function set filterFunction(value:Function) : void
      {
      }
      
      public function get length() : int
      {
         return this.currentLength;
      }
      
      public function get sort() : ISort
      {
         return null;
      }
      
      public function set sort(value:ISort) : void
      {
      }
      
      public function getParentItem(node:Object) : *
      {
         var uid:String = this.itemToUID(node);
         if(this.parentMap.hasOwnProperty(uid))
         {
            return this.parentMap[uid];
         }
         return undefined;
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
            modelCursor = this.treeData.createCursor();
            if(modelCursor.beforeFirst)
            {
               return this.treeData.length;
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
                        this.startTrackUpdates(parNode);
                        this.childrenMap[parNode] = this.treeData;
                        this.parentNode = parNode;
                     }
                  }
                  this.startTrackUpdates(node);
               }
               if(node === null)
               {
                  length += 1;
               }
               else
               {
                  length += this.calculateLength(node,null) + 1;
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
            uid = this.itemToUID(node);
            this.parentMap[uid] = parent;
            if(Boolean(node != null && this.openNodes[uid]) && Boolean(this.dataDescriptor.isBranch(node,this.treeData)) && this.dataDescriptor.hasChildren(node,this.treeData))
            {
               childNodes = this.getChildren(node);
               if(childNodes != null)
               {
                  numChildren = int(childNodes.length);
                  for(i = 0; i < numChildren; i++)
                  {
                     if(node is XML)
                     {
                        this.startTrackUpdates(childNodes[i]);
                     }
                     length += this.calculateLength(childNodes[i],node) + 1;
                  }
               }
            }
         }
         return length;
      }
      
      public function describeData() : Object
      {
         return null;
      }
      
      public function createCursor() : IViewCursor
      {
         return new HierarchicalViewCursor(this,this.treeData,this.dataDescriptor,this.itemToUID,this.openNodes);
      }
      
      public function contains(item:Object) : Boolean
      {
         var cursor:IViewCursor = this.createCursor();
         var done:Boolean = false;
         while(!done)
         {
            if(cursor.current == item)
            {
               return true;
            }
            done = Boolean(cursor.moveNext());
         }
         return false;
      }
      
      public function disableAutoUpdate() : void
      {
      }
      
      public function enableAutoUpdate() : void
      {
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
      
      public function refresh() : Boolean
      {
         var event:CollectionEvent = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE);
         event.kind = CollectionEventKind.REFRESH;
         dispatchEvent(event);
         return true;
      }
      
      private function getChildren(node:Object) : ICollectionView
      {
         var children:ICollectionView = this.dataDescriptor.getChildren(node,this.treeData);
         var oldChildren:ICollectionView = this.childrenMap[node];
         if(oldChildren != children)
         {
            if(oldChildren != null)
            {
               oldChildren.removeEventListener(CollectionEvent.COLLECTION_CHANGE,this.nestedCollectionChangeHandler);
            }
            if(Boolean(children))
            {
               children.addEventListener(CollectionEvent.COLLECTION_CHANGE,this.nestedCollectionChangeHandler,false,0,true);
               this.childrenMap[node] = children;
            }
            else
            {
               delete this.childrenMap[node];
            }
         }
         return children;
      }
      
      private function updateLength(node:Object = null, parent:Object = null) : void
      {
         this.currentLength = this.calculateLength();
      }
      
      private function getVisibleNodes(node:Object, parent:Object, nodeArray:Array) : void
      {
         var childNodes:ICollectionView = null;
         var numChildren:int = 0;
         var i:int = 0;
         nodeArray.push(node);
         var uid:String = this.itemToUID(node);
         this.parentMap[uid] = parent;
         if(Boolean(this.openNodes[uid]) && Boolean(this.dataDescriptor.isBranch(node,this.treeData)) && this.dataDescriptor.hasChildren(node,this.treeData))
         {
            childNodes = this.getChildren(node);
            if(childNodes != null)
            {
               numChildren = int(childNodes.length);
               for(i = 0; i < numChildren; i++)
               {
                  this.getVisibleNodes(childNodes[i],node,nodeArray);
               }
            }
         }
      }
      
      private function getVisibleLocation(oldLocation:int) : int
      {
         var newLocation:int = 0;
         var modelCursor:IViewCursor = this.treeData.createCursor();
         var i:int = 0;
         while(i < oldLocation && !modelCursor.afterLast)
         {
            newLocation += this.calculateLength(modelCursor.current,null) + 1;
            modelCursor.moveNext();
            i++;
         }
         return newLocation;
      }
      
      private function getVisibleLocationInSubCollection(parent:Object, oldLocation:int) : int
      {
         var children:ICollectionView = null;
         var cursor:IViewCursor = null;
         var newLocation:int = oldLocation;
         var target:Object = parent;
         parent = this.getParentItem(parent);
         while(parent != null)
         {
            children = this.childrenMap[parent];
            cursor = children.createCursor();
            while(!cursor.afterLast)
            {
               if(cursor.current == target)
               {
                  newLocation++;
                  break;
               }
               newLocation += this.calculateLength(cursor.current,parent) + 1;
               cursor.moveNext();
            }
            target = parent;
            parent = this.getParentItem(parent);
         }
         cursor = this.treeData.createCursor();
         while(!cursor.afterLast)
         {
            if(cursor.current == target)
            {
               newLocation++;
               break;
            }
            newLocation += this.calculateLength(cursor.current,parent) + 1;
            cursor.moveNext();
         }
         return newLocation;
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
               this.updateLength();
               dispatchEvent(event);
            }
            else if(ce.kind == CollectionEventKind.ADD)
            {
               n = int(ce.items.length);
               convertedEvent = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE,false,true,ce.kind);
               convertedEvent.location = this.getVisibleLocation(ce.location);
               for(i = 0; i < n; i++)
               {
                  node = ce.items[i];
                  if(node is XML)
                  {
                     this.startTrackUpdates(node);
                  }
                  this.getVisibleNodes(node,null,convertedEvent.items);
               }
               this.currentLength += convertedEvent.items.length;
               dispatchEvent(convertedEvent);
            }
            else if(ce.kind == CollectionEventKind.REMOVE)
            {
               n = int(ce.items.length);
               convertedEvent = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE,false,true,ce.kind);
               convertedEvent.location = this.getVisibleLocation(ce.location);
               for(i = 0; i < n; i++)
               {
                  node = ce.items[i];
                  if(node is XML)
                  {
                     this.stopTrackUpdates(node);
                  }
                  this.getVisibleNodes(node,null,convertedEvent.items);
               }
               this.currentLength -= convertedEvent.items.length;
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
                     this.stopTrackUpdates(node);
                  }
                  this.getVisibleNodes(node,null,convertedEvent.items);
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
                  this.currentLength -= convertedEvent.items.length;
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
               this.updateLength();
               n = int(ce.items.length);
               convertedEvent = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE,false,true,ce.kind);
               for(i = 0; i < n; i++)
               {
                  node = ce.items[i];
                  if(node is XML)
                  {
                     this.startTrackUpdates(node);
                  }
                  parent = this.getParentItem(node);
                  if(parent != null)
                  {
                     this.getVisibleNodes(node,parent,convertedEvent.items);
                  }
               }
               convertedEvent.location = this.getVisibleLocationInSubCollection(parent,ce.location);
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
                     this.stopTrackUpdates(node);
                  }
                  parent = this.getParentItem(node);
                  if(parent != null)
                  {
                     this.getVisibleNodes(node,parent,convertedEvent.items);
                  }
               }
               convertedEvent.location = this.getVisibleLocationInSubCollection(parent,ce.location);
               this.currentLength -= convertedEvent.items.length;
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
                  parent = this.getParentItem(node);
                  if(parent != null)
                  {
                     this.getVisibleNodes(node,parent,convertedEvent.items);
                  }
               }
               j = 0;
               for(i = 0; i < n; i++)
               {
                  node = ce.items[i].oldValue;
                  if(node is XML)
                  {
                     this.stopTrackUpdates(node);
                  }
                  while(convertedEvent.items[j] != node)
                  {
                     j++;
                  }
                  convertedEvent.items.splice(j,1);
               }
               if(Boolean(convertedEvent.items.length))
               {
                  this.currentLength -= convertedEvent.items.length;
                  dispatchEvent(convertedEvent);
               }
               dispatchEvent(event);
            }
            else if(ce.kind == CollectionEventKind.RESET)
            {
               this.updateLength();
               convertedEvent = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE,false,true,CollectionEventKind.REFRESH);
               dispatchEvent(convertedEvent);
            }
         }
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
                  for(q in this.childrenMap)
                  {
                     if(q === currentTarget)
                     {
                        list = this.childrenMap[q].list as XMLListAdapter;
                        break;
                     }
                  }
                  if(!list && target is XML && XML(target).children().length() == 1)
                  {
                     list = (this.getChildren(target) as XMLListCollection).list as XMLListAdapter;
                  }
                  if(Boolean(list) && !list.busy())
                  {
                     if(this.childrenMap[q] === this.treeData)
                     {
                        children = this.treeData as XMLListCollection;
                        if(Boolean(this.parentNode))
                        {
                           children.dispatchResetEvent = false;
                           children.source = this.parentNode.*;
                        }
                     }
                     else
                     {
                        children = this.getChildren(q) as XMLListCollection;
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
                  for(p in this.childrenMap)
                  {
                     if(p === currentTarget)
                     {
                        children = this.childrenMap[p];
                        list = children.list as XMLListAdapter;
                        if(Boolean(list) && !list.busy())
                        {
                           xmllist = children.source as XMLList;
                           if(this.childrenMap[p] === this.treeData)
                           {
                              children = this.treeData as XMLListCollection;
                              if(Boolean(this.parentNode))
                              {
                                 children.dispatchResetEvent = false;
                                 children.source = this.parentNode.*;
                              }
                           }
                           else
                           {
                              oldChildren = children;
                              children = this.getChildren(p) as XMLListCollection;
                              if(!children)
                              {
                                 oldChildren.addEventListener(CollectionEvent.COLLECTION_CHANGE,this.nestedCollectionChangeHandler,false,0,true);
                                 event = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE);
                                 event.kind = CollectionEventKind.REMOVE;
                                 event.location = 0;
                                 event.items = [value];
                                 oldChildren.dispatchEvent(event);
                                 oldChildren.removeEventListener(CollectionEvent.COLLECTION_CHANGE,this.nestedCollectionChangeHandler);
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
      
      private function startTrackUpdates(item:Object) : void
      {
         XMLNotifier.getInstance().watchXML(item,this);
      }
      
      private function stopTrackUpdates(item:Object) : void
      {
         XMLNotifier.getInstance().unwatchXML(item,this);
      }
      
      public function expandEventHandler(event:CollectionEvent) : void
      {
         var ce:CollectionEvent = null;
         if(event is CollectionEvent)
         {
            ce = CollectionEvent(event);
            if(ce.kind == CollectionEventKind.EXPAND)
            {
               event.stopImmediatePropagation();
               this.updateLength();
            }
         }
      }
   }
}

