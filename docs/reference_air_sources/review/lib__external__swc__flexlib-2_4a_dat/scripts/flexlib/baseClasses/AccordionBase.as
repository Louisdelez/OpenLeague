package flexlib.baseClasses
{
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   import flash.ui.Keyboard;
   import flexlib.containers.accordionClasses.AccordionHeader;
   import mx.automation.IAutomationObject;
   import mx.controls.Button;
   import mx.core.ClassFactory;
   import mx.core.ComponentDescriptor;
   import mx.core.Container;
   import mx.core.ContainerCreationPolicy;
   import mx.core.EdgeMetrics;
   import mx.core.IDataRenderer;
   import mx.core.IFactory;
   import mx.core.IInvalidating;
   import mx.core.IUIComponent;
   import mx.core.ScrollPolicy;
   import mx.core.UIComponent;
   import mx.effects.Effect;
   import mx.effects.Tween;
   import mx.events.ChildExistenceChangedEvent;
   import mx.events.FlexEvent;
   import mx.events.IndexChangedEvent;
   import mx.graphics.RoundedRectangle;
   import mx.managers.HistoryManager;
   import mx.managers.IFocusManagerComponent;
   import mx.managers.IHistoryManagerClient;
   import mx.styles.CSSStyleDeclaration;
   import mx.styles.StyleManager;
   
   [DefaultTriggerEvent("change")]
   [DefaultBindingProperty(source="selectedIndex",destination="selectedIndex")]
   [Exclude(name="verticalScrollBarStyleName",kind="style")]
   [Exclude(name="horizontalScrollBarStyleName",kind="style")]
   [Exclude(name="scroll",kind="event")]
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
   [Exclude(name="clipContent",kind="property")]
   [Exclude(name="autoLayout",kind="property")]
   [Style(name="textSelectedColor",type="uint",format="Color",inherit="yes")]
   [Style(name="textRollOverColor",type="uint",format="Color",inherit="yes")]
   [Style(name="openEasingFunction",type="Function",inherit="no")]
   [Style(name="openDuration",type="Number",format="Time",inherit="no")]
   [Style(name="headerHeight",type="Number",format="Length",inherit="no")]
   [Style(name="verticalGap",type="Number",format="Length",inherit="no")]
   [Style(name="horizontalGap",type="Number",format="Length",inherit="no")]
   [Style(name="paddingBottom",type="Number",format="Length",inherit="no")]
   [Style(name="paddingTop",type="Number",format="Length",inherit="no")]
   [Style(name="headerStyleName",type="String",inherit="no")]
   [Style(name="selectedFillColors",type="Array",arrayType="uint",format="Color",inherit="no")]
   [Style(name="focusRoundedCorners",type="String",inherit="no")]
   [Style(name="focusAlpha",type="Number",inherit="no")]
   [Style(name="fillColors",type="Array",arrayType="uint",format="Color",inherit="no")]
   [Style(name="fillAlphas",type="Array",arrayType="Number",inherit="no")]
   [Event(name="change",type="mx.events.IndexChangedEvent")]
   [RequiresDataBinding("true")]
   public class AccordionBase extends Container implements IHistoryManagerClient, IFocusManagerComponent
   {
      
      private static const HEADER_NAME_BASE:String = "_header";
      
      private var historyManagementEnabledChanged:Boolean = false;
      
      protected var layoutStyleChanged:Boolean = false;
      
      private var _headerRenderer:IFactory;
      
      protected var tweenOldSelectedIndex:int;
      
      protected var showFocusIndicator:Boolean = false;
      
      protected var accPreferredWidth:Number;
      
      protected var _resizeToContent:Boolean = false;
      
      private var _selectedIndex:int = -1;
      
      private var proposedSelectedIndex:int = -1;
      
      private var _focusedIndex:int = -1;
      
      private var firstTime:Boolean = true;
      
      private var bInLoadState:Boolean = false;
      
      protected var tweenNewSelectedIndex:int;
      
      private var initialSelectedIndex:int = -1;
      
      protected var accMinWidth:Number;
      
      private var overlayTargetArea:RoundedRectangle;
      
      protected var accPreferredHeight:Number;
      
      protected var tween:Tween;
      
      protected var tweenContentHeight:Number;
      
      protected var accMinHeight:Number;
      
      private var overlayChild:IUIComponent;
      
      private var _historyManagementEnabled:Boolean = true;
      
      private var bSaveState:Boolean = false;
      
      protected var tweenContentWidth:Number;
      
      protected var tweenViewMetrics:EdgeMetrics;
      
      protected var currentDissolveEffect:Effect;
      
      protected var bSliding:Boolean = false;
      
      public function AccordionBase()
      {
         super();
         headerRenderer = new ClassFactory(AccordionHeader);
         tabEnabled = true;
         super.clipContent = false;
         addEventListener(Event.ADDED,addedHandler);
         addEventListener(Event.REMOVED,removedHandler);
         addEventListener(ChildExistenceChangedEvent.CHILD_ADD,childAddHandler);
         addEventListener(ChildExistenceChangedEvent.CHILD_REMOVE,childRemoveHandler);
         showInAutomationHierarchy = true;
      }
      
      override protected function keyDownHandler(event:KeyboardEvent) : void
      {
         var prevValue:int = 0;
         if(event.target != this)
         {
            return;
         }
         prevValue = selectedIndex;
         switch(event.keyCode)
         {
            case Keyboard.PAGE_DOWN:
               drawHeaderFocus(_focusedIndex,false);
               _focusedIndex = selectedIndex = selectedIndex < numChildren - 1 ? int(selectedIndex + 1) : 0;
               drawHeaderFocus(_focusedIndex,true);
               event.stopPropagation();
               dispatchChangeEvent(prevValue,selectedIndex,event);
               break;
            case Keyboard.PAGE_UP:
               drawHeaderFocus(_focusedIndex,false);
               _focusedIndex = selectedIndex = selectedIndex > 0 ? int(selectedIndex - 1) : int(numChildren - 1);
               drawHeaderFocus(_focusedIndex,true);
               event.stopPropagation();
               dispatchChangeEvent(prevValue,selectedIndex,event);
               break;
            case Keyboard.HOME:
               drawHeaderFocus(_focusedIndex,false);
               _focusedIndex = selectedIndex = 0;
               drawHeaderFocus(_focusedIndex,true);
               event.stopPropagation();
               dispatchChangeEvent(prevValue,selectedIndex,event);
               break;
            case Keyboard.END:
               drawHeaderFocus(_focusedIndex,false);
               _focusedIndex = selectedIndex = numChildren - 1;
               drawHeaderFocus(_focusedIndex,true);
               event.stopPropagation();
               dispatchChangeEvent(prevValue,selectedIndex,event);
               break;
            case Keyboard.DOWN:
            case Keyboard.RIGHT:
               drawHeaderFocus(_focusedIndex,false);
               _focusedIndex = _focusedIndex < numChildren - 1 ? int(_focusedIndex + 1) : 0;
               drawHeaderFocus(_focusedIndex,true);
               event.stopPropagation();
               break;
            case Keyboard.UP:
            case Keyboard.LEFT:
               drawHeaderFocus(_focusedIndex,false);
               _focusedIndex = _focusedIndex > 0 ? int(_focusedIndex - 1) : int(numChildren - 1);
               drawHeaderFocus(_focusedIndex,true);
               event.stopPropagation();
               break;
            case Keyboard.SPACE:
            case Keyboard.ENTER:
               event.stopPropagation();
               if(_focusedIndex != selectedIndex)
               {
                  selectedIndex = _focusedIndex;
                  dispatchChangeEvent(prevValue,selectedIndex,event);
               }
         }
      }
      
      override §§namespace("http://www.adobe.com/2006/flex/mx/internal") function addOverlay(color:uint, targetArea:RoundedRectangle = null) : void
      {
         if(Boolean(overlayChild))
         {
            removeOverlay();
         }
         overlayChild = selectedChild as IUIComponent;
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
      
      protected function instantiateSelectedChild() : void
      {
         if(!selectedChild)
         {
            return;
         }
         if(Boolean(selectedChild) && selectedChild.numChildrenCreated == -1)
         {
            selectedChild.createComponentsFromDescriptors();
         }
         invalidateSize();
         invalidateDisplayList();
         if(selectedChild is IInvalidating)
         {
            IInvalidating(selectedChild).invalidateSize();
         }
      }
      
      override protected function focusInHandler(event:FocusEvent) : void
      {
         super.focusInHandler(event);
         showFocusIndicator = focusManager.showFocusIndicator;
         if(event.target == this)
         {
            focusManager.defaultButtonEnabled = false;
         }
      }
      
      [Inspectable(environment="none")]
      override public function get horizontalScrollPolicy() : String
      {
         return ScrollPolicy.OFF;
      }
      
      protected function getHeaderHeight() : Number
      {
         var headerHeight:Number = NaN;
         headerHeight = Number(getStyle("headerHeight"));
         if(isNaN(headerHeight))
         {
            headerHeight = 0;
            if(numChildren > 0)
            {
               headerHeight = Number(getHeaderAt(0).measuredHeight);
            }
         }
         return headerHeight;
      }
      
      protected function get contentWidth() : Number
      {
         var contentWidth:Number = NaN;
         var vm:EdgeMetrics = null;
         contentWidth = Number(unscaledWidth);
         vm = viewMetricsAndPadding;
         contentWidth -= vm.left + vm.right;
         return contentWidth - (getStyle("paddingLeft") + getStyle("paddingRight"));
      }
      
      public function set headerRenderer(value:IFactory) : void
      {
         _headerRenderer = value;
         dispatchEvent(new Event("headerRendererChanged"));
      }
      
      [Inspectable(environment="none")]
      override public function get verticalScrollPolicy() : String
      {
         return ScrollPolicy.OFF;
      }
      
      public function saveState() : Object
      {
         var index:int = 0;
         index = _selectedIndex == -1 ? 0 : _selectedIndex;
         return {"selectedIndex":index};
      }
      
      override public function set horizontalScrollPolicy(value:String) : void
      {
      }
      
      override public function createComponentsFromDescriptors(recurse:Boolean = true) : void
      {
         var numChildrenBefore:int = 0;
         var n:int = 0;
         var i:int = 0;
         var descriptor:ComponentDescriptor = null;
         if(actualCreationPolicy == ContainerCreationPolicy.ALL)
         {
            super.createComponentsFromDescriptors();
            return;
         }
         numChildrenBefore = int(numChildren);
         if(Boolean(childDescriptors))
         {
            n = int(childDescriptors.length);
            for(i = 0; i < n; i++)
            {
               descriptor = ComponentDescriptor(childDescriptors[i]);
               createComponentFromDescriptor(descriptor,false);
            }
         }
         numChildrenCreated = numChildren - numChildrenBefore;
         processedDescriptors = true;
      }
      
      public function getHeaderAt(index:int) : Button
      {
         return Button(rawChildren.getChildByName(HEADER_NAME_BASE + index));
      }
      
      override protected function measure() : void
      {
         super.measure();
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function onTweenEnd(value:Number) : void
      {
         var oldSelectedIndex:int = 0;
         var vm:EdgeMetrics = null;
         var verticalGap:Number = NaN;
         var headerHeight:Number = NaN;
         var localContentWidth:Number = NaN;
         var localContentHeight:Number = NaN;
         var y:Number = NaN;
         var content:Container = null;
         var n:int = 0;
         var i:int = 0;
         var header:Button = null;
         bSliding = false;
         oldSelectedIndex = tweenOldSelectedIndex;
         vm = tweenViewMetrics;
         verticalGap = Number(getStyle("verticalGap"));
         headerHeight = getHeaderHeight();
         localContentWidth = calcContentWidth();
         localContentHeight = calcContentHeight();
         y = Number(vm.top);
         n = int(numChildren);
         for(i = 0; i < n; i++)
         {
            header = getHeaderAt(i);
            header.$y = y;
            y += headerHeight;
            if(i == selectedIndex)
            {
               content = Container(getChildAt(i));
               content.cacheAsBitmap = false;
               content.scrollRect = null;
               content.visible = true;
               y += localContentHeight;
            }
            y += verticalGap;
         }
         if(oldSelectedIndex != -1)
         {
            content = Container(getChildAt(oldSelectedIndex));
            content.cacheAsBitmap = false;
            content.scrollRect = null;
            content.visible = false;
            content.tweeningProperties = null;
         }
         tweenViewMetrics = null;
         tweenContentWidth = NaN;
         tweenContentHeight = NaN;
         tweenOldSelectedIndex = 0;
         tweenNewSelectedIndex = 0;
         tween = null;
         UIComponent.resumeBackgroundProcessing();
         Container(getChildAt(selectedIndex)).tweeningProperties = null;
         if(Boolean(currentDissolveEffect))
         {
            if(currentDissolveEffect.target != null)
            {
               currentDissolveEffect.play();
            }
            else
            {
               currentDissolveEffect.play([this]);
            }
         }
         callLater(instantiateSelectedChild);
      }
      
      private function initializeHandler(event:FlexEvent) : void
      {
         UIComponent(overlayChild).addOverlay(overlayColor,overlayTargetArea);
      }
      
      [Inspectable(environment="none")]
      override public function get autoLayout() : Boolean
      {
         return true;
      }
      
      private function childAddHandler(event:ChildExistenceChangedEvent) : void
      {
         var child:DisplayObject = null;
         var newHeader:Button = null;
         child = event.relatedObject;
         child.visible = false;
         createHeader(child,getChildIndex(child));
         child.addEventListener("labelChanged",labelChangedHandler);
         child.addEventListener("iconChanged",iconChangedHandler);
         if(numChildren == 1 && proposedSelectedIndex == -1)
         {
            selectedIndex = 0;
            newHeader = getHeaderAt(0);
            newHeader.selected = true;
            _focusedIndex = 0;
            drawHeaderFocus(_focusedIndex,showFocusIndicator);
         }
         if(Boolean(child as IAutomationObject))
         {
         }
         IAutomationObject(child).showInAutomationHierarchy = true;
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
         commitSelectedIndex();
         if(firstTime)
         {
            firstTime = false;
            systemManager.addEventListener(Event.REMOVED,systemManager_removedHandler);
         }
      }
      
      override public function set verticalScrollPolicy(value:String) : void
      {
      }
      
      public function set selectedIndex(value:int) : void
      {
         if(value == -1)
         {
            return;
         }
         if(value == _selectedIndex)
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
      
      override public function drawFocus(isFocused:Boolean) : void
      {
         drawHeaderFocus(_focusedIndex,isFocused);
      }
      
      override §§namespace("http://www.adobe.com/2006/flex/mx/internal") function setActualCreationPolicies(policy:String) : void
      {
         var n:int = 0;
         var i:int = 0;
         super.setActualCreationPolicies(policy);
         if(policy == ContainerCreationPolicy.ALL && numChildren > 0)
         {
            n = int(numChildren);
            for(i = 0; i < n; i++)
            {
               Container(getChildAt(i)).createComponentsFromDescriptors();
            }
         }
      }
      
      protected function getHeaderWidth() : Number
      {
         var headerWidth:Number = NaN;
         headerWidth = Number(getStyle("headerWidth"));
         if(isNaN(headerWidth))
         {
            headerWidth = 0;
            if(numChildren > 0)
            {
               headerWidth = Number(getHeaderAt(0).measuredHeight);
            }
         }
         return headerWidth;
      }
      
      override public function set clipContent(value:Boolean) : void
      {
      }
      
      private function labelChangedHandler(event:Event) : void
      {
         var child:DisplayObject = null;
         var childIndex:int = 0;
         var header:Button = null;
         child = DisplayObject(event.target);
         childIndex = int(getChildIndex(child));
         header = getHeaderAt(childIndex);
         header.label = Container(event.target).label;
      }
      
      private function addedHandler(event:Event) : void
      {
         if(event.target != this)
         {
            return;
         }
         if(historyManagementEnabled)
         {
            HistoryManager.register(this);
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
      
      private function shuffleHeaders(oldIndex:int, newIndex:int) : void
      {
         var i:int = 0;
         var header:Button = null;
         header = getHeaderAt(oldIndex);
         if(newIndex < oldIndex)
         {
            for(i = oldIndex; i > newIndex; i--)
            {
               getHeaderAt(i - 1).name = HEADER_NAME_BASE + i;
            }
         }
         else
         {
            for(i = oldIndex; i < newIndex; i++)
            {
               getHeaderAt(i + 1).name = HEADER_NAME_BASE + i;
            }
         }
         header.name = HEADER_NAME_BASE + newIndex;
      }
      
      private function childRemoveHandler(event:ChildExistenceChangedEvent) : void
      {
         var child:DisplayObject = null;
         var oldIndex:int = 0;
         var newIndex:int = 0;
         var index:int = 0;
         var nChildren:int = 0;
         var i:int = 0;
         var newHeader:Button = null;
         if(numChildren == 0)
         {
            return;
         }
         child = event.relatedObject;
         oldIndex = selectedIndex;
         index = int(getChildIndex(child));
         nChildren = numChildren - 1;
         rawChildren.removeChild(getHeaderAt(index));
         for(i = index; i < nChildren; i++)
         {
            getHeaderAt(i + 1).name = HEADER_NAME_BASE + i;
         }
         if(nChildren == 0)
         {
            newIndex = _focusedIndex = -1;
         }
         else
         {
            if(index > selectedIndex)
            {
               return;
            }
            if(index < selectedIndex)
            {
               newIndex = oldIndex - 1;
            }
            else if(index == selectedIndex)
            {
               if(index == nChildren)
               {
                  newIndex = oldIndex - 1;
               }
               else
               {
                  newIndex = oldIndex;
               }
               newHeader = getHeaderAt(newIndex);
               newHeader.selected = true;
            }
         }
         if(_focusedIndex > index)
         {
            --_focusedIndex;
            drawHeaderFocus(_focusedIndex,showFocusIndicator);
         }
         else if(_focusedIndex == index)
         {
            if(index == nChildren)
            {
               --_focusedIndex;
            }
            drawHeaderFocus(_focusedIndex,showFocusIndicator);
         }
         _selectedIndex = newIndex;
         instantiateSelectedChild();
         dispatchEvent(new FlexEvent(FlexEvent.VALUE_COMMIT));
      }
      
      protected function drawHeaderFocus(headerIndex:int, isFocused:Boolean) : void
      {
         if(headerIndex != -1)
         {
            getHeaderAt(headerIndex).drawFocus(isFocused);
         }
      }
      
      [Bindable("headerRendererChanged")]
      public function get headerRenderer() : IFactory
      {
         return _headerRenderer;
      }
      
      protected function calcContentHeight() : Number
      {
         var contentHeight:Number = NaN;
         var vm:EdgeMetrics = null;
         var verticalGap:Number = NaN;
         var headerHeight:Number = NaN;
         var n:int = 0;
         var i:int = 0;
         contentHeight = Number(unscaledHeight);
         vm = viewMetricsAndPadding;
         contentHeight -= vm.top + vm.bottom;
         verticalGap = Number(getStyle("verticalGap"));
         headerHeight = getHeaderHeight();
         n = int(numChildren);
         for(i = 0; i < n; i++)
         {
            contentHeight -= headerHeight;
            if(i > 0)
            {
               contentHeight -= verticalGap;
            }
         }
         return contentHeight;
      }
      
      public function set selectedChild(value:Container) : void
      {
         var newIndex:int = 0;
         newIndex = int(getChildIndex(DisplayObject(value)));
         if(newIndex >= 0 && newIndex < numChildren)
         {
            selectedIndex = newIndex;
         }
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
      
      private function removedHandler(event:Event) : void
      {
         if(event.target != this)
         {
            return;
         }
         HistoryManager.unregister(this);
      }
      
      private function systemManager_removedHandler(event:Event) : void
      {
         if(event.target == systemManager)
         {
            HistoryManager.unregister(this);
         }
      }
      
      private function iconChangedHandler(event:Event) : void
      {
         var child:DisplayObject = null;
         var childIndex:int = 0;
         var header:Button = null;
         child = DisplayObject(event.target);
         childIndex = int(getChildIndex(child));
         header = getHeaderAt(childIndex);
         header.setStyle("icon",Container(event.target).icon);
      }
      
      private function createHeader(content:DisplayObject, i:int) : void
      {
         var header:Button = null;
         var headerStyleName:String = null;
         var headerStyleDecl:CSSStyleDeclaration = null;
         var contentContainer:Container = null;
         var toolTip:String = null;
         if(selectedIndex != -1 && Boolean(getHeaderAt(selectedIndex)))
         {
            getHeaderAt(selectedIndex).selected = false;
         }
         header = Button(headerRenderer.newInstance());
         header.name = HEADER_NAME_BASE + (numChildren - 1);
         header.styleName = this;
         headerStyleName = getStyle("headerStyleName");
         if(Boolean(headerStyleName))
         {
            headerStyleDecl = StyleManager.getStyleDeclaration("." + headerStyleName);
            if(Boolean(headerStyleDecl))
            {
               header.styleDeclaration = headerStyleDecl;
            }
         }
         header.addEventListener(MouseEvent.CLICK,headerClickHandler);
         IDataRenderer(header).data = content;
         if(content is Container)
         {
            contentContainer = Container(content);
            header.label = contentContainer.label;
            if(Boolean(contentContainer.icon))
            {
               header.setStyle("icon",contentContainer.icon);
            }
            toolTip = contentContainer.toolTip;
            if(Boolean(toolTip) && toolTip != "")
            {
               header.toolTip = toolTip;
               contentContainer.toolTip = null;
            }
         }
         rawChildren.addChild(header);
         if(i != numChildren - 1)
         {
            shuffleHeaders(numChildren - 1,i);
         }
         if(selectedIndex != -1 && Boolean(getHeaderAt(selectedIndex)))
         {
            getHeaderAt(selectedIndex).selected = true;
         }
      }
      
      protected function get contentHeight() : Number
      {
         var contentHeight:Number = NaN;
         var vm:EdgeMetrics = null;
         var verticalGap:Number = NaN;
         var n:int = 0;
         var i:int = 0;
         contentHeight = Number(unscaledHeight);
         vm = viewMetricsAndPadding;
         contentHeight -= vm.top + vm.bottom;
         verticalGap = Number(getStyle("verticalGap"));
         n = int(numChildren);
         for(i = 0; i < n; i++)
         {
            contentHeight -= getHeaderAt(i).height;
            if(i > 0)
            {
               contentHeight -= verticalGap;
            }
         }
         return contentHeight;
      }
      
      [Inspectable(environment="none")]
      override public function get clipContent() : Boolean
      {
         return true;
      }
      
      override protected function focusOutHandler(event:FocusEvent) : void
      {
         super.focusOutHandler(event);
         showFocusIndicator = false;
         if(Boolean(focusManager) && event.target == this)
         {
            focusManager.defaultButtonEnabled = true;
         }
      }
      
      override public function setChildIndex(child:DisplayObject, newIndex:int) : void
      {
         var oldIndex:int = 0;
         var nChildren:int = 0;
         var oldSelectedHeader:Button = null;
         var newSelectedHeader:Button = null;
         oldIndex = int(getChildIndex(child));
         if(oldIndex == -1 || newIndex < 0)
         {
            return;
         }
         nChildren = int(numChildren);
         if(newIndex >= nChildren)
         {
            newIndex = nChildren - 1;
         }
         if(newIndex == oldIndex)
         {
            return;
         }
         oldSelectedHeader = getHeaderAt(selectedIndex);
         if(Boolean(oldSelectedHeader))
         {
            oldSelectedHeader.selected = false;
            drawHeaderFocus(_focusedIndex,false);
         }
         super.setChildIndex(child,newIndex);
         shuffleHeaders(oldIndex,newIndex);
         newSelectedHeader = getHeaderAt(selectedIndex);
         if(Boolean(newSelectedHeader))
         {
            newSelectedHeader.selected = true;
            drawHeaderFocus(_focusedIndex,showFocusIndicator);
         }
         instantiateSelectedChild();
      }
      
      [Inspectable(category="General",defaultValue="0")]
      [Bindable("valueCommit")]
      public function get selectedIndex() : int
      {
         if(proposedSelectedIndex != -1)
         {
            return proposedSelectedIndex;
         }
         return _selectedIndex;
      }
      
      protected function startTween(oldSelectedIndex:int, newSelectedIndex:int) : void
      {
         var openDuration:Number = NaN;
         var easingFunction:Function = null;
         var newSelectedChild:Container = null;
         var paddingLeft:Number = NaN;
         var contentX:Number = NaN;
         bSliding = true;
         tweenViewMetrics = viewMetricsAndPadding;
         tweenContentWidth = calcContentWidth();
         tweenContentHeight = calcContentHeight();
         tweenOldSelectedIndex = oldSelectedIndex;
         tweenNewSelectedIndex = newSelectedIndex;
         openDuration = Number(getStyle("openDuration"));
         tween = new Tween(this,0,tweenContentHeight,openDuration);
         easingFunction = getStyle("openEasingFunction") as Function;
         if(easingFunction != null)
         {
            tween.easingFunction = easingFunction;
         }
         if(oldSelectedIndex != -1)
         {
            Container(getChildAt(oldSelectedIndex)).tweeningProperties = ["x","y","width","height"];
         }
         Container(getChildAt(newSelectedIndex)).tweeningProperties = ["x","y","width","height"];
         newSelectedChild = Container(getChildAt(newSelectedIndex));
         if(newSelectedChild.numChildren == 0)
         {
            paddingLeft = Number(getStyle("paddingLeft"));
            contentX = borderMetrics.left + (paddingLeft > 0 ? paddingLeft : 0);
            newSelectedChild.move(contentX,newSelectedChild.y);
            newSelectedChild.setActualSize(tweenContentWidth,tweenContentHeight);
         }
      }
      
      [Inspectable(defaultValue="false")]
      public function get resizeToContent() : Boolean
      {
         return _resizeToContent;
      }
      
      protected function commitSelectedIndex() : void
      {
         var newIndex:int = 0;
         var oldIndex:int = 0;
         var dissolveInstanceClass:Class = null;
         var i:int = 0;
         if(proposedSelectedIndex == -1)
         {
            return;
         }
         newIndex = proposedSelectedIndex;
         proposedSelectedIndex = -1;
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
         oldIndex = _selectedIndex;
         if(newIndex == oldIndex)
         {
            return;
         }
         currentDissolveEffect = null;
         if(isEffectStarted)
         {
            dissolveInstanceClass = Class(systemManager.getDefinitionByName("mx.effects.effectClasses.DissolveInstance"));
            for(i = 0; i < _effectsStarted.length; i++)
            {
               if(Boolean(dissolveInstanceClass) && _effectsStarted[i] is dissolveInstanceClass)
               {
                  currentDissolveEffect = _effectsStarted[i].effect;
                  _effectsStarted[i].end();
                  break;
               }
            }
         }
         if(_focusedIndex != newIndex)
         {
            drawHeaderFocus(_focusedIndex,false);
         }
         if(oldIndex != -1)
         {
            getHeaderAt(oldIndex).selected = false;
         }
         _selectedIndex = newIndex;
         if(initialSelectedIndex == -1)
         {
            initialSelectedIndex = _selectedIndex;
         }
         getHeaderAt(newIndex).selected = true;
         if(_focusedIndex != newIndex)
         {
            _focusedIndex = newIndex;
            drawHeaderFocus(_focusedIndex,showFocusIndicator);
         }
         if(bSaveState)
         {
            HistoryManager.save();
            bSaveState = false;
         }
         if(getStyle("openDuration") == 0 || oldIndex == -1)
         {
            Container(getChildAt(newIndex)).setVisible(true);
            Container(getChildAt(newIndex)).setVisible(false,true);
            if(oldIndex != -1)
            {
               Container(getChildAt(oldIndex)).setVisible(false);
            }
            instantiateSelectedChild();
         }
         else
         {
            if(Boolean(tween))
            {
               tween.endTween();
            }
            startTween(oldIndex,newIndex);
         }
      }
      
      override §§namespace("http://www.adobe.com/2006/flex/mx/internal") function removeOverlay() : void
      {
         if(Boolean(overlayChild))
         {
            UIComponent(overlayChild).removeOverlay();
            overlayChild = null;
         }
      }
      
      public function loadState(state:Object) : void
      {
         var newIndex:int = 0;
         newIndex = Boolean(state) ? int(state.selectedIndex) : 0;
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
      
      [Inspectable(defaultValue="true")]
      public function get historyManagementEnabled() : Boolean
      {
         return _historyManagementEnabled;
      }
      
      [Bindable("valueCommit")]
      public function get selectedChild() : Container
      {
         if(selectedIndex == -1)
         {
            return null;
         }
         return Container(getChildAt(selectedIndex));
      }
      
      override public function set autoLayout(value:Boolean) : void
      {
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function get focusedIndex() : int
      {
         return _focusedIndex;
      }
      
      override public function styleChanged(styleProp:String) : void
      {
         var headerStyleName:Object = null;
         var headerStyleDecl:CSSStyleDeclaration = null;
         var i:int = 0;
         var header:Button = null;
         super.styleChanged(styleProp);
         if(!styleProp || styleProp == "headerStyleName" || styleProp == "styleName")
         {
            headerStyleName = getStyle("headerStyleName");
            if(Boolean(headerStyleName))
            {
               headerStyleDecl = StyleManager.getStyleDeclaration("." + headerStyleName);
               if(Boolean(headerStyleDecl))
               {
                  for(i = 0; i < numChildren; i++)
                  {
                     header = getHeaderAt(i);
                     if(Boolean(header))
                     {
                        header.styleDeclaration = headerStyleDecl;
                        header.regenerateStyleCache(true);
                        header.styleChanged(null);
                     }
                  }
               }
            }
         }
         else if(StyleManager.isSizeInvalidatingStyle(styleProp))
         {
            layoutStyleChanged = true;
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function onTweenUpdate(value:Number) : void
      {
         var vm:EdgeMetrics = null;
         var contentWidth:Number = NaN;
         var contentHeight:Number = NaN;
         var oldSelectedIndex:int = 0;
         var newSelectedIndex:int = 0;
         var newContentHeight:Number = NaN;
         var oldContentHeight:Number = NaN;
         var oldOffset:Number = NaN;
         var newOffset:Number = NaN;
         var y:Number = NaN;
         var verticalGap:Number = NaN;
         var n:int = 0;
         var i:int = 0;
         var header:Button = null;
         var content:Container = null;
         vm = tweenViewMetrics;
         contentWidth = tweenContentWidth;
         contentHeight = tweenContentHeight;
         oldSelectedIndex = tweenOldSelectedIndex;
         newSelectedIndex = tweenNewSelectedIndex;
         newContentHeight = value;
         oldContentHeight = contentHeight - value;
         oldOffset = oldSelectedIndex < newSelectedIndex ? -newContentHeight : newContentHeight;
         newOffset = newSelectedIndex > oldSelectedIndex ? oldContentHeight : -oldContentHeight;
         y = Number(vm.top);
         verticalGap = Number(getStyle("verticalGap"));
         n = int(numChildren);
         for(i = 0; i < n; i++)
         {
            header = getHeaderAt(i);
            content = Container(getChildAt(i));
            header.$y = y;
            y += header.height;
            if(i == oldSelectedIndex)
            {
               content.cacheAsBitmap = true;
               content.scrollRect = new Rectangle(0,-oldOffset,contentWidth,contentHeight);
               content.visible = true;
               y += oldContentHeight;
            }
            else if(i == newSelectedIndex)
            {
               content.cacheAsBitmap = true;
               content.scrollRect = new Rectangle(0,-newOffset,contentWidth,contentHeight);
               content.visible = true;
               y += newContentHeight;
            }
            y += verticalGap;
         }
      }
      
      protected function calcContentWidth() : Number
      {
         var contentWidth:Number = NaN;
         var vm:EdgeMetrics = null;
         contentWidth = Number(unscaledWidth);
         vm = viewMetricsAndPadding;
         return contentWidth - (vm.left + vm.right);
      }
      
      protected function headerClickHandler(event:Event) : void
      {
         var header:Button = null;
         var oldIndex:int = 0;
         var newIndex:int = 0;
         header = Button(event.currentTarget);
         oldIndex = selectedIndex;
         selectedChild = Container(IDataRenderer(header).data);
         newIndex = selectedIndex;
         if(oldIndex != newIndex)
         {
            dispatchChangeEvent(oldIndex,newIndex,event);
         }
      }
      
      private function dispatchChangeEvent(oldIndex:int, newIndex:int, cause:Event = null) : void
      {
         var indexChangeEvent:IndexChangedEvent = null;
         indexChangeEvent = new IndexChangedEvent(IndexChangedEvent.CHANGE);
         indexChangeEvent.oldIndex = oldIndex;
         indexChangeEvent.newIndex = newIndex;
         indexChangeEvent.relatedObject = getChildAt(newIndex);
         indexChangeEvent.triggerEvent = cause;
         dispatchEvent(indexChangeEvent);
      }
      
      override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         super.updateDisplayList(unscaledWidth,unscaledHeight);
      }
   }
}

