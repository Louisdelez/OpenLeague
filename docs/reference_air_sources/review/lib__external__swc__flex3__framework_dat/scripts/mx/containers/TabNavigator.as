package mx.containers
{
   import flash.display.DisplayObject;
   import flash.events.FocusEvent;
   import flash.events.KeyboardEvent;
   import mx.controls.Button;
   import mx.controls.TabBar;
   import mx.core.Container;
   import mx.core.EdgeMetrics;
   import mx.core.FlexVersion;
   import mx.core.IFlexDisplayObject;
   import mx.core.IInvalidating;
   import mx.core.IProgrammaticSkin;
   import mx.core.IUIComponent;
   import mx.core.mx_internal;
   import mx.managers.IFocusManagerComponent;
   import mx.styles.StyleProxy;
   
   use namespace mx_internal;
   
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
   [Style(name="fillColors",type="Array",arrayType="uint",format="Color",inherit="no")]
   [Style(name="fillAlphas",type="Array",arrayType="Number",inherit="no")]
   public class TabNavigator extends ViewStack implements IFocusManagerComponent
   {
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
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
         historyManagementEnabled = true;
      }
      
      override protected function get contentHeight() : Number
      {
         var vm:EdgeMetrics = viewMetricsAndPadding;
         var vmTop:Number = vm.top;
         var vmBottom:Number = vm.bottom;
         if(isNaN(vmTop))
         {
            vmTop = 0;
         }
         if(isNaN(vmBottom))
         {
            vmBottom = 0;
         }
         return unscaledHeight - tabBarHeight - vmTop - vmBottom;
      }
      
      mx_internal function getTabBar() : TabBar
      {
         return tabBar;
      }
      
      override protected function layoutChrome(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         var borderOffset:Number = NaN;
         super.layoutChrome(unscaledWidth,unscaledHeight);
         if(Boolean(border))
         {
            borderOffset = tabBarHeight;
            border.setActualSize(unscaledWidth,unscaledHeight - borderOffset);
            border.move(0,borderOffset);
         }
      }
      
      private function get tabBarHeight() : Number
      {
         var tabHeight:Number = getStyle("tabHeight");
         if(isNaN(tabHeight))
         {
            tabHeight = tabBar.getExplicitOrMeasuredHeight();
         }
         return tabHeight - borderMetrics.top;
      }
      
      override protected function get contentY() : Number
      {
         var paddingTop:Number = getStyle("paddingTop");
         if(isNaN(paddingTop))
         {
            paddingTop = 0;
         }
         return tabBarHeight + paddingTop;
      }
      
      override protected function commitProperties() : void
      {
         super.commitProperties();
         if(Boolean(tabBar && tabBar.dataProvider != this) && Boolean(numChildren > 0) && Boolean(getChildAt(0)))
         {
            tabBar.dataProvider = this;
         }
      }
      
      override protected function adjustFocusRect(object:DisplayObject = null) : void
      {
         super.adjustFocusRect(object);
         var focusObj:IFlexDisplayObject = IFlexDisplayObject(getFocusObject());
         if(Boolean(focusObj))
         {
            focusObj.setActualSize(focusObj.width,focusObj.height - tabBarHeight);
            focusObj.move(focusObj.x,focusObj.y + tabBarHeight);
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
      
      override protected function focusOutHandler(event:FocusEvent) : void
      {
         super.focusOutHandler(event);
         if(Boolean(focusManager) && event.target == this)
         {
            focusManager.defaultButtonEnabled = true;
         }
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         if(!tabBar)
         {
            tabBar = new TabBar();
            tabBar.name = "tabBar";
            tabBar.focusEnabled = false;
            tabBar.styleName = new StyleProxy(this,tabBarStyleFilters);
            rawChildren.addChild(tabBar);
            if(FlexVersion.compatibilityVersion < FlexVersion.VERSION_3_0)
            {
               tabBar.setStyle("paddingTop",0);
               tabBar.setStyle("paddingBottom",0);
               tabBar.setStyle("borderStyle","none");
            }
         }
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
         var tab0:Button = getTabAt(0);
         var result:Number = tabBar.y + tab0.y + tab0.baselinePosition;
         if(isEmpty)
         {
            removeChildAt(0);
            validateNow();
         }
         return result;
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
         addedHeight = tabBarHeight;
         measuredMinHeight += addedHeight;
         measuredHeight += addedHeight;
         var tabWidth:Number = getStyle("tabWidth");
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
         if(Boolean(selectedChild) && Container(selectedChild).numChildrenCreated == -1)
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
      
      protected function get tabBarStyleFilters() : Object
      {
         return _tabBarStyleFilters;
      }
      
      override protected function keyDownHandler(event:KeyboardEvent) : void
      {
         if(focusManager.getFocus() == this)
         {
            tabBar.dispatchEvent(event);
         }
      }
      
      override protected function focusInHandler(event:FocusEvent) : void
      {
         super.focusInHandler(event);
         if(event.target == this)
         {
            focusManager.defaultButtonEnabled = false;
         }
      }
      
      public function getTabAt(index:int) : Button
      {
         return Button(tabBar.getChildAt(index));
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
                  n = Container(parent).rawChildren.numChildren;
                  fci = Container(parent).firstChildIndex;
                  Container(parent).rawChildren.setChildIndex(focusObj,Math.max(0,fci == n ? n - 1 : fci));
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
            else
            {
               parent.setChildIndex(focusObj,parent.numChildren - 1);
            }
         }
         tabBar.drawFocus(isFocused);
      }
      
      override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         var bm:EdgeMetrics = borderMetrics;
         var vm:EdgeMetrics = viewMetrics;
         var w:Number = unscaledWidth - vm.left - vm.right;
         var th:Number = tabBarHeight + bm.top;
         var pw:Number = tabBar.getExplicitOrMeasuredWidth();
         tabBar.setActualSize(Math.min(w,pw),th);
         var leftOffset:Number = getStyle("tabOffset");
         switch(getStyle("horizontalAlign"))
         {
            case "left":
               tabBar.move(0 + leftOffset,tabBar.y);
               break;
            case "right":
               tabBar.move(unscaledWidth - tabBar.width + leftOffset,tabBar.y);
               break;
            case "center":
               tabBar.move((unscaledWidth - tabBar.width) / 2 + leftOffset,tabBar.y);
         }
      }
   }
}

