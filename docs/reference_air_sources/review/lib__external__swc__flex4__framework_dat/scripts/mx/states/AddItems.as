package mx.states
{
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.events.IEventDispatcher;
   import mx.collections.IList;
   import mx.core.ContainerCreationPolicy;
   import mx.core.IChildList;
   import mx.core.IDeferredContentOwner;
   import mx.core.ITransientDeferredInstance;
   import mx.core.IVisualElement;
   import mx.core.IVisualElementContainer;
   import mx.core.UIComponent;
   import mx.core.mx_internal;
   
   use namespace mx_internal;
   
   [DefaultProperty("itemsFactory")]
   public class AddItems extends OverrideBase
   {
      
      mx_internal static const VERSION:String = "4.6.0.23201";
      
      public static const FIRST:String = "first";
      
      public static const LAST:String = "last";
      
      public static const BEFORE:String = "before";
      
      public static const AFTER:String = "after";
      
      private var added:Boolean = false;
      
      private var startIndex:int;
      
      private var numAdded:int;
      
      private var instanceCreated:Boolean = false;
      
      private var _creationPolicy:String = "auto";
      
      private var _destructionPolicy:String = "never";
      
      public var destination:Object;
      
      private var _items:*;
      
      private var _itemsFactory:ITransientDeferredInstance;
      
      [Inspectable(category="General")]
      public var position:String = "last";
      
      [Inspectable(category="General")]
      public var isStyle:Boolean = false;
      
      [Inspectable(category="General")]
      public var isArray:Boolean = false;
      
      [Inspectable(category="General")]
      public var vectorClass:Class;
      
      [Inspectable(category="General")]
      public var propertyName:String;
      
      [Inspectable(category="General")]
      public var relativeTo:Object;
      
      private var _waitingForDeferredContent:Boolean = false;
      
      public function AddItems()
      {
         super();
      }
      
      [Inspectable(category="General")]
      public function get creationPolicy() : String
      {
         return this._creationPolicy;
      }
      
      public function set creationPolicy(value:String) : void
      {
         this._creationPolicy = value;
         if(this._creationPolicy == ContainerCreationPolicy.ALL)
         {
            this.createInstance();
         }
      }
      
      [Inspectable(category="General")]
      public function get destructionPolicy() : String
      {
         return this._destructionPolicy;
      }
      
      public function set destructionPolicy(value:String) : void
      {
         this._destructionPolicy = value;
      }
      
      [Inspectable(category="General")]
      public function get items() : *
      {
         if(!this._items && this.creationPolicy != ContainerCreationPolicy.NONE)
         {
            this.createInstance();
         }
         return this._items;
      }
      
      public function set items(value:*) : void
      {
         this._items = value;
      }
      
      [Inspectable(category="General")]
      public function get itemsFactory() : ITransientDeferredInstance
      {
         return this._itemsFactory;
      }
      
      public function set itemsFactory(value:ITransientDeferredInstance) : void
      {
         this._itemsFactory = value;
         if(this.creationPolicy == ContainerCreationPolicy.ALL)
         {
            this.createInstance();
         }
      }
      
      public function createInstance() : void
      {
         if(!this.instanceCreated && !this._items && Boolean(this.itemsFactory))
         {
            this.instanceCreated = true;
            this.items = this.itemsFactory.getInstance();
         }
      }
      
      override public function initialize() : void
      {
         if(this.creationPolicy == ContainerCreationPolicy.AUTO)
         {
            this.createInstance();
         }
      }
      
      override public function apply(parent:UIComponent) : void
      {
         var dest:* = undefined;
         var localItems:Array = null;
         dest = getOverrideContext(this.destination,parent);
         this.added = false;
         parentContext = parent;
         if(!dest)
         {
            if(this.destination != null && !applied)
            {
               addContextListener(this.destination);
            }
            applied = true;
            return;
         }
         applied = true;
         this.destination = dest;
         if(this.items is Array && !this.isArray)
         {
            localItems = this.items;
         }
         else
         {
            localItems = [this.items];
         }
         switch(this.position)
         {
            case FIRST:
               this.startIndex = 0;
               break;
            case LAST:
               this.startIndex = -1;
               break;
            case BEFORE:
               this.startIndex = this.getRelatedIndex(parent,dest);
               break;
            case AFTER:
               this.startIndex = this.getRelatedIndex(parent,dest) + 1;
         }
         if((this.propertyName == null || this.propertyName == "mxmlContent") && dest is IVisualElementContainer)
         {
            if(!this.addItemsToContentHolder(dest as IVisualElementContainer,localItems))
            {
               return;
            }
         }
         else if(this.propertyName == null && dest is IChildList)
         {
            this.addItemsToContainer(dest as IChildList,localItems);
         }
         else if(this.propertyName != null && !this.isStyle && dest[this.propertyName] is IList)
         {
            this.addItemsToIList(dest[this.propertyName],localItems);
         }
         else if(Boolean(this.vectorClass))
         {
            this.addItemsToVector(dest,this.propertyName,localItems);
         }
         else
         {
            this.addItemsToArray(dest,this.propertyName,localItems);
         }
         this.added = true;
         this.numAdded = localItems.length;
      }
      
      override public function remove(parent:UIComponent) : void
      {
         var localItems:Array = null;
         var i:int = 0;
         var tempVector:Object = null;
         var tempArray:Array = null;
         var dest:* = getOverrideContext(this.destination,parent);
         if(!this.added)
         {
            if(dest == null)
            {
               removeContextListener();
            }
            else if(this._waitingForDeferredContent)
            {
               this.removeCreationCompleteListener();
            }
            applied = false;
            parentContext = null;
            return;
         }
         if(this.items is Array && !this.isArray)
         {
            localItems = this.items;
         }
         else
         {
            localItems = [this.items];
         }
         if((this.propertyName == null || this.propertyName == "mxmlContent") && dest is IVisualElementContainer)
         {
            for(i = 0; i < this.numAdded; i++)
            {
               if(IVisualElementContainer(dest).numElements > this.startIndex)
               {
                  IVisualElementContainer(dest).removeElementAt(this.startIndex);
               }
            }
         }
         else if(this.propertyName == null && dest is IChildList)
         {
            for(i = 0; i < this.numAdded; i++)
            {
               if(IChildList(dest).numChildren > this.startIndex)
               {
                  IChildList(dest).removeChildAt(this.startIndex);
               }
            }
         }
         else if(this.propertyName != null && !this.isStyle && dest[this.propertyName] is IList)
         {
            this.removeItemsFromIList(dest[this.propertyName] as IList);
         }
         else if(Boolean(this.vectorClass))
         {
            tempVector = this.isStyle ? dest.getStyle(this.propertyName) : dest[this.propertyName];
            if(this.numAdded < tempVector.length)
            {
               tempVector.splice(this.startIndex,this.numAdded);
               this.assign(dest,this.propertyName,tempVector);
            }
            else
            {
               this.assign(dest,this.propertyName,new this.vectorClass());
            }
         }
         else
         {
            tempArray = this.isStyle ? dest.getStyle(this.propertyName) : dest[this.propertyName];
            if(this.numAdded < tempArray.length)
            {
               tempArray.splice(this.startIndex,this.numAdded);
               this.assign(dest,this.propertyName,tempArray);
            }
            else
            {
               this.assign(dest,this.propertyName,new Array());
            }
         }
         if(this.destructionPolicy == "auto")
         {
            this.destroyInstance();
         }
         this.added = false;
         applied = false;
         parentContext = null;
      }
      
      private function destroyInstance() : void
      {
         if(Boolean(this._itemsFactory))
         {
            this.instanceCreated = false;
            this.items = null;
            this._itemsFactory.reset();
         }
      }
      
      protected function getObjectIndex(object:Object, dest:Object) : int
      {
         try
         {
            if((this.propertyName == null || this.propertyName == "mxmlContent") && dest is IVisualElementContainer)
            {
               return IVisualElementContainer(dest).getElementIndex(object as IVisualElement);
            }
            if(this.propertyName == null && dest is IChildList)
            {
               return IChildList(dest).getChildIndex(DisplayObject(object));
            }
            if(this.propertyName != null && !this.isStyle && dest[this.propertyName] is IList)
            {
               return IList(dest[this.propertyName].list).getItemIndex(object);
            }
            if(this.propertyName != null && this.isStyle)
            {
               return dest.getStyle(this.propertyName).indexOf(object);
            }
            return dest[this.propertyName].indexOf(object);
         }
         catch(e:Error)
         {
         }
         return -1;
      }
      
      protected function getRelatedIndex(parent:UIComponent, dest:Object) : int
      {
         var i:int = 0;
         var relativeObject:Object = null;
         var index:int = -1;
         if(this.relativeTo is Array)
         {
            i = 0;
            while(i < this.relativeTo.length && index < 0)
            {
               relativeObject = getOverrideContext(this.relativeTo[i],parent);
               index = this.getObjectIndex(relativeObject,dest);
               i++;
            }
         }
         else
         {
            relativeObject = getOverrideContext(this.relativeTo,parent);
            index = this.getObjectIndex(relativeObject,dest);
         }
         return index;
      }
      
      protected function addItemsToContentHolder(dest:IVisualElementContainer, items:Array) : Boolean
      {
         var dco:IDeferredContentOwner = null;
         if(dest is IDeferredContentOwner && dest is IEventDispatcher)
         {
            dco = dest as IDeferredContentOwner;
            if(!dco.deferredContentCreated)
            {
               IEventDispatcher(dest).addEventListener("contentCreationComplete",this.onDestinationContentCreated);
               this._waitingForDeferredContent = true;
               return false;
            }
         }
         if(this.startIndex == -1)
         {
            this.startIndex = dest.numElements;
         }
         for(var i:int = 0; i < items.length; i++)
         {
            dest.addElementAt(items[i],this.startIndex + i);
         }
         return true;
      }
      
      protected function addItemsToContainer(dest:IChildList, items:Array) : void
      {
         if(this.startIndex == -1)
         {
            this.startIndex = dest.numChildren;
         }
         for(var i:int = 0; i < items.length; i++)
         {
            dest.addChildAt(items[i],this.startIndex + i);
         }
      }
      
      protected function addItemsToArray(dest:Object, propertyName:String, items:Array) : void
      {
         var tempArray:Array = this.isStyle ? dest.getStyle(propertyName) : dest[propertyName];
         if(!tempArray)
         {
            tempArray = new Array();
         }
         if(this.startIndex == -1)
         {
            this.startIndex = tempArray.length;
         }
         for(var i:int = 0; i < items.length; i++)
         {
            tempArray.splice(this.startIndex + i,0,items[i]);
         }
         this.assign(dest,propertyName,tempArray);
      }
      
      protected function addItemsToVector(dest:Object, propertyName:String, items:Array) : void
      {
         var tempVector:Object = this.isStyle ? dest.getStyle(propertyName) : dest[propertyName];
         if(!tempVector)
         {
            tempVector = new this.vectorClass();
         }
         if(this.startIndex == -1)
         {
            this.startIndex = tempVector.length;
         }
         for(var i:int = 0; i < items.length; i++)
         {
            tempVector.splice(this.startIndex + i,0,items[i]);
         }
         this.assign(dest,propertyName,tempVector);
      }
      
      protected function addItemsToIList(list:IList, items:Array) : void
      {
         if(this.startIndex == -1)
         {
            this.startIndex = list.length;
         }
         for(var i:int = 0; i < items.length; i++)
         {
            list.addItemAt(items[i],this.startIndex + i);
         }
      }
      
      protected function removeItemsFromIList(list:IList) : void
      {
         for(var i:int = 0; i < this.numAdded; i++)
         {
            list.removeItemAt(this.startIndex);
         }
      }
      
      protected function assign(dest:Object, propertyName:String, value:Object) : void
      {
         if(this.isStyle)
         {
            dest.setStyle(propertyName,value);
            dest.styleChanged(propertyName);
            dest.notifyStyleChangeInChildren(propertyName,true);
         }
         else
         {
            dest[propertyName] = value;
         }
      }
      
      private function onDestinationContentCreated(e:Event) : void
      {
         if(Boolean(parentContext))
         {
            this.removeCreationCompleteListener();
            this.apply(parentContext);
         }
      }
      
      private function removeCreationCompleteListener() : void
      {
         if(Boolean(parentContext))
         {
            parentContext.removeEventListener("contentCreationComplete",this.onDestinationContentCreated);
            this._waitingForDeferredContent = false;
         }
      }
   }
}

