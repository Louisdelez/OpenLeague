package mx.containers
{
   import flash.display.DisplayObject;
   import flash.events.FocusEvent;
   import flash.events.KeyboardEvent;
   import mx.controls.Button;
   import mx.controls.TabBar;
   import mx.core.Container;
   import mx.core.EdgeMetrics;
   import mx.core.IFlexDisplayObject;
   import mx.core.IInvalidating;
   import mx.core.IProgrammaticSkin;
   import mx.core.IUIComponent;
   import mx.core.UIComponent;
   import mx.managers.IFocusManagerComponent;
   import mx.styles.StyleProxy;
   
   [IconFile("TabNavigator.png")]
   [Exclude(name="verticalScrollBarStyleName",kind="style")]
   [Exclude(name="horizontalScrollBarStyleName",kind="style")]
   [Exclude(name="fillColors",kind="style")]
   [Exclude(name="fillAlphas",kind="style")]
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
   [Style(name="tabOffset",type="Number",format="Length",inherit="no")]
   [Style(name="tabWidth",type="Number",format="Length",inherit="no")]
   [Style(name="tabStyleName",type="String",inherit="no")]
   [Style(name="tabHeight",type="Number",format="Length",inherit="no")]
   [Style(name="selectedTabTextStyleName",type="String",inherit="no")]
   [Style(name="lastTabStyleName",type="String",inherit="no")]
   [Style(name="horizontalGap",type="Number",format="Length",inherit="no")]
   [Style(name="horizontalAlign",type="String",enumeration="left,center,right",inherit="no")]
   [Style(name="firstTabStyleName",type="String",inherit="no")]
   [Style(name="focusRoundedCorners",type="String",inherit="no")]
   [Style(name="focusAlpha",type="Number",inherit="no")]
   [Style(name="fillColors",type="Array",arrayType="uint",format="Color",inherit="no",theme="halo")]
   [Style(name="fillAlphas",type="Array",arrayType="Number",inherit="no",theme="halo")]
   public class TabNavigator extends ViewStack implements IFocusManagerComponent
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      private static const MIN_TAB_WIDTH:Number = 30;
      
      private static var _tabBarStyleFilters:Object = {
         "firstTabStyleName":"firstTabStyleName",
         "horizontalAlign":"horizontalAlign",
         "horizontalGap":"horizontalGap",
         "lastTabStyleName":"lastTabStyleName",
         "selectedTabTextStyleName":"selectedTabTextStyleName",
         "tabStyleName":"tabStyleName",
         "tabWidth":"tabWidth",
         "verticalAlign":"verticalAlign",
         "verticalGap":"verticalGap"
      };
      
      protected var tabBar:TabBar;
      
      public function TabNavigator()
      {
         super();
         tabEnabled = true;
         tabFocusEnabled = true;
         hasFocusableChildren = true;
         historyManagementEnabled = true;
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
         var tab0:Button = this.getTabAt(0);
         var result:Number = this.tabBar.y + tab0.y + tab0.baselinePosition;
         if(isEmpty)
         {
            removeChildAt(0);
            validateNow();
         }
         return result;
      }
      
      override protected function get contentHeight() : Number
      {
         var vm:EdgeMetrics = viewMetricsAndPadding;
         var vmTop:Number = Number(vm.top);
         var vmBottom:Number = Number(vm.bottom);
         if(isNaN(vmTop))
         {
            vmTop = 0;
         }
         if(isNaN(vmBottom))
         {
            vmBottom = 0;
         }
         return unscaledHeight - this.tabBarHeight - vmTop - vmBottom;
      }
      
      override protected function get contentY() : Number
      {
         var paddingTop:Number = Number(getStyle("paddingTop"));
         if(isNaN(paddingTop))
         {
            paddingTop = 0;
         }
         return this.tabBarHeight + paddingTop;
      }
      
      private function get tabBarHeight() : Number
      {
         var tabHeight:Number = Number(getStyle("tabHeight"));
         if(isNaN(tabHeight))
         {
            tabHeight = Number(this.tabBar.getExplicitOrMeasuredHeight());
         }
         return tabHeight - borderMetrics.top;
      }
      
      protected function get tabBarStyleFilters() : Object
      {
         return _tabBarStyleFilters;
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         if(!this.tabBar)
         {
            this.tabBar = new TabBar();
            this.tabBar.name = "tabBar";
            this.tabBar.focusEnabled = false;
            this.tabBar.styleName = new StyleProxy(this,this.tabBarStyleFilters);
            rawChildren.addChild(this.tabBar);
         }
      }
      
      override protected function commitProperties() : void
      {
         super.commitProperties();
         if(Boolean(this.tabBar && this.tabBar.dataProvider != this) && Boolean(numChildren > 0) && Boolean(getChildAt(0)))
         {
            this.tabBar.dataProvider = this;
         }
      }
      
      override protected function measure() : void
      {
         var addedHeight:Number = NaN;
         if(Boolean(vsPreferredWidth) && !resizeToContent)
         {
            measuredMinWidth = vsMinWidth;
            measuredMinHeight = vsMinHeight;
            measuredWidth = vsPreferredWidth;
            measuredHeight = vsPreferredHeight;
            return;
         }
         super.measure();
         addedHeight = this.tabBarHeight;
         measuredMinHeight += addedHeight;
         measuredHeight += addedHeight;
         var tabWidth:Number = Number(getStyle("tabWidth"));
         if(isNaN(tabWidth))
         {
            tabWidth = 0;
         }
         var minTabBarWidth:Number = numChildren * Math.max(tabWidth,MIN_TAB_WIDTH);
         var vm:EdgeMetrics = viewMetrics;
         minTabBarWidth += vm.left + vm.right;
         if(numChildren > 1)
         {
            minTabBarWidth += getStyle("horizontalGap") * (numChildren - 1);
         }
         if(measuredWidth < minTabBarWidth)
         {
            measuredWidth = minTabBarWidth;
         }
         if(Boolean(selectedChild) && selectedChild.deferredContentCreated == false)
         {
            return;
         }
         if(numChildren == 0)
         {
            return;
         }
         vsMinWidth = measuredMinWidth;
         vsMinHeight = measuredMinHeight;
         vsPreferredWidth = measuredWidth;
         vsPreferredHeight = measuredHeight;
      }
      
      override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         var bm:EdgeMetrics = borderMetrics;
         var vm:EdgeMetrics = viewMetrics;
         var w:Number = unscaledWidth - vm.left - vm.right;
         var th:Number = this.tabBarHeight + bm.top;
         var pw:Number = Number(this.tabBar.getExplicitOrMeasuredWidth());
         this.tabBar.setActualSize(Math.min(w,pw),th);
         var leftOffset:Number = Number(getStyle("tabOffset"));
         switch(getStyle("horizontalAlign"))
         {
            case "left":
               this.tabBar.move(0 + leftOffset,this.tabBar.y);
               break;
            case "right":
               this.tabBar.move(unscaledWidth - this.tabBar.width + leftOffset,this.tabBar.y);
               break;
            case "center":
               this.tabBar.move((unscaledWidth - this.tabBar.width) / 2 + leftOffset,this.tabBar.y);
         }
      }
      
      override public function drawFocus(isFocused:Boolean) : void
      {
         var n:int = 0;
         var fci:int = 0;
         super.drawFocus(isFocused);
         if(!parent)
         {
            return;
         }
         var focusObj:DisplayObject = IUIComponent(parent).focusPane;
         if(isFocused && !isEffectStarted)
         {
            if(Boolean(focusObj))
            {
               if(parent is Container)
               {
                  n = int(Container(parent).rawChildren.numChildren);
                  fci = Container(parent).firstChildIndex;
                  Container(parent).rawChildren.setChildIndex(focusObj,Math.max(0,fci == n ? n - 1 : fci));
               }
               else if(parent is UIComponent)
               {
                  UIComponent(parent).$setChildIndex(focusObj,0);
               }
               else
               {
                  parent.setChildIndex(focusObj,0);
               }
            }
         }
         else if(Boolean(focusObj))
         {
            if(parent is Container)
            {
               Container(parent).rawChildren.setChildIndex(focusObj,Container(parent).rawChildren.numChildren - 1);
            }
            else if(parent is UIComponent)
            {
               UIComponent(parent).$setChildIndex(focusObj,parent.numChildren - 1);
            }
            else
            {
               parent.setChildIndex(focusObj,parent.numChildren - 1);
            }
         }
         this.tabBar.drawFocus(isFocused);
      }
      
      override protected function adjustFocusRect(object:DisplayObject = null) : void
      {
         super.adjustFocusRect(object);
         var focusObj:IFlexDisplayObject = IFlexDisplayObject(getFocusObject());
         if(Boolean(focusObj))
         {
            focusObj.setActualSize(focusObj.width,focusObj.height - this.tabBarHeight);
            focusObj.move(focusObj.x,focusObj.y + this.tabBarHeight);
            if(focusObj is IInvalidating)
            {
               IInvalidating(focusObj).validateNow();
            }
            else if(focusObj is IProgrammaticSkin)
            {
               IProgrammaticSkin(focusObj).validateNow();
            }
         }
      }
      
      override protected function layoutChrome(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         var borderOffset:Number = NaN;
         super.layoutChrome(unscaledWidth,unscaledHeight);
         if(Boolean(border))
         {
            borderOffset = this.tabBarHeight;
            border.setActualSize(unscaledWidth,unscaledHeight - borderOffset);
            border.move(0,borderOffset);
         }
      }
      
      public function getTabAt(index:int) : Button
      {
         return Button(this.tabBar.getChildAt(index));
      }
      
      override protected function focusInHandler(event:FocusEvent) : void
      {
         super.focusInHandler(event);
         if(event.target == this)
         {
            focusManager.defaultButtonEnabled = false;
         }
      }
      
      override protected function focusOutHandler(event:FocusEvent) : void
      {
         super.focusOutHandler(event);
         if(Boolean(focusManager) && event.target == this)
         {
            focusManager.defaultButtonEnabled = true;
         }
      }
      
      override protected function keyDownHandler(event:KeyboardEvent) : void
      {
         if(focusManager.getFocus() == this)
         {
            this.tabBar.dispatchEvent(event);
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function getTabBar() : TabBar
      {
         return this.tabBar;
      }
   }
}

