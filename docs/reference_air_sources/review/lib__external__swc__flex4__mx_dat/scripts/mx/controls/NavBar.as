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
   import mx.core.IFactory;
   import mx.core.IFlexDisplayObject;
   import mx.core.INavigatorContent;
   import mx.core.ScrollPolicy;
   import mx.core.UIComponent;
   import mx.events.ChildExistenceChangedEvent;
   import mx.events.CollectionEvent;
   import mx.events.FlexEvent;
   import mx.events.IndexChangedEvent;
   import mx.events.ItemClickEvent;
   import mx.styles.StyleProtoChain;
   
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
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var targetStack:ViewStack;
      
      private var pendingTargetStack:Object;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var navItemFactory:IFactory = new ClassFactory(Button);
      
      private var lastToolTip:String = null;
      
      private var measurementHasBeenCalled:Boolean = false;
      
      private var _dataProvider:IList;
      
      private var dataProviderChanged:Boolean = false;
      
      private var _iconField:String = "icon";
      
      private var _labelField:String = "label";
      
      private var _labelFunction:Function;
      
      private var _selectedIndex:int = -1;
      
      private var _toolTipField:String = "toolTip";
      
      public function NavBar()
      {
         super();
         direction = BoxDirection.HORIZONTAL;
         showInAutomationHierarchy = true;
      }
      
      override public function get baselinePosition() : Number
      {
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
               if(Boolean(this.targetStack))
               {
                  Button(getChildAt(i)).enabled = value && Boolean(UIComponent(this.targetStack.getChildAt(i)).enabled);
               }
               else
               {
                  Button(getChildAt(i)).enabled = value;
               }
            }
         }
      }
      
      [Inspectable(environment="none")]
      override public function get horizontalScrollPolicy() : String
      {
         return ScrollPolicy.OFF;
      }
      
      override public function set horizontalScrollPolicy(value:String) : void
      {
      }
      
      [Inspectable(environment="none")]
      override public function get verticalScrollPolicy() : String
      {
         return ScrollPolicy.OFF;
      }
      
      override public function set verticalScrollPolicy(value:String) : void
      {
      }
      
      [Inspectable(category="Data")]
      [Bindable("collectionChange")]
      public function get dataProvider() : Object
      {
         return Boolean(this.targetStack) ? this.targetStack : this._dataProvider;
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
         if(Boolean(this._dataProvider))
         {
            this._dataProvider.removeEventListener(CollectionEvent.COLLECTION_CHANGE,this.collectionChangeHandler);
         }
         if(value is String && (Boolean(document) && Boolean(document[value])))
         {
            value = document[value];
         }
         if(value is String || value is ViewStack)
         {
            this.setTargetViewStack(value);
            return;
         }
         if(value is IList && IList(value).length > 0 && IList(value).getItemAt(0) is DisplayObject || value is Array && (value as Array).length > 0 && value[0] is DisplayObject)
         {
            name = Boolean(id) ? className + " \'" + id + "\'" : "a " + className;
            message = resourceManager.getString("controls","errWrongType",[name]);
            throw new Error(message);
         }
         this.setTargetViewStack(null);
         removeAllChildren();
         if(value is IList)
         {
            this._dataProvider = IList(value);
         }
         else if(value is Array)
         {
            this._dataProvider = new ArrayCollection(value as Array);
         }
         else
         {
            this._dataProvider = null;
         }
         this.dataProviderChanged = true;
         invalidateProperties();
         if(Boolean(this._dataProvider))
         {
            this._dataProvider.addEventListener(CollectionEvent.COLLECTION_CHANGE,this.collectionChangeHandler,false,0,true);
         }
         if(inheritingStyles == StyleProtoChain.STYLE_UNINITIALIZED)
         {
            return;
         }
         dispatchEvent(new Event("collectionChange"));
      }
      
      [Inspectable(category="Data")]
      [Bindable("iconFieldChanged")]
      public function get iconField() : String
      {
         return this._iconField;
      }
      
      public function set iconField(value:String) : void
      {
         this._iconField = value;
         if(Boolean(this._dataProvider))
         {
            this.dataProvider = this._dataProvider;
         }
         dispatchEvent(new Event("iconFieldChanged"));
      }
      
      [Inspectable(category="Data")]
      [Bindable("labelFieldChanged")]
      public function get labelField() : String
      {
         return this._labelField;
      }
      
      public function set labelField(value:String) : void
      {
         this._labelField = value;
         if(Boolean(this._dataProvider))
         {
            this.dataProvider = this._dataProvider;
         }
         dispatchEvent(new Event("labelFieldChanged"));
      }
      
      [Inspectable(category="Data")]
      [Bindable("labelFunctionChanged")]
      public function get labelFunction() : Function
      {
         return this._labelFunction;
      }
      
      public function set labelFunction(value:Function) : void
      {
         this._labelFunction = value;
         if(Boolean(this._dataProvider))
         {
            this.dataProvider = this._dataProvider;
         }
         dispatchEvent(new Event("labelFunctionChanged"));
      }
      
      [Inspectable(category="General",defaultValue="-1")]
      [Bindable("valueCommit")]
      [Bindable("itemClick")]
      public function get selectedIndex() : int
      {
         return this._selectedIndex;
      }
      
      public function set selectedIndex(value:int) : void
      {
         this._selectedIndex = value;
         if(Boolean(this.targetStack))
         {
            this.targetStack.selectedIndex = value;
         }
         dispatchEvent(new FlexEvent(FlexEvent.VALUE_COMMIT));
      }
      
      [Inspectable(category="Data")]
      [Bindable("toolTipFieldChanged")]
      public function get toolTipField() : String
      {
         return this._toolTipField;
      }
      
      public function set toolTipField(value:String) : void
      {
         this._toolTipField = value;
         if(Boolean(this._dataProvider))
         {
            this.dataProvider = this._dataProvider;
         }
         dispatchEvent(new Event("toolTipFieldChanged"));
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         if(this.dataProviderChanged)
         {
            this.createNavChildren();
            this.dataProviderChanged = false;
         }
      }
      
      override protected function commitProperties() : void
      {
         super.commitProperties();
         if(!this.measurementHasBeenCalled)
         {
            this.checkPendingTargetStack();
            this.measurementHasBeenCalled = true;
         }
         if(this.dataProviderChanged)
         {
            this.dataProviderChanged = false;
            this.createNavChildren();
         }
         if(Boolean(blocker))
         {
            blocker.visible = false;
         }
      }
      
      override public function notifyStyleChangeInChildren(styleProp:String, recursive:Boolean) : void
      {
         super.notifyStyleChangeInChildren(styleProp,true);
      }
      
      public function itemToLabel(data:Object) : String
      {
         if(data == null)
         {
            return "";
         }
         if(this.labelFunction != null)
         {
            return this.labelFunction(data);
         }
         if(data is XML)
         {
            try
            {
               if(data[this.labelField].length() != 0)
               {
                  data = data[this.labelField];
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
               if(data[this.labelField] != null)
               {
                  data = data[this.labelField];
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
      
      protected function createNavItem(label:String, icon:Class = null) : IFlexDisplayObject
      {
         return null;
      }
      
      protected function hiliteSelectedNavItem(index:int) : void
      {
      }
      
      protected function resetNavItems() : void
      {
      }
      
      protected function updateNavItemLabel(index:int, label:String) : void
      {
         var item:Button = Button(getChildAt(index));
         item.label = label;
      }
      
      protected function updateNavItemIcon(index:int, icon:Class) : void
      {
         var item:Button = Button(getChildAt(index));
         item.setStyle("icon",icon);
      }
      
      private function createNavChildren() : void
      {
         var item:Object = null;
         var navItem:Button = null;
         var label:String = null;
         var iconValue:Object = null;
         var icon:Class = null;
         if(!this._dataProvider)
         {
            return;
         }
         var n:int = int(this._dataProvider.length);
         for(var i:int = 0; i < n; navItem.enabled = enabled,i++)
         {
            item = this._dataProvider.getItemAt(i);
            if(item is String && this.labelFunction == null)
            {
               navItem = Button(this.createNavItem(String(item)));
            }
            else
            {
               label = this.itemToLabel(item);
               if(Boolean(this.iconField))
               {
                  iconValue = null;
                  try
                  {
                     iconValue = item[this.iconField];
                  }
                  catch(e:Error)
                  {
                  }
                  icon = iconValue is String ? Class(systemManager.getDefinitionByName(String(iconValue))) : Class(iconValue);
                  navItem = Button(this.createNavItem(label,icon));
               }
               else
               {
                  navItem = Button(this.createNavItem(label,null));
               }
               if(Boolean(this.toolTipField))
               {
                  try
                  {
                     navItem.toolTip = item[this.toolTipField] === undefined ? null : item[this.toolTipField];
                  }
                  catch(e:Error)
                  {
                  }
                  continue;
               }
            }
         }
         this.resetNavItems();
      }
      
      private function setTargetViewStack(newStack:Object) : void
      {
         if(!this.measurementHasBeenCalled && Boolean(newStack))
         {
            this.pendingTargetStack = newStack;
            invalidateProperties();
         }
         else
         {
            this._setTargetViewStack(newStack);
         }
      }
      
      private function _setTargetViewStack(newStack:Object) : void
      {
         var newTargetStack:ViewStack = null;
         var numViews:int = 0;
         var child:INavigatorContent = null;
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
         if(Boolean(this.targetStack))
         {
            this.targetStack.removeEventListener(ChildExistenceChangedEvent.CHILD_ADD,this.childAddHandler);
            this.targetStack.removeEventListener(ChildExistenceChangedEvent.CHILD_REMOVE,this.childRemoveHandler);
            this.targetStack.removeEventListener(Event.CHANGE,this.changeHandler);
            this.targetStack.removeEventListener(FlexEvent.VALUE_COMMIT,this.changeHandler);
            this.targetStack.removeEventListener(IndexChangedEvent.CHILD_INDEX_CHANGE,this.childIndexChangeHandler);
            numViews = this.targetStack.numChildren;
            for(i = 0; i < numViews; i++)
            {
               child = INavigatorContent(this.targetStack.getChildAt(i));
               child.removeEventListener("labelChanged",this.labelChangedHandler);
               child.removeEventListener("iconChanged",this.iconChangedHandler);
               child.removeEventListener("enabledChanged",this.enabledChangedHandler);
               child.removeEventListener("toolTipChanged",this.toolTipChangedHandler);
            }
         }
         removeAllChildren();
         this._selectedIndex = -1;
         this.targetStack = newTargetStack;
         if(!this.targetStack)
         {
            return;
         }
         this.targetStack.addEventListener(ChildExistenceChangedEvent.CHILD_ADD,this.childAddHandler);
         this.targetStack.addEventListener(ChildExistenceChangedEvent.CHILD_REMOVE,this.childRemoveHandler);
         this.targetStack.addEventListener(Event.CHANGE,this.changeHandler);
         this.targetStack.addEventListener(FlexEvent.VALUE_COMMIT,this.changeHandler);
         this.targetStack.addEventListener(IndexChangedEvent.CHILD_INDEX_CHANGE,this.childIndexChangeHandler);
         numViews = this.targetStack.numChildren;
         for(i = 0; i < numViews; i++)
         {
            child = INavigatorContent(this.targetStack.getChildAt(i));
            item = Button(this.createNavItem(this.itemToLabel(child),child.icon));
            if(Boolean(child.toolTip))
            {
               item.toolTip = child.toolTip;
               child.toolTip = null;
            }
            child.addEventListener("labelChanged",this.labelChangedHandler);
            child.addEventListener("iconChanged",this.iconChangedHandler);
            child.addEventListener("enabledChanged",this.enabledChangedHandler);
            child.addEventListener("toolTipChanged",this.toolTipChangedHandler);
            item.enabled = enabled && Boolean(child.enabled);
         }
         var index:int = this.targetStack.selectedIndex;
         if(index == -1 && this.targetStack.numChildren > 0)
         {
            index = 0;
         }
         if(index != -1)
         {
            this.hiliteSelectedNavItem(index);
         }
         this.resetNavItems();
         invalidateDisplayList();
      }
      
      private function checkPendingTargetStack() : void
      {
         if(Boolean(this.pendingTargetStack))
         {
            this._setTargetViewStack(this.pendingTargetStack);
            this.pendingTargetStack = null;
         }
      }
      
      private function collectionChangeHandler(event:Event) : void
      {
         this.dataProvider = this.dataProvider;
      }
      
      private function childAddHandler(event:ChildExistenceChangedEvent) : void
      {
         if(event.target == this)
         {
            return;
         }
         if(event.relatedObject.parent != this.targetStack)
         {
            return;
         }
         var newChild:INavigatorContent = INavigatorContent(event.relatedObject);
         var item:Button = Button(this.createNavItem(this.itemToLabel(newChild),newChild.icon));
         var index:int = int(newChild.parent.getChildIndex(DisplayObject(newChild)));
         setChildIndex(item,index);
         if(Boolean(newChild.toolTip))
         {
            item.toolTip = newChild.toolTip;
            newChild.toolTip = null;
         }
         newChild.addEventListener("labelChanged",this.labelChangedHandler);
         newChild.addEventListener("iconChanged",this.iconChangedHandler);
         newChild.addEventListener("enabledChanged",this.enabledChangedHandler);
         newChild.addEventListener("toolTipChanged",this.toolTipChangedHandler);
         item.enabled = enabled && Boolean(newChild.enabled);
         callLater(this.resetNavItems);
      }
      
      private function childRemoveHandler(event:ChildExistenceChangedEvent) : void
      {
         if(event.target == this)
         {
            return;
         }
         event.relatedObject.removeEventListener("labelChanged",this.labelChangedHandler);
         event.relatedObject.removeEventListener("iconChanged",this.iconChangedHandler);
         event.relatedObject.removeEventListener("enabledChanged",this.enabledChangedHandler);
         event.relatedObject.removeEventListener("toolTipChanged",this.toolTipChangedHandler);
         var viewStack:ViewStack = ViewStack(event.target);
         removeChildAt(viewStack.getChildIndex(event.relatedObject));
         callLater(this.resetNavItems);
      }
      
      private function changeHandler(event:Event) : void
      {
         if(event.target == this.dataProvider)
         {
            this.hiliteSelectedNavItem(Object(event.target).selectedIndex);
         }
      }
      
      private function childIndexChangeHandler(event:IndexChangedEvent) : void
      {
         if(event.target == this)
         {
            return;
         }
         setChildIndex(getChildAt(event.oldIndex),event.newIndex);
         this.resetNavItems();
      }
      
      private function labelChangedHandler(event:Event) : void
      {
         var itemIndex:int = this.targetStack.getChildIndex(DisplayObject(event.target));
         this.updateNavItemLabel(itemIndex,INavigatorContent(event.target).label);
      }
      
      private function iconChangedHandler(event:Event) : void
      {
         var itemIndex:int = this.targetStack.getChildIndex(DisplayObject(event.target));
         this.updateNavItemIcon(itemIndex,INavigatorContent(event.target).icon);
      }
      
      private function toolTipChangedHandler(event:Event) : void
      {
         var itemIndex:int = this.targetStack.getChildIndex(DisplayObject(event.target));
         var item:UIComponent = UIComponent(getChildAt(itemIndex));
         if(Boolean(UIComponent(event.target).toolTip))
         {
            item.toolTip = UIComponent(event.target).toolTip;
            this.lastToolTip = UIComponent(event.target).toolTip;
            UIComponent(event.target).toolTip = null;
         }
         else if(!this.lastToolTip)
         {
            item.toolTip = UIComponent(event.target).toolTip;
            this.lastToolTip = "placeholder";
            UIComponent(event.target).toolTip = null;
         }
         else
         {
            this.lastToolTip = null;
         }
      }
      
      private function enabledChangedHandler(event:Event) : void
      {
         var itemIndex:int = this.targetStack.getChildIndex(DisplayObject(event.target));
         Button(getChildAt(itemIndex)).enabled = enabled && Boolean(event.target.enabled);
      }
      
      protected function clickHandler(event:MouseEvent) : void
      {
         var index:int = getChildIndex(DisplayObject(event.currentTarget));
         if(Boolean(this.targetStack))
         {
            this.targetStack.selectedIndex = index;
         }
         this._selectedIndex = index;
         var newEvent:ItemClickEvent = new ItemClickEvent(ItemClickEvent.ITEM_CLICK);
         newEvent.label = Button(event.currentTarget).label;
         newEvent.index = index;
         newEvent.relatedObject = InteractiveObject(event.currentTarget);
         newEvent.item = Boolean(this._dataProvider) ? this._dataProvider.getItemAt(index) : null;
         dispatchEvent(newEvent);
         event.stopImmediatePropagation();
      }
   }
}

