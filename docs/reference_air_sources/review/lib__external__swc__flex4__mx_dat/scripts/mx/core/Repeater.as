package mx.core
{
   import flash.display.DisplayObject;
   import flash.events.Event;
   import mx.automation.IAutomationObject;
   import mx.collections.ArrayCollection;
   import mx.collections.CursorBookmark;
   import mx.collections.ICollectionView;
   import mx.collections.IList;
   import mx.collections.IViewCursor;
   import mx.collections.ItemResponder;
   import mx.collections.ListCollectionView;
   import mx.collections.XMLListCollection;
   import mx.collections.errors.ItemPendingError;
   import mx.events.CollectionEvent;
   import mx.events.CollectionEventKind;
   import mx.events.FlexEvent;
   
   [ResourceBundle("core")]
   [IconFile("Repeater.png")]
   [Event(name="repeatStart",type="mx.events.FlexEvent")]
   [Event(name="repeatEnd",type="mx.events.FlexEvent")]
   [Event(name="repeat",type="mx.events.FlexEvent")]
   public class Repeater extends UIComponent implements IRepeater
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      private var iterator:IViewCursor;
      
      private var created:Boolean = false;
      
      private var descriptorIndex:int;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var createdComponents:Array;
      
      public var childDescriptors:Array;
      
      private var _container:Container;
      
      private var _count:int = -1;
      
      private var _currentIndex:int;
      
      private var collection:ICollectionView;
      
      private var _recycleChildren:Boolean = false;
      
      private var _startingIndex:int = 0;
      
      public function Repeater()
      {
         super();
      }
      
      override public function set showInAutomationHierarchy(value:Boolean) : void
      {
      }
      
      public function get container() : IContainer
      {
         return this._container as IContainer;
      }
      
      [Inspectable(category="General",defaultValue="-1")]
      [Bindable("countChanged")]
      public function get count() : int
      {
         return this._count;
      }
      
      public function set count(value:int) : void
      {
         this._count = value;
         this.execute();
         dispatchEvent(new Event("countChanged"));
      }
      
      [Inspectable(category="General",defaultValue="-1")]
      [Bindable("nextRepeaterItem")]
      public function get currentIndex() : int
      {
         var message:String = null;
         if(this._currentIndex == -1)
         {
            message = resourceManager.getString("core","notExecuting");
            throw new Error(message);
         }
         return this._currentIndex;
      }
      
      [Inspectable(category="General",defaultValue="null")]
      [Bindable("nextRepeaterItem")]
      public function get currentItem() : Object
      {
         var result:Object = null;
         var message:String = null;
         if(this._currentIndex == -1)
         {
            message = resourceManager.getString("core","notExecuting");
            throw new Error(message);
         }
         if(Boolean(this.iterator))
         {
            try
            {
               this.iterator.seek(CursorBookmark.FIRST,this._currentIndex);
               result = this.iterator.current;
            }
            catch(itemPendingError:ItemPendingError)
            {
               itemPendingError.addResponder(new ItemResponder(responderResultHandler,responderFaultHandler));
            }
         }
         return result;
      }
      
      [Inspectable(category="General",defaultValue="null")]
      [Bindable("collectionChange")]
      public function get dataProvider() : Object
      {
         return this.collection;
      }
      
      public function set dataProvider(value:Object) : void
      {
         var xl:XMLList = null;
         var tmp:Array = null;
         var hadValue:Boolean = false;
         if(Boolean(this.collection))
         {
            hadValue = true;
            this.collection.removeEventListener(CollectionEvent.COLLECTION_CHANGE,this.collectionChangedHandler);
            this.collection = null;
            this.iterator = null;
         }
         if(value is Array)
         {
            this.collection = new ArrayCollection(value as Array);
         }
         else if(value is ICollectionView)
         {
            this.collection = ICollectionView(value);
         }
         else if(value is IList)
         {
            this.collection = new ListCollectionView(IList(value));
         }
         else if(value is XMLList)
         {
            this.collection = new XMLListCollection(value as XMLList);
         }
         else if(value is XML)
         {
            xl = new XMLList();
            xl += value;
            this.collection = new XMLListCollection(xl);
         }
         else if(value != null)
         {
            tmp = [value];
            this.collection = new ArrayCollection(tmp);
         }
         if(Boolean(this.collection))
         {
            this.collection.addEventListener(CollectionEvent.COLLECTION_CHANGE,this.collectionChangedHandler,false,0,true);
            this.iterator = this.collection.createCursor();
         }
         dispatchEvent(new Event("collectionChange"));
         if(Boolean(this.collection) || hadValue)
         {
            this.execute();
         }
      }
      
      private function get numCreatedChildren() : int
      {
         var component:IFlexDisplayObject = null;
         var repeater:Repeater = null;
         var result:int = 0;
         for(var i:int = 0; i < this.createdComponents.length; i++)
         {
            component = this.createdComponents[i];
            if(component is Repeater)
            {
               repeater = Repeater(component);
               result += repeater.numCreatedChildren;
            }
            else
            {
               result += 1;
            }
         }
         return result;
      }
      
      [Inspectable(category="Other",defaultValue="false")]
      public function get recycleChildren() : Boolean
      {
         return this._recycleChildren;
      }
      
      public function set recycleChildren(value:Boolean) : void
      {
         this._recycleChildren = value;
      }
      
      [Inspectable(category="General",defaultValue="0")]
      [Bindable("startingIndexChanged")]
      public function get startingIndex() : int
      {
         return this._startingIndex;
      }
      
      public function set startingIndex(value:int) : void
      {
         this._startingIndex = value;
         this.execute();
         dispatchEvent(new Event("startingIndexChanged"));
      }
      
      override public function toString() : String
      {
         return Object(this.container).toString() + "." + super.toString();
      }
      
      public function initializeRepeater(container:IContainer, recurse:Boolean) : void
      {
         this._container = Container(container);
         this.descriptorIndex = container.numChildren;
         this.created = true;
         if(Boolean(this.collection))
         {
            this.createComponentsFromDescriptors(recurse);
         }
         if(owner == null)
         {
            owner = Container(container);
         }
      }
      
      public function executeChildBindings() : void
      {
         var child:IRepeaterClient = null;
         var n:int = int(this.container.numChildren);
         for(var i:int = 0; i < n; i++)
         {
            child = IRepeaterClient(this.container.getChildAt(i));
            if(this.hasDescendant(child) && child is IDeferredInstantiationUIComponent)
            {
               IDeferredInstantiationUIComponent(child).executeBindings();
            }
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function getItemAt(index:int) : Object
      {
         var result:Object = null;
         if(Boolean(this.iterator))
         {
            try
            {
               this.iterator.seek(CursorBookmark.FIRST,index);
               result = this.iterator.current;
            }
            catch(itemPendingError:ItemPendingError)
            {
               itemPendingError.addResponder(new ItemResponder(responderResultHandler,responderFaultHandler));
            }
         }
         return result;
      }
      
      private function responderResultHandler(data:Object, info:Object) : void
      {
         this.execute();
      }
      
      private function responderFaultHandler(data:Object, info:Object) : void
      {
      }
      
      private function hasDescendant(o:Object) : Boolean
      {
         var repeaters:Array = o.repeaters;
         if(repeaters == null)
         {
            return false;
         }
         var n:int = int(repeaters.length);
         for(var i:int = 0; i < n; i++)
         {
            if(repeaters[i] == this)
            {
               return true;
            }
         }
         return false;
      }
      
      private function removeAllChildren(container:IContainer) : void
      {
         var child:IRepeaterClient = null;
         var n:int = int(container.numChildren);
         for(var i:int = n - 1; i >= 0; i--)
         {
            child = IRepeaterClient(container.getChildAt(i));
            if(this.hasDescendant(child))
            {
               if(child is Container)
               {
                  this.removeAllChildren(Container(child));
                  this.removeAllChildRepeaters(Container(child));
               }
               container.removeChildAt(i);
               if(child is IDeferredInstantiationUIComponent)
               {
                  IDeferredInstantiationUIComponent(child).deleteReferenceOnParentDocument(IFlexDisplayObject(parentDocument));
               }
            }
         }
      }
      
      private function removeAllChildRepeaters(container:Container) : void
      {
         var n:int = 0;
         var i:int = 0;
         var repeater:Repeater = null;
         if(Boolean(container.childRepeaters))
         {
            n = int(container.childRepeaters.length);
            for(i = n - 1; i >= 0; i--)
            {
               repeater = container.childRepeaters[i];
               if(this.hasDescendant(repeater))
               {
                  this.removeRepeater(repeater);
               }
            }
         }
      }
      
      private function removeChildRepeater(container:Container, repeater:Repeater) : void
      {
         var i:int = 0;
         var n:int = int(container.childRepeaters.length);
         while(i < n)
         {
            if(container.repeaters[i] == repeater)
            {
               container.repeaters.splice(i,1);
               break;
            }
            i++;
         }
      }
      
      private function createComponentFromDescriptor(instanceIndex:int, descriptorIndex:int, recurse:Boolean) : IFlexDisplayObject
      {
         var descriptor:UIComponentDescriptor = this.childDescriptors[descriptorIndex];
         if(!descriptor.document)
         {
            descriptor.document = document;
         }
         descriptor.instanceIndices = Boolean(instanceIndices) ? instanceIndices : [];
         descriptor.instanceIndices.push(instanceIndex);
         descriptor.repeaters = repeaters;
         descriptor.repeaters.push(this);
         descriptor.repeaterIndices = repeaterIndices;
         descriptor.repeaterIndices.push(this.startingIndex + instanceIndex);
         descriptor.invalidateProperties();
         var child:IFlexDisplayObject = Container(this.container).createComponentFromDescriptor(descriptor,recurse);
         descriptor.instanceIndices = null;
         descriptor.repeaters = null;
         descriptor.repeaterIndices = null;
         dispatchEvent(new Event("nextRepeaterItem"));
         return child;
      }
      
      private function createComponentsFromDescriptors(recurse:Boolean) : void
      {
         var n:int = 0;
         var i:int = 0;
         var m:int = 0;
         var j:int = 0;
         var component:IFlexDisplayObject = null;
         dispatchEvent(new FlexEvent(FlexEvent.REPEAT_START));
         this.createdComponents = [];
         if(Boolean(this.collection) && Boolean(this.collection.length > 0) && this.collection.length - this.startingIndex > 0)
         {
            n = this.positiveMin(this.collection.length - this.startingIndex,this.count);
            for(i = 0; i < n; i++)
            {
               this._currentIndex = this.startingIndex + i;
               dispatchEvent(new FlexEvent(FlexEvent.REPEAT));
               if(Boolean(this.childDescriptors) && this.childDescriptors.length > 0)
               {
                  m = int(this.childDescriptors.length);
                  for(j = 0; j < m; j++)
                  {
                     component = this.createComponentFromDescriptor(i,j,recurse);
                     this.createdComponents.push(component);
                     if(component is IUIComponent)
                     {
                        IUIComponent(component).owner = this;
                     }
                     if(component is IAutomationObject)
                     {
                        IAutomationObject(component).showInAutomationHierarchy = true;
                     }
                  }
               }
            }
            this._currentIndex = -1;
         }
         dispatchEvent(new FlexEvent(FlexEvent.REPEAT_END));
      }
      
      private function getIndexForFirstChild() : int
      {
         var component:IFlexDisplayObject = null;
         var repeater:Repeater = null;
         var locationInfo:LocationInfo = new LocationInfo();
         var i:int = 0;
         var cc:Array = Container(this.container).createdComponents;
         var length:int = Boolean(cc) ? int(cc.length) : 0;
         while(i < length)
         {
            component = Container(this.container).createdComponents[i];
            if(component == this)
            {
               locationInfo.found = true;
               break;
            }
            if(component is Repeater)
            {
               repeater = Repeater(component);
               repeater.getIndexForRepeater(this,locationInfo);
               if(locationInfo.found)
               {
                  break;
               }
            }
            else
            {
               locationInfo.index += 1;
            }
            i++;
         }
         return locationInfo.found ? locationInfo.index : int(this.container.numChildren);
      }
      
      private function getIndexForRepeater(target:Repeater, locationInfo:LocationInfo) : void
      {
         var component:IFlexDisplayObject = null;
         var repeater:Repeater = null;
         var i:int = 0;
         var length:int = int(this.createdComponents.length);
         while(i < length)
         {
            component = this.createdComponents[i];
            if(component == target)
            {
               locationInfo.found = true;
               break;
            }
            if(component is Repeater)
            {
               repeater = Repeater(component);
               repeater.getIndexForRepeater(target,locationInfo);
               if(locationInfo.found)
               {
                  break;
               }
            }
            else
            {
               locationInfo.index += 1;
            }
            i++;
         }
      }
      
      private function reindexDescendants(from:int, to:int) : void
      {
         var child:IRepeaterClient = null;
         var n:int = this.container.numChildren - from;
         for(var i:int = 0; i < n; i++)
         {
            child = IRepeaterClient(this.container.getChildAt(from + i));
            this.container.setChildIndex(DisplayObject(child),to + i);
         }
      }
      
      private function resetRepeaterIndices(o:IRepeaterClient, index:int) : void
      {
         var fc:Container = null;
         var n:int = 0;
         var i:int = 0;
         var child:IRepeaterClient = null;
         var repeaterIndices:Array = o.repeaterIndices;
         repeaterIndices[repeaterIndices.length - 1] = index;
         o.repeaterIndices = repeaterIndices;
         if(o is Container)
         {
            fc = Container(o);
            n = fc.numChildren;
            for(i = 0; i < n; i++)
            {
               child = IRepeaterClient(fc.getChildAt(i));
               this.resetRepeaterIndices(child,index);
            }
         }
      }
      
      private function recycle() : void
      {
         var i:int = 0;
         var m:int = 0;
         var j:int = 0;
         var previousChildIndex:int = 0;
         var repeater:Repeater = null;
         var createdComponent:IRepeaterClient = null;
         var from:int = 0;
         var to:int = 0;
         var component:IRepeaterClient = null;
         var extra:IRepeaterClient = null;
         dispatchEvent(new FlexEvent(FlexEvent.REPEAT_START));
         var n:int = 0;
         var numComponents:int = 0;
         if(Boolean(this.collection) && Boolean(this.collection.length > 0) && this.collection.length - this.startingIndex > 0)
         {
            n = this.positiveMin(this.collection.length - this.startingIndex,this.count);
            previousChildIndex = 0;
            for(i = 0; i < n; i++)
            {
               this._currentIndex = this.startingIndex + i;
               dispatchEvent(new FlexEvent(FlexEvent.REPEAT));
               if(Boolean(this.childDescriptors))
               {
                  m = int(this.childDescriptors.length);
                  if(this.createdComponents.length >= (i + 1) * m)
                  {
                     for(j = 0; j < m; j++)
                     {
                        createdComponent = this.createdComponents[i * m + j];
                        if(createdComponent is Repeater)
                        {
                           repeater = Repeater(createdComponent);
                           this.resetRepeaterIndices(repeater,this._currentIndex);
                           repeater.owner = this;
                           repeater.execute();
                        }
                        else
                        {
                           this.resetRepeaterIndices(createdComponent,this._currentIndex);
                           if(createdComponent is IDeferredInstantiationUIComponent)
                           {
                              IDeferredInstantiationUIComponent(createdComponent).executeBindings(true);
                           }
                        }
                        numComponents++;
                     }
                  }
                  else
                  {
                     for(j = 0; j < m; j++)
                     {
                        from = int(this.container.numChildren);
                        to = this.getIndexForFirstChild() + this.numCreatedChildren;
                        component = IRepeaterClient(this.createComponentFromDescriptor(i,j,true));
                        this.createdComponents.push(component);
                        if(component is IUIComponent)
                        {
                           IUIComponent(component).owner = this;
                        }
                        if(component is IAutomationObject)
                        {
                           IAutomationObject(component).showInAutomationHierarchy = true;
                        }
                        if(component is Repeater)
                        {
                           repeater = Repeater(component);
                           repeater.reindexDescendants(from,to);
                        }
                        else
                        {
                           this.container.setChildIndex(DisplayObject(component),to);
                        }
                        numComponents++;
                     }
                  }
               }
            }
         }
         this._currentIndex = -1;
         for(i = this.createdComponents.length - 1; i >= numComponents; i--)
         {
            extra = this.createdComponents.pop();
            if(extra is Repeater)
            {
               this.removeRepeater(Repeater(extra));
            }
            else if(Boolean(extra))
            {
               if(extra is Container)
               {
                  this.removeAllChildren(Container(extra));
                  this.removeAllChildRepeaters(Container(extra));
               }
               if(this.container.contains(DisplayObject(extra)))
               {
                  this.container.removeChild(DisplayObject(extra));
               }
               if(extra is IDeferredInstantiationUIComponent)
               {
                  IDeferredInstantiationUIComponent(extra).deleteReferenceOnParentDocument(IFlexDisplayObject(parentDocument));
               }
            }
         }
         dispatchEvent(new FlexEvent(FlexEvent.REPEAT_END));
      }
      
      private function recreate() : void
      {
         this.removeAllChildren(this.container);
         this.removeAllChildRepeaters(Container(this.container));
         var from:int = int(this.container.numChildren);
         var to:int = this.getIndexForFirstChild();
         this.createComponentsFromDescriptors(true);
         if(from != to)
         {
            this.reindexDescendants(from,to);
         }
      }
      
      private function execute() : void
      {
         if(!this.created)
         {
            return;
         }
         if(Boolean(this.recycleChildren) && Boolean(this.createdComponents) && this.createdComponents.length > 0)
         {
            this.recycle();
         }
         else
         {
            this.recreate();
         }
      }
      
      private function collectionChangedHandler(collectionEvent:CollectionEvent) : void
      {
         switch(collectionEvent.kind)
         {
            case CollectionEventKind.UPDATE:
               break;
            default:
               this.execute();
         }
      }
      
      private function addItems(firstIndex:int, lastIndex:int) : void
      {
         var i:int = 0;
         var child:IRepeaterClient = null;
         var repeaterIndex:int = 0;
         var numItemsAdded:int = 0;
         var m:int = 0;
         var j:int = 0;
         var from:int = 0;
         var to:int = 0;
         var component:IFlexDisplayObject = null;
         var r:Repeater = null;
         if(this.startingIndex > lastIndex)
         {
            return;
         }
         var index:int = -1;
         var n:int = int(this.container.numChildren);
         if(lastIndex == this.collection.length - 1)
         {
            for(i = n - 1; i >= 0; i--)
            {
               child = IRepeaterClient(this.container.getChildAt(i));
               repeaterIndex = this.getRepeaterIndex(child);
               if(repeaterIndex != -1)
               {
                  index = i + 1;
                  break;
               }
            }
         }
         else
         {
            numItemsAdded = lastIndex - firstIndex + 1;
            for(i = 0; i < n; i++)
            {
               child = IRepeaterClient(this.container.getChildAt(i));
               repeaterIndex = this.getRepeaterIndex(child);
               if(repeaterIndex != -1)
               {
                  if(firstIndex <= repeaterIndex && repeaterIndex <= lastIndex && index == -1)
                  {
                     index = i;
                  }
                  if(repeaterIndex >= firstIndex)
                  {
                     this.adjustIndices(child,numItemsAdded);
                  }
               }
            }
         }
         if(this.count == -1)
         {
            n = lastIndex;
         }
         else
         {
            n = this.positiveMin(this.startingIndex + this.count - 1,lastIndex);
         }
         for(i = Math.max(this.startingIndex,firstIndex); i <= n; i++)
         {
            m = int(this.childDescriptors.length);
            this._currentIndex = i;
            dispatchEvent(new FlexEvent(FlexEvent.REPEAT));
            for(j = 0; j < m; j++)
            {
               from = int(this.container.numChildren);
               to = this.getIndexForFirstChild() + this.numCreatedChildren;
               component = this.createComponentFromDescriptor(i - this.startingIndex,j,true);
               this.createdComponents.push(component);
               if(component is IUIComponent)
               {
                  IUIComponent(component).owner = this;
               }
               if(component is IAutomationObject)
               {
                  IAutomationObject(component).showInAutomationHierarchy = true;
               }
               if(component is Repeater)
               {
                  r = Repeater(component);
                  r.owner = this;
                  r.reindexDescendants(from,to);
               }
               else
               {
                  this.container.setChildIndex(DisplayObject(component),to);
               }
            }
         }
         this._currentIndex = -1;
      }
      
      private function removeItems(firstIndex:int, lastIndex:int) : void
      {
         var i:int = 0;
         var component:IRepeaterClient = null;
         var repeaterIndex:int = 0;
         var repeater:Repeater = null;
         if(Boolean(this.createdComponents) && this.createdComponents.length > 0)
         {
            for(i = this.createdComponents.length - 1; i >= 0; i--)
            {
               component = this.createdComponents[i];
               repeaterIndex = this.getRepeaterIndex(component);
               if(firstIndex <= repeaterIndex && (repeaterIndex < lastIndex || lastIndex == -1) || repeaterIndex >= this.dataProvider.length)
               {
                  if(component is Repeater)
                  {
                     repeater = Repeater(component);
                     this.removeRepeater(repeater);
                  }
                  else if(this.container.contains(DisplayObject(component)))
                  {
                     this.container.removeChild(DisplayObject(component));
                  }
                  if(component is IDeferredInstantiationUIComponent)
                  {
                     IDeferredInstantiationUIComponent(component).deleteReferenceOnParentDocument(IFlexDisplayObject(parentDocument));
                  }
                  this.createdComponents.splice(i,1);
               }
               else if(firstIndex <= repeaterIndex && lastIndex != -1 && repeaterIndex >= lastIndex)
               {
                  this.adjustIndices(component,lastIndex - firstIndex + 1);
                  if(component is IDeferredInstantiationUIComponent)
                  {
                     IDeferredInstantiationUIComponent(component).executeBindings(true);
                  }
               }
            }
         }
      }
      
      private function removeRepeater(repeater:Repeater) : void
      {
         repeater.removeAllChildren(repeater.container);
         repeater.removeAllChildRepeaters(Container(repeater.container));
         this.removeChildRepeater(Container(this.container),repeater);
         repeater.deleteReferenceOnParentDocument(IFlexDisplayObject(parentDocument));
         repeater.dataProvider = null;
      }
      
      private function updateItems(firstIndex:int, lastIndex:int) : void
      {
         var n:int = 0;
         var i:int = 0;
         var child:IRepeaterClient = null;
         var repeaterIndex:int = 0;
         if(this.recycleChildren)
         {
            n = int(this.container.numChildren);
            for(i = 0; i < n; i++)
            {
               child = IRepeaterClient(this.container.getChildAt(i));
               repeaterIndex = this.getRepeaterIndex(child);
               if(repeaterIndex != -1 && firstIndex <= repeaterIndex && repeaterIndex <= lastIndex)
               {
                  if(child is IDeferredInstantiationUIComponent)
                  {
                     IDeferredInstantiationUIComponent(child).executeBindings(true);
                  }
               }
            }
         }
         else
         {
            this.removeItems(firstIndex,lastIndex);
            this.addItems(firstIndex,lastIndex);
         }
      }
      
      private function sort() : void
      {
         this.execute();
      }
      
      private function getRepeaterIndex(o:IRepeaterClient) : int
      {
         var repeaters:Array = o.repeaters;
         if(repeaters == null)
         {
            return -1;
         }
         var n:int = int(repeaters.length);
         for(var i:int = 0; i < n; i++)
         {
            if(repeaters[i] == this)
            {
               return o.repeaterIndices[i];
            }
         }
         return -1;
      }
      
      private function adjustIndices(o:IRepeaterClient, adjustment:int) : void
      {
         var repeaters:Array = o.repeaters;
         if(repeaters == null)
         {
            return;
         }
         var n:int = int(repeaters.length);
         for(var i:int = 0; i < n; i++)
         {
            if(repeaters[i] == this)
            {
               o.repeaterIndices[i] += adjustment;
               o.instanceIndices[i] += adjustment;
               break;
            }
         }
      }
      
      private function positiveMin(x:int, y:int) : int
      {
         var result:int = 0;
         if(x >= 0)
         {
            if(y >= 0)
            {
               if(x < y)
               {
                  result = x;
               }
               else
               {
                  result = y;
               }
            }
            else
            {
               result = x;
            }
         }
         else
         {
            result = y;
         }
         return result;
      }
   }
}

class LocationInfo
{
   
   public var found:Boolean = false;
   
   public var index:int = 0;
   
   public function LocationInfo()
   {
      super();
   }
}
