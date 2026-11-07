package mx.containers
{
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   import flash.ui.Keyboard;
   import mx.automation.IAutomationObject;
   import mx.containers.accordionClasses.AccordionHeader;
   import mx.controls.Button;
   import mx.core.ClassFactory;
   import mx.core.ComponentDescriptor;
   import mx.core.Container;
   import mx.core.ContainerCreationPolicy;
   import mx.core.EdgeMetrics;
   import mx.core.FlexVersion;
   import mx.core.IDataRenderer;
   import mx.core.IFactory;
   import mx.core.IInvalidating;
   import mx.core.IUIComponent;
   import mx.core.ScrollPolicy;
   import mx.core.UIComponent;
   import mx.core.mx_internal;
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
   
   use namespace mx_internal;
   
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
   [Style(name="verticalGap",type="Number",format="Length",inherit="no")]
   [Style(name="textSelectedColor",type="uint",format="Color",inherit="yes")]
   [Style(name="textRollOverColor",type="uint",format="Color",inherit="yes")]
   [Style(name="selectedFillColors",type="Array",arrayType="uint",format="Color",inherit="no",deprecatedReplacement="headerStyleName",deprecatedSince="3.0")]
   [Style(name="paddingTop",type="Number",format="Length",inherit="no")]
   [Style(name="paddingBottom",type="Number",format="Length",inherit="no")]
   [Style(name="openEasingFunction",type="Function",inherit="no")]
   [Style(name="openDuration",type="Number",format="Time",inherit="no")]
   [Style(name="headerHeight",type="Number",format="Length",inherit="no")]
   [Style(name="horizontalGap",type="Number",format="Length",inherit="no")]
   [Style(name="headerStyleName",type="String",inherit="no")]
   [Style(name="focusThickness",type="Number",format="Length",inherit="no",deprecatedReplacement="headerStyleName",deprecatedSince="3.0")]
   [Style(name="focusSkin",type="Class",inherit="no",deprecatedReplacement="headerStyleName",deprecatedSince="3.0")]
   [Style(name="focusRoundedCorners",type="String",inherit="no",deprecatedReplacement="headerStyleName",deprecatedSince="3.0")]
   [Style(name="focusAlpha",type="Number",inherit="no",deprecatedReplacement="headerStyleName",deprecatedSince="3.0")]
   [Style(name="fillColors",type="Array",arrayType="uint",format="Color",inherit="no",deprecatedReplacement="headerStyleName",deprecatedSince="3.0")]
   [Style(name="fillAlphas",type="Array",arrayType="Number",inherit="no",deprecatedReplacement="headerStyleName",deprecatedSince="3.0")]
   [Event(name="change",type="mx.events.IndexChangedEvent")]
   [IconFile("Accordion.png")]
   [RequiresDataBinding("true")]
   public class Accordion extends Container implements IHistoryManagerClient, IFocusManagerComponent
   {
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      private static const HEADER_NAME_BASE:String = "_header";
      
      private var historyManagementEnabledChanged:Boolean = false;
      
      private var layoutStyleChanged:Boolean = false;
      
      private var initialSelectedIndex:int = -1;
      
      private var childAddedOrRemoved:Boolean = false;
      
      private var overlayTargetArea:RoundedRectangle;
      
      private var proposedSelectedIndex:int = -1;
      
      private var accMinWidth:Number;
      
      private var currentDissolveEffect:Effect;
      
      private var accPreferredHeight:Number;
      
      private var tweenContentHeight:Number;
      
      private var tween:Tween;
      
      private var bSliding:Boolean = false;
      
      private var showFocusIndicator:Boolean = false;
      
      private var _focusedIndex:int = -1;
      
      private var _headerRenderer:IFactory;
      
      private var accMinHeight:Number;
      
      private var tweenOldSelectedIndex:int;
      
      private var firstTime:Boolean = true;
      
      private var accPreferredWidth:Number;
      
      private var _historyManagementEnabled:Boolean = true;
      
      private var overlayChild:IUIComponent;
      
      private var tweenNewSelectedIndex:int;
      
      private var bSaveState:Boolean = false;
      
      private var tweenContentWidth:Number;
      
      private var bInLoadState:Boolean = false;
      
      private var _resizeToContent:Boolean = false;
      
      private var tweenViewMetrics:EdgeMetrics;
      
      private var _selectedIndex:int = -1;
      
      public function Accordion()
      {
         super();
         headerRenderer = new ClassFactory(AccordionHeader);
         tabEnabled = true;
         super.clipContent = false;
         addEventListener(ChildExistenceChangedEvent.CHILD_ADD,childAddHandler);
         addEventListener(ChildExistenceChangedEvent.CHILD_REMOVE,childRemoveHandler);
         showInAutomationHierarchy = true;
      }
      
      protected function get contentHeight() : Number
      {
         var contentHeight:Number = unscaledHeight;
         var vm:EdgeMetrics = viewMetricsAndPadding;
         contentHeight -= vm.top + vm.bottom;
         var verticalGap:Number = getStyle("verticalGap");
         var n:int = numChildren;
         for(var i:int = 0; i < n; i++)
         {
            contentHeight -= getHeaderAt(i).height;
            if(i > 0)
            {
               contentHeight -= verticalGap;
            }
         }
         return contentHeight;
      }
      
      private function commitSelectedIndex() : void
      {
         var dissolveInstanceClass:Class = null;
         var i:int = 0;
         if(proposedSelectedIndex == -1)
         {
            return;
         }
         var newIndex:int = proposedSelectedIndex;
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
         var oldIndex:int = _selectedIndex;
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
            instantiateChild(selectedChild);
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
      
      private function dispatchChangeEvent(oldIndex:int, newIndex:int, cause:Event = null) : void
      {
         var indexChangeEvent:IndexChangedEvent = new IndexChangedEvent(IndexChangedEvent.CHANGE);
         indexChangeEvent.oldIndex = oldIndex;
         indexChangeEvent.newIndex = newIndex;
         indexChangeEvent.relatedObject = getChildAt(newIndex);
         indexChangeEvent.triggerEvent = cause;
         dispatchEvent(indexChangeEvent);
      }
      
      [Inspectable(environment="none")]
      override public function get clipContent() : Boolean
      {
         return true;
      }
      
      private function labelChangedHandler(event:Event) : void
      {
         var child:DisplayObject = DisplayObject(event.target);
         var childIndex:int = getChildIndex(child);
         var header:Button = getHeaderAt(childIndex);
         header.label = Container(event.target).label;
      }
      
      override public function set clipContent(value:Boolean) : void
      {
      }
      
      public function getHeaderAt(index:int) : Button
      {
         return Button(rawChildren.getChildByName(HEADER_NAME_BASE + index));
      }
      
      override public function setChildIndex(child:DisplayObject, newIndex:int) : void
      {
         var oldIndex:int = getChildIndex(child);
         if(oldIndex == -1 || newIndex < 0)
         {
            return;
         }
         var nChildren:int = numChildren;
         if(newIndex >= nChildren)
         {
            newIndex = nChildren - 1;
         }
         if(newIndex == oldIndex)
         {
            return;
         }
         var oldSelectedHeader:Button = getHeaderAt(selectedIndex);
         if(Boolean(oldSelectedHeader))
         {
            oldSelectedHeader.selected = false;
            drawHeaderFocus(_focusedIndex,false);
         }
         super.setChildIndex(child,newIndex);
         shuffleHeaders(oldIndex,newIndex);
         var newSelectedHeader:Button = getHeaderAt(selectedIndex);
         if(Boolean(newSelectedHeader))
         {
            newSelectedHeader.selected = true;
            drawHeaderFocus(_focusedIndex,showFocusIndicator);
         }
         instantiateChild(selectedChild);
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
      
      public function saveState() : Object
      {
         var index:int = _selectedIndex == -1 ? 0 : _selectedIndex;
         return {"selectedIndex":index};
      }
      
      private function startTween(oldSelectedIndex:int, newSelectedIndex:int) : void
      {
         var paddingLeft:Number = NaN;
         var contentX:Number = NaN;
         bSliding = true;
         tweenViewMetrics = viewMetricsAndPadding;
         tweenContentWidth = calcContentWidth();
         tweenContentHeight = calcContentHeight();
         tweenOldSelectedIndex = oldSelectedIndex;
         tweenNewSelectedIndex = newSelectedIndex;
         var openDuration:Number = getStyle("openDuration");
         tween = new Tween(this,0,tweenContentHeight,openDuration);
         var easingFunction:Function = getStyle("openEasingFunction") as Function;
         if(easingFunction != null)
         {
            tween.easingFunction = easingFunction;
         }
         if(oldSelectedIndex != -1)
         {
            Container(getChildAt(oldSelectedIndex)).tweeningProperties = ["x","y","width","height"];
         }
         Container(getChildAt(newSelectedIndex)).tweeningProperties = ["x","y","width","height"];
         var newSelectedChild:Container = Container(getChildAt(newSelectedIndex));
         if(newSelectedChild.numChildren == 0)
         {
            paddingLeft = getStyle("paddingLeft");
            contentX = borderMetrics.left + (paddingLeft > 0 ? paddingLeft : 0);
            newSelectedChild.move(contentX,newSelectedChild.y);
            newSelectedChild.setActualSize(tweenContentWidth,tweenContentHeight);
         }
         UIComponent.suspendBackgroundProcessing();
      }
      
      [Inspectable(defaultValue="false")]
      public function get resizeToContent() : Boolean
      {
         return _resizeToContent;
      }
      
      override mx_internal function removeOverlay() : void
      {
         if(Boolean(overlayChild))
         {
            UIComponent(overlayChild).removeOverlay();
            overlayChild = null;
         }
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
      
      override public function set horizontalScrollPolicy(value:String) : void
      {
      }
      
      override public function createComponentsFromDescriptors(recurse:Boolean = true) : void
      {
         var n:int = 0;
         var i:int = 0;
         var descriptor:ComponentDescriptor = null;
         if(actualCreationPolicy == ContainerCreationPolicy.ALL)
         {
            super.createComponentsFromDescriptors();
            return;
         }
         var numChildrenBefore:int = numChildren;
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
      
      private function shuffleHeaders(oldIndex:int, newIndex:int) : void
      {
         var i:int = 0;
         var header:Button = getHeaderAt(oldIndex);
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
      
      private function instantiateChild(child:Container) : void
      {
         if(!child)
         {
            return;
         }
         if(Boolean(child) && child.numChildrenCreated == -1)
         {
            child.createComponentsFromDescriptors();
         }
         invalidateSize();
         invalidateDisplayList();
         if(child is IInvalidating)
         {
            IInvalidating(child).invalidateSize();
         }
      }
      
      override protected function measure() : void
      {
         var preferredWidth:Number = NaN;
         var preferredHeight:Number = NaN;
         var button:Button = null;
         var child:IUIComponent = null;
         super.measure();
         var minWidth:Number = 0;
         var minHeight:Number = 0;
         preferredWidth = 0;
         preferredHeight = 0;
         var paddingLeft:Number = getStyle("paddingLeft");
         var paddingRight:Number = getStyle("paddingRight");
         var headerHeight:Number = getHeaderHeight();
         if(Boolean(accPreferredWidth && !_resizeToContent) && Boolean(!layoutStyleChanged) && !childAddedOrRemoved)
         {
            measuredMinWidth = accMinWidth;
            measuredMinHeight = accMinHeight;
            measuredWidth = accPreferredWidth;
            measuredHeight = accPreferredHeight;
            return;
         }
         layoutStyleChanged = false;
         childAddedOrRemoved = false;
         var n:int = numChildren;
         for(var i:int = 0; i < n; i++)
         {
            button = getHeaderAt(i);
            child = IUIComponent(getChildAt(i));
            minWidth = Math.max(minWidth,button.minWidth);
            minHeight += headerHeight;
            preferredWidth = Math.max(preferredWidth,minWidth);
            preferredHeight += headerHeight;
            if(i == selectedIndex)
            {
               preferredWidth = Math.max(preferredWidth,child.getExplicitOrMeasuredWidth());
               preferredHeight += child.getExplicitOrMeasuredHeight();
               minWidth = Math.max(minWidth,child.minWidth);
               minHeight += child.minHeight;
            }
         }
         var vm:EdgeMetrics = viewMetricsAndPadding;
         var widthPadding:Number = vm.left + vm.right;
         var heightPadding:Number = vm.top + vm.bottom;
         if(paddingLeft < 0)
         {
            widthPadding -= paddingLeft;
         }
         if(paddingRight < 0)
         {
            widthPadding -= paddingRight;
         }
         minWidth += widthPadding;
         preferredWidth += widthPadding;
         minHeight += heightPadding;
         preferredHeight += heightPadding;
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
         accMinWidth = minWidth;
         accMinHeight = minHeight;
         accPreferredWidth = preferredWidth;
         accPreferredHeight = preferredHeight;
      }
      
      private function drawHeaderFocus(headerIndex:int, isFocused:Boolean) : void
      {
         if(headerIndex != -1)
         {
            getHeaderAt(headerIndex).drawFocus(isFocused);
         }
      }
      
      override protected function keyDownHandler(event:KeyboardEvent) : void
      {
         if(event.target != this)
         {
            return;
         }
         var prevValue:int = selectedIndex;
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
      
      override protected function focusInHandler(event:FocusEvent) : void
      {
         super.focusInHandler(event);
         showFocusIndicator = focusManager.showFocusIndicator;
         if(event.target == this)
         {
            focusManager.defaultButtonEnabled = false;
         }
      }
      
      override mx_internal function addOverlay(color:uint, targetArea:RoundedRectangle = null) : void
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
      
      [Bindable("headerRendererChanged")]
      public function get headerRenderer() : IFactory
      {
         return _headerRenderer;
      }
      
      private function childRemoveHandler(event:ChildExistenceChangedEvent) : void
      {
         var newIndex:int = 0;
         var newHeader:Button = null;
         childAddedOrRemoved = true;
         if(numChildren == 0)
         {
            return;
         }
         var child:DisplayObject = event.relatedObject;
         var oldIndex:int = selectedIndex;
         var index:int = getChildIndex(child);
         child.removeEventListener("labelChanged",labelChangedHandler);
         child.removeEventListener("iconChanged",iconChangedHandler);
         var nChildren:int = numChildren - 1;
         rawChildren.removeChild(getHeaderAt(index));
         for(var i:int = index; i < nChildren; i++)
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
                  if(newIndex != -1)
                  {
                     instantiateChild(Container(getChildAt(newIndex)));
                  }
               }
               else
               {
                  newIndex = oldIndex;
                  instantiateChild(Container(getChildAt(newIndex + 1)));
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
         dispatchEvent(new FlexEvent(FlexEvent.VALUE_COMMIT));
      }
      
      override public function set autoLayout(value:Boolean) : void
      {
      }
      
      mx_internal function onTweenEnd(value:Number) : void
      {
         var content:Container = null;
         var header:Button = null;
         bSliding = false;
         var oldSelectedIndex:int = tweenOldSelectedIndex;
         var vm:EdgeMetrics = tweenViewMetrics;
         var verticalGap:Number = getStyle("verticalGap");
         var headerHeight:Number = getHeaderHeight();
         var localContentWidth:Number = calcContentWidth();
         var localContentHeight:Number = calcContentHeight();
         var y:Number = vm.top;
         var n:int = numChildren;
         for(var i:int = 0; i < n; i++)
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
         callLater(instantiateChild,[selectedChild]);
      }
      
      public function set selectedChild(value:Container) : void
      {
         var newIndex:int = getChildIndex(DisplayObject(value));
         if(newIndex >= 0 && newIndex < numChildren)
         {
            selectedIndex = newIndex;
         }
      }
      
      private function getHeaderHeight() : Number
      {
         var headerHeight:Number = getStyle("headerHeight");
         if(isNaN(headerHeight))
         {
            headerHeight = 0;
            if(numChildren > 0)
            {
               headerHeight = getHeaderAt(0).measuredHeight;
            }
         }
         return headerHeight;
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
      
      private function initializeHandler(event:FlexEvent) : void
      {
         UIComponent(overlayChild).addOverlay(overlayColor,overlayTargetArea);
      }
      
      mx_internal function get focusedIndex() : int
      {
         return _focusedIndex;
      }
      
      [Inspectable(environment="none")]
      override public function get horizontalScrollPolicy() : String
      {
         return ScrollPolicy.OFF;
      }
      
      private function childAddHandler(event:ChildExistenceChangedEvent) : void
      {
         var newHeader:Button = null;
         childAddedOrRemoved = true;
         var child:DisplayObject = event.relatedObject;
         child.visible = false;
         createHeader(child,getChildIndex(child));
         child.addEventListener("labelChanged",labelChangedHandler,false,0,true);
         child.addEventListener("iconChanged",iconChangedHandler,false,0,true);
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
      
      private function calcContentHeight() : Number
      {
         var contentHeight:Number = unscaledHeight;
         var vm:EdgeMetrics = viewMetricsAndPadding;
         contentHeight -= vm.top + vm.bottom;
         var verticalGap:Number = getStyle("verticalGap");
         var headerHeight:Number = getHeaderHeight();
         var n:int = numChildren;
         for(var i:int = 0; i < n; i++)
         {
            contentHeight -= headerHeight;
            if(i > 0)
            {
               contentHeight -= verticalGap;
            }
         }
         return contentHeight;
      }
      
      mx_internal function onTweenUpdate(value:Number) : void
      {
         var header:Button = null;
         var content:Container = null;
         var vm:EdgeMetrics = tweenViewMetrics;
         var contentWidth:Number = tweenContentWidth;
         var contentHeight:Number = tweenContentHeight;
         var oldSelectedIndex:int = tweenOldSelectedIndex;
         var newSelectedIndex:int = tweenNewSelectedIndex;
         var newContentHeight:Number = value;
         var oldContentHeight:Number = contentHeight - value;
         var oldOffset:Number = oldSelectedIndex < newSelectedIndex ? -newContentHeight : newContentHeight;
         var newOffset:Number = newSelectedIndex > oldSelectedIndex ? oldContentHeight : -oldContentHeight;
         var y:Number = vm.top;
         var verticalGap:Number = getStyle("verticalGap");
         var n:int = numChildren;
         for(var i:int = 0; i < n; i++)
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
      
      private function removedFromStageHandler(event:Event) : void
      {
         HistoryManager.unregister(this);
      }
      
      private function createHeader(content:DisplayObject, i:int) : void
      {
         var headerStyleDecl:CSSStyleDeclaration = null;
         var contentContainer:Container = null;
         var toolTip:String = null;
         if(selectedIndex != -1 && Boolean(getHeaderAt(selectedIndex)))
         {
            getHeaderAt(selectedIndex).selected = false;
         }
         var header:Button = Button(headerRenderer.newInstance());
         header.name = HEADER_NAME_BASE + (numChildren - 1);
         if(FlexVersion.compatibilityVersion < FlexVersion.VERSION_3_0)
         {
            header.styleName = this;
         }
         var headerStyleName:String = getStyle("headerStyleName");
         if(Boolean(headerStyleName))
         {
            if(FlexVersion.compatibilityVersion < FlexVersion.VERSION_3_0)
            {
               headerStyleDecl = StyleManager.getStyleDeclaration("." + headerStyleName);
               if(Boolean(headerStyleDecl))
               {
                  header.styleDeclaration = headerStyleDecl;
               }
            }
            else
            {
               header.styleName = headerStyleName;
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
      
      [Inspectable(environment="none")]
      override public function get autoLayout() : Boolean
      {
         return true;
      }
      
      override public function get baselinePosition() : Number
      {
         var child0:Container = null;
         if(FlexVersion.compatibilityVersion < FlexVersion.VERSION_3_0)
         {
            return super.baselinePosition;
         }
         if(!validateBaselinePosition())
         {
            return NaN;
         }
         var isEmpty:Boolean = numChildren == 0;
         if(isEmpty)
         {
            child0 = new Container();
            addChild(child0);
            validateNow();
         }
         var header0:Button = getHeaderAt(0);
         var result:Number = header0.y + header0.baselinePosition;
         if(isEmpty)
         {
            removeChildAt(0);
            validateNow();
         }
         return result;
      }
      
      override public function styleChanged(styleProp:String) : void
      {
         var headerStyleName:Object = null;
         var header:Button = null;
         var headerStyleDecl:CSSStyleDeclaration = null;
         var i:int = 0;
         var j:int = 0;
         super.styleChanged(styleProp);
         if(!styleProp || styleProp == "headerStyleName" || styleProp == "styleName")
         {
            headerStyleName = getStyle("headerStyleName");
            if(Boolean(headerStyleName))
            {
               if(FlexVersion.compatibilityVersion < FlexVersion.VERSION_3_0)
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
               else
               {
                  for(j = 0; j < numChildren; j++)
                  {
                     header = getHeaderAt(j);
                     if(Boolean(header))
                     {
                        header.styleName = headerStyleName;
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
      
      private function calcContentWidth() : Number
      {
         var contentWidth:Number = unscaledWidth;
         var vm:EdgeMetrics = viewMetricsAndPadding;
         return contentWidth - (vm.left + vm.right);
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
            addEventListener(Event.ADDED_TO_STAGE,addedToStageHandler,false,0,true);
            addEventListener(Event.REMOVED_FROM_STAGE,removedFromStageHandler,false,0,true);
         }
      }
      
      protected function get contentWidth() : Number
      {
         var contentWidth:Number = unscaledWidth;
         var vm:EdgeMetrics = viewMetricsAndPadding;
         contentWidth -= vm.left + vm.right;
         return contentWidth - (getStyle("paddingLeft") + getStyle("paddingRight"));
      }
      
      private function headerClickHandler(event:Event) : void
      {
         var header:Button = Button(event.currentTarget);
         var oldIndex:int = selectedIndex;
         selectedChild = Container(IDataRenderer(header).data);
         var newIndex:int = selectedIndex;
         if(oldIndex != newIndex)
         {
            dispatchChangeEvent(oldIndex,newIndex,event);
         }
      }
      
      private function iconChangedHandler(event:Event) : void
      {
         var child:DisplayObject = DisplayObject(event.target);
         var childIndex:int = getChildIndex(child);
         var header:Button = getHeaderAt(childIndex);
         header.setStyle("icon",Container(event.target).icon);
      }
      
      public function set headerRenderer(value:IFactory) : void
      {
         _headerRenderer = value;
         dispatchEvent(new Event("headerRendererChanged"));
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
      
      [Inspectable(environment="none")]
      override public function get verticalScrollPolicy() : String
      {
         return ScrollPolicy.OFF;
      }
      
      override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         var header:Button = null;
         var content:IUIComponent = null;
         var contentW:Number = NaN;
         var contentH:Number = NaN;
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         if(Boolean(tween))
         {
            return;
         }
         var bm:EdgeMetrics = borderMetrics;
         var paddingLeft:Number = getStyle("paddingLeft");
         var paddingRight:Number = getStyle("paddingRight");
         var paddingTop:Number = getStyle("paddingTop");
         var verticalGap:Number = getStyle("verticalGap");
         var localContentWidth:Number = calcContentWidth();
         var localContentHeight:Number = calcContentHeight();
         var x:Number = bm.left + paddingLeft;
         var y:Number = bm.top + paddingTop;
         var contentX:Number = x;
         var adjContentWidth:Number = localContentWidth;
         var headerHeight:Number = getHeaderHeight();
         if(paddingLeft < 0)
         {
            contentX -= paddingLeft;
            adjContentWidth += paddingLeft;
         }
         if(paddingRight < 0)
         {
            adjContentWidth += paddingRight;
         }
         var n:int = numChildren;
         for(var i:int = 0; i < n; i++)
         {
            header = getHeaderAt(i);
            content = IUIComponent(getChildAt(i));
            header.move(x,y);
            header.setActualSize(localContentWidth,headerHeight);
            y += headerHeight;
            if(i == selectedIndex)
            {
               content.move(contentX,y);
               content.visible = true;
               contentW = adjContentWidth;
               contentH = localContentHeight;
               if(!isNaN(content.percentWidth))
               {
                  if(contentW > content.maxWidth)
                  {
                     contentW = content.maxWidth;
                  }
               }
               else if(contentW > content.getExplicitOrMeasuredWidth())
               {
                  contentW = content.getExplicitOrMeasuredWidth();
               }
               if(!isNaN(content.percentHeight))
               {
                  if(contentH > content.maxHeight)
                  {
                     contentH = content.maxHeight;
                  }
               }
               else if(contentH > content.getExplicitOrMeasuredHeight())
               {
                  contentH = content.getExplicitOrMeasuredHeight();
               }
               if(content.width != contentW || content.height != contentH)
               {
                  content.setActualSize(contentW,contentH);
               }
               y += localContentHeight;
            }
            else
            {
               content.move(contentX,i < selectedIndex ? y : y - localContentHeight);
               content.visible = false;
            }
            y += verticalGap;
         }
         if(Boolean(blocker))
         {
            rawChildren.setChildIndex(blocker,numChildren - 1);
         }
         drawHeaderFocus(_focusedIndex,showFocusIndicator);
      }
      
      override public function drawFocus(isFocused:Boolean) : void
      {
         drawHeaderFocus(_focusedIndex,isFocused);
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
      
      override mx_internal function setActualCreationPolicies(policy:String) : void
      {
         var n:int = 0;
         var i:int = 0;
         super.mx_internal::setActualCreationPolicies(policy);
         if(policy == ContainerCreationPolicy.ALL && numChildren > 0)
         {
            n = numChildren;
            for(i = 0; i < n; i++)
            {
               Container(getChildAt(i)).createComponentsFromDescriptors();
            }
         }
      }
   }
}

