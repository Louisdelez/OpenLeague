package mx.controls
{
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.events.EventPhase;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.ui.Keyboard;
   import mx.containers.BoxDirection;
   import mx.controls.buttonBarClasses.ButtonBarButton;
   import mx.core.ClassFactory;
   import mx.core.EdgeMetrics;
   import mx.core.IFlexDisplayObject;
   import mx.core.IUIComponent;
   import mx.events.ChildExistenceChangedEvent;
   import mx.managers.IFocusManagerComponent;
   
   [MaxChildren("0")]
   [Alternative(replacement="spark.components.ButtonBar",since="4.0")]
   [IconFile("ButtonBar.png")]
   [DefaultTriggerEvent("itemClick")]
   [DefaultProperty("dataProvider")]
   [Exclude(name="verticalScrollBarStyleName",kind="style")]
   [Exclude(name="shadowDistance",kind="style")]
   [Exclude(name="shadowDirection",kind="style")]
   [Exclude(name="shadowColor",kind="style")]
   [Exclude(name="shadowCapColor",kind="style")]
   [Exclude(name="horizontalScrollBarStyleName",kind="style")]
   [Exclude(name="dropShadowEnabled",kind="style")]
   [Exclude(name="dropShadowColor",kind="style")]
   [Exclude(name="cornerRadius",kind="style")]
   [Exclude(name="borderThickness",kind="style")]
   [Exclude(name="borderStyle",kind="style")]
   [Exclude(name="borderSkin",kind="style")]
   [Exclude(name="borderSides",kind="style")]
   [Exclude(name="borderColor",kind="style")]
   [Exclude(name="backgroundSize",kind="style")]
   [Exclude(name="backgroundImage",kind="style")]
   [Exclude(name="backgroundColor",kind="style")]
   [Exclude(name="backgroundAttachment",kind="style")]
   [Exclude(name="backgroundAlpha",kind="style")]
   [Exclude(name="click",kind="event")]
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
   [Style(name="verticalGap",type="Number",format="Length",inherit="no")]
   [Style(name="verticalAlign",type="String",enumeration="top,middle,bottom",inherit="no")]
   [Style(name="lastButtonStyleName",type="String",inherit="no")]
   [Style(name="horizontalGap",type="Number",format="Length",inherit="no")]
   [Style(name="horizontalAlign",type="String",enumeration="left,center,right",inherit="no")]
   [Style(name="firstButtonStyleName",type="String",inherit="no")]
   [Style(name="buttonWidth",type="Number",format="Length",inherit="no")]
   [Style(name="buttonStyleName",type="String",inherit="no")]
   [Style(name="buttonHeight",type="Number",format="Length",inherit="no")]
   [Event(name="itemClick",type="mx.events.ItemClickEvent")]
   public class ButtonBar extends NavBar implements IFocusManagerComponent
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var simulatedClickTriggerEvent:Event = null;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var buttonStyleNameProp:String = "buttonStyleName";
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var firstButtonStyleNameProp:String = "firstButtonStyleName";
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var lastButtonStyleNameProp:String = "lastButtonStyleName";
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var buttonWidthProp:String = "buttonWidth";
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var buttonHeightProp:String = "buttonHeight";
      
      private var recalcButtonWidths:Boolean = false;
      
      private var recalcButtonHeights:Boolean = false;
      
      private var oldUnscaledWidth:Number;
      
      private var oldUnscaledHeight:Number;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var focusedIndex:int = 0;
      
      private var directionChanged:Boolean = false;
      
      public function ButtonBar()
      {
         super();
         tabEnabled = true;
         tabFocusEnabled = true;
         navItemFactory = new ClassFactory(ButtonBarButton);
         addEventListener("scaleXChanged",this.scaleChangedHandler);
         addEventListener("scaleYChanged",this.scaleChangedHandler);
         addEventListener(ChildExistenceChangedEvent.CHILD_REMOVE,this.childRemoveHandler);
      }
      
      override public function get borderMetrics() : EdgeMetrics
      {
         return EdgeMetrics.EMPTY;
      }
      
      [Inspectable(category="General",enumeration="vertical,horizontal",defaultValue="horizontal")]
      [Bindable("directionChanged")]
      override public function set direction(value:String) : void
      {
         if(Boolean(initialized) && value != direction)
         {
            this.directionChanged = true;
            invalidateProperties();
         }
         super.direction = value;
      }
      
      override public function get viewMetrics() : EdgeMetrics
      {
         return EdgeMetrics.EMPTY;
      }
      
      override public function styleChanged(styleProp:String) : void
      {
         var allStyles:Boolean = styleProp == null || styleProp == "styleName";
         super.styleChanged(styleProp);
         if(allStyles || styleProp == this.buttonStyleNameProp || styleProp == this.firstButtonStyleNameProp || styleProp == this.lastButtonStyleNameProp)
         {
            this.resetNavItems();
         }
         else if(styleProp == this.buttonWidthProp)
         {
            this.recalcButtonWidths = true;
         }
         else if(styleProp == this.buttonHeightProp)
         {
            this.recalcButtonHeights = true;
         }
         else if(Boolean(styleManager.isInheritingStyle(styleProp)) && Boolean(styleManager.isSizeInvalidatingStyle(styleProp)))
         {
            this.recalcButtonWidths = this.recalcButtonHeights = true;
         }
      }
      
      override protected function commitProperties() : void
      {
         var n:int = 0;
         var i:int = 0;
         super.commitProperties();
         if(this.directionChanged)
         {
            this.directionChanged = false;
            n = numChildren;
            for(i = 0; i < n; i++)
            {
               Button(getChildAt(i)).changeSkins();
            }
         }
         if(this.recalcButtonHeights)
         {
            this.resetButtonHeights();
         }
         if(this.recalcButtonWidths)
         {
            this.resetButtonWidths();
         }
      }
      
      override protected function measure() : void
      {
         super.measure();
         var vm:EdgeMetrics = viewMetricsAndPadding;
         measuredWidth = this.calcFullWidth() + vm.left + vm.right;
         measuredHeight = this.calcFullHeight() + vm.top + vm.bottom;
         if(Boolean(getStyle(this.buttonWidthProp)))
         {
            measuredMinWidth = measuredWidth;
         }
         if(Boolean(getStyle(this.buttonHeightProp)))
         {
            measuredMinHeight = measuredHeight;
         }
      }
      
      override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         var isHorizontal:Boolean = false;
         var i:int = 0;
         var c:Button = null;
         var excessSpace:Number = NaN;
         var averageWidth:int = 0;
         var nLarge:int = 0;
         var tw:Number = NaN;
         var tSmall:int = 0;
         var mw:int = 0;
         var assignedWidth:Number = NaN;
         var th:Number = NaN;
         isHorizontal = direction == BoxDirection.HORIZONTAL;
         var isVertical:Boolean = !isHorizontal;
         var buttonWidth:Number = Number(getStyle(this.buttonWidthProp));
         var buttonHeightStyle:Number = Number(getStyle(this.buttonHeightProp));
         var buttonHeight:Number = buttonHeightStyle;
         var vm:EdgeMetrics = viewMetricsAndPadding;
         var n:int = numChildren;
         var horizontalGap:Number = Number(getStyle("horizontalGap"));
         var verticalGap:Number = Number(getStyle("verticalGap"));
         var totalHorizontalGap:Number = isHorizontal && numChildren > 0 ? horizontalGap * (n - 1) : 0;
         var totalVerticalGap:Number = isVertical && numChildren > 0 ? verticalGap * (n - 1) : 0;
         var w:Number = unscaledWidth - vm.left - vm.right - totalHorizontalGap;
         var h:Number = unscaledHeight - vm.top - vm.bottom - totalVerticalGap;
         if(!w || !h)
         {
            return;
         }
         if(Boolean(border))
         {
            border.visible = false;
         }
         if(unscaledWidth != this.oldUnscaledWidth)
         {
            this.recalcButtonWidths = true;
            this.oldUnscaledWidth = unscaledWidth;
         }
         if(unscaledHeight != this.oldUnscaledHeight)
         {
            this.recalcButtonHeights = true;
            this.oldUnscaledHeight = unscaledHeight;
         }
         if(this.recalcButtonWidths)
         {
            this.recalcButtonWidths = false;
            if(isNaN(buttonWidth) && isVertical)
            {
               buttonWidth = w;
            }
            excessSpace = w - (this.calcFullWidth() - totalHorizontalGap);
            averageWidth = n > 0 ? int(w / n) : 0;
            nLarge = 0;
            tw = 0;
            tSmall = 0;
            if(excessSpace != 0 && isHorizontal)
            {
               for(i = 0; i < n; i++)
               {
                  c = Button(getChildAt(i));
                  if(isNaN(c.explicitWidth))
                  {
                     mw = int(c.measuredWidth);
                     tw += mw;
                     if(mw > averageWidth)
                     {
                        nLarge++;
                     }
                     else
                     {
                        tSmall += mw;
                     }
                  }
               }
            }
            else
            {
               tw = w;
            }
            for(i = 0; i < n; i++)
            {
               c = Button(getChildAt(i));
               if(isNaN(c.explicitWidth))
               {
                  c.minWidth = 0;
                  if(!isNaN(buttonWidth))
                  {
                     c.minWidth = c.maxWidth = buttonWidth;
                     c.percentWidth = buttonWidth / Math.min(w,tw) * 100;
                  }
                  else if(excessSpace < 0)
                  {
                     assignedWidth = Number(c.measuredWidth);
                     if(assignedWidth > averageWidth)
                     {
                        assignedWidth = (w - tSmall) / nLarge;
                     }
                     c.percentWidth = assignedWidth / w * 100;
                  }
                  else if(excessSpace > 0)
                  {
                     c.percentWidth = c.measuredWidth / tw * 100;
                  }
                  else
                  {
                     c.percentWidth = NaN;
                  }
                  if(isVertical)
                  {
                     c.percentWidth = 100;
                  }
               }
            }
         }
         if(this.recalcButtonHeights)
         {
            this.recalcButtonHeights = false;
            if(isNaN(buttonHeight) && isHorizontal)
            {
               buttonHeight = h;
            }
            excessSpace = h - (this.calcFullHeight() - totalVerticalGap);
            th = 0;
            if(excessSpace != 0 && isVertical)
            {
               for(i = 0; i < n; i++)
               {
                  c = Button(getChildAt(i));
                  if(isNaN(c.explicitHeight))
                  {
                     th += c.measuredHeight;
                  }
               }
            }
            for(i = 0; i < n; i++)
            {
               c = Button(getChildAt(i));
               if(isNaN(c.explicitHeight))
               {
                  c.minHeight = 0;
                  if(!isNaN(buttonHeight))
                  {
                     c.minHeight = buttonHeight;
                     c.percentHeight = buttonHeight / Math.min(th,h) * 100;
                  }
                  if(!isNaN(buttonHeightStyle))
                  {
                     c.maxHeight = buttonHeightStyle;
                  }
                  if(isHorizontal)
                  {
                     c.percentHeight = 100;
                  }
                  else if(excessSpace < 0)
                  {
                     c.percentHeight = c.measuredHeight / th * 100;
                  }
                  else if(excessSpace > 0)
                  {
                     c.percentHeight = c.measuredHeight / th * 100;
                  }
                  else
                  {
                     c.percentHeight = NaN;
                  }
               }
            }
         }
         super.updateDisplayList(unscaledWidth,unscaledHeight);
      }
      
      override public function drawFocus(isFocused:Boolean) : void
      {
         this.drawButtonFocus(this.focusedIndex,isFocused);
      }
      
      override protected function createNavItem(label:String, icon:Class = null) : IFlexDisplayObject
      {
         var newButton:Button = Button(navItemFactory.newInstance());
         newButton.focusEnabled = false;
         newButton.label = label;
         newButton.setStyle("icon",icon);
         newButton.addEventListener(MouseEvent.CLICK,this.clickHandler);
         addChild(newButton);
         this.recalcButtonWidths = this.recalcButtonHeights = true;
         return newButton;
      }
      
      override protected function resetNavItems() : void
      {
         var button:Button = null;
         var buttonStyleName:String = getStyle(this.buttonStyleNameProp);
         var firstButtonStyleName:String = getStyle(this.firstButtonStyleNameProp);
         var lastButtonStyleName:String = getStyle(this.lastButtonStyleNameProp);
         if(!buttonStyleName)
         {
            buttonStyleName = "ButtonBarButton";
         }
         if(!firstButtonStyleName)
         {
            firstButtonStyleName = buttonStyleName;
         }
         if(!lastButtonStyleName)
         {
            lastButtonStyleName = buttonStyleName;
         }
         var n:int = numChildren;
         for(var i:int = 0; i < n; i++)
         {
            button = Button(getChildAt(i));
            if(i == 0)
            {
               button.styleName = firstButtonStyleName;
            }
            else if(i == n - 1)
            {
               button.styleName = lastButtonStyleName;
            }
            else
            {
               button.styleName = buttonStyleName;
            }
            button.changeSkins();
            button.invalidateDisplayList();
         }
         this.recalcButtonWidths = this.recalcButtonHeights = true;
         invalidateDisplayList();
      }
      
      private function calcFullWidth() : Number
      {
         var w:Number = NaN;
         var cw:Number = NaN;
         var n:int = numChildren;
         var gap:Number = 0;
         if(n == 0)
         {
            return 0;
         }
         if(n > 1)
         {
            gap = Number(getStyle("horizontalGap"));
         }
         var horizontal:Boolean = direction == BoxDirection.HORIZONTAL;
         var buttonWidth:Number = Number(getStyle(this.buttonWidthProp));
         var child:IUIComponent = IUIComponent(getChildAt(0));
         if(Boolean(buttonWidth))
         {
            w = isNaN(child.explicitWidth) ? buttonWidth : Number(child.explicitWidth);
         }
         else
         {
            w = Number(child.getExplicitOrMeasuredWidth());
         }
         for(var i:int = 1; i < n; i++)
         {
            child = IUIComponent(getChildAt(i));
            if(Boolean(buttonWidth))
            {
               cw = isNaN(child.explicitWidth) ? buttonWidth : Number(child.explicitWidth);
            }
            else
            {
               cw = Number(child.getExplicitOrMeasuredWidth());
            }
            if(horizontal)
            {
               w += gap + cw;
            }
            else
            {
               w = Math.max(w,cw);
            }
         }
         return w;
      }
      
      private function calcFullHeight() : Number
      {
         var gap:Number = NaN;
         var h:Number = NaN;
         var ch:Number = NaN;
         var n:int = numChildren;
         if(n == 0)
         {
            return 0;
         }
         if(n > 1)
         {
            gap = Number(getStyle("verticalGap"));
         }
         var vertical:Boolean = direction == BoxDirection.VERTICAL;
         var buttonHeight:Number = Number(getStyle(this.buttonHeightProp));
         var child:IUIComponent = IUIComponent(getChildAt(0));
         if(Boolean(buttonHeight))
         {
            h = isNaN(child.explicitHeight) ? buttonHeight : Number(child.explicitHeight);
         }
         else
         {
            h = Number(child.getExplicitOrMeasuredHeight());
         }
         for(var i:int = 1; i < n; i++)
         {
            child = IUIComponent(getChildAt(i));
            if(Boolean(buttonHeight))
            {
               ch = isNaN(child.explicitHeight) ? buttonHeight : Number(child.explicitHeight);
            }
            else
            {
               ch = Number(child.getExplicitOrMeasuredHeight());
            }
            if(vertical)
            {
               h += gap + ch;
            }
            else
            {
               h = Math.max(h,ch);
            }
         }
         return h;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function prevIndex(index:int) : int
      {
         var n:int = numChildren;
         return index == 0 ? int(n - 1) : int(index - 1);
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function nextIndex(index:int) : int
      {
         var n:int = numChildren;
         if(n == 0)
         {
            return -1;
         }
         return index == n - 1 ? 0 : int(index + 1);
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function drawButtonFocus(index:int, focused:Boolean) : void
      {
         var b:Button = null;
         if(numChildren > 0 && index < numChildren)
         {
            b = Button(getChildAt(index));
            b.drawFocus(focused && Boolean(focusManager.showFocusIndicator));
            if(focused)
            {
               dispatchEvent(new Event("focusDraw"));
            }
            if(!focused && b.phase != ButtonPhase.UP)
            {
               b.phase = ButtonPhase.UP;
            }
         }
      }
      
      override protected function keyDownHandler(event:KeyboardEvent) : void
      {
         var child:Button = null;
         if(event.eventPhase != EventPhase.AT_TARGET)
         {
            return;
         }
         var keyCode:uint = uint(mapKeycodeForLayoutDirection(event,true));
         switch(keyCode)
         {
            case Keyboard.DOWN:
            case Keyboard.RIGHT:
               focusManager.showFocusIndicator = true;
               this.drawButtonFocus(this.focusedIndex,false);
               this.focusedIndex = this.nextIndex(this.focusedIndex);
               if(this.focusedIndex != -1)
               {
                  this.drawButtonFocus(this.focusedIndex,true);
               }
               event.stopPropagation();
               break;
            case Keyboard.UP:
            case Keyboard.LEFT:
               focusManager.showFocusIndicator = true;
               this.drawButtonFocus(this.focusedIndex,false);
               this.focusedIndex = this.prevIndex(this.focusedIndex);
               if(this.focusedIndex != -1)
               {
                  this.drawButtonFocus(this.focusedIndex,true);
               }
               event.stopPropagation();
               break;
            case Keyboard.SPACE:
               if(this.focusedIndex != -1)
               {
                  child = Button(getChildAt(this.focusedIndex));
                  child.dispatchEvent(event);
               }
               event.stopPropagation();
         }
      }
      
      override protected function keyUpHandler(event:KeyboardEvent) : void
      {
         var child:Button = null;
         if(event.eventPhase != EventPhase.AT_TARGET)
         {
            return;
         }
         switch(event.keyCode)
         {
            case Keyboard.SPACE:
               if(this.focusedIndex != -1)
               {
                  child = Button(getChildAt(this.focusedIndex));
                  child.dispatchEvent(event);
               }
               event.stopPropagation();
         }
      }
      
      override protected function clickHandler(event:MouseEvent) : void
      {
         if(this.simulatedClickTriggerEvent == null)
         {
            this.focusedIndex = getChildIndex(DisplayObject(event.currentTarget));
            this.drawButtonFocus(this.focusedIndex,true);
         }
         super.clickHandler(event);
      }
      
      private function childRemoveHandler(event:ChildExistenceChangedEvent) : void
      {
         var button:Button = null;
         var child:DisplayObject = event.relatedObject;
         var index:int = getChildIndex(child);
         var n:int = numChildren;
         if(n < 2)
         {
            return;
         }
         var buttonStyleName:String = getStyle(this.buttonStyleNameProp);
         var firstButtonStyleName:String = getStyle(this.firstButtonStyleNameProp);
         var lastButtonStyleName:String = getStyle(this.lastButtonStyleNameProp);
         if(!buttonStyleName)
         {
            buttonStyleName = "buttonBarButtonStyle";
         }
         if(!firstButtonStyleName)
         {
            firstButtonStyleName = buttonStyleName;
         }
         if(!lastButtonStyleName)
         {
            lastButtonStyleName = buttonStyleName;
         }
         if(index == 0 || index == n - 1)
         {
            button = Button(getChildAt(index == n - 1 ? int(n - 2) : 0));
            button.styleName = index == 0 ? firstButtonStyleName : lastButtonStyleName;
            button.changeSkins();
            button.invalidateDisplayList();
         }
      }
      
      protected function resetButtonWidths() : void
      {
         var child:Button = null;
         for(var i:int = 0; i < numChildren; i++)
         {
            child = getChildAt(i) as Button;
            if(Boolean(child))
            {
               child.explicitWidth = NaN;
               child.minWidth = NaN;
               child.maxWidth = NaN;
            }
         }
      }
      
      protected function resetButtonHeights() : void
      {
         var child:Button = null;
         for(var i:int = 0; i < numChildren; i++)
         {
            child = getChildAt(i) as Button;
            if(Boolean(child))
            {
               child.explicitHeight = NaN;
               child.minHeight = NaN;
               child.maxHeight = NaN;
            }
         }
      }
      
      private function scaleChangedHandler(event:Event) : void
      {
         this.resetButtonHeights();
         this.resetButtonWidths();
      }
   }
}

