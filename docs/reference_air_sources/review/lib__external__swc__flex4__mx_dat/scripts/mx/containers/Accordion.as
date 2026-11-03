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
   import mx.core.IDataRenderer;
   import mx.core.IDeferredContentOwner;
   import mx.core.IFactory;
   import mx.core.IInvalidating;
   import mx.core.INavigatorContent;
   import mx.core.IUIComponent;
   import mx.core.ScrollPolicy;
   import mx.core.UIComponent;
   import mx.effects.Effect;
   import mx.effects.Tween;
   import mx.events.ChildExistenceChangedEvent;
   import mx.events.FlexEvent;
   import mx.events.IndexChangedEvent;
   import mx.geom.RoundedRectangle;
   import mx.managers.HistoryManager;
   import mx.managers.IFocusManagerComponent;
   import mx.managers.IHistoryManagerClient;
   
   [DefaultTriggerEvent("change")]
   [DefaultBindingProperty(source="selectedIndex",destination="selectedIndex")]
   [Exclude(name="focusThickness",kind="style")]
   [Exclude(name="focusSkin",kind="style")]
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
   [Style(name="paddingTop",type="Number",format="Length",inherit="no")]
   [Style(name="paddingBottom",type="Number",format="Length",inherit="no")]
   [Style(name="openEasingFunction",type="Function",inherit="no")]
   [Style(name="openDuration",type="Number",format="Time",inherit="no")]
   [Style(name="headerHeight",type="Number",format="Length",inherit="no")]
   [Style(name="horizontalGap",type="Number",format="Length",inherit="no")]
   [Style(name="headerStyleName",type="String",inherit="no")]
   [Event(name="change",type="mx.events.IndexChangedEvent")]
   [IconFile("Accordion.png")]
   [RequiresDataBinding("true")]
   public class Accordion extends Container implements IHistoryManagerClient, IFocusManagerComponent
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      private static const HEADER_NAME_BASE:String = "_header";
      
      private var bSliding:Boolean = false;
      
      private var initialSelectedIndex:int = -1;
      
      private var bSaveState:Boolean = false;
      
      private var bInLoadState:Boolean = false;
      
      private var firstTime:Boolean = true;
      
      private var showFocusIndicator:Boolean = false;
      
      private var tweenViewMetrics:EdgeMetrics;
      
      private var tweenContentWidth:Number;
      
      private var tweenContentHeight:Number;
      
      private var tweenOldSelectedIndex:int;
      
      private var tweenNewSelectedIndex:int;
      
      private var tween:Tween;
      
      private var accMinWidth:Number;
      
      private var accMinHeight:Number;
      
      private var accPreferredWidth:Number;
      
      private var accPreferredHeight:Number;
      
      private var childAddedOrRemoved:Boolean = false;
      
      private var overlayChild:IUIComponent;
      
      private var overlayTargetArea:RoundedRectangle;
      
      private var layoutStyleChanged:Boolean = false;
      
      private var currentDissolveEffect:Effect;
      
      private var _focusedIndex:int = -1;
      
      private var _headerRenderer:IFactory;
      
      private var _historyManagementEnabled:Boolean = true;
      
      private var historyManagementEnabledChanged:Boolean = false;
      
      private var _resizeToContent:Boolean = false;
      
      private var _selectedIndex:int = -1;
      
      private var proposedSelectedIndex:int = -1;
      
      public function Accordion()
      {
         super();
         this.headerRenderer = new ClassFactory(AccordionHeader);
         tabEnabled = true;
         tabFocusEnabled = true;
         hasFocusableChildren = true;
         super.clipContent = false;
         addEventListener(ChildExistenceChangedEvent.CHILD_ADD,this.childAddHandler);
         addEventListener(ChildExistenceChangedEvent.CHILD_REMOVE,this.childRemoveHandler);
         showInAutomationHierarchy = true;
      }
      
      [Inspectable(environment="none")]
      override public function get autoLayout() : Boolean
      {
         return true;
      }
      
      override public function set autoLayout(value:Boolean) : void
      {
      }
      
      override public function get baselinePosition() : Number
      {
         var child0:Container = null;
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
         var header0:Button = this.getHeaderAt(0);
         var result:Number = header0.y + header0.baselinePosition;
         if(isEmpty)
         {
            removeChildAt(0);
            validateNow();
         }
         return result;
      }
      
      [Inspectable(environment="none")]
      override public function get clipContent() : Boolean
      {
         return true;
      }
      
      override public function set clipContent(value:Boolean) : void
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
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function get focusedIndex() : int
      {
         return this._focusedIndex;
      }
      
      protected function get contentHeight() : Number
      {
         var contentHeight:Number = Number(unscaledHeight);
         var vm:EdgeMetrics = viewMetricsAndPadding;
         contentHeight -= vm.top + vm.bottom;
         var verticalGap:Number = Number(getStyle("verticalGap"));
         var n:int = numChildren;
         for(var i:int = 0; i < n; i++)
         {
            contentHeight -= this.getHeaderAt(i).height;
            if(i > 0)
            {
               contentHeight -= verticalGap;
            }
         }
         return contentHeight;
      }
      
      protected function get contentWidth() : Number
      {
         var contentWidth:Number = Number(unscaledWidth);
         var vm:EdgeMetrics = viewMetricsAndPadding;
         contentWidth -= vm.left + vm.right;
         return contentWidth - (getStyle("paddingLeft") + getStyle("paddingRight"));
      }
      
      [Bindable("headerRendererChanged")]
      public function get headerRenderer() : IFactory
      {
         return this._headerRenderer;
      }
      
      public function set headerRenderer(value:IFactory) : void
      {
         this._headerRenderer = value;
         dispatchEvent(new Event("headerRendererChanged"));
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
      
      [Inspectable(defaultValue="false")]
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
      
      [Inspectable(category="General",defaultValue="0")]
      [Bindable("valueCommit")]
      public function get selectedIndex() : int
      {
         if(this.proposedSelectedIndex != -1)
         {
            return this.proposedSelectedIndex;
         }
         return this._selectedIndex;
      }
      
      public function set selectedIndex(value:int) : void
      {
         if(value == -1)
         {
            return;
         }
         if(value == this._selectedIndex)
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
         var oldSelectedHeader:Button = this.getHeaderAt(this.selectedIndex);
         if(Boolean(oldSelectedHeader))
         {
            oldSelectedHeader.selected = false;
            this.drawHeaderFocus(this._focusedIndex,false);
         }
         super.setChildIndex(child,newIndex);
         this.shuffleHeaders(oldIndex,newIndex);
         var newSelectedHeader:Button = this.getHeaderAt(this.selectedIndex);
         if(Boolean(newSelectedHeader))
         {
            newSelectedHeader.selected = true;
            this.drawHeaderFocus(this._focusedIndex,this.showFocusIndicator);
         }
         this.instantiateChild(this.selectedChild);
      }
      
      private function shuffleHeaders(oldIndex:int, newIndex:int) : void
      {
         var i:int = 0;
         var header:Button = this.getHeaderAt(oldIndex);
         if(newIndex < oldIndex)
         {
            for(i = oldIndex; i > newIndex; i--)
            {
               this.getHeaderAt(i - 1).name = HEADER_NAME_BASE + i;
            }
         }
         else
         {
            for(i = oldIndex; i < newIndex; i++)
            {
               this.getHeaderAt(i + 1).name = HEADER_NAME_BASE + i;
            }
         }
         header.name = HEADER_NAME_BASE + newIndex;
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
         this.commitSelectedIndex();
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
         var preferredHeight:Number = NaN;
         var button:Button = null;
         var child:IUIComponent = null;
         super.measure();
         var minWidth:Number = 0;
         minHeight = 0;
         var preferredWidth:Number = 0;
         preferredHeight = 0;
         var paddingLeft:Number = Number(getStyle("paddingLeft"));
         var paddingRight:Number = Number(getStyle("paddingRight"));
         var headerHeight:Number = this.getHeaderHeight();
         if(Boolean(this.accPreferredWidth && !this._resizeToContent) && Boolean(!this.layoutStyleChanged) && !this.childAddedOrRemoved)
         {
            measuredMinWidth = this.accMinWidth;
            measuredMinHeight = this.accMinHeight;
            measuredWidth = this.accPreferredWidth;
            measuredHeight = this.accPreferredHeight;
            return;
         }
         this.layoutStyleChanged = false;
         this.childAddedOrRemoved = false;
         var n:int = numChildren;
         for(var i:int = 0; i < n; i++)
         {
            button = this.getHeaderAt(i);
            child = getLayoutChildAt(i);
            minWidth = Math.max(minWidth,button.minWidth);
            minHeight += headerHeight;
            preferredWidth = Math.max(preferredWidth,minWidth);
            preferredHeight += headerHeight;
            if(i == this.selectedIndex)
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
         if(Boolean(this.selectedChild) && INavigatorContent(this.selectedChild).deferredContentCreated == false)
         {
            return;
         }
         if(numChildren == 0)
         {
            return;
         }
         this.accMinWidth = minWidth;
         this.accMinHeight = minHeight;
         this.accPreferredWidth = preferredWidth;
         this.accPreferredHeight = preferredHeight;
      }
      
      override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         var header:Button = null;
         var content:IUIComponent = null;
         var contentW:Number = NaN;
         var contentH:Number = NaN;
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         if(Boolean(this.tween))
         {
            return;
         }
         var bm:EdgeMetrics = borderMetrics;
         var paddingLeft:Number = Number(getStyle("paddingLeft"));
         var paddingRight:Number = Number(getStyle("paddingRight"));
         var paddingTop:Number = Number(getStyle("paddingTop"));
         var verticalGap:Number = Number(getStyle("verticalGap"));
         var localContentWidth:Number = this.calcContentWidth();
         var localContentHeight:Number = this.calcContentHeight();
         var x:Number = bm.left + paddingLeft;
         var y:Number = bm.top + paddingTop;
         var contentX:Number = x;
         var adjContentWidth:Number = localContentWidth;
         var headerHeight:Number = this.getHeaderHeight();
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
            header = this.getHeaderAt(i);
            content = getLayoutChildAt(i);
            header.move(x,y);
            header.setActualSize(localContentWidth,headerHeight);
            y += headerHeight;
            if(i == this.selectedIndex)
            {
               content.move(contentX,y);
               content.visible = true;
               contentW = adjContentWidth;
               contentH = localContentHeight;
               if(!isNaN(content.percentWidth))
               {
                  if(contentW > content.maxWidth)
                  {
                     contentW = Number(content.maxWidth);
                  }
               }
               else if(contentW > content.getExplicitOrMeasuredWidth())
               {
                  contentW = Number(content.getExplicitOrMeasuredWidth());
               }
               if(!isNaN(content.percentHeight))
               {
                  if(contentH > content.maxHeight)
                  {
                     contentH = Number(content.maxHeight);
                  }
               }
               else if(contentH > content.getExplicitOrMeasuredHeight())
               {
                  contentH = Number(content.getExplicitOrMeasuredHeight());
               }
               if(content.width != contentW || content.height != contentH)
               {
                  content.setActualSize(contentW,contentH);
               }
               y += localContentHeight;
            }
            else
            {
               content.move(contentX,i < this.selectedIndex ? y : y - localContentHeight);
               content.visible = false;
            }
            y += verticalGap;
         }
         if(Boolean(blocker))
         {
            rawChildren.setChildIndex(blocker,numChildren - 1);
         }
         this.drawHeaderFocus(this._focusedIndex,this.showFocusIndicator);
      }
      
      override §§namespace("http://www.adobe.com/2006/flex/mx/internal") function setActualCreationPolicies(policy:String) : void
      {
         var n:int = 0;
         var i:int = 0;
         super.setActualCreationPolicies(policy);
         if(policy == ContainerCreationPolicy.ALL && numChildren > 0)
         {
            n = numChildren;
            for(i = 0; i < n; i++)
            {
               IDeferredContentOwner(getChildAt(i)).createDeferredContent();
            }
         }
      }
      
      override protected function focusInHandler(event:FocusEvent) : void
      {
         super.focusInHandler(event);
         this.showFocusIndicator = focusManager.showFocusIndicator;
         if(event.target == this)
         {
            focusManager.defaultButtonEnabled = false;
         }
      }
      
      override protected function focusOutHandler(event:FocusEvent) : void
      {
         super.focusOutHandler(event);
         this.showFocusIndicator = false;
         if(Boolean(focusManager) && event.target == this)
         {
            focusManager.defaultButtonEnabled = true;
         }
      }
      
      override public function drawFocus(isFocused:Boolean) : void
      {
         this.drawHeaderFocus(this._focusedIndex,isFocused);
      }
      
      override public function styleChanged(styleProp:String) : void
      {
         var headerStyleName:Object = null;
         var header:Button = null;
         var j:int = 0;
         super.styleChanged(styleProp);
         if(!styleProp || styleProp == "headerStyleName" || styleProp == "styleName")
         {
            headerStyleName = getStyle("headerStyleName");
            if(Boolean(headerStyleName))
            {
               for(j = 0; j < numChildren; j++)
               {
                  header = this.getHeaderAt(j);
                  if(Boolean(header))
                  {
                     header.styleName = headerStyleName;
                  }
               }
            }
         }
         else if(styleManager.isSizeInvalidatingStyle(styleProp))
         {
            this.layoutStyleChanged = true;
         }
      }
      
      override §§namespace("http://www.adobe.com/2006/flex/mx/internal") function addOverlay(color:uint, targetArea:RoundedRectangle = null) : void
      {
         if(Boolean(this.overlayChild))
         {
            this.removeOverlay();
         }
         this.overlayChild = this.selectedChild as IUIComponent;
         if(!this.overlayChild)
         {
            return;
         }
         effectOverlayColor = color;
         this.overlayTargetArea = targetArea;
         if(Boolean(this.selectedChild) && this.selectedChild.deferredContentCreated == false)
         {
            this.selectedChild.addEventListener(FlexEvent.INITIALIZE,this.initializeHandler);
         }
         else
         {
            this.initializeHandler(null);
         }
      }
      
      private function initializeHandler(event:FlexEvent) : void
      {
         UIComponent(this.overlayChild).addOverlay(effectOverlayColor,this.overlayTargetArea);
      }
      
      override §§namespace("http://www.adobe.com/2006/flex/mx/internal") function removeOverlay() : void
      {
         if(Boolean(this.overlayChild))
         {
            UIComponent(this.overlayChild).removeOverlay();
            this.overlayChild = null;
         }
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
      
      public function getHeaderAt(index:int) : Button
      {
         return Button(rawChildren.getChildByName(HEADER_NAME_BASE + index));
      }
      
      private function getHeaderHeight() : Number
      {
         var headerHeight:Number = Number(getStyle("headerHeight"));
         if(isNaN(headerHeight))
         {
            headerHeight = 0;
            if(numChildren > 0)
            {
               headerHeight = Number(this.getHeaderAt(0).measuredHeight);
            }
         }
         return headerHeight;
      }
      
      private function createHeader(content:DisplayObject, i:int) : void
      {
         var contentContainer:INavigatorContent = null;
         var toolTip:String = null;
         if(this.selectedIndex != -1 && Boolean(this.getHeaderAt(this.selectedIndex)))
         {
            this.getHeaderAt(this.selectedIndex).selected = false;
         }
         var header:Button = Button(this.headerRenderer.newInstance());
         header.name = HEADER_NAME_BASE + (numChildren - 1);
         var headerStyleName:String = getStyle("headerStyleName");
         if(Boolean(headerStyleName))
         {
            header.styleName = headerStyleName;
         }
         header.addEventListener(MouseEvent.CLICK,this.headerClickHandler);
         IDataRenderer(header).data = content;
         if(content is INavigatorContent)
         {
            contentContainer = INavigatorContent(content);
            header.label = contentContainer.label;
            if(Boolean(contentContainer.icon))
            {
               header.setStyle("icon",contentContainer.icon);
            }
            toolTip = (contentContainer as UIComponent).toolTip;
            if(Boolean(toolTip) && toolTip != "")
            {
               header.toolTip = toolTip;
               (contentContainer as UIComponent).toolTip = null;
            }
         }
         rawChildren.addChild(header);
         if(i != numChildren - 1)
         {
            this.shuffleHeaders(numChildren - 1,i);
         }
         if(this.selectedIndex != -1 && Boolean(this.getHeaderAt(this.selectedIndex)))
         {
            this.getHeaderAt(this.selectedIndex).selected = true;
         }
      }
      
      private function calcContentWidth() : Number
      {
         var contentWidth:Number = Number(unscaledWidth);
         var vm:EdgeMetrics = viewMetricsAndPadding;
         return contentWidth - (vm.left + vm.right);
      }
      
      private function calcContentHeight() : Number
      {
         var contentHeight:Number = Number(unscaledHeight);
         var vm:EdgeMetrics = viewMetricsAndPadding;
         contentHeight -= vm.top + vm.bottom;
         var verticalGap:Number = Number(getStyle("verticalGap"));
         var headerHeight:Number = this.getHeaderHeight();
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
      
      private function drawHeaderFocus(headerIndex:int, isFocused:Boolean) : void
      {
         if(headerIndex != -1)
         {
            this.getHeaderAt(headerIndex).drawFocus(isFocused);
         }
      }
      
      private function headerClickHandler(event:Event) : void
      {
         var header:Button = Button(event.currentTarget);
         var oldIndex:int = this.selectedIndex;
         this.selectedChild = INavigatorContent(IDataRenderer(header).data);
         var newIndex:int = this.selectedIndex;
         if(oldIndex != newIndex)
         {
            this.dispatchChangeEvent(oldIndex,newIndex,event);
         }
      }
      
      private function commitSelectedIndex() : void
      {
         var dissolveInstanceClass:Class = null;
         var i:int = 0;
         if(this.proposedSelectedIndex == -1)
         {
            return;
         }
         var newIndex:int = this.proposedSelectedIndex;
         this.proposedSelectedIndex = -1;
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
         var oldIndex:int = this._selectedIndex;
         if(newIndex == oldIndex)
         {
            return;
         }
         this.currentDissolveEffect = null;
         if(isEffectStarted)
         {
            dissolveInstanceClass = Class(systemManager.getDefinitionByName("mx.effects.effectClasses.DissolveInstance"));
            for(i = 0; i < _effectsStarted.length; i++)
            {
               if(Boolean(dissolveInstanceClass) && _effectsStarted[i] is dissolveInstanceClass)
               {
                  this.currentDissolveEffect = _effectsStarted[i].effect;
                  _effectsStarted[i].end();
                  break;
               }
            }
         }
         if(this._focusedIndex != newIndex)
         {
            this.drawHeaderFocus(this._focusedIndex,false);
         }
         if(oldIndex != -1)
         {
            this.getHeaderAt(oldIndex).selected = false;
         }
         this._selectedIndex = newIndex;
         if(this.initialSelectedIndex == -1)
         {
            this.initialSelectedIndex = this._selectedIndex;
         }
         this.getHeaderAt(newIndex).selected = true;
         if(this._focusedIndex != newIndex)
         {
            this._focusedIndex = newIndex;
            this.drawHeaderFocus(this._focusedIndex,this.showFocusIndicator);
         }
         if(this.bSaveState)
         {
            HistoryManager.save();
            this.bSaveState = false;
         }
         if(getStyle("openDuration") == 0 || oldIndex == -1)
         {
            IUIComponent(getChildAt(newIndex)).setVisible(true);
            IUIComponent(getChildAt(newIndex)).setVisible(false,true);
            if(oldIndex != -1)
            {
               IUIComponent(getChildAt(oldIndex)).setVisible(false);
            }
            this.instantiateChild(this.selectedChild);
         }
         else
         {
            if(Boolean(this.tween))
            {
               this.tween.endTween();
            }
            this.startTween(oldIndex,newIndex);
         }
      }
      
      private function instantiateChild(child:INavigatorContent) : void
      {
         if(!child)
         {
            return;
         }
         if(Boolean(child) && child.deferredContentCreated == false)
         {
            child.createDeferredContent();
         }
         invalidateSize();
         invalidateDisplayList();
         if(child is IInvalidating)
         {
            IInvalidating(child).invalidateSize();
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
      
      private function startTween(oldSelectedIndex:int, newSelectedIndex:int) : void
      {
         var paddingLeft:Number = NaN;
         var contentX:Number = NaN;
         this.bSliding = true;
         this.tweenViewMetrics = viewMetricsAndPadding;
         this.tweenContentWidth = this.calcContentWidth();
         this.tweenContentHeight = this.calcContentHeight();
         this.tweenOldSelectedIndex = oldSelectedIndex;
         this.tweenNewSelectedIndex = newSelectedIndex;
         var openDuration:Number = Number(getStyle("openDuration"));
         this.tween = new Tween(this,0,this.tweenContentHeight,openDuration);
         var easingFunction:Function = getStyle("openEasingFunction") as Function;
         if(easingFunction != null)
         {
            this.tween.easingFunction = easingFunction;
         }
         if(oldSelectedIndex != -1)
         {
            IUIComponent(getChildAt(oldSelectedIndex)).tweeningProperties = ["x","y","width","height"];
         }
         IUIComponent(getChildAt(newSelectedIndex)).tweeningProperties = ["x","y","width","height"];
         var newSelectedChild:IDeferredContentOwner = IDeferredContentOwner(getChildAt(newSelectedIndex));
         if(newSelectedChild.deferredContentCreated == false)
         {
            paddingLeft = Number(getStyle("paddingLeft"));
            contentX = borderMetrics.left + (paddingLeft > 0 ? paddingLeft : 0);
            newSelectedChild.move(contentX,newSelectedChild.y);
            newSelectedChild.setActualSize(this.tweenContentWidth,this.tweenContentHeight);
         }
         UIComponent.suspendBackgroundProcessing();
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function onTweenUpdate(value:Number) : void
      {
         var header:Button = null;
         var content:UIComponent = null;
         var vm:EdgeMetrics = this.tweenViewMetrics;
         var contentWidth:Number = this.tweenContentWidth;
         var contentHeight:Number = this.tweenContentHeight;
         var oldSelectedIndex:int = this.tweenOldSelectedIndex;
         var newSelectedIndex:int = this.tweenNewSelectedIndex;
         var newContentHeight:Number = value;
         var oldContentHeight:Number = contentHeight - value;
         var oldOffset:Number = oldSelectedIndex < newSelectedIndex ? -newContentHeight : newContentHeight;
         var newOffset:Number = newSelectedIndex > oldSelectedIndex ? oldContentHeight : -oldContentHeight;
         var y:Number = Number(vm.top);
         var verticalGap:Number = Number(getStyle("verticalGap"));
         var n:int = numChildren;
         for(var i:int = 0; i < n; i++)
         {
            header = this.getHeaderAt(i);
            content = UIComponent(getChildAt(i));
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
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function onTweenEnd(value:Number) : void
      {
         var content:UIComponent = null;
         var header:Button = null;
         this.bSliding = false;
         var oldSelectedIndex:int = this.tweenOldSelectedIndex;
         var vm:EdgeMetrics = this.tweenViewMetrics;
         var verticalGap:Number = Number(getStyle("verticalGap"));
         var headerHeight:Number = this.getHeaderHeight();
         var localContentWidth:Number = this.calcContentWidth();
         var localContentHeight:Number = this.calcContentHeight();
         var y:Number = Number(vm.top);
         var n:int = numChildren;
         for(var i:int = 0; i < n; i++)
         {
            header = this.getHeaderAt(i);
            header.$y = y;
            y += headerHeight;
            if(i == this.selectedIndex)
            {
               content = UIComponent(getChildAt(i));
               content.cacheAsBitmap = false;
               content.scrollRect = null;
               content.visible = true;
               y += localContentHeight;
            }
            y += verticalGap;
         }
         if(oldSelectedIndex != -1)
         {
            content = UIComponent(getChildAt(oldSelectedIndex));
            content.cacheAsBitmap = false;
            content.scrollRect = null;
            content.visible = false;
            content.tweeningProperties = null;
         }
         this.tweenViewMetrics = null;
         this.tweenContentWidth = NaN;
         this.tweenContentHeight = NaN;
         this.tweenOldSelectedIndex = 0;
         this.tweenNewSelectedIndex = 0;
         this.tween = null;
         UIComponent.resumeBackgroundProcessing();
         UIComponent(getChildAt(this.selectedIndex)).tweeningProperties = null;
         if(Boolean(this.currentDissolveEffect))
         {
            if(this.currentDissolveEffect.target != null)
            {
               this.currentDissolveEffect.play();
            }
            else
            {
               this.currentDissolveEffect.play([this]);
            }
         }
         callLater(this.instantiateChild,[this.selectedChild]);
      }
      
      override protected function keyDownHandler(event:KeyboardEvent) : void
      {
         if(event.target != this)
         {
            return;
         }
         var prevValue:int = this.selectedIndex;
         var keyCode:uint = uint(mapKeycodeForLayoutDirection(event));
         switch(keyCode)
         {
            case Keyboard.PAGE_DOWN:
               this.drawHeaderFocus(this._focusedIndex,false);
               this._focusedIndex = this.selectedIndex = this.selectedIndex < numChildren - 1 ? int(this.selectedIndex + 1) : 0;
               this.drawHeaderFocus(this._focusedIndex,true);
               event.stopPropagation();
               this.dispatchChangeEvent(prevValue,this.selectedIndex,event);
               break;
            case Keyboard.PAGE_UP:
               this.drawHeaderFocus(this._focusedIndex,false);
               this._focusedIndex = this.selectedIndex = this.selectedIndex > 0 ? int(this.selectedIndex - 1) : int(numChildren - 1);
               this.drawHeaderFocus(this._focusedIndex,true);
               event.stopPropagation();
               this.dispatchChangeEvent(prevValue,this.selectedIndex,event);
               break;
            case Keyboard.HOME:
               this.drawHeaderFocus(this._focusedIndex,false);
               this._focusedIndex = this.selectedIndex = 0;
               this.drawHeaderFocus(this._focusedIndex,true);
               event.stopPropagation();
               this.dispatchChangeEvent(prevValue,this.selectedIndex,event);
               break;
            case Keyboard.END:
               this.drawHeaderFocus(this._focusedIndex,false);
               this._focusedIndex = this.selectedIndex = numChildren - 1;
               this.drawHeaderFocus(this._focusedIndex,true);
               event.stopPropagation();
               this.dispatchChangeEvent(prevValue,this.selectedIndex,event);
               break;
            case Keyboard.DOWN:
            case Keyboard.RIGHT:
               this.drawHeaderFocus(this._focusedIndex,false);
               this._focusedIndex = this._focusedIndex < numChildren - 1 ? int(this._focusedIndex + 1) : 0;
               this.drawHeaderFocus(this._focusedIndex,true);
               event.stopPropagation();
               break;
            case Keyboard.UP:
            case Keyboard.LEFT:
               this.drawHeaderFocus(this._focusedIndex,false);
               this._focusedIndex = this._focusedIndex > 0 ? int(this._focusedIndex - 1) : int(numChildren - 1);
               this.drawHeaderFocus(this._focusedIndex,true);
               event.stopPropagation();
               break;
            case Keyboard.SPACE:
            case Keyboard.ENTER:
               event.stopPropagation();
               if(this._focusedIndex != this.selectedIndex)
               {
                  this.selectedIndex = this._focusedIndex;
                  this.dispatchChangeEvent(prevValue,this.selectedIndex,event);
               }
         }
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
      
      private function childAddHandler(event:ChildExistenceChangedEvent) : void
      {
         var newHeader:Button = null;
         this.childAddedOrRemoved = true;
         var child:DisplayObject = event.relatedObject;
         child.visible = false;
         this.createHeader(child,getChildIndex(child));
         child.addEventListener("labelChanged",this.labelChangedHandler,false,0,true);
         child.addEventListener("iconChanged",this.iconChangedHandler,false,0,true);
         if(numChildren == 1 && this.proposedSelectedIndex == -1)
         {
            this.selectedIndex = 0;
            newHeader = this.getHeaderAt(0);
            newHeader.selected = true;
            this._focusedIndex = 0;
            this.drawHeaderFocus(this._focusedIndex,this.showFocusIndicator);
         }
         if(Boolean(child as IAutomationObject))
         {
            IAutomationObject(child).showInAutomationHierarchy = true;
         }
      }
      
      private function childRemoveHandler(event:ChildExistenceChangedEvent) : void
      {
         var newIndex:int = 0;
         var newHeader:Button = null;
         this.childAddedOrRemoved = true;
         if(numChildren == 0)
         {
            return;
         }
         var child:DisplayObject = event.relatedObject;
         var oldIndex:int = this.selectedIndex;
         var index:int = getChildIndex(child);
         child.removeEventListener("labelChanged",this.labelChangedHandler);
         child.removeEventListener("iconChanged",this.iconChangedHandler);
         var nChildren:int = numChildren - 1;
         rawChildren.removeChild(this.getHeaderAt(index));
         for(var i:int = index; i < nChildren; i++)
         {
            this.getHeaderAt(i + 1).name = HEADER_NAME_BASE + i;
         }
         if(nChildren == 0)
         {
            newIndex = this._focusedIndex = -1;
         }
         else
         {
            if(index > this.selectedIndex)
            {
               return;
            }
            if(index < this.selectedIndex)
            {
               newIndex = oldIndex - 1;
            }
            else if(index == this.selectedIndex)
            {
               if(index == nChildren)
               {
                  newIndex = oldIndex - 1;
                  if(newIndex != -1)
                  {
                     this.instantiateChild(INavigatorContent(getChildAt(newIndex)));
                  }
               }
               else
               {
                  newIndex = oldIndex;
                  this.instantiateChild(INavigatorContent(getChildAt(newIndex + 1)));
               }
               newHeader = this.getHeaderAt(newIndex);
               newHeader.selected = true;
            }
         }
         if(this._focusedIndex > index)
         {
            --this._focusedIndex;
            this.drawHeaderFocus(this._focusedIndex,this.showFocusIndicator);
         }
         else if(this._focusedIndex == index)
         {
            if(index == nChildren)
            {
               --this._focusedIndex;
            }
            this.drawHeaderFocus(this._focusedIndex,this.showFocusIndicator);
         }
         this._selectedIndex = newIndex;
         dispatchEvent(new FlexEvent(FlexEvent.VALUE_COMMIT));
      }
      
      private function labelChangedHandler(event:Event) : void
      {
         var child:DisplayObject = DisplayObject(event.target);
         var childIndex:int = getChildIndex(child);
         var header:Button = this.getHeaderAt(childIndex);
         header.label = INavigatorContent(event.target).label;
      }
      
      private function iconChangedHandler(event:Event) : void
      {
         var child:DisplayObject = DisplayObject(event.target);
         var childIndex:int = getChildIndex(child);
         var header:Button = this.getHeaderAt(childIndex);
         header.setStyle("icon",INavigatorContent(event.target).icon);
      }
   }
}

