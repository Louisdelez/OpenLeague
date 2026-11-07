package mx.controls
{
   import flash.display.DisplayObject;
   import flash.display.InteractiveObject;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import mx.collections.ArrayCollection;
   import mx.collections.IList;
   import mx.containers.Box;
   import mx.containers.BoxDirection;
   import mx.containers.ViewStack;
   import mx.core.ClassFactory;
   import mx.core.Container;
   import mx.core.FlexVersion;
   import mx.core.IFactory;
   import mx.core.IFlexDisplayObject;
   import mx.core.ScrollPolicy;
   import mx.core.UIComponent;
   import mx.core.mx_internal;
   import mx.events.ChildExistenceChangedEvent;
   import mx.events.CollectionEvent;
   import mx.events.FlexEvent;
   import mx.events.IndexChangedEvent;
   import mx.events.ItemClickEvent;
   
   use namespace mx_internal;
   
   [ResourceBundle("controls")]
   [Exclude(name="verticalScrollBarStyleName",kind="style")]
   [Exclude(name="horizontalScrollBarStyleName",kind="style")]
   [Exclude(name="click",kind="event")]
   [Exclude(name="scroll",kind="event")]
   [Exclude(name="verticalScrollPosition",kind="property")]
   [Exclude(name="verticalScrollPolicy",kind="property")]
   [Exclude(name="verticalScrollBar",kind="property")]
   [Exclude(name="verticalPageScrollSize",kind="property")]
   [Exclude(name="verticalLineScrollSize",kind="property")]
   [Exclude(name="maxVerticalScrollPosition",kind="property")]
   [Exclude(name="maxHorizontalScrollPosition",kind="property")]
   [Exclude(name="label",kind="property")]
   [Exclude(name="icon",kind="property")]
   [Exclude(name="horizontalScrollPosition",kind="property")]
   [Exclude(name="horizontalScrollPolicy",kind="property")]
   [Exclude(name="horizontalScrollBar",kind="property")]
   [Exclude(name="horizontalPageScrollSize",kind="property")]
   [Exclude(name="horizontalLineScrollSize",kind="property")]
   [Exclude(name="defaultButton",kind="property")]
   [Event(name="itemClick",type="mx.events.ItemClickEvent")]
   public class NavBar extends Box
   {
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      private var _labelField:String = "label";
      
      private var _iconField:String = "icon";
      
      private var _dataProvider:IList;
      
      private var measurementHasBeenCalled:Boolean = false;
      
      private var _toolTipField:String = "toolTip";
      
      mx_internal var navItemFactory:IFactory = new ClassFactory(Button);
      
      private var pendingTargetStack:Object;
      
      private var lastToolTip:String = null;
      
      private var _labelFunction:Function;
      
      mx_internal var targetStack:ViewStack;
      
      private var _selectedIndex:int = -1;
      
      private var dataProviderChanged:Boolean = false;
      
      public function NavBar()
      {
         super();
         direction = BoxDirection.HORIZONTAL;
         showInAutomationHierarchy = true;
      }
      
      [Inspectable(category="Data")]
      [Bindable("iconFieldChanged")]
      public function get iconField() : String
      {
         return _iconField;
      }
      
      [Inspectable(category="General",enumeration="true,false",defaultValue="true")]
      override public function set enabled(value:Boolean) : void
      {
         var n:int = 0;
         var i:int = 0;
         if(value != enabled)
         {
            super.enabled = value;
            n = numChildren;
            for(i = 0; i < n; i++)
            {
               if(Boolean(targetStack))
               {
                  Button(getChildAt(i)).enabled = value && Container(targetStack.getChildAt(i)).enabled;
               }
               else
               {
                  Button(getChildAt(i)).enabled = value;
               }
            }
         }
      }
      
      protected function updateNavItemIcon(index:int, icon:Class) : void
      {
         var item:Button = Button(getChildAt(index));
         item.setStyle("icon",icon);
      }
      
      private function childIndexChangeHandler(event:IndexChangedEvent) : void
      {
         if(event.target == this)
         {
            return;
         }
         setChildIndex(getChildAt(event.oldIndex),event.newIndex);
         resetNavItems();
      }
      
      protected function hiliteSelectedNavItem(index:int) : void
      {
      }
      
      private function checkPendingTargetStack() : void
      {
         if(Boolean(pendingTargetStack))
         {
            _setTargetViewStack(pendingTargetStack);
            pendingTargetStack = null;
         }
      }
      
      private function setTargetViewStack(newStack:Object) : void
      {
         if(!measurementHasBeenCalled && Boolean(newStack))
         {
            pendingTargetStack = newStack;
            invalidateProperties();
         }
         else
         {
            _setTargetViewStack(newStack);
         }
      }
      
      override public function get baselinePosition() : Number
      {
         if(FlexVersion.compatibilityVersion < FlexVersion.VERSION_3_0)
         {
            return super.baselinePosition;
         }
         if(!validateBaselinePosition())
         {
            return NaN;
         }
         if(numChildren == 0)
         {
            return super.baselinePosition;
         }
         var child:Button = Button(getChildAt(0));
         validateNow();
         return child.y + child.baselinePosition;
      }
      
      private function enabledChangedHandler(event:Event) : void
      {
         var itemIndex:int = targetStack.getChildIndex(DisplayObject(event.target));
         Button(getChildAt(itemIndex)).enabled = enabled && Boolean(event.target.enabled);
      }
      
      private function labelChangedHandler(event:Event) : void
      {
         var itemIndex:int = targetStack.getChildIndex(DisplayObject(event.target));
         updateNavItemLabel(itemIndex,Container(event.target).label);
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         if(dataProviderChanged)
         {
            createNavChildren();
            dataProviderChanged = false;
         }
      }
      
      override public function notifyStyleChangeInChildren(styleProp:String, recursive:Boolean) : void
      {
         super.notifyStyleChangeInChildren(styleProp,true);
      }
      
      protected function clickHandler(event:MouseEvent) : void
      {
         var index:int = getChildIndex(DisplayObject(event.currentTarget));
         if(Boolean(targetStack))
         {
            targetStack.selectedIndex = index;
         }
         _selectedIndex = index;
         var newEvent:ItemClickEvent = new ItemClickEvent(ItemClickEvent.ITEM_CLICK);
         newEvent.label = Button(event.currentTarget).label;
         newEvent.index = index;
         newEvent.relatedObject = InteractiveObject(event.currentTarget);
         newEvent.item = Boolean(_dataProvider) ? _dataProvider.getItemAt(index) : null;
         dispatchEvent(newEvent);
         event.stopImmediatePropagation();
      }
      
      [Inspectable(environment="none")]
      override public function get horizontalScrollPolicy() : String
      {
         return ScrollPolicy.OFF;
      }
      
      public function set iconField(value:String) : void
      {
         _iconField = value;
         if(Boolean(_dataProvider))
         {
            dataProvider = _dataProvider;
         }
         dispatchEvent(new Event("iconFieldChanged"));
      }
      
      private function childAddHandler(event:ChildExistenceChangedEvent) : void
      {
         if(event.target == this)
         {
            return;
         }
         if(event.relatedObject.parent != targetStack)
         {
            return;
         }
         var newChild:Container = Container(event.relatedObject);
         var item:Button = Button(createNavItem(itemToLabel(newChild),newChild.icon));
         var index:int = newChild.parent.getChildIndex(DisplayObject(newChild));
         setChildIndex(item,index);
         if(Boolean(newChild.toolTip))
         {
            item.toolTip = newChild.toolTip;
            newChild.toolTip = null;
         }
         newChild.addEventListener("labelChanged",labelChangedHandler);
         newChild.addEventListener("iconChanged",iconChangedHandler);
         newChild.addEventListener("enabledChanged",enabledChangedHandler);
         newChild.addEventListener("toolTipChanged",toolTipChangedHandler);
         item.enabled = enabled && newChild.enabled;
         callLater(resetNavItems);
      }
      
      public function itemToLabel(data:Object) : String
      {
         if(data == null)
         {
            return "";
         }
         if(labelFunction != null)
         {
            return labelFunction(data);
         }
         if(data is XML)
         {
            try
            {
               if(data[labelField].length() != 0)
               {
                  data = data[labelField];
               }
            }
            catch(e:Error)
            {
            }
         }
         else if(data is Object)
         {
            try
            {
               if(data[labelField] != null)
               {
                  data = data[labelField];
               }
            }
            catch(e:Error)
            {
            }
         }
         if(data is String)
         {
            return String(data);
         }
         if(data is Number)
         {
            return data.toString();
         }
         return "";
      }
      
      private function createNavChildren() : void
      {
         var i:int;
         var n:int;
         var item:Object = null;
         var navItem:Button = null;
         var label:String = null;
         var iconValue:Object = null;
         var icon:Class = null;
         if(!_dataProvider)
         {
            return;
         }
         n = _dataProvider.length;
         for(i = 0; i < n; navItem.enabled = enabled,i++)
         {
            item = _dataProvider.getItemAt(i);
            if(item is String && labelFunction == null)
            {
               navItem = Button(createNavItem(String(item)));
            }
            else
            {
               label = itemToLabel(item);
               if(Boolean(iconField))
               {
                  iconValue = null;
                  try
                  {
                     iconValue = item[iconField];
                  }
                  catch(e:Error)
                  {
                  }
                  icon = iconValue is String ? Class(systemManager.getDefinitionByName(String(iconValue))) : Class(iconValue);
                  navItem = Button(createNavItem(label,icon));
               }
               else
               {
                  navItem = Button(createNavItem(label,null));
               }
               if(Boolean(toolTipField))
               {
                  try
                  {
                     navItem.toolTip = item[toolTipField] === undefined ? null : item[toolTipField];
                  }
                  catch(e:Error)
                  {
                  }
                  continue;
               }
            }
         }
         resetNavItems();
      }
      
      public function set toolTipField(value:String) : void
      {
         _toolTipField = value;
         if(Boolean(_dataProvider))
         {
            dataProvider = _dataProvider;
         }
         dispatchEvent(new Event("toolTipFieldChanged"));
      }
      
      private function _setTargetViewStack(newStack:Object) : void
      {
         var newTargetStack:ViewStack = null;
         var numViews:int = 0;
         var child:Container = null;
         var i:int = 0;
         var item:Button = null;
         if(newStack is ViewStack)
         {
            newTargetStack = ViewStack(newStack);
         }
         else if(Boolean(newStack))
         {
            newTargetStack = parentDocument[newStack];
         }
         else
         {
            newTargetStack = null;
         }
         if(Boolean(targetStack))
         {
            targetStack.removeEventListener(ChildExistenceChangedEvent.CHILD_ADD,childAddHandler);
            targetStack.removeEventListener(ChildExistenceChangedEvent.CHILD_REMOVE,childRemoveHandler);
            targetStack.removeEventListener(Event.CHANGE,changeHandler);
            targetStack.removeEventListener(IndexChangedEvent.CHILD_INDEX_CHANGE,childIndexChangeHandler);
            numViews = targetStack.numChildren;
            for(i = 0; i < numViews; i++)
            {
               child = Container(targetStack.getChildAt(i));
               child.removeEventListener("labelChanged",labelChangedHandler);
               child.removeEventListener("iconChanged",iconChangedHandler);
               child.removeEventListener("enabledChanged",enabledChangedHandler);
               child.removeEventListener("toolTipChanged",toolTipChangedHandler);
            }
         }
         removeAllChildren();
         _selectedIndex = -1;
         targetStack = newTargetStack;
         if(!targetStack)
         {
            return;
         }
         targetStack.addEventListener(ChildExistenceChangedEvent.CHILD_ADD,childAddHandler);
         targetStack.addEventListener(ChildExistenceChangedEvent.CHILD_REMOVE,childRemoveHandler);
         targetStack.addEventListener(Event.CHANGE,changeHandler);
         targetStack.addEventListener(IndexChangedEvent.CHILD_INDEX_CHANGE,childIndexChangeHandler);
         numViews = targetStack.numChildren;
         for(i = 0; i < numViews; i++)
         {
            child = Container(targetStack.getChildAt(i));
            item = Button(createNavItem(itemToLabel(child),child.icon));
            if(Boolean(child.toolTip))
            {
               item.toolTip = child.toolTip;
               child.toolTip = null;
            }
            child.addEventListener("labelChanged",labelChangedHandler);
            child.addEventListener("iconChanged",iconChangedHandler);
            child.addEventListener("enabledChanged",enabledChangedHandler);
            child.addEventListener("toolTipChanged",toolTipChangedHandler);
            item.enabled = enabled && child.enabled;
         }
         var index:int = targetStack.selectedIndex;
         if(index == -1 && targetStack.numChildren > 0)
         {
            index = 0;
         }
         if(index != -1)
         {
            hiliteSelectedNavItem(index);
         }
         resetNavItems();
         invalidateDisplayList();
      }
      
      private function toolTipChangedHandler(event:Event) : void
      {
         var itemIndex:int = targetStack.getChildIndex(DisplayObject(event.target));
         var item:UIComponent = UIComponent(getChildAt(itemIndex));
         if(Boolean(UIComponent(event.target).toolTip))
         {
            item.toolTip = UIComponent(event.target).toolTip;
            lastToolTip = UIComponent(event.target).toolTip;
            UIComponent(event.target).toolTip = null;
         }
         else if(!lastToolTip)
         {
            item.toolTip = UIComponent(event.target).toolTip;
            lastToolTip = "placeholder";
            UIComponent(event.target).toolTip = null;
         }
         else
         {
            lastToolTip = null;
         }
      }
      
      protected function createNavItem(label:String, icon:Class = null) : IFlexDisplayObject
      {
         return null;
      }
      
      [Inspectable(category="Data")]
      [Bindable("collectionChange")]
      public function get dataProvider() : Object
      {
         return Boolean(targetStack) ? targetStack : _dataProvider;
      }
      
      protected function updateNavItemLabel(index:int, label:String) : void
      {
         var item:Button = Button(getChildAt(index));
         item.label = label;
      }
      
      override public function set horizontalScrollPolicy(value:String) : void
      {
      }
      
      override protected function commitProperties() : void
      {
         super.commitProperties();
         if(!measurementHasBeenCalled)
         {
            checkPendingTargetStack();
            measurementHasBeenCalled = true;
         }
         if(dataProviderChanged)
         {
            dataProviderChanged = false;
            createNavChildren();
         }
         if(Boolean(blocker))
         {
            blocker.visible = false;
         }
      }
      
      public function set labelField(value:String) : void
      {
         _labelField = value;
         if(Boolean(_dataProvider))
         {
            dataProvider = _dataProvider;
         }
         dispatchEvent(new Event("labelFieldChanged"));
      }
      
      private function iconChangedHandler(event:Event) : void
      {
         var itemIndex:int = targetStack.getChildIndex(DisplayObject(event.target));
         updateNavItemIcon(itemIndex,Container(event.target).icon);
      }
      
      protected function resetNavItems() : void
      {
      }
      
      [Inspectable(category="Data")]
      [Bindable("toolTipFieldChanged")]
      public function get toolTipField() : String
      {
         return _toolTipField;
      }
      
      public function set labelFunction(value:Function) : void
      {
         _labelFunction = value;
         if(Boolean(_dataProvider))
         {
            dataProvider = _dataProvider;
         }
         dispatchEvent(new Event("labelFunctionChanged"));
      }
      
      [Inspectable(category="Data")]
      [Bindable("labelFieldChanged")]
      public function get labelField() : String
      {
         return _labelField;
      }
      
      override public function set verticalScrollPolicy(value:String) : void
      {
      }
      
      private function childRemoveHandler(event:ChildExistenceChangedEvent) : void
      {
         if(event.target == this)
         {
            return;
         }
         event.relatedObject.removeEventListener("labelChanged",labelChangedHandler);
         event.relatedObject.removeEventListener("iconChanged",iconChangedHandler);
         event.relatedObject.removeEventListener("enabledChanged",enabledChangedHandler);
         event.relatedObject.removeEventListener("toolTipChanged",toolTipChangedHandler);
         var viewStack:ViewStack = ViewStack(event.target);
         removeChildAt(viewStack.getChildIndex(event.relatedObject));
         callLater(resetNavItems);
      }
      
      [Inspectable(category="Data")]
      [Bindable("labelFunctionChanged")]
      public function get labelFunction() : Function
      {
         return _labelFunction;
      }
      
      [Inspectable(environment="none")]
      override public function get verticalScrollPolicy() : String
      {
         return ScrollPolicy.OFF;
      }
      
      public function set dataProvider(value:Object) : void
      {
         var message:String = null;
         var name:String = null;
         if(Boolean(value && !(value is String) && !(value is ViewStack)) && Boolean(!(value is Array)) && !(value is IList))
         {
            message = resourceManager.getString("controls","errWrongContainer",[id]);
            throw new Error(message);
         }
         if(Boolean(_dataProvider))
         {
            _dataProvider.removeEventListener(CollectionEvent.COLLECTION_CHANGE,collectionChangeHandler);
         }
         if(value is String && (Boolean(document) && Boolean(document[value])))
         {
            value = document[value];
         }
         if(value is String || value is ViewStack)
         {
            setTargetViewStack(value);
            return;
         }
         if(value is IList && IList(value).length > 0 && IList(value).getItemAt(0) is DisplayObject || value is Array && (value as Array).length > 0 && value[0] is DisplayObject)
         {
            name = Boolean(id) ? className + " \'" + id + "\'" : "a " + className;
            message = resourceManager.getString("controls","errWrongType",[name]);
            throw new Error(message);
         }
         setTargetViewStack(null);
         removeAllChildren();
         if(value is IList)
         {
            _dataProvider = IList(value);
         }
         else if(value is Array)
         {
            _dataProvider = new ArrayCollection(value as Array);
         }
         else
         {
            _dataProvider = null;
         }
         dataProviderChanged = true;
         invalidateProperties();
         if(Boolean(_dataProvider))
         {
            _dataProvider.addEventListener(CollectionEvent.COLLECTION_CHANGE,collectionChangeHandler,false,0,true);
         }
         if(inheritingStyles == UIComponent.STYLE_UNINITIALIZED)
         {
            return;
         }
         dispatchEvent(new Event("collectionChange"));
      }
      
      private function changeHandler(event:Event) : void
      {
         if(event.target == dataProvider)
         {
            hiliteSelectedNavItem(Object(event.target).selectedIndex);
         }
      }
      
      private function collectionChangeHandler(event:Event) : void
      {
         dataProvider = dataProvider;
      }
      
      public function set selectedIndex(value:int) : void
      {
         _selectedIndex = value;
         if(Boolean(targetStack))
         {
            targetStack.selectedIndex = value;
         }
         dispatchEvent(new FlexEvent(FlexEvent.VALUE_COMMIT));
      }
      
      [Inspectable(category="General",defaultValue="-1")]
      [Bindable("valueCommit")]
      [Bindable("itemClick")]
      public function get selectedIndex() : int
      {
         return _selectedIndex;
      }
   }
}

