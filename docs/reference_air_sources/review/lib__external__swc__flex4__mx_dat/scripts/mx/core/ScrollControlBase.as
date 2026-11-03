package mx.core
{
   import flash.display.DisplayObject;
   import flash.display.Graphics;
   import flash.display.Shape;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import mx.controls.HScrollBar;
   import mx.controls.VScrollBar;
   import mx.controls.scrollClasses.ScrollBar;
   import mx.events.ScrollEvent;
   import mx.events.ScrollEventDetail;
   import mx.events.ScrollEventDirection;
   import mx.managers.ToolTipManager;
   import mx.styles.ISimpleStyleClient;
   
   [Style(name="verticalScrollBarStyleName",type="String",inherit="no")]
   [Style(name="symbolColor",type="uint",format="Color",inherit="yes",theme="spark")]
   [Style(name="horizontalScrollBarStyleName",type="String",inherit="no")]
   [Style(name="focusColor",type="uint",format="Color",inherit="yes",theme="spark")]
   [Style(name="cornerRadius",type="Number",format="Length",inherit="no",theme="halo")]
   [Style(name="contentBackgroundColor",type="uint",format="Color",inherit="yes",theme="spark")]
   [Style(name="contentBackgroundAlpha",type="Number",inherit="yes",theme="spark")]
   [Style(name="chromeColor",type="uint",format="Color",inherit="yes",theme="spark")]
   [Style(name="accentColor",type="uint",format="Color",inherit="yes",theme="spark")]
   [Style(name="textIndent",type="Number",format="Length",inherit="yes")]
   [Style(name="textFieldClass",type="Class",inherit="no")]
   [Style(name="textDecoration",type="String",enumeration="none,underline",inherit="yes")]
   [Style(name="textAlign",type="String",enumeration="left,center,right",inherit="yes")]
   [Style(name="locale",type="String",inherit="yes")]
   [Style(name="letterSpacing",type="Number",inherit="yes")]
   [Style(name="kerning",type="Boolean",inherit="yes")]
   [Style(name="fontWeight",type="String",enumeration="normal,bold",inherit="yes")]
   [Style(name="fontThickness",type="Number",inherit="yes")]
   [Style(name="fontStyle",type="String",enumeration="normal,italic",inherit="yes")]
   [Style(name="fontSize",type="Number",format="Length",inherit="yes")]
   [Style(name="fontSharpness",type="Number",inherit="yes")]
   [Style(name="fontGridFitType",type="String",enumeration="none,pixel,subpixel",inherit="yes")]
   [Style(name="fontFamily",type="String",inherit="yes")]
   [Style(name="fontAntiAliasType",type="String",enumeration="normal,advanced",inherit="yes")]
   [Style(name="disabledColor",type="uint",format="Color",inherit="yes")]
   [Style(name="direction",type="String",enumeration="ltr,rtl,inherit",inherit="yes")]
   [Style(name="color",type="uint",format="Color",inherit="yes")]
   [Style(name="leading",type="Number",format="Length",inherit="yes")]
   [Style(name="focusRoundedCorners",type="String",inherit="no")]
   [Style(name="focusAlpha",type="Number",inherit="no")]
   [Style(name="shadowDistance",type="Number",format="Length",inherit="no",theme="halo")]
   [Style(name="shadowDirection",type="String",enumeration="left,center,right",inherit="no",theme="halo")]
   [Style(name="dropShadowColor",type="uint",format="Color",inherit="yes",theme="halo")]
   [Style(name="dropShadowVisible",type="Boolean",inherit="no",theme="spark")]
   [Style(name="dropShadowEnabled",type="Boolean",inherit="no",theme="halo")]
   [Style(name="borderVisible",type="Boolean",inherit="no",theme="spark")]
   [Style(name="borderThickness",type="Number",format="Length",inherit="no",theme="halo")]
   [Style(name="borderStyle",type="String",enumeration="inset,outset,solid,none",inherit="no")]
   [Style(name="borderSkin",type="Class",inherit="no")]
   [Style(name="borderSides",type="String",inherit="no",theme="halo")]
   [Style(name="borderColor",type="uint",format="Color",inherit="no",theme="halo, spark")]
   [Style(name="borderAlpha",type="Number",inherit="no",theme="spark")]
   [Style(name="backgroundSize",type="String",inherit="no",theme="halo")]
   [Style(name="backgroundImage",type="Object",format="File",inherit="no",theme="halo")]
   [Style(name="backgroundDisabledColor",type="uint",format="Color",inherit="yes",theme="halo")]
   [Style(name="backgroundColor",type="uint",format="Color",inherit="no",theme="halo")]
   [Style(name="backgroundAlpha",type="Number",inherit="no",theme="halo")]
   [Event(name="scroll",type="mx.events.ScrollEvent")]
   public class ScrollControlBase extends UIComponent
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      protected var border:IFlexDisplayObject;
      
      private var _viewMetrics:EdgeMetrics;
      
      protected var maskShape:Shape;
      
      protected var horizontalScrollBar:ScrollBar;
      
      protected var verticalScrollBar:ScrollBar;
      
      private var numberOfCols:Number = 0;
      
      private var numberOfRows:Number = 0;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _maxVerticalScrollPosition:Number;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _maxHorizontalScrollPosition:Number;
      
      private var viewableRows:Number;
      
      private var viewableColumns:Number;
      
      private var propsInited:Boolean;
      
      protected var scrollAreaChanged:Boolean;
      
      private var invLayout:Boolean;
      
      private var scrollTip:IToolTip;
      
      private var scrollThumbMidPoint:Number;
      
      private var oldTTMEnabled:Boolean;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _horizontalScrollPosition:Number = 0;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _horizontalScrollPolicy:String = "off";
      
      [Inspectable(defaultValue="true")]
      public var liveScrolling:Boolean = true;
      
      private var _scrollTipFunction:Function;
      
      [Inspectable(defaultValue="false")]
      public var showScrollTips:Boolean = false;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _verticalScrollPosition:Number = 0;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _verticalScrollPolicy:String = "auto";
      
      public function ScrollControlBase()
      {
         super();
         this._viewMetrics = EdgeMetrics.EMPTY;
         addEventListener(MouseEvent.MOUSE_WHEEL,this.mouseWheelHandler);
      }
      
      override public function set enabled(value:Boolean) : void
      {
         super.enabled = value;
         if(Boolean(this.horizontalScrollBar))
         {
            this.horizontalScrollBar.enabled = value;
         }
         if(Boolean(this.verticalScrollBar))
         {
            this.verticalScrollBar.enabled = value;
         }
      }
      
      public function get borderMetrics() : EdgeMetrics
      {
         return Boolean(this.border) && this.border is IRectangularBorder ? IRectangularBorder(this.border).borderMetrics : EdgeMetrics.EMPTY;
      }
      
      [Inspectable(defaultValue="0")]
      [Bindable("viewChanged")]
      [Bindable("scroll")]
      public function get horizontalScrollPosition() : Number
      {
         return this._horizontalScrollPosition;
      }
      
      public function set horizontalScrollPosition(value:Number) : void
      {
         this._horizontalScrollPosition = value;
         if(Boolean(this.horizontalScrollBar))
         {
            this.horizontalScrollBar.scrollPosition = value;
         }
         dispatchEvent(new Event("viewChanged"));
      }
      
      [Inspectable(enumeration="off,on,auto",defaultValue="off")]
      [Bindable("horizontalScrollPolicyChanged")]
      public function get horizontalScrollPolicy() : String
      {
         return this._horizontalScrollPolicy;
      }
      
      public function set horizontalScrollPolicy(value:String) : void
      {
         var newPolicy:String = value.toLowerCase();
         if(this._horizontalScrollPolicy != newPolicy)
         {
            this._horizontalScrollPolicy = newPolicy;
            invalidateDisplayList();
            dispatchEvent(new Event("horizontalScrollPolicyChanged"));
         }
      }
      
      [Inspectable(defaultValue="0")]
      [Bindable("maxHorizontalScrollPositionChanged")]
      public function get maxHorizontalScrollPosition() : Number
      {
         if(!isNaN(this._maxHorizontalScrollPosition))
         {
            return this._maxHorizontalScrollPosition;
         }
         return Boolean(this.horizontalScrollBar) ? this.horizontalScrollBar.maxScrollPosition : 0;
      }
      
      public function set maxHorizontalScrollPosition(value:Number) : void
      {
         this._maxHorizontalScrollPosition = value;
         dispatchEvent(new Event("maxHorizontalScrollPositionChanged"));
      }
      
      [Inspectable(defaultValue="0")]
      [Bindable("maxVerticalScrollPositionChanged")]
      public function get maxVerticalScrollPosition() : Number
      {
         if(!isNaN(this._maxVerticalScrollPosition))
         {
            return this._maxVerticalScrollPosition;
         }
         return Boolean(this.verticalScrollBar) ? this.verticalScrollBar.maxScrollPosition : 0;
      }
      
      public function set maxVerticalScrollPosition(value:Number) : void
      {
         this._maxVerticalScrollPosition = value;
         dispatchEvent(new Event("maxVerticalScrollPositionChanged"));
      }
      
      [Inspectable(defaultValue="")]
      [Bindable("scrollTipFunctionChanged")]
      public function get scrollTipFunction() : Function
      {
         return this._scrollTipFunction;
      }
      
      public function set scrollTipFunction(value:Function) : void
      {
         this._scrollTipFunction = value;
         dispatchEvent(new Event("scrollTipFunctionChanged"));
      }
      
      public function get viewMetrics() : EdgeMetrics
      {
         this._viewMetrics = this.borderMetrics.clone();
         if(!this.horizontalScrollBar && this.horizontalScrollPolicy == ScrollPolicy.ON)
         {
            this.createHScrollBar(true);
            this.horizontalScrollBar.addEventListener(ScrollEvent.SCROLL,this.scrollHandler);
            this.horizontalScrollBar.addEventListener(ScrollEvent.SCROLL,this.scrollTipHandler);
            this.horizontalScrollBar.scrollPosition = this._horizontalScrollPosition;
            invalidateDisplayList();
         }
         if(!this.verticalScrollBar && this.verticalScrollPolicy == ScrollPolicy.ON)
         {
            this.createVScrollBar(true);
            this.verticalScrollBar.addEventListener(ScrollEvent.SCROLL,this.scrollHandler);
            this.verticalScrollBar.addEventListener(ScrollEvent.SCROLL,this.scrollTipHandler);
            this.verticalScrollBar.scrollPosition = this._verticalScrollPosition;
            invalidateDisplayList();
         }
         if(Boolean(this.verticalScrollBar) && Boolean(this.verticalScrollBar.visible))
         {
            this._viewMetrics.right += this.verticalScrollBar.minWidth;
         }
         if(Boolean(this.horizontalScrollBar) && Boolean(this.horizontalScrollBar.visible))
         {
            this._viewMetrics.bottom += this.horizontalScrollBar.minHeight;
         }
         return this._viewMetrics;
      }
      
      [Inspectable(defaultValue="0")]
      [Bindable("viewChanged")]
      [Bindable("scroll")]
      public function get verticalScrollPosition() : Number
      {
         return this._verticalScrollPosition;
      }
      
      public function set verticalScrollPosition(value:Number) : void
      {
         this._verticalScrollPosition = value;
         if(Boolean(this.verticalScrollBar))
         {
            this.verticalScrollBar.scrollPosition = value;
         }
         dispatchEvent(new Event("viewChanged"));
      }
      
      [Inspectable(enumeration="off,on,auto",defaultValue="auto")]
      [Bindable("verticalScrollPolicyChanged")]
      public function get verticalScrollPolicy() : String
      {
         return this._verticalScrollPolicy;
      }
      
      public function set verticalScrollPolicy(value:String) : void
      {
         var newPolicy:String = value.toLowerCase();
         if(this._verticalScrollPolicy != newPolicy)
         {
            this._verticalScrollPolicy = newPolicy;
            invalidateDisplayList();
            dispatchEvent(new Event("verticalScrollPolicyChanged"));
         }
      }
      
      override protected function createChildren() : void
      {
         var g:Graphics = null;
         super.createChildren();
         this.createBorder();
         if(!this.maskShape)
         {
            this.maskShape = new FlexShape();
            this.maskShape.name = "mask";
            g = this.maskShape.graphics;
            g.beginFill(16777215);
            g.drawRect(0,0,10,10);
            g.endFill();
            addChild(this.maskShape);
         }
         this.maskShape.visible = false;
      }
      
      override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         this.layoutChrome(unscaledWidth,unscaledHeight);
         var w:Number = unscaledWidth;
         var h:Number = unscaledHeight;
         this.invLayout = false;
         var vm:EdgeMetrics = this._viewMetrics = this.viewMetrics;
         if(Boolean(this.horizontalScrollBar) && Boolean(this.horizontalScrollBar.visible))
         {
            this.horizontalScrollBar.setActualSize(w - vm.left - vm.right,this.horizontalScrollBar.minHeight);
            this.horizontalScrollBar.move(vm.left,h - vm.bottom);
            this.horizontalScrollBar.enabled = enabled;
         }
         if(Boolean(this.verticalScrollBar) && Boolean(this.verticalScrollBar.visible))
         {
            this.verticalScrollBar.setActualSize(this.verticalScrollBar.minWidth,h - vm.top - vm.bottom);
            this.verticalScrollBar.move(w - vm.right,vm.top);
            this.verticalScrollBar.enabled = enabled;
         }
         var mask:DisplayObject = this.maskShape;
         var wd:Number = w - vm.left - vm.right;
         var ht:Number = h - vm.top - vm.bottom;
         mask.width = wd < 0 ? 0 : wd;
         mask.height = ht < 0 ? 0 : ht;
         mask.x = vm.left;
         mask.y = vm.top;
      }
      
      override public function styleChanged(styleProp:String) : void
      {
         var horizontalScrollBarStyleName:String = null;
         var verticalScrollBarStyleName:String = null;
         var allStyles:Boolean = styleProp == null || styleProp == "styleName";
         super.styleChanged(styleProp);
         if(allStyles || styleProp == "horizontalScrollBarStyleName")
         {
            if(Boolean(this.horizontalScrollBar))
            {
               horizontalScrollBarStyleName = getStyle("horizontalScrollBarStyleName");
               this.horizontalScrollBar.styleName = horizontalScrollBarStyleName;
            }
         }
         if(allStyles || styleProp == "verticalScrollBarStyleName")
         {
            if(Boolean(this.verticalScrollBar))
            {
               verticalScrollBarStyleName = getStyle("verticalScrollBarStyleName");
               this.verticalScrollBar.styleName = verticalScrollBarStyleName;
            }
         }
         if(allStyles || styleProp == "borderSkin")
         {
            if(Boolean(this.border))
            {
               removeChild(DisplayObject(this.border));
               this.border = null;
               this.createBorder();
            }
         }
      }
      
      protected function layoutChrome(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         if(Boolean(this.border))
         {
            this.border.move(0,0);
            this.border.setActualSize(unscaledWidth,unscaledHeight);
         }
      }
      
      protected function createBorder() : void
      {
         var borderClass:Class = null;
         if(!this.border && this.isBorderNeeded())
         {
            borderClass = getStyle("borderSkin");
            if(borderClass != null)
            {
               this.border = new borderClass();
               if(FlexVersion.compatibilityVersion < FlexVersion.VERSION_4_0)
               {
                  if(this.border is IUIComponent)
                  {
                     IUIComponent(this.border).enabled = enabled;
                  }
               }
               if(this.border is ISimpleStyleClient)
               {
                  ISimpleStyleClient(this.border).styleName = this;
               }
               addChildAt(DisplayObject(this.border),0);
               invalidateDisplayList();
            }
         }
      }
      
      private function isBorderNeeded() : Boolean
      {
         var v:Object = getStyle("borderStyle");
         if(Boolean(v))
         {
            if(v != "none" || Boolean(v == "none") && Boolean(getStyle("mouseShield")))
            {
               return true;
            }
         }
         v = getStyle("backgroundColor");
         if(v !== null && v !== "")
         {
            return true;
         }
         v = getStyle("backgroundImage");
         return v != null && v != "";
      }
      
      protected function setScrollBarProperties(totalColumns:int, visibleColumns:int, totalRows:int, visibleRows:int) : void
      {
         var shouldBeVisible:Boolean = false;
         var horizontalScrollPolicy:String = this.horizontalScrollPolicy;
         var verticalScrollPolicy:String = this.verticalScrollPolicy;
         this.scrollAreaChanged = false;
         if(horizontalScrollPolicy == ScrollPolicy.ON || visibleColumns < totalColumns && totalColumns > 0 && horizontalScrollPolicy == ScrollPolicy.AUTO)
         {
            if(!this.horizontalScrollBar)
            {
               this.createHScrollBar(false);
               this.horizontalScrollBar.addEventListener(ScrollEvent.SCROLL,this.scrollHandler);
               this.horizontalScrollBar.addEventListener(ScrollEvent.SCROLL,this.scrollTipHandler);
               this.horizontalScrollBar.scrollPosition = this._horizontalScrollPosition;
            }
            shouldBeVisible = this.roomForScrollBar(this.horizontalScrollBar,unscaledWidth,unscaledHeight);
            if(shouldBeVisible != this.horizontalScrollBar.visible)
            {
               this.horizontalScrollBar.visible = shouldBeVisible;
               this.scrollAreaChanged = true;
            }
            if(Boolean(this.horizontalScrollBar) && Boolean(this.horizontalScrollBar.visible) && (this.numberOfCols != totalColumns || this.viewableColumns != visibleColumns || this.scrollAreaChanged))
            {
               this.horizontalScrollBar.setScrollProperties(visibleColumns,0,totalColumns - visibleColumns);
               if(this.horizontalScrollBar.scrollPosition != this._horizontalScrollPosition)
               {
                  this.horizontalScrollBar.scrollPosition = this._horizontalScrollPosition;
               }
               this.viewableColumns = visibleColumns;
               this.numberOfCols = totalColumns;
            }
         }
         else if((Boolean(horizontalScrollPolicy == ScrollPolicy.AUTO || horizontalScrollPolicy == ScrollPolicy.OFF)) && Boolean(this.horizontalScrollBar) && Boolean(this.horizontalScrollBar.visible))
         {
            this.horizontalScrollPosition = 0;
            this.horizontalScrollBar.setScrollProperties(visibleColumns,0,0);
            this.horizontalScrollBar.visible = false;
            this.viewableColumns = NaN;
            this.scrollAreaChanged = true;
         }
         if(verticalScrollPolicy == ScrollPolicy.ON || visibleRows < totalRows && totalRows > 0 && verticalScrollPolicy == ScrollPolicy.AUTO)
         {
            if(!this.verticalScrollBar)
            {
               this.createVScrollBar(false);
               this.verticalScrollBar.addEventListener(ScrollEvent.SCROLL,this.scrollHandler);
               this.verticalScrollBar.addEventListener(ScrollEvent.SCROLL,this.scrollTipHandler);
               this.verticalScrollBar.scrollPosition = this._verticalScrollPosition;
            }
            shouldBeVisible = this.roomForScrollBar(this.verticalScrollBar,unscaledWidth,unscaledHeight);
            if(shouldBeVisible != this.verticalScrollBar.visible)
            {
               this.verticalScrollBar.visible = shouldBeVisible;
               this.scrollAreaChanged = true;
            }
            if(Boolean(this.verticalScrollBar) && Boolean(this.verticalScrollBar.visible) && (this.numberOfRows != totalRows || this.viewableRows != visibleRows || this.scrollAreaChanged))
            {
               this.verticalScrollBar.setScrollProperties(visibleRows,0,totalRows - visibleRows);
               if(this.verticalScrollBar.scrollPosition != this._verticalScrollPosition)
               {
                  this.verticalScrollBar.scrollPosition = this._verticalScrollPosition;
               }
               this.viewableRows = visibleRows;
               this.numberOfRows = totalRows;
            }
         }
         else if((Boolean(verticalScrollPolicy == ScrollPolicy.AUTO || verticalScrollPolicy == ScrollPolicy.OFF)) && Boolean(this.verticalScrollBar) && Boolean(this.verticalScrollBar.visible))
         {
            this.verticalScrollPosition = 0;
            this.verticalScrollBar.setScrollProperties(visibleRows,0,0);
            this.verticalScrollBar.visible = false;
            this.viewableRows = NaN;
            this.scrollAreaChanged = true;
         }
         if(this.scrollAreaChanged)
         {
            this.updateDisplayList(unscaledWidth,unscaledHeight);
         }
      }
      
      private function createHScrollBar(visible:Boolean) : ScrollBar
      {
         this.horizontalScrollBar = new HScrollBar();
         this.horizontalScrollBar.visible = visible;
         this.horizontalScrollBar.enabled = enabled;
         var horizontalScrollBarStyleName:String = getStyle("horizontalScrollBarStyleName");
         this.horizontalScrollBar.styleName = horizontalScrollBarStyleName;
         addChild(this.horizontalScrollBar);
         this.horizontalScrollBar.validateNow();
         return this.horizontalScrollBar;
      }
      
      private function createVScrollBar(visible:Boolean) : ScrollBar
      {
         this.verticalScrollBar = new VScrollBar();
         this.verticalScrollBar.visible = visible;
         this.verticalScrollBar.enabled = enabled;
         var verticalScrollBarStyleName:String = getStyle("verticalScrollBarStyleName");
         this.verticalScrollBar.styleName = verticalScrollBarStyleName;
         addChild(this.verticalScrollBar);
         UIComponentGlobals.layoutManager.validateClient(this.verticalScrollBar,true);
         return this.verticalScrollBar;
      }
      
      protected function roomForScrollBar(bar:ScrollBar, unscaledWidth:Number, unscaledHeight:Number) : Boolean
      {
         var bm:EdgeMetrics = this.borderMetrics;
         return unscaledWidth >= bar.minWidth + bm.left + bm.right && unscaledHeight >= bar.minHeight + bm.top + bm.bottom;
      }
      
      protected function scrollHandler(event:Event) : void
      {
         var scrollBar:ScrollBar = null;
         var pos:Number = NaN;
         var prop:QName = null;
         if(event is ScrollEvent)
         {
            scrollBar = ScrollBar(event.target);
            pos = scrollBar.scrollPosition;
            if(scrollBar == this.verticalScrollBar)
            {
               prop = new QName(mx_internal,"_verticalScrollPosition");
            }
            else if(scrollBar == this.horizontalScrollBar)
            {
               prop = new QName(mx_internal,"_horizontalScrollPosition");
            }
            dispatchEvent(event);
            if(Boolean(prop))
            {
               this[prop] = pos;
            }
         }
      }
      
      private function scrollTipHandler(event:Event) : void
      {
         var scrollBar:ScrollBar = null;
         var isVertical:Boolean = false;
         var dir:String = null;
         var pos:Number = NaN;
         var tip:String = null;
         var pt:Point = null;
         if(event is ScrollEvent)
         {
            if(!this.showScrollTips)
            {
               return;
            }
            if(ScrollEvent(event).detail == ScrollEventDetail.THUMB_POSITION)
            {
               if(Boolean(this.scrollTip))
               {
                  ToolTipManager.destroyToolTip(this.scrollTip);
                  this.scrollTip = null;
                  ToolTipManager.enabled = this.oldTTMEnabled;
               }
            }
            else if(ScrollEvent(event).detail == ScrollEventDetail.THUMB_TRACK)
            {
               scrollBar = ScrollBar(event.target);
               isVertical = scrollBar == this.verticalScrollBar;
               dir = isVertical ? "vertical" : "horizontal";
               pos = scrollBar.scrollPosition;
               if(!this.scrollTip)
               {
                  this.scrollTip = ToolTipManager.createToolTip("",0,0,null,this);
                  this.scrollThumbMidPoint = scrollBar.scrollThumb.height / 2;
                  this.oldTTMEnabled = ToolTipManager.enabled;
                  ToolTipManager.enabled = false;
               }
               tip = pos.toString();
               if(this._scrollTipFunction != null)
               {
                  tip = this._scrollTipFunction(dir,pos);
               }
               if(tip == "")
               {
                  this.scrollTip.visible = false;
               }
               else
               {
                  this.scrollTip.text = tip;
                  ToolTipManager.sizeTip(this.scrollTip);
                  pt = new Point();
                  if(isVertical)
                  {
                     pt.x = -3 - this.scrollTip.width;
                     pt.y = scrollBar.scrollThumb.y + this.scrollThumbMidPoint - this.scrollTip.height / 2;
                  }
                  else
                  {
                     pt.x = -3 - this.scrollTip.height;
                     pt.y = scrollBar.scrollThumb.y + this.scrollThumbMidPoint - this.scrollTip.width / 2;
                  }
                  pt = scrollBar.localToGlobal(pt);
                  this.scrollTip.move(pt.x,pt.y);
                  this.scrollTip.visible = true;
               }
            }
         }
      }
      
      protected function mouseWheelHandler(event:MouseEvent) : void
      {
         var scrollDirection:int = 0;
         var scrollAmount:Number = NaN;
         var oldPosition:Number = NaN;
         var scrollEvent:ScrollEvent = null;
         if(Boolean(this.verticalScrollBar) && Boolean(this.verticalScrollBar.visible) && !event.isDefaultPrevented())
         {
            scrollDirection = event.delta <= 0 ? 1 : -1;
            scrollAmount = Math.max(Math.abs(event.delta),this.verticalScrollBar.lineScrollSize);
            oldPosition = this.verticalScrollPosition;
            this.verticalScrollPosition += 3 * scrollAmount * scrollDirection;
            scrollEvent = new ScrollEvent(ScrollEvent.SCROLL);
            scrollEvent.direction = ScrollEventDirection.VERTICAL;
            scrollEvent.position = this.verticalScrollPosition;
            scrollEvent.delta = this.verticalScrollPosition - oldPosition;
            dispatchEvent(scrollEvent);
            event.preventDefault();
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function get scroll_verticalScrollBar() : ScrollBar
      {
         return this.verticalScrollBar;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function get scroll_horizontalScrollBar() : ScrollBar
      {
         return this.horizontalScrollBar;
      }
   }
}

