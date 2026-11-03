package mx.containers
{
   import flash.display.DisplayObject;
   import flash.events.Event;
   import mx.automation.IAutomationObject;
   import mx.core.Container;
   import mx.core.ContainerCreationPolicy;
   import mx.core.EdgeMetrics;
   import mx.core.IInvalidating;
   import mx.core.INavigatorContent;
   import mx.core.ISelectableList;
   import mx.core.IUIComponent;
   import mx.core.ScrollPolicy;
   import mx.core.UIComponent;
   import mx.effects.Effect;
   import mx.effects.EffectManager;
   import mx.events.CollectionEvent;
   import mx.events.CollectionEventKind;
   import mx.events.EffectEvent;
   import mx.events.FlexEvent;
   import mx.events.IndexChangedEvent;
   import mx.events.PropertyChangeEvent;
   import mx.geom.RoundedRectangle;
   import mx.managers.HistoryManager;
   import mx.managers.IHistoryManagerClient;
   
   [IconFile("ViewStack.png")]
   [Exclude(name="focusOutEffect",kind="effect")]
   [Exclude(name="focusInEffect",kind="effect")]
   [Exclude(name="verticalScrollBarStyleName",kind="style")]
   [Exclude(name="horizontalScrollBarStyleName",kind="style")]
   [Exclude(name="focusThickness",kind="style")]
   [Exclude(name="focusSkin",kind="style")]
   [Exclude(name="focusBlendMode",kind="style")]
   [Exclude(name="scroll",kind="event")]
   [Exclude(name="focusOut",kind="event")]
   [Exclude(name="focusIn",kind="event")]
   [Exclude(name="verticalScrollPosition",kind="property")]
   [Exclude(name="verticalScrollPolicy",kind="property")]
   [Exclude(name="verticalScrollBar",kind="property")]
   [Exclude(name="verticalPageScrollSize",kind="property")]
   [Exclude(name="verticalLineScrollSize",kind="property")]
   [Exclude(name="maxVerticalScrollPosition",kind="property")]
   [Exclude(name="maxHorizontalScrollPosition",kind="property")]
   [Exclude(name="horizontalScrollPosition",kind="property")]
   [Exclude(name="horizontalScrollPolicy",kind="property")]
   [Exclude(name="horizontalScrollBar",kind="property")]
   [Exclude(name="horizontalPageScrollSize",kind="property")]
   [Exclude(name="horizontalLineScrollSize",kind="property")]
   [Exclude(name="defaultButton",kind="property")]
   [Exclude(name="autoLayout",kind="property")]
   [Style(name="paddingTop",type="Number",format="Length",inherit="no")]
   [Style(name="paddingBottom",type="Number",format="Length",inherit="no")]
   [Style(name="verticalGap",type="Number",format="Length",inherit="no")]
   [Style(name="horizontalGap",type="Number",format="Length",inherit="no")]
   [Event(name="change",type="mx.events.IndexChangedEvent")]
   public class ViewStack extends Container implements IHistoryManagerClient, ISelectableList
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      private var needToInstantiateSelectedChild:Boolean = false;
      
      private var bSaveState:Boolean = false;
      
      private var bInLoadState:Boolean = false;
      
      private var firstTime:Boolean = true;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var vsMinWidth:Number;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var vsMinHeight:Number;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var vsPreferredWidth:Number;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var vsPreferredHeight:Number;
      
      private var effectOverlayChild:UIComponent;
      
      private var effectOverlayTargetArea:RoundedRectangle;
      
      private var lastIndex:int = -1;
      
      private var dispatchChangeEventPending:Boolean = false;
      
      private var addingChildren:Boolean = false;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _historyManagementEnabled:Boolean = false;
      
      private var historyManagementEnabledChanged:Boolean = false;
      
      private var _resizeToContent:Boolean = false;
      
      private var _selectedIndex:int = -1;
      
      private var proposedSelectedIndex:int = -1;
      
      private var initialSelectedIndex:int = -1;
      
      public function ViewStack()
      {
         super();
      }
      
      override public function get autoLayout() : Boolean
      {
         return true;
      }
      
      override public function set autoLayout(value:Boolean) : void
      {
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
      
      protected function get contentHeight() : Number
      {
         var vm:EdgeMetrics = viewMetricsAndPadding;
         return unscaledHeight - vm.top - vm.bottom;
      }
      
      protected function get contentWidth() : Number
      {
         var vm:EdgeMetrics = viewMetricsAndPadding;
         return unscaledWidth - vm.left - vm.right;
      }
      
      protected function get contentX() : Number
      {
         return getStyle("paddingLeft");
      }
      
      protected function get contentY() : Number
      {
         return getStyle("paddingTop");
      }
      
      [Inspectable(defaultValue="true")]
      public function get historyManagementEnabled() : Boolean
      {
         return this._historyManagementEnabled;
      }
      
      public function set historyManagementEnabled(value:Boolean) : void
      {
         if(value != this._historyManagementEnabled)
         {
            this._historyManagementEnabled = value;
            this.historyManagementEnabledChanged = true;
            invalidateProperties();
         }
      }
      
      public function get resizeToContent() : Boolean
      {
         return this._resizeToContent;
      }
      
      public function set resizeToContent(value:Boolean) : void
      {
         if(value != this._resizeToContent)
         {
            this._resizeToContent = value;
            if(value)
            {
               invalidateSize();
            }
         }
      }
      
      [Bindable("creationComplete")]
      [Bindable("valueCommit")]
      public function get selectedChild() : INavigatorContent
      {
         if(this.selectedIndex == -1)
         {
            return null;
         }
         return INavigatorContent(getChildAt(this.selectedIndex));
      }
      
      public function set selectedChild(value:INavigatorContent) : void
      {
         var newIndex:int = getChildIndex(DisplayObject(value));
         if(newIndex >= 0 && newIndex < numChildren)
         {
            this.selectedIndex = newIndex;
         }
      }
      
      [Inspectable(category="General")]
      [Bindable("creationComplete")]
      [Bindable("valueCommit")]
      [Bindable("change")]
      public function get selectedIndex() : int
      {
         return this.proposedSelectedIndex == -1 ? this._selectedIndex : this.proposedSelectedIndex;
      }
      
      public function set selectedIndex(value:int) : void
      {
         if(value == this.selectedIndex)
         {
            return;
         }
         if(this.addingChildren)
         {
            return;
         }
         this.proposedSelectedIndex = value;
         invalidateProperties();
         if(this.historyManagementEnabled && this._selectedIndex != -1 && !this.bInLoadState)
         {
            this.bSaveState = true;
         }
         dispatchEvent(new FlexEvent(FlexEvent.VALUE_COMMIT));
      }
      
      override protected function commitProperties() : void
      {
         super.commitProperties();
         if(this.historyManagementEnabledChanged)
         {
            if(this.historyManagementEnabled)
            {
               HistoryManager.register(this);
            }
            else
            {
               HistoryManager.unregister(this);
            }
            this.historyManagementEnabledChanged = false;
         }
         if(this.proposedSelectedIndex != -1)
         {
            this.commitSelectedIndex(this.proposedSelectedIndex);
            this.proposedSelectedIndex = -1;
         }
         if(this.needToInstantiateSelectedChild)
         {
            this.instantiateSelectedChild();
            this.needToInstantiateSelectedChild = false;
         }
         if(this.dispatchChangeEventPending)
         {
            this.dispatchChangeEvent(this.lastIndex,this.selectedIndex);
            this.dispatchChangeEventPending = false;
         }
         if(this.firstTime)
         {
            this.firstTime = false;
            addEventListener(Event.ADDED_TO_STAGE,this.addedToStageHandler,false,0,true);
            addEventListener(Event.REMOVED_FROM_STAGE,this.removedFromStageHandler,false,0,true);
         }
      }
      
      override protected function measure() : void
      {
         var minHeight:Number = NaN;
         var preferredWidth:Number = NaN;
         var preferredHeight:Number = NaN;
         var child:UIComponent = null;
         super.measure();
         var minWidth:Number = 0;
         minHeight = 0;
         preferredWidth = 0;
         preferredHeight = 0;
         if(Boolean(this.vsPreferredWidth) && !this._resizeToContent)
         {
            measuredMinWidth = this.vsMinWidth;
            measuredMinHeight = this.vsMinHeight;
            measuredWidth = this.vsPreferredWidth;
            measuredHeight = this.vsPreferredHeight;
            return;
         }
         if(numChildren > 0 && this.selectedIndex != -1)
         {
            child = UIComponent(getChildAt(this.selectedIndex));
            minWidth = Number(child.minWidth);
            preferredWidth = Number(child.getExplicitOrMeasuredWidth());
            minHeight = Number(child.minHeight);
            preferredHeight = Number(child.getExplicitOrMeasuredHeight());
         }
         var vm:EdgeMetrics = viewMetricsAndPadding;
         var wPadding:Number = vm.left + vm.right;
         minWidth += wPadding;
         preferredWidth += wPadding;
         var hPadding:Number = vm.top + vm.bottom;
         minHeight += hPadding;
         preferredHeight += hPadding;
         measuredMinWidth = minWidth;
         measuredMinHeight = minHeight;
         measuredWidth = preferredWidth;
         measuredHeight = preferredHeight;
         if(Boolean(this.selectedChild) && INavigatorContent(this.selectedChild).deferredContentCreated == false)
         {
            return;
         }
         if(numChildren == 0)
         {
            return;
         }
         this.vsMinWidth = minWidth;
         this.vsMinHeight = minHeight;
         this.vsPreferredWidth = preferredWidth;
         this.vsPreferredHeight = preferredHeight;
      }
      
      override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         var child:UIComponent = null;
         var newWidth:Number = NaN;
         var newHeight:Number = NaN;
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         var nChildren:int = numChildren;
         var w:Number = this.contentWidth;
         var h:Number = this.contentHeight;
         var left:Number = this.contentX;
         var top:Number = this.contentY;
         if(this.selectedIndex != -1)
         {
            child = UIComponent(getChildAt(this.selectedIndex));
            newWidth = w;
            newHeight = h;
            if(!isNaN(child.percentWidth))
            {
               if(newWidth > child.maxWidth)
               {
                  newWidth = Number(child.maxWidth);
               }
            }
            else if(newWidth > child.explicitWidth)
            {
               newWidth = Number(child.explicitWidth);
            }
            if(!isNaN(child.percentHeight))
            {
               if(newHeight > child.maxHeight)
               {
                  newHeight = Number(child.maxHeight);
               }
            }
            else if(newHeight > child.explicitHeight)
            {
               newHeight = Number(child.explicitHeight);
            }
            if(child.width != newWidth || child.height != newHeight)
            {
               child.setActualSize(newWidth,newHeight);
            }
            if(child.x != left || child.y != top)
            {
               child.move(left,top);
            }
            child.visible = true;
         }
      }
      
      override §§namespace("http://www.adobe.com/2006/flex/mx/internal") function addOverlay(color:uint, targetArea:RoundedRectangle = null) : void
      {
         if(Boolean(this.effectOverlayChild))
         {
            this.removeOverlay();
         }
         this.effectOverlayChild = this.selectedChild as UIComponent;
         if(!this.effectOverlayChild)
         {
            return;
         }
         effectOverlayColor = color;
         this.effectOverlayTargetArea = targetArea;
         if(Boolean(this.selectedChild) && this.selectedChild.deferredContentCreated == false)
         {
            this.selectedChild.addEventListener(FlexEvent.INITIALIZE,this.initializeHandler);
         }
         else
         {
            this.initializeHandler(null);
         }
      }
      
      override §§namespace("http://www.adobe.com/2006/flex/mx/internal") function removeOverlay() : void
      {
         if(Boolean(this.effectOverlayChild))
         {
            UIComponent(this.effectOverlayChild).removeOverlay();
            this.effectOverlayChild = null;
         }
      }
      
      override §§namespace("http://www.adobe.com/2006/flex/mx/internal") function setActualCreationPolicies(policy:String) : void
      {
         var i:int = 0;
         var containerChild:INavigatorContent = null;
         super.setActualCreationPolicies(policy);
         if(policy == ContainerCreationPolicy.ALL && numChildren > 0)
         {
            for(i = 0; i < numChildren; i++)
            {
               containerChild = getChildAt(i) as INavigatorContent;
               if(Boolean(containerChild) && containerChild.deferredContentCreated == false)
               {
                  containerChild.createDeferredContent();
               }
            }
         }
      }
      
      override public function createComponentsFromDescriptors(recurse:Boolean = true) : void
      {
         if(actualCreationPolicy == ContainerCreationPolicy.ALL)
         {
            super.createComponentsFromDescriptors();
            return;
         }
         var numChildrenBefore:int = numChildren;
         var n:int = Boolean(childDescriptors) ? int(childDescriptors.length) : 0;
         for(var i:int = 0; i < n; i++)
         {
            createComponentFromDescriptor(childDescriptors[i],false);
         }
         numChildrenCreated = numChildren - numChildrenBefore;
         processedDescriptors = true;
         dispatchEvent(new FlexEvent(FlexEvent.CONTENT_CREATION_COMPLETE));
      }
      
      public function saveState() : Object
      {
         var index:int = this._selectedIndex == -1 ? 0 : this._selectedIndex;
         return {"selectedIndex":index};
      }
      
      public function loadState(state:Object) : void
      {
         var newIndex:int = Boolean(state) ? int(state.selectedIndex) : 0;
         if(newIndex == -1)
         {
            newIndex = this.initialSelectedIndex;
         }
         if(newIndex == -1)
         {
            newIndex = 0;
         }
         if(newIndex != this._selectedIndex)
         {
            this.bInLoadState = true;
            this.selectedIndex = newIndex;
            this.bInLoadState = false;
         }
      }
      
      protected function commitSelectedIndex(newIndex:int) : void
      {
         var currentChild:UIComponent = null;
         var hideEffect:Effect = null;
         if(numChildren == 0)
         {
            this._selectedIndex = -1;
            return;
         }
         if(newIndex < 0)
         {
            newIndex = 0;
         }
         else if(newIndex > numChildren - 1)
         {
            newIndex = numChildren - 1;
         }
         if(this.lastIndex != -1 && this.lastIndex < numChildren)
         {
            UIComponent(getChildAt(this.lastIndex)).endEffectsStarted();
         }
         if(this._selectedIndex != -1)
         {
            (this.selectedChild as UIComponent).endEffectsStarted();
         }
         this.lastIndex = this._selectedIndex;
         if(newIndex == this.lastIndex)
         {
            return;
         }
         this._selectedIndex = newIndex;
         if(this.initialSelectedIndex == -1)
         {
            this.initialSelectedIndex = this._selectedIndex;
         }
         if(this.lastIndex != -1 && newIndex != -1)
         {
            this.dispatchChangeEventPending = true;
         }
         var listenForEffectEnd:Boolean = false;
         if(this.lastIndex != -1 && this.lastIndex < numChildren)
         {
            currentChild = UIComponent(getChildAt(this.lastIndex));
            currentChild.setVisible(false);
            if(Boolean(currentChild.getStyle("hideEffect")))
            {
               hideEffect = EffectManager.lastEffectCreated;
               if(Boolean(hideEffect))
               {
                  hideEffect.addEventListener(EffectEvent.EFFECT_END,this.hideEffectEndHandler);
                  listenForEffectEnd = true;
               }
            }
         }
         if(!listenForEffectEnd)
         {
            this.hideEffectEndHandler(null);
         }
      }
      
      private function hideEffectEndHandler(event:EffectEvent) : void
      {
         if(Boolean(event))
         {
            event.currentTarget.removeEventListener(EffectEvent.EFFECT_END,this.hideEffectEndHandler);
         }
         this.needToInstantiateSelectedChild = true;
         invalidateProperties();
         if(this.bSaveState)
         {
            HistoryManager.save();
            this.bSaveState = false;
         }
      }
      
      private function instantiateSelectedChild() : void
      {
         if(!this.selectedChild)
         {
            return;
         }
         if(Boolean(this.selectedChild) && this.selectedChild.deferredContentCreated == false)
         {
            if(initialized)
            {
               this.selectedChild.addEventListener(FlexEvent.CREATION_COMPLETE,this.childCreationCompleteHandler);
            }
            this.selectedChild.createDeferredContent();
         }
         if(this.selectedChild is IInvalidating)
         {
            IInvalidating(this.selectedChild).invalidateSize();
         }
         invalidateSize();
         invalidateDisplayList();
      }
      
      private function dispatchChangeEvent(oldIndex:int, newIndex:int) : void
      {
         var event:IndexChangedEvent = new IndexChangedEvent(IndexChangedEvent.CHANGE);
         event.oldIndex = oldIndex;
         event.newIndex = newIndex;
         event.relatedObject = getChildAt(newIndex);
         dispatchEvent(event);
      }
      
      private function addedToStageHandler(event:Event) : void
      {
         if(this.historyManagementEnabled)
         {
            HistoryManager.register(this);
         }
      }
      
      private function removedFromStageHandler(event:Event) : void
      {
         HistoryManager.unregister(this);
      }
      
      private function initializeHandler(event:FlexEvent) : void
      {
         this.effectOverlayChild.removeEventListener(FlexEvent.INITIALIZE,this.initializeHandler);
         UIComponent(this.effectOverlayChild).addOverlay(effectOverlayColor,this.effectOverlayTargetArea);
      }
      
      private function childCreationCompleteHandler(event:FlexEvent) : void
      {
         event.target.removeEventListener(FlexEvent.CREATION_COMPLETE,this.childCreationCompleteHandler);
         event.target.dispatchEvent(new FlexEvent(FlexEvent.SHOW));
      }
      
      private function childAddHandler(child:DisplayObject) : void
      {
         var uiChild:IUIComponent = null;
         var index:int = getChildIndex(child);
         if(child is IUIComponent)
         {
            uiChild = IUIComponent(child);
            uiChild.visible = false;
         }
         if(child is INavigatorContent)
         {
            child.addEventListener("labelChanged",this.navigatorChildChangedHandler);
            child.addEventListener("iconChanged",this.navigatorChildChangedHandler);
         }
         if(numChildren == 1 && this.proposedSelectedIndex == -1)
         {
            this._selectedIndex = 0;
            dispatchEvent(new FlexEvent(FlexEvent.VALUE_COMMIT));
            this.needToInstantiateSelectedChild = true;
            invalidateProperties();
         }
         else if(index <= this.selectedIndex && numChildren > 1 && this.proposedSelectedIndex == -1)
         {
            ++this._selectedIndex;
            dispatchEvent(new FlexEvent(FlexEvent.VALUE_COMMIT));
         }
         if(child is IAutomationObject)
         {
            IAutomationObject(child).showInAutomationHierarchy = true;
         }
      }
      
      private function childRemoveHandler(child:DisplayObject, index:int) : void
      {
         if(child is INavigatorContent)
         {
            child.removeEventListener("labelChanged",this.navigatorChildChangedHandler);
            child.removeEventListener("iconChanged",this.navigatorChildChangedHandler);
         }
         if(index > this.selectedIndex)
         {
            return;
         }
         var currentSelectedIndex:int = this.selectedIndex;
         if(index < currentSelectedIndex || currentSelectedIndex == numChildren)
         {
            if(currentSelectedIndex == 0)
            {
               this._selectedIndex = -1;
               dispatchEvent(new FlexEvent(FlexEvent.VALUE_COMMIT));
            }
            else
            {
               --this._selectedIndex;
               dispatchEvent(new FlexEvent(FlexEvent.VALUE_COMMIT));
            }
         }
         else if(index == currentSelectedIndex)
         {
            this.needToInstantiateSelectedChild = true;
            invalidateProperties();
         }
      }
      
      override public function addChildAt(item:DisplayObject, index:int) : DisplayObject
      {
         this.addingChildren = true;
         var obj:DisplayObject = super.addChildAt(item,index);
         this.internalDispatchEvent(CollectionEventKind.ADD,obj,index);
         this.childAddHandler(item);
         this.addingChildren = false;
         return obj;
      }
      
      override public function removeChild(item:DisplayObject) : DisplayObject
      {
         var index:int = getChildIndex(item);
         var obj:DisplayObject = super.removeChild(item);
         this.internalDispatchEvent(CollectionEventKind.REMOVE,obj,index);
         this.childRemoveHandler(item,index);
         return obj;
      }
      
      override public function removeAllChildren() : void
      {
         super.removeAllChildren();
         this.internalDispatchEvent(CollectionEventKind.RESET);
      }
      
      private function navigatorChildChangedHandler(event:Event) : void
      {
         var pe:PropertyChangeEvent = new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE);
         pe.source = event.target;
         pe.property = event.type == "labelChanged" ? "label" : "icon";
         this.internalDispatchEvent(CollectionEventKind.UPDATE,pe,getChildIndex(event.target as DisplayObject));
      }
      
      private function internalDispatchEvent(kind:String, item:Object = null, location:int = -1) : void
      {
         var event:CollectionEvent = null;
         var objEvent:PropertyChangeEvent = null;
         if(hasEventListener(CollectionEvent.COLLECTION_CHANGE))
         {
            event = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE);
            event.kind = kind;
            event.items.push(item);
            event.location = location;
            dispatchEvent(event);
         }
         if(Boolean(hasEventListener(PropertyChangeEvent.PROPERTY_CHANGE)) && (kind == CollectionEventKind.ADD || kind == CollectionEventKind.REMOVE))
         {
            objEvent = new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE);
            objEvent.property = location;
            if(kind == CollectionEventKind.ADD)
            {
               objEvent.newValue = item;
            }
            else
            {
               objEvent.oldValue = item;
            }
            dispatchEvent(objEvent);
         }
      }
      
      public function get length() : int
      {
         return numChildren;
      }
      
      public function addItem(item:Object) : void
      {
         addChild(item as DisplayObject);
      }
      
      public function addItemAt(item:Object, index:int) : void
      {
         this.addChildAt(item as DisplayObject,index);
      }
      
      public function getItemAt(index:int, prefetch:int = 0) : Object
      {
         return getChildAt(index);
      }
      
      public function getItemIndex(item:Object) : int
      {
         return getChildIndex(item as DisplayObject);
      }
      
      public function itemUpdated(item:Object, property:Object = null, oldValue:Object = null, newValue:Object = null) : void
      {
      }
      
      public function removeAll() : void
      {
         this.removeAllChildren();
      }
      
      public function removeItemAt(index:int) : Object
      {
         return removeChildAt(index);
      }
      
      public function setItemAt(item:Object, index:int) : Object
      {
         var result:Object = removeChildAt(index);
         this.addChildAt(item as DisplayObject,index);
         return result;
      }
      
      public function toArray() : Array
      {
         var result:Array = [];
         for(var i:int = 0; i < numChildren; i++)
         {
            result.push(getChildAt(i));
         }
         return result;
      }
   }
}

