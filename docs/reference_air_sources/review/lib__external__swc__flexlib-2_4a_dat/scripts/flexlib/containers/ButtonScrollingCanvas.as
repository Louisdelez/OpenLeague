package flexlib.containers
{
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import mx.containers.Canvas;
   import mx.controls.Button;
   import mx.core.ScrollPolicy;
   import mx.styles.CSSStyleDeclaration;
   import mx.styles.StyleManager;
   
   [IconFile("ButtonScrollingCanvas.png")]
   [Style(name="downButtonStyleName",type="String",inherit="no")]
   [Style(name="upButtonStyleName",type="String",inherit="no")]
   [Style(name="rightButtonStyleName",type="String",inherit="no")]
   [Style(name="leftButtonStyleName",type="String",inherit="no")]
   [Style(name="buttonWidth",type="Number",inherit="no")]
   public class ButtonScrollingCanvas extends Canvas
   {
      
      [Embed(source="../assets/assets.swf",symbol="up_arrow")]
      private static var DEFAULT_UP_BUTTON:Class = ButtonScrollingCanvas_DEFAULT_UP_BUTTON;
      
      [Embed(source="../assets/assets.swf",symbol="down_arrow")]
      private static var DEFAULT_DOWN_BUTTON:Class = ButtonScrollingCanvas_DEFAULT_DOWN_BUTTON;
      
      [Embed(source="../assets/assets.swf",symbol="left_arrow")]
      private static var DEFAULT_LEFT_BUTTON:Class = ButtonScrollingCanvas_DEFAULT_LEFT_BUTTON;
      
      [Embed(source="../assets/assets.swf",symbol="right_arrow")]
      private static var DEFAULT_RIGHT_BUTTON:Class = ButtonScrollingCanvas_DEFAULT_RIGHT_BUTTON;
      
      public static var DEFAULT_BUTTON_WIDTH:Number = 50;
      
      initializeStyles();
      
      private var rightButton:Button;
      
      public var scrollJump:Number = 10;
      
      private var _stopScrollingEvent:String = MouseEvent.MOUSE_UP;
      
      public var scrollSpeed:Number = 10;
      
      private var _childrenCreated:Boolean = false;
      
      private var upButton:Button;
      
      private var leftButton:Button;
      
      private var _explicitButtonHeight:Number;
      
      private var downButton:Button;
      
      private var timer:Timer;
      
      private var innerCanvas:Canvas;
      
      private var _startScrollingEvent:String = MouseEvent.MOUSE_DOWN;
      
      public function ButtonScrollingCanvas()
      {
         super();
      }
      
      private static function initializeStyles() : void
      {
         var selector:CSSStyleDeclaration = null;
         var upStyleName:String = null;
         var upSelector:CSSStyleDeclaration = null;
         var downStyleName:String = null;
         var downSelector:CSSStyleDeclaration = null;
         var leftStyleName:String = null;
         var leftSelector:CSSStyleDeclaration = null;
         var rightStyleName:String = null;
         var rightSelector:CSSStyleDeclaration = null;
         selector = StyleManager.getStyleDeclaration("ButtonScrollingCanvas");
         if(!selector)
         {
            selector = new CSSStyleDeclaration();
         }
         selector.defaultFactory = function():void
         {
            this.upButtonStyleName = "upButton";
            this.downButtonStyleName = "downButton";
            this.leftButtonStyleName = "leftButton";
            this.rightButtonStyleName = "rightButton";
         };
         StyleManager.setStyleDeclaration("ButtonScrollingCanvas",selector,false);
         upStyleName = selector.getStyle("upButtonStyleName");
         upSelector = StyleManager.getStyleDeclaration("." + upStyleName);
         if(!upSelector)
         {
            upSelector = new CSSStyleDeclaration();
         }
         upSelector.defaultFactory = function():void
         {
            this.icon = DEFAULT_UP_BUTTON;
            this.fillAlphas = [1,1,1,1];
            this.cornerRadius = 0;
         };
         StyleManager.setStyleDeclaration("." + upStyleName,upSelector,false);
         downStyleName = selector.getStyle("downButtonStyleName");
         downSelector = StyleManager.getStyleDeclaration("." + downStyleName);
         if(!downSelector)
         {
            downSelector = new CSSStyleDeclaration();
         }
         downSelector.defaultFactory = function():void
         {
            this.icon = DEFAULT_DOWN_BUTTON;
            this.fillAlphas = [1,1,1,1];
            this.cornerRadius = 0;
         };
         StyleManager.setStyleDeclaration("." + downStyleName,downSelector,false);
         leftStyleName = selector.getStyle("leftButtonStyleName");
         leftSelector = StyleManager.getStyleDeclaration("." + leftStyleName);
         if(!leftSelector)
         {
            leftSelector = new CSSStyleDeclaration();
         }
         leftSelector.defaultFactory = function():void
         {
            this.icon = DEFAULT_LEFT_BUTTON;
            this.fillAlphas = [1,1,1,1];
            this.cornerRadius = 0;
         };
         StyleManager.setStyleDeclaration("." + leftStyleName,leftSelector,false);
         rightStyleName = selector.getStyle("rightButtonStyleName");
         rightSelector = StyleManager.getStyleDeclaration("." + rightStyleName);
         if(!rightSelector)
         {
            rightSelector = new CSSStyleDeclaration();
         }
         rightSelector.defaultFactory = function():void
         {
            this.icon = DEFAULT_RIGHT_BUTTON;
            this.fillAlphas = [1,1,1,1];
            this.cornerRadius = 0;
         };
         StyleManager.setStyleDeclaration("." + rightStyleName,rightSelector,false);
      }
      
      private function stopScrolling(event:Event) : void
      {
         if(timer.running)
         {
            timer.stop();
         }
      }
      
      override public function get verticalScrollPosition() : Number
      {
         return innerCanvas.verticalScrollPosition;
      }
      
      override public function get horizontalScrollPosition() : Number
      {
         return innerCanvas.horizontalScrollPosition;
      }
      
      override public function set verticalScrollPosition(value:Number) : void
      {
         innerCanvas.verticalScrollPosition = value;
         callLater(enableOrDisableButtons);
      }
      
      public function set stopScrollingEvent(value:String) : void
      {
         _stopScrollingEvent = value;
      }
      
      private function scrollLeft(event:TimerEvent) : void
      {
         innerCanvas.horizontalScrollPosition -= scrollJump;
         enableOrDisableButtons();
      }
      
      override public function set horizontalScrollPosition(value:Number) : void
      {
         innerCanvas.horizontalScrollPosition = value;
         callLater(enableOrDisableButtons);
      }
      
      override public function addChild(child:DisplayObject) : DisplayObject
      {
         if(_childrenCreated)
         {
            return innerCanvas.addChild(child);
         }
         return super.addChild(child);
      }
      
      override public function getChildIndex(child:DisplayObject) : int
      {
         return _childrenCreated ? int(innerCanvas.getChildIndex(child)) : int(super.getChildIndex(child));
      }
      
      private function scrollDown(event:TimerEvent) : void
      {
         innerCanvas.verticalScrollPosition += scrollJump;
         enableOrDisableButtons();
      }
      
      public function set startScrollingEvent(value:String) : void
      {
         if(_childrenCreated)
         {
            removeListeners(_startScrollingEvent);
            addListeners(value);
         }
         _startScrollingEvent = value;
      }
      
      private function startScrollingUp(event:Event) : void
      {
         if(!(event.currentTarget as Button).enabled)
         {
            return;
         }
         startScrolling(scrollUp,event.currentTarget as Button);
      }
      
      public function get buttonWidth() : Number
      {
         var s:Number = NaN;
         s = Number(getStyle("buttonWidth"));
         if(Boolean(s))
         {
            return s;
         }
         return ButtonScrollingCanvas.DEFAULT_BUTTON_WIDTH;
      }
      
      override public function get maxHorizontalScrollPosition() : Number
      {
         return innerCanvas.maxHorizontalScrollPosition;
      }
      
      private function positionButtons(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         var buttonWidth:Number = NaN;
         var buttonHeight:Number = NaN;
         buttonWidth = this.buttonWidth;
         buttonHeight = Boolean(_explicitButtonHeight) ? _explicitButtonHeight : unscaledHeight;
         leftButton.move(0,0);
         leftButton.setActualSize(buttonWidth,buttonHeight);
         rightButton.move(unscaledWidth - buttonWidth,0);
         rightButton.setActualSize(buttonWidth,buttonHeight);
         upButton.move(buttonWidth,0);
         downButton.move(buttonWidth,unscaledHeight - buttonWidth);
         upButton.setActualSize(unscaledWidth - buttonWidth * 2,buttonWidth);
         downButton.setActualSize(unscaledWidth - buttonWidth * 2,buttonWidth);
      }
      
      private function removeListeners(eventString:String) : void
      {
         leftButton.removeEventListener(eventString,startScrollingLeft);
         rightButton.removeEventListener(eventString,startScrollingRight);
         upButton.removeEventListener(eventString,startScrollingUp);
         downButton.removeEventListener(eventString,startScrollingDown);
      }
      
      private function startScrollingRight(event:Event) : void
      {
         if(!(event.currentTarget as Button).enabled)
         {
            return;
         }
         startScrolling(scrollRight,event.currentTarget as Button);
      }
      
      override public function getChildAt(index:int) : DisplayObject
      {
         return _childrenCreated ? innerCanvas.getChildAt(index) : super.getChildAt(index);
      }
      
      private function scrollUp(event:TimerEvent) : void
      {
         innerCanvas.verticalScrollPosition -= scrollJump;
         enableOrDisableButtons();
      }
      
      public function get stopScrollingEvent() : String
      {
         return this._stopScrollingEvent;
      }
      
      private function startScrollingLeft(event:Event) : void
      {
         if(!(event.currentTarget as Button).enabled)
         {
            return;
         }
         startScrolling(scrollLeft,event.currentTarget as Button);
      }
      
      override public function addChildAt(child:DisplayObject, index:int) : DisplayObject
      {
         if(_childrenCreated)
         {
            return innerCanvas.addChildAt(child,index);
         }
         return super.addChildAt(child,index);
      }
      
      override public function getChildByName(name:String) : DisplayObject
      {
         return _childrenCreated ? innerCanvas.getChildByName(name) : super.getChildByName(name);
      }
      
      private function addListeners(eventString:String) : void
      {
         leftButton.addEventListener(eventString,startScrollingLeft,false,0,true);
         rightButton.addEventListener(eventString,startScrollingRight,false,0,true);
         upButton.addEventListener(eventString,startScrollingUp,false,0,true);
         downButton.addEventListener(eventString,startScrollingDown,false,0,true);
      }
      
      public function get startScrollingEvent() : String
      {
         return this._startScrollingEvent;
      }
      
      public function set explicitButtonHeight(value:Number) : void
      {
         this._explicitButtonHeight = value;
         invalidateDisplayList();
      }
      
      override public function get maxVerticalScrollPosition() : Number
      {
         return innerCanvas.maxVerticalScrollPosition;
      }
      
      private function startScrollingDown(event:Event) : void
      {
         if(!(event.currentTarget as Button).enabled)
         {
            return;
         }
         startScrolling(scrollDown,event.currentTarget as Button);
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         timer = new Timer(scrollSpeed);
         leftButton = new Button();
         rightButton = new Button();
         upButton = new Button();
         downButton = new Button();
         leftButton.styleName = getStyle("leftButtonStyleName");
         rightButton.styleName = getStyle("rightButtonStyleName");
         upButton.styleName = getStyle("upButtonStyleName");
         downButton.styleName = getStyle("downButtonStyleName");
         innerCanvas = new Canvas();
         innerCanvas.document = this.document;
         innerCanvas.horizontalScrollPolicy = ScrollPolicy.OFF;
         innerCanvas.verticalScrollPolicy = ScrollPolicy.OFF;
         innerCanvas.clipContent = true;
         while(this.numChildren > 0)
         {
            innerCanvas.addChild(this.removeChildAt(0));
         }
         rawChildren.addChild(innerCanvas);
         rawChildren.addChild(leftButton);
         rawChildren.addChild(rightButton);
         rawChildren.addChild(upButton);
         rawChildren.addChild(downButton);
         _childrenCreated = true;
         addListeners(_startScrollingEvent);
      }
      
      private function scrollRight(event:TimerEvent) : void
      {
         innerCanvas.horizontalScrollPosition += scrollJump;
         enableOrDisableButtons();
      }
      
      public function set buttonWidth(value:Number) : void
      {
         this.setStyle("buttonWidth",value);
         invalidateDisplayList();
      }
      
      override public function getChildren() : Array
      {
         return _childrenCreated ? innerCanvas.getChildren() : super.getChildren();
      }
      
      override public function initialize() : void
      {
         super.initialize();
         ButtonScrollingCanvas.initializeStyles();
      }
      
      private function startScrolling(scrollFunction:Function, button:Button) : void
      {
         if(_stopScrollingEvent == MouseEvent.MOUSE_UP)
         {
            stage.addEventListener(_stopScrollingEvent,stopScrolling);
         }
         else
         {
            button.addEventListener(_stopScrollingEvent,stopScrolling);
         }
         if(timer.running)
         {
            timer.stop();
         }
         timer = new Timer(this.scrollSpeed);
         timer.addEventListener(TimerEvent.TIMER,scrollFunction);
         timer.start();
      }
      
      protected function enableOrDisableButtons() : void
      {
         if(this.horizontalScrollPolicy == ScrollPolicy.OFF)
         {
            leftButton.visible = rightButton.visible = leftButton.includeInLayout = rightButton.includeInLayout = false;
         }
         else
         {
            leftButton.visible = leftButton.enabled = innerCanvas.horizontalScrollPosition > 0;
            rightButton.visible = rightButton.enabled = innerCanvas.horizontalScrollPosition < innerCanvas.maxHorizontalScrollPosition;
         }
         if(this.verticalScrollPolicy == ScrollPolicy.OFF)
         {
            upButton.visible = downButton.visible = upButton.includeInLayout = downButton.includeInLayout = false;
         }
         else
         {
            upButton.visible = upButton.enabled = upButton.includeInLayout = innerCanvas.verticalScrollPosition > 0;
            downButton.visible = downButton.enabled = downButton.includeInLayout = innerCanvas.verticalScrollPosition < innerCanvas.maxVerticalScrollPosition;
         }
         positionButtons(this.width,this.height);
      }
      
      override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         innerCanvas.setActualSize(unscaledWidth,unscaledHeight);
         positionButtons(unscaledWidth,unscaledHeight);
         callLater(enableOrDisableButtons);
      }
   }
}

