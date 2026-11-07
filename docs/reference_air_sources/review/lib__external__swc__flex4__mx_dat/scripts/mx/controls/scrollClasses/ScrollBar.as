package mx.controls.scrollClasses
{
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.ui.Keyboard;
   import flash.utils.Timer;
   import mx.controls.Button;
   import mx.core.UIComponent;
   import mx.events.FlexEvent;
   import mx.events.SandboxMouseEvent;
   import mx.events.ScrollEvent;
   import mx.events.ScrollEventDetail;
   import mx.styles.ISimpleStyleClient;
   import mx.styles.StyleProxy;
   
   [Exclude(name="focusThickness",kind="style")]
   [Exclude(name="focusSkin",kind="style")]
   [Exclude(name="focusBlendMode",kind="style")]
   [Exclude(name="errorColor",kind="style")]
   [Exclude(name="doubleClickEnabled",kind="property")]
   [Style(name="upArrowUpSkin",type="Class",inherit="no")]
   [Style(name="upArrowOverSkin",type="Class",inherit="no")]
   [Style(name="upArrowDownSkin",type="Class",inherit="no")]
   [Style(name="upArrowDisabledSkin",type="Class",inherit="no")]
   [Style(name="upArrowSkin",type="Class",inherit="no",states="up, over, down, disabled")]
   [Style(name="trackUpSkin",type="Class",inherit="no")]
   [Style(name="trackOverSkin",type="Class",inherit="no")]
   [Style(name="trackDownSkin",type="Class",inherit="no")]
   [Style(name="trackDisabledSkin",type="Class",inherit="no")]
   [Style(name="trackSkin",type="Class",inherit="no")]
   [Style(name="trackColors",type="Array",arrayType="uint",format="Color",inherit="no",theme="halo")]
   [Style(name="thumbUpSkin",type="Class",inherit="no")]
   [Style(name="thumbOverSkin",type="Class",inherit="no")]
   [Style(name="thumbOffset",type="Number",inherit="no")]
   [Style(name="thumbIcon",type="Class",inherit="no")]
   [Style(name="thumbDownSkin",type="Class",inherit="no")]
   [Style(name="thumbSkin",type="Class",inherit="no",states="up, over, down")]
   [Style(name="symbolColor",type="uint",format="Color",inherit="yes",theme="spark")]
   [Style(name="downArrowUpSkin",type="Class",inherit="no")]
   [Style(name="downArrowOverSkin",type="Class",inherit="no")]
   [Style(name="downArrowDownSkin",type="Class",inherit="no")]
   [Style(name="downArrowDisabledSkin",type="Class",inherit="no")]
   [Style(name="downArrowSkin",type="Class",inherit="no",states="up, over, down, disabled")]
   [Style(name="highlightAlphas",type="Array",arrayType="Number",inherit="no",theme="halo")]
   [Style(name="fillColors",type="Array",arrayType="uint",format="Color",inherit="no",theme="halo")]
   [Style(name="fillAlphas",type="Array",arrayType="Number",inherit="no",theme="halo")]
   [Style(name="cornerRadius",type="Number",format="Length",inherit="no",theme="halo, spark")]
   [Style(name="borderColor",type="uint",format="Color",inherit="no",theme="halo")]
   public class ScrollBar extends UIComponent
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      public static const THICKNESS:Number = 16;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var upArrow:Button;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var downArrow:Button;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var scrollTrack:Button;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var scrollThumb:ScrollThumb;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _minWidth:Number = 16;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _minHeight:Number = 32;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var isScrolling:Boolean;
      
      private var trackScrollTimer:Timer;
      
      private var trackScrollRepeatDirection:int;
      
      private var trackScrolling:Boolean = false;
      
      private var trackPosition:Number;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var oldPosition:Number;
      
      private var _direction:String = "vertical";
      
      private var _lineScrollSize:Number = 1;
      
      private var _maxScrollPosition:Number = 0;
      
      private var _minScrollPosition:Number = 0;
      
      private var _pageSize:Number = 0;
      
      private var _pageScrollSize:Number = 0;
      
      private var _scrollPosition:Number = 0;
      
      public function ScrollBar()
      {
         super();
      }
      
      override public function set doubleClickEnabled(value:Boolean) : void
      {
      }
      
      override public function set enabled(value:Boolean) : void
      {
         super.enabled = value;
         invalidateDisplayList();
      }
      
      [Inspectable(category="General",enumeration="vertical,horizontal",defaultValue="vertical")]
      [Bindable("directionChanged")]
      public function get direction() : String
      {
         return this._direction;
      }
      
      public function set direction(value:String) : void
      {
         this._direction = value;
         invalidateSize();
         invalidateDisplayList();
         dispatchEvent(new Event("directionChanged"));
      }
      
      protected function get downArrowStyleFilters() : Object
      {
         return null;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function get lineMinusDetail() : String
      {
         return this.direction == ScrollBarDirection.VERTICAL ? ScrollEventDetail.LINE_UP : ScrollEventDetail.LINE_LEFT;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function get linePlusDetail() : String
      {
         return this.direction == ScrollBarDirection.VERTICAL ? ScrollEventDetail.LINE_DOWN : ScrollEventDetail.LINE_RIGHT;
      }
      
      [Inspectable(category="Other",defaultValue="1")]
      public function get lineScrollSize() : Number
      {
         return this._lineScrollSize;
      }
      
      public function set lineScrollSize(value:Number) : void
      {
         this._lineScrollSize = value;
      }
      
      private function get maxDetail() : String
      {
         return this.direction == ScrollBarDirection.VERTICAL ? ScrollEventDetail.AT_BOTTOM : ScrollEventDetail.AT_RIGHT;
      }
      
      [Inspectable(category="Other",defaultValue="0")]
      public function get maxScrollPosition() : Number
      {
         return this._maxScrollPosition;
      }
      
      public function set maxScrollPosition(value:Number) : void
      {
         this._maxScrollPosition = value;
         invalidateDisplayList();
      }
      
      private function get minDetail() : String
      {
         return this.direction == ScrollBarDirection.VERTICAL ? ScrollEventDetail.AT_TOP : ScrollEventDetail.AT_LEFT;
      }
      
      [Inspectable(category="Other",defaultValue="0")]
      public function get minScrollPosition() : Number
      {
         return this._minScrollPosition;
      }
      
      public function set minScrollPosition(value:Number) : void
      {
         this._minScrollPosition = value;
         invalidateDisplayList();
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function get pageMinusDetail() : String
      {
         return this.direction == ScrollBarDirection.VERTICAL ? ScrollEventDetail.PAGE_UP : ScrollEventDetail.PAGE_LEFT;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function get pagePlusDetail() : String
      {
         return this.direction == ScrollBarDirection.VERTICAL ? ScrollEventDetail.PAGE_DOWN : ScrollEventDetail.PAGE_RIGHT;
      }
      
      [Inspectable(category="Other",defaultValue="0")]
      public function get pageSize() : Number
      {
         return this._pageSize;
      }
      
      public function set pageSize(value:Number) : void
      {
         this._pageSize = value;
      }
      
      [Inspectable(category="Other",defaultValue="0")]
      public function get pageScrollSize() : Number
      {
         return this._pageScrollSize;
      }
      
      public function set pageScrollSize(value:Number) : void
      {
         this._pageScrollSize = value;
      }
      
      [Inspectable(category="Other",defaultValue="0")]
      public function get scrollPosition() : Number
      {
         return this._scrollPosition;
      }
      
      public function set scrollPosition(value:Number) : void
      {
         var denom:Number = NaN;
         var y:Number = NaN;
         var x:Number = NaN;
         this._scrollPosition = value;
         if(Boolean(this.scrollThumb))
         {
            if(!cacheAsBitmap)
            {
               cacheHeuristic = this.scrollThumb.cacheHeuristic = true;
            }
            if(!this.isScrolling)
            {
               value = Math.min(value,this.maxScrollPosition);
               value = Math.max(value,this.minScrollPosition);
               denom = this.maxScrollPosition - this.minScrollPosition;
               y = denom == 0 || isNaN(denom) ? 0 : (value - this.minScrollPosition) * (this.trackHeight - this.scrollThumb.height) / denom + this.trackY;
               x = (this.virtualWidth - this.scrollThumb.width) / 2 + getStyle("thumbOffset");
               this.scrollThumb.move(Math.round(x),Math.round(y));
            }
         }
      }
      
      protected function get thumbStyleFilters() : Object
      {
         return null;
      }
      
      private function get trackHeight() : Number
      {
         return this.virtualHeight - (this.upArrow.getExplicitOrMeasuredHeight() + this.downArrow.getExplicitOrMeasuredHeight());
      }
      
      private function get trackY() : Number
      {
         return this.upArrow.getExplicitOrMeasuredHeight();
      }
      
      protected function get upArrowStyleFilters() : Object
      {
         return null;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function get virtualHeight() : Number
      {
         return unscaledHeight;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function get virtualWidth() : Number
      {
         return unscaledWidth;
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         if(!this.scrollTrack)
         {
            this.scrollTrack = new Button();
            this.scrollTrack.focusEnabled = false;
            this.scrollTrack.tabEnabled = false;
            this.scrollTrack.skinName = "trackSkin";
            this.scrollTrack.upSkinName = "trackUpSkin";
            this.scrollTrack.overSkinName = "trackOverSkin";
            this.scrollTrack.downSkinName = "trackDownSkin";
            this.scrollTrack.disabledSkinName = "trackDisabledSkin";
            if(this.scrollTrack is ISimpleStyleClient)
            {
               ISimpleStyleClient(this.scrollTrack).styleName = this;
            }
            addChild(this.scrollTrack);
            this.scrollTrack.validateProperties();
         }
         if(!this.upArrow)
         {
            this.upArrow = new Button();
            this.upArrow.enabled = false;
            this.upArrow.autoRepeat = true;
            this.upArrow.focusEnabled = false;
            this.upArrow.tabEnabled = false;
            this.upArrow.upSkinName = "upArrowUpSkin";
            this.upArrow.overSkinName = "upArrowOverSkin";
            this.upArrow.downSkinName = "upArrowDownSkin";
            this.upArrow.disabledSkinName = "upArrowDisabledSkin";
            this.upArrow.skinName = "upArrowSkin";
            this.upArrow.upIconName = "";
            this.upArrow.overIconName = "";
            this.upArrow.downIconName = "";
            this.upArrow.disabledIconName = "";
            addChild(this.upArrow);
            this.upArrow.styleName = new StyleProxy(this,this.upArrowStyleFilters);
            this.upArrow.validateProperties();
            this.upArrow.addEventListener(FlexEvent.BUTTON_DOWN,this.upArrow_buttonDownHandler);
         }
         if(!this.downArrow)
         {
            this.downArrow = new Button();
            this.downArrow.enabled = false;
            this.downArrow.autoRepeat = true;
            this.downArrow.focusEnabled = false;
            this.downArrow.tabEnabled = false;
            this.downArrow.upSkinName = "downArrowUpSkin";
            this.downArrow.overSkinName = "downArrowOverSkin";
            this.downArrow.downSkinName = "downArrowDownSkin";
            this.downArrow.disabledSkinName = "downArrowDisabledSkin";
            this.downArrow.skinName = "downArrowSkin";
            this.downArrow.upIconName = "";
            this.downArrow.overIconName = "";
            this.downArrow.downIconName = "";
            this.downArrow.disabledIconName = "";
            addChild(this.downArrow);
            this.downArrow.styleName = new StyleProxy(this,this.downArrowStyleFilters);
            this.downArrow.validateProperties();
            this.downArrow.addEventListener(FlexEvent.BUTTON_DOWN,this.downArrow_buttonDownHandler);
         }
      }
      
      override protected function measure() : void
      {
         super.measure();
         this.upArrow.validateSize();
         this.downArrow.validateSize();
         this.scrollTrack.validateSize();
         this._minWidth = Boolean(this.scrollThumb) ? Number(this.scrollThumb.getExplicitOrMeasuredWidth()) : 0;
         this._minWidth = Math.max(this.scrollTrack.getExplicitOrMeasuredWidth(),this.upArrow.getExplicitOrMeasuredWidth(),this.downArrow.getExplicitOrMeasuredWidth(),this._minWidth);
         this._minHeight = this.upArrow.getExplicitOrMeasuredHeight() + this.downArrow.getExplicitOrMeasuredHeight();
      }
      
      override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         if($height == 1)
         {
            return;
         }
         if(!this.upArrow)
         {
            return;
         }
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         if(cacheAsBitmap)
         {
            cacheHeuristic = false;
            if(Boolean(this.scrollThumb))
            {
               this.scrollThumb.cacheHeuristic = false;
            }
         }
         this.upArrow.setActualSize(this.upArrow.getExplicitOrMeasuredWidth(),this.upArrow.getExplicitOrMeasuredHeight());
         this.upArrow.move((this.virtualWidth - this.upArrow.width) / 2,0);
         this.scrollTrack.setActualSize(this.scrollTrack.getExplicitOrMeasuredWidth(),this.virtualHeight);
         this.scrollTrack.x = (this.virtualWidth - this.scrollTrack.width) / 2;
         this.scrollTrack.y = 0;
         this.downArrow.setActualSize(this.downArrow.getExplicitOrMeasuredWidth(),this.downArrow.getExplicitOrMeasuredHeight());
         this.downArrow.move((this.virtualWidth - this.downArrow.width) / 2,this.virtualHeight - this.downArrow.getExplicitOrMeasuredHeight());
         this.setScrollProperties(this.pageSize,this.minScrollPosition,this.maxScrollPosition,this._pageScrollSize);
         this.scrollPosition = this._scrollPosition;
      }
      
      public function setScrollProperties(pageSize:Number, minScrollPosition:Number, maxScrollPosition:Number, pageScrollSize:Number = 0) : void
      {
         var thumbHeight:Number = NaN;
         this.pageSize = pageSize;
         this._pageScrollSize = pageScrollSize > 0 ? pageScrollSize : pageSize;
         this.minScrollPosition = Math.max(minScrollPosition,0);
         this.maxScrollPosition = Math.max(maxScrollPosition,0);
         this._scrollPosition = Math.max(this.minScrollPosition,this._scrollPosition);
         this._scrollPosition = Math.min(this.maxScrollPosition,this._scrollPosition);
         if(this.maxScrollPosition - this.minScrollPosition > 0 && enabled)
         {
            this.upArrow.enabled = true;
            this.downArrow.enabled = true;
            this.scrollTrack.enabled = true;
            addEventListener(MouseEvent.MOUSE_DOWN,this.scrollTrack_mouseDownHandler);
            addEventListener(MouseEvent.MOUSE_OVER,this.scrollTrack_mouseOverHandler);
            addEventListener(MouseEvent.MOUSE_OUT,this.scrollTrack_mouseOutHandler);
            if(!this.scrollThumb)
            {
               this.scrollThumb = new ScrollThumb();
               this.scrollThumb.focusEnabled = false;
               this.scrollThumb.tabEnabled = false;
               addChildAt(this.scrollThumb,getChildIndex(this.downArrow));
               this.scrollThumb.styleName = new StyleProxy(this,this.thumbStyleFilters);
               this.scrollThumb.upSkinName = "thumbUpSkin";
               this.scrollThumb.overSkinName = "thumbOverSkin";
               this.scrollThumb.downSkinName = "thumbDownSkin";
               this.scrollThumb.iconName = "thumbIcon";
               this.scrollThumb.skinName = "thumbSkin";
            }
            thumbHeight = this.trackHeight < 0 ? 0 : Math.round(pageSize / (this.maxScrollPosition - this.minScrollPosition + pageSize) * this.trackHeight);
            if(thumbHeight < this.scrollThumb.minHeight)
            {
               if(this.trackHeight < this.scrollThumb.minHeight)
               {
                  this.scrollThumb.visible = false;
               }
               else
               {
                  thumbHeight = Number(this.scrollThumb.minHeight);
                  this.scrollThumb.visible = true;
                  this.scrollThumb.setActualSize(this.scrollThumb.measuredWidth,this.scrollThumb.minHeight);
               }
            }
            else
            {
               this.scrollThumb.visible = true;
               this.scrollThumb.setActualSize(this.scrollThumb.measuredWidth,thumbHeight);
            }
            this.scrollThumb.setRange(this.upArrow.getExplicitOrMeasuredHeight() + 0,this.virtualHeight - this.downArrow.getExplicitOrMeasuredHeight() - this.scrollThumb.height,this.minScrollPosition,this.maxScrollPosition);
            this.scrollPosition = Math.max(Math.min(this.scrollPosition,this.maxScrollPosition),this.minScrollPosition);
         }
         else
         {
            this.upArrow.enabled = false;
            this.downArrow.enabled = false;
            this.scrollTrack.enabled = false;
            if(Boolean(this.scrollThumb))
            {
               this.scrollThumb.visible = false;
            }
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function lineScroll(direction:int) : void
      {
         var oldPosition:Number = NaN;
         var detail:String = null;
         var delta:Number = this._lineScrollSize;
         var newPos:Number = this._scrollPosition + direction * delta;
         if(newPos > this.maxScrollPosition)
         {
            newPos = this.maxScrollPosition;
         }
         else if(newPos < this.minScrollPosition)
         {
            newPos = this.minScrollPosition;
         }
         if(newPos != this.scrollPosition)
         {
            oldPosition = this.scrollPosition;
            this.scrollPosition = newPos;
            detail = direction < 0 ? this.lineMinusDetail : this.linePlusDetail;
            this.dispatchScrollEvent(oldPosition,detail);
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function pageScroll(direction:int) : void
      {
         var oldPosition:Number = NaN;
         var detail:String = null;
         var delta:Number = this._pageScrollSize != 0 ? this._pageScrollSize : this.pageSize;
         var newPos:Number = this._scrollPosition + direction * delta;
         if(newPos > this.maxScrollPosition)
         {
            newPos = this.maxScrollPosition;
         }
         else if(newPos < this.minScrollPosition)
         {
            newPos = this.minScrollPosition;
         }
         if(newPos != this.scrollPosition)
         {
            oldPosition = this.scrollPosition;
            this.scrollPosition = newPos;
            detail = direction < 0 ? this.pageMinusDetail : this.pagePlusDetail;
            this.dispatchScrollEvent(oldPosition,detail);
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function dispatchScrollEvent(oldPosition:Number, detail:String) : void
      {
         var event:ScrollEvent = new ScrollEvent(ScrollEvent.SCROLL);
         event.detail = detail;
         event.position = this.scrollPosition;
         event.delta = this.scrollPosition - oldPosition;
         event.direction = this.direction;
         dispatchEvent(event);
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function isScrollBarKey(key:uint) : Boolean
      {
         var oldPosition:Number = NaN;
         if(key == Keyboard.HOME)
         {
            if(this.scrollPosition != 0)
            {
               oldPosition = this.scrollPosition;
               this.scrollPosition = 0;
               this.dispatchScrollEvent(oldPosition,this.minDetail);
            }
            return true;
         }
         if(key == Keyboard.END)
         {
            if(this.scrollPosition < this.maxScrollPosition)
            {
               oldPosition = this.scrollPosition;
               this.scrollPosition = this.maxScrollPosition;
               this.dispatchScrollEvent(oldPosition,this.maxDetail);
            }
            return true;
         }
         return false;
      }
      
      private function upArrow_buttonDownHandler(event:FlexEvent) : void
      {
         if(isNaN(this.oldPosition))
         {
            this.oldPosition = this.scrollPosition;
         }
         this.lineScroll(-1);
      }
      
      private function downArrow_buttonDownHandler(event:FlexEvent) : void
      {
         if(isNaN(this.oldPosition))
         {
            this.oldPosition = this.scrollPosition;
         }
         this.lineScroll(1);
      }
      
      private function scrollTrack_mouseOverHandler(event:MouseEvent) : void
      {
         if(!(event.target == this || event.target == this.scrollTrack) || !enabled)
         {
            return;
         }
         if(this.trackScrolling)
         {
            this.trackScrollTimer.start();
         }
      }
      
      private function scrollTrack_mouseOutHandler(event:MouseEvent) : void
      {
         if(this.trackScrolling && enabled)
         {
            this.trackScrollTimer.stop();
         }
      }
      
      private function scrollTrack_mouseDownHandler(event:MouseEvent) : void
      {
         if(!(event.target == this || event.target == this.scrollTrack) || !enabled)
         {
            return;
         }
         this.trackScrolling = true;
         var sbRoot:DisplayObject = systemManager.getSandboxRoot();
         sbRoot.addEventListener(MouseEvent.MOUSE_UP,this.scrollTrack_mouseUpHandler,true);
         sbRoot.addEventListener(MouseEvent.MOUSE_MOVE,this.scrollTrack_mouseMoveHandler,true);
         sbRoot.addEventListener(SandboxMouseEvent.MOUSE_UP_SOMEWHERE,this.scrollTrack_mouseLeaveHandler);
         systemManager.deployMouseShields(true);
         var pt:Point = new Point(event.localX,event.localY);
         pt = event.target.localToGlobal(pt);
         pt = globalToLocal(pt);
         this.trackPosition = pt.y;
         if(isNaN(this.oldPosition))
         {
            this.oldPosition = this.scrollPosition;
         }
         this.trackScrollRepeatDirection = this.scrollThumb.y + this.scrollThumb.height < pt.y ? 1 : (this.scrollThumb.y > pt.y ? -1 : 0);
         this.pageScroll(this.trackScrollRepeatDirection);
         if(!this.trackScrollTimer)
         {
            this.trackScrollTimer = new Timer(getStyle("repeatDelay"),1);
            this.trackScrollTimer.addEventListener(TimerEvent.TIMER,this.trackScrollTimerHandler);
         }
         else
         {
            this.trackScrollTimer.delay = getStyle("repeatDelay");
            this.trackScrollTimer.repeatCount = 1;
         }
         this.trackScrollTimer.start();
      }
      
      private function trackScrollTimerHandler(event:Event) : void
      {
         if(this.trackScrollRepeatDirection == 1)
         {
            if(this.scrollThumb.y + this.scrollThumb.height > this.trackPosition)
            {
               return;
            }
         }
         if(this.trackScrollRepeatDirection == -1)
         {
            if(this.scrollThumb.y < this.trackPosition)
            {
               return;
            }
         }
         this.pageScroll(this.trackScrollRepeatDirection);
         if(Boolean(this.trackScrollTimer) && this.trackScrollTimer.repeatCount == 1)
         {
            this.trackScrollTimer.delay = getStyle("repeatInterval");
            this.trackScrollTimer.repeatCount = 0;
         }
      }
      
      private function scrollTrack_mouseUpHandler(event:MouseEvent) : void
      {
         this.scrollTrack_mouseLeaveHandler(event);
      }
      
      private function scrollTrack_mouseLeaveHandler(event:Event) : void
      {
         this.trackScrolling = false;
         var sbRoot:DisplayObject = systemManager.getSandboxRoot();
         sbRoot.removeEventListener(MouseEvent.MOUSE_UP,this.scrollTrack_mouseUpHandler,true);
         sbRoot.removeEventListener(MouseEvent.MOUSE_MOVE,this.scrollTrack_mouseMoveHandler,true);
         sbRoot.removeEventListener(SandboxMouseEvent.MOUSE_UP_SOMEWHERE,this.scrollTrack_mouseLeaveHandler);
         systemManager.deployMouseShields(false);
         if(Boolean(this.trackScrollTimer))
         {
            this.trackScrollTimer.reset();
         }
         if(event.target != this.scrollTrack)
         {
            return;
         }
         var detail:String = this.oldPosition > this.scrollPosition ? this.pageMinusDetail : this.pagePlusDetail;
         this.dispatchScrollEvent(this.oldPosition,detail);
         this.oldPosition = NaN;
      }
      
      private function scrollTrack_mouseMoveHandler(event:MouseEvent) : void
      {
         var pt:Point = null;
         if(this.trackScrolling)
         {
            pt = new Point(event.stageX,event.stageY);
            pt = globalToLocal(pt);
            this.trackPosition = pt.y;
         }
      }
   }
}

