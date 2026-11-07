package mx.containers
{
   import flash.display.DisplayObject;
   import flash.events.Event;
   import mx.automation.IAutomationObject;
   import mx.core.Container;
   import mx.core.ContainerCreationPolicy;
   import mx.core.EdgeMetrics;
   import mx.core.IInvalidating;
   import mx.core.IUIComponent;
   import mx.core.ScrollPolicy;
   import mx.core.UIComponent;
   import mx.core.mx_internal;
   import mx.effects.Effect;
   import mx.effects.EffectManager;
   import mx.events.ChildExistenceChangedEvent;
   import mx.events.EffectEvent;
   import mx.events.FlexEvent;
   import mx.events.IndexChangedEvent;
   import mx.graphics.RoundedRectangle;
   import mx.managers.HistoryManager;
   import mx.managers.IHistoryManagerClient;
   
   use namespace mx_internal;
   
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
   public class ViewStack extends Container implements IHistoryManagerClient
   {
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      private var dispatchChangeEventPending:Boolean = false;
      
      private var historyManagementEnabledChanged:Boolean = false;
      
      mx_internal var vsPreferredHeight:Number;
      
      private var initialSelectedIndex:int = -1;
      
      private var firstTime:Boolean = true;
      
      mx_internal var _historyManagementEnabled:Boolean = false;
      
      private var overlayChild:Container;
      
      private var overlayTargetArea:RoundedRectangle;
      
      private var proposedSelectedIndex:int = -1;
      
      private var needToInstantiateSelectedChild:Boolean = false;
      
      private var bSaveState:Boolean = false;
      
      mx_internal var vsMinHeight:Number;
      
      private var bInLoadState:Boolean = false;
      
      mx_internal var vsPreferredWidth:Number;
      
      private var _resizeToContent:Boolean = false;
      
      mx_internal var vsMinWidth:Number;
      
      private var lastIndex:int = -1;
      
      private var _selectedIndex:int = -1;
      
      public function ViewStack()
      {
         super();
         addEventListener(ChildExistenceChangedEvent.CHILD_ADD,childAddHandler);
         addEventListener(ChildExistenceChangedEvent.CHILD_REMOVE,childRemoveHandler);
      }
      
      protected function get contentHeight() : Number
      {
         var vm:EdgeMetrics = viewMetricsAndPadding;
         return unscaledHeight - vm.top - vm.bottom;
      }
      
      public function set selectedChild(value:Container) : void
      {
         var newIndex:int = getChildIndex(DisplayObject(value));
         if(newIndex >= 0 && newIndex < numChildren)
         {
            selectedIndex = newIndex;
         }
      }
      
      override mx_internal function setActualCreationPolicies(policy:String) : void
      {
         var i:int = 0;
         var containerChild:Container = null;
         super.mx_internal::setActualCreationPolicies(policy);
         if(policy == ContainerCreationPolicy.ALL && numChildren > 0)
         {
            for(i = 0; i < numChildren; i++)
            {
               containerChild = getChildAt(i) as Container;
               if(Boolean(containerChild) && containerChild.numChildrenCreated == -1)
               {
                  containerChild.createComponentsFromDescriptors();
               }
            }
         }
      }
      
      private function dispatchChangeEvent(oldIndex:int, newIndex:int) : void
      {
         var event:IndexChangedEvent = new IndexChangedEvent(IndexChangedEvent.CHANGE);
         event.oldIndex = oldIndex;
         event.newIndex = newIndex;
         event.relatedObject = getChildAt(newIndex);
         dispatchEvent(event);
      }
      
      protected function get contentY() : Number
      {
         return getStyle("paddingTop");
      }
      
      protected function commitSelectedIndex(newIndex:int) : void
      {
         var currentChild:Container = null;
         var hideEffect:Effect = null;
         if(numChildren == 0)
         {
            _selectedIndex = -1;
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
         if(lastIndex != -1 && lastIndex < numChildren)
         {
            Container(getChildAt(lastIndex)).endEffectsStarted();
         }
         if(_selectedIndex != -1)
         {
            selectedChild.endEffectsStarted();
         }
         lastIndex = _selectedIndex;
         if(newIndex == lastIndex)
         {
            return;
         }
         _selectedIndex = newIndex;
         if(initialSelectedIndex == -1)
         {
            initialSelectedIndex = _selectedIndex;
         }
         if(lastIndex != -1 && newIndex != -1)
         {
            dispatchChangeEventPending = true;
         }
         var listenForEffectEnd:Boolean = false;
         if(lastIndex != -1 && lastIndex < numChildren)
         {
            currentChild = Container(getChildAt(lastIndex));
            currentChild.setVisible(false);
            if(Boolean(currentChild.getStyle("hideEffect")))
            {
               hideEffect = EffectManager.lastEffectCreated;
               if(Boolean(hideEffect))
               {
                  hideEffect.addEventListener(EffectEvent.EFFECT_END,hideEffectEndHandler);
                  listenForEffectEnd = true;
               }
            }
         }
         if(!listenForEffectEnd)
         {
            hideEffectEndHandler(null);
         }
      }
      
      private function instantiateSelectedChild() : void
      {
         if(!selectedChild)
         {
            return;
         }
         if(Boolean(selectedChild) && selectedChild.numChildrenCreated == -1)
         {
            if(initialized)
            {
               selectedChild.addEventListener(FlexEvent.CREATION_COMPLETE,childCreationCompleteHandler);
            }
            selectedChild.createComponentsFromDescriptors(true);
         }
         if(selectedChild is IInvalidating)
         {
            IInvalidating(selectedChild).invalidateSize();
         }
         invalidateSize();
         invalidateDisplayList();
      }
      
      private function initializeHandler(event:FlexEvent) : void
      {
         overlayChild.removeEventListener(FlexEvent.INITIALIZE,initializeHandler);
         UIComponent(overlayChild).addOverlay(overlayColor,overlayTargetArea);
      }
      
      public function set historyManagementEnabled(value:Boolean) : void
      {
         if(value != _historyManagementEnabled)
         {
            _historyManagementEnabled = value;
            historyManagementEnabledChanged = true;
            invalidateProperties();
         }
      }
      
      [Inspectable(environment="none")]
      override public function get horizontalScrollPolicy() : String
      {
         return ScrollPolicy.OFF;
      }
      
      private function childAddHandler(event:ChildExistenceChangedEvent) : void
      {
         var uiChild:IUIComponent = null;
         var child:DisplayObject = event.relatedObject;
         var index:int = getChildIndex(child);
         if(child is IUIComponent)
         {
            uiChild = IUIComponent(child);
            uiChild.visible = false;
         }
         if(numChildren == 1 && proposedSelectedIndex == -1)
         {
            proposedSelectedIndex = 0;
            invalidateProperties();
         }
         else if(index <= selectedIndex && numChildren > 1 && proposedSelectedIndex == -1)
         {
            ++selectedIndex;
         }
         if(child is IAutomationObject)
         {
            IAutomationObject(child).showInAutomationHierarchy = true;
         }
      }
      
      private function addedToStageHandler(event:Event) : void
      {
         if(historyManagementEnabled)
         {
            HistoryManager.register(this);
         }
      }
      
      public function get resizeToContent() : Boolean
      {
         return _resizeToContent;
      }
      
      public function saveState() : Object
      {
         var index:int = _selectedIndex == -1 ? 0 : _selectedIndex;
         return {"selectedIndex":index};
      }
      
      override public function get autoLayout() : Boolean
      {
         return true;
      }
      
      override mx_internal function removeOverlay() : void
      {
         if(Boolean(overlayChild))
         {
            UIComponent(overlayChild).removeOverlay();
            overlayChild = null;
         }
      }
      
      private function removedFromStageHandler(event:Event) : void
      {
         HistoryManager.unregister(this);
      }
      
      [Bindable("creationComplete")]
      [Bindable("valueCommit")]
      public function get selectedChild() : Container
      {
         if(selectedIndex == -1)
         {
            return null;
         }
         return Container(getChildAt(selectedIndex));
      }
      
      private function hideEffectEndHandler(event:EffectEvent) : void
      {
         if(Boolean(event))
         {
            event.currentTarget.removeEventListener(EffectEvent.EFFECT_END,hideEffectEndHandler);
         }
         needToInstantiateSelectedChild = true;
         invalidateProperties();
         if(bSaveState)
         {
            HistoryManager.save();
            bSaveState = false;
         }
      }
      
      private function childCreationCompleteHandler(event:FlexEvent) : void
      {
         event.target.removeEventListener(FlexEvent.CREATION_COMPLETE,childCreationCompleteHandler);
         event.target.dispatchEvent(new FlexEvent(FlexEvent.SHOW));
      }
      
      override public function set horizontalScrollPolicy(value:String) : void
      {
      }
      
      [Inspectable(defaultValue="true")]
      public function get historyManagementEnabled() : Boolean
      {
         return _historyManagementEnabled;
      }
      
      public function loadState(state:Object) : void
      {
         var newIndex:int = Boolean(state) ? int(state.selectedIndex) : 0;
         if(newIndex == -1)
         {
            newIndex = initialSelectedIndex;
         }
         if(newIndex == -1)
         {
            newIndex = 0;
         }
         if(newIndex != _selectedIndex)
         {
            bInLoadState = true;
            selectedIndex = newIndex;
            bInLoadState = false;
         }
      }
      
      protected function get contentWidth() : Number
      {
         var vm:EdgeMetrics = viewMetricsAndPadding;
         return unscaledWidth - vm.left - vm.right;
      }
      
      override protected function commitProperties() : void
      {
         super.commitProperties();
         if(historyManagementEnabledChanged)
         {
            if(historyManagementEnabled)
            {
               HistoryManager.register(this);
            }
            else
            {
               HistoryManager.unregister(this);
            }
            historyManagementEnabledChanged = false;
         }
         if(proposedSelectedIndex != -1)
         {
            commitSelectedIndex(proposedSelectedIndex);
            proposedSelectedIndex = -1;
         }
         if(needToInstantiateSelectedChild)
         {
            instantiateSelectedChild();
            needToInstantiateSelectedChild = false;
         }
         if(dispatchChangeEventPending)
         {
            dispatchChangeEvent(lastIndex,selectedIndex);
            dispatchChangeEventPending = false;
         }
         if(firstTime)
         {
            firstTime = false;
            addEventListener(Event.ADDED_TO_STAGE,addedToStageHandler,false,0,true);
            addEventListener(Event.REMOVED_FROM_STAGE,removedFromStageHandler,false,0,true);
         }
      }
      
      public function set resizeToContent(value:Boolean) : void
      {
         if(value != _resizeToContent)
         {
            _resizeToContent = value;
            if(value)
            {
               invalidateSize();
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
      }
      
      override protected function measure() : void
      {
         var preferredWidth:Number = NaN;
         var child:Container = null;
         super.measure();
         var minWidth:Number = 0;
         var minHeight:Number = 0;
         preferredWidth = 0;
         var preferredHeight:Number = 0;
         if(Boolean(vsPreferredWidth) && !_resizeToContent)
         {
            measuredMinWidth = vsMinWidth;
            measuredMinHeight = vsMinHeight;
            measuredWidth = vsPreferredWidth;
            measuredHeight = vsPreferredHeight;
            return;
         }
         if(numChildren > 0 && selectedIndex != -1)
         {
            child = Container(getChildAt(selectedIndex));
            minWidth = child.minWidth;
            preferredWidth = child.getExplicitOrMeasuredWidth();
            minHeight = child.minHeight;
            preferredHeight = child.getExplicitOrMeasuredHeight();
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
         if(Boolean(selectedChild) && Container(selectedChild).numChildrenCreated == -1)
         {
            return;
         }
         if(numChildren == 0)
         {
            return;
         }
         vsMinWidth = minWidth;
         vsMinHeight = minHeight;
         vsPreferredWidth = preferredWidth;
         vsPreferredHeight = preferredHeight;
      }
      
      override public function set verticalScrollPolicy(value:String) : void
      {
      }
      
      public function set selectedIndex(value:int) : void
      {
         if(value == selectedIndex)
         {
            return;
         }
         proposedSelectedIndex = value;
         invalidateProperties();
         if(historyManagementEnabled && _selectedIndex != -1 && !bInLoadState)
         {
            bSaveState = true;
         }
         dispatchEvent(new FlexEvent(FlexEvent.VALUE_COMMIT));
      }
      
      override mx_internal function addOverlay(color:uint, targetArea:RoundedRectangle = null) : void
      {
         if(Boolean(overlayChild))
         {
            removeOverlay();
         }
         overlayChild = selectedChild;
         if(!overlayChild)
         {
            return;
         }
         overlayColor = color;
         overlayTargetArea = targetArea;
         if(Boolean(selectedChild) && selectedChild.numChildrenCreated == -1)
         {
            selectedChild.addEventListener(FlexEvent.INITIALIZE,initializeHandler);
         }
         else
         {
            initializeHandler(null);
         }
      }
      
      override public function set autoLayout(value:Boolean) : void
      {
      }
      
      [Inspectable(environment="none")]
      override public function get verticalScrollPolicy() : String
      {
         return ScrollPolicy.OFF;
      }
      
      [Inspectable(category="General")]
      [Bindable("creationComplete")]
      [Bindable("valueCommit")]
      [Bindable("change")]
      public function get selectedIndex() : int
      {
         return proposedSelectedIndex == -1 ? _selectedIndex : proposedSelectedIndex;
      }
      
      private function childRemoveHandler(event:ChildExistenceChangedEvent) : void
      {
         var child:DisplayObject = event.relatedObject;
         var index:int = getChildIndex(child);
         if(index > selectedIndex)
         {
            return;
         }
         var currentSelectedIndex:int = selectedIndex;
         if(index < currentSelectedIndex || currentSelectedIndex == numChildren - 1)
         {
            if(currentSelectedIndex == 0)
            {
               selectedIndex = -1;
               _selectedIndex = -1;
            }
            else
            {
               --selectedIndex;
            }
         }
         else if(index == currentSelectedIndex)
         {
            needToInstantiateSelectedChild = true;
            invalidateProperties();
         }
      }
      
      override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         var child:Container = null;
         var newWidth:Number = NaN;
         var newHeight:Number = NaN;
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         var nChildren:int = numChildren;
         var w:Number = contentWidth;
         var h:Number = contentHeight;
         var left:Number = contentX;
         var top:Number = contentY;
         if(selectedIndex != -1)
         {
            child = Container(getChildAt(selectedIndex));
            newWidth = w;
            newHeight = h;
            if(!isNaN(child.percentWidth))
            {
               if(newWidth > child.maxWidth)
               {
                  newWidth = child.maxWidth;
               }
            }
            else if(newWidth > child.explicitWidth)
            {
               newWidth = child.explicitWidth;
            }
            if(!isNaN(child.percentHeight))
            {
               if(newHeight > child.maxHeight)
               {
                  newHeight = child.maxHeight;
               }
            }
            else if(newHeight > child.explicitHeight)
            {
               newHeight = child.explicitHeight;
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
      
      protected function get contentX() : Number
      {
         return getStyle("paddingLeft");
      }
   }
}

