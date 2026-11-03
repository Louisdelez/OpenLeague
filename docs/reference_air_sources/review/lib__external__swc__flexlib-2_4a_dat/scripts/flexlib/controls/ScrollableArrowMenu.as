package flexlib.controls
{
   import flash.display.DisplayObjectContainer;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import mx.controls.Button;
   import mx.controls.Menu;
   import mx.controls.scrollClasses.ScrollBar;
   import mx.core.Application;
   import mx.core.ScrollPolicy;
   import mx.events.ScrollEvent;
   import mx.styles.CSSStyleDeclaration;
   import mx.styles.StyleManager;
   
   [Style(name="downButtonStyleName",type="String",inherit="no")]
   [Style(name="upButtonStyleName",type="String",inherit="no")]
   [IconFile("ScrollableArrowMenu.png")]
   public class ScrollableArrowMenu extends ScrollableMenu
   {
      
      [Embed(source="../assets/assets.swf",symbol="up_arrow")]
      private static var DEFAULT_UP_BUTTON:Class = ScrollableArrowMenu_DEFAULT_UP_BUTTON;
      
      [Embed(source="../assets/assets.swf",symbol="down_arrow")]
      private static var DEFAULT_DOWN_BUTTON:Class = ScrollableArrowMenu_DEFAULT_DOWN_BUTTON;
      
      initializeStyles();
      
      public var scrollJump:Number = 1;
      
      public var scrollSpeed:Number = 80;
      
      private var upButton:Button;
      
      private var downButton:Button;
      
      private var _arrowScrollPolicy:String = ScrollPolicy.AUTO;
      
      private var timer:Timer;
      
      public function ScrollableArrowMenu()
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
         selector = StyleManager.getStyleDeclaration("ScrollableArrowMenu");
         if(!selector)
         {
            selector = new CSSStyleDeclaration();
         }
         selector.defaultFactory = function():void
         {
            this.upButtonStyleName = "upButton";
            this.downButtonStyleName = "downButton";
         };
         StyleManager.setStyleDeclaration("ScrollableArrowMenu",selector,false);
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
      }
      
      public static function createMenu(parent:DisplayObjectContainer, mdp:Object, showRoot:Boolean = true) : ScrollableArrowMenu
      {
         var menu:ScrollableArrowMenu = null;
         menu = new ScrollableArrowMenu();
         menu.tabEnabled = false;
         menu.owner = DisplayObjectContainer(Application.application);
         menu.showRoot = showRoot;
         popUpMenu(menu,parent,mdp);
         return menu;
      }
      
      private function scrollDown(event:TimerEvent) : void
      {
         if(this.verticalScrollPosition + scrollJump < this.maxVerticalScrollPosition)
         {
            this.verticalScrollPosition += scrollJump;
         }
         else
         {
            this.verticalScrollPosition = this.maxVerticalScrollPosition;
         }
         checkButtons(null);
      }
      
      private function checkButtons(event:Event) : void
      {
         if(this.arrowScrollPolicy == ScrollPolicy.AUTO)
         {
            upButton.visible = upButton.enabled = this.verticalScrollPosition != 0;
            downButton.visible = downButton.enabled = this.verticalScrollPosition != this.maxVerticalScrollPosition;
         }
         else if(this.arrowScrollPolicy == ScrollPolicy.ON)
         {
            upButton.visible = downButton.visible = true;
            upButton.enabled = this.verticalScrollPosition != 0;
            downButton.enabled = this.verticalScrollPosition != this.maxVerticalScrollPosition;
         }
         else
         {
            upButton.visible = upButton.enabled = downButton.visible = downButton.enabled = false;
         }
      }
      
      public function set arrowScrollPolicy(value:String) : void
      {
         this._arrowScrollPolicy = value;
         invalidateDisplayList();
      }
      
      private function scrollUp(event:TimerEvent) : void
      {
         if(this.verticalScrollPosition - scrollJump > 0)
         {
            this.verticalScrollPosition -= scrollJump;
         }
         else
         {
            this.verticalScrollPosition = 0;
         }
         checkButtons(null);
      }
      
      private function startScrollingDown(event:Event) : void
      {
         if(Boolean(timer) && timer.running)
         {
            timer.stop();
         }
         timer = new Timer(this.scrollSpeed);
         timer.addEventListener(TimerEvent.TIMER,scrollDown);
         timer.start();
      }
      
      override protected function createSubMenu() : Menu
      {
         var menu:ScrollableArrowMenu = null;
         menu = new ScrollableArrowMenu();
         menu.arrowScrollPolicy = this.arrowScrollPolicy;
         return menu;
      }
      
      override public function initialize() : void
      {
         super.initialize();
         ScrollableArrowMenu.initializeStyles();
      }
      
      override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         var w:Number = NaN;
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         w = unscaledWidth;
         if(Boolean(verticalScrollBar))
         {
            w = unscaledWidth - ScrollBar.THICKNESS;
         }
         upButton.setActualSize(w,15);
         downButton.setActualSize(w,15);
         upButton.move(0,0);
         downButton.move(0,measuredHeight - downButton.height);
         checkButtons(null);
      }
      
      private function stopScrolling(event:Event) : void
      {
         event.currentTarget.removeEventListener(MouseEvent.MOUSE_UP,stopScrolling);
         if(Boolean(timer) && timer.running)
         {
            timer.stop();
         }
      }
      
      public function get arrowScrollPolicy() : String
      {
         return _arrowScrollPolicy;
      }
      
      private function startScrollingUp(event:Event) : void
      {
         if(Boolean(timer) && timer.running)
         {
            timer.stop();
         }
         timer = new Timer(this.scrollSpeed);
         timer.addEventListener(TimerEvent.TIMER,scrollUp);
         timer.start();
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         upButton = new Button();
         downButton = new Button();
         upButton.styleName = getStyle("upButtonStyleName");
         downButton.styleName = getStyle("downButtonStyleName");
         addChild(upButton);
         addChild(downButton);
         upButton.addEventListener(MouseEvent.ROLL_OVER,startScrollingUp);
         upButton.addEventListener(MouseEvent.ROLL_OUT,stopScrolling);
         downButton.addEventListener(MouseEvent.ROLL_OVER,startScrollingDown);
         downButton.addEventListener(MouseEvent.ROLL_OUT,stopScrolling);
         this.addEventListener(ScrollEvent.SCROLL,checkButtons);
      }
   }
}

