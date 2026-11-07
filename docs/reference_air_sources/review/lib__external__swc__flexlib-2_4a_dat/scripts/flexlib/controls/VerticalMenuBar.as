package flexlib.controls
{
   import flash.display.DisplayObject;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flexlib.controls.menuClasses.VerticalMenuItemRenderer;
   import mx.controls.Menu;
   import mx.controls.MenuBar;
   import mx.controls.menuClasses.IMenuBarItemRenderer;
   import mx.controls.menuClasses.MenuItemRenderer;
   import mx.core.ClassFactory;
   import mx.events.MenuEvent;
   import mx.managers.ISystemManager;
   
   [IconFile("VerticalMenuBar.png")]
   public class VerticalMenuBar extends MenuBar
   {
      
      private static const MARGIN_HEIGHT:int = 0;
      
      public static const LEFT:String = "left";
      
      public static const RIGHT:String = "right";
      
      private var _direction:String = VerticalMenuBar.RIGHT;
      
      public function VerticalMenuBar()
      {
         super();
      }
      
      private function shiftRootMenu(menu:Menu, menuBar:MenuBar, item:IMenuBarItemRenderer) : void
      {
         var pt:Point = null;
         var sm:ISystemManager = null;
         pt = new Point(0,0);
         pt = DisplayObject(item).localToGlobal(pt);
         if(this._direction == VerticalMenuBar.LEFT)
         {
            pt.x -= menu.width;
         }
         else
         {
            pt.x += item.width;
         }
         pt.y -= item.height;
         sm = systemManager;
         if(pt.y + item.height + 1 + menu.getExplicitOrMeasuredHeight() > screen.height + screen.y)
         {
            pt.y -= menu.getExplicitOrMeasuredHeight();
         }
         else
         {
            pt.y += item.height + 1;
         }
         if(pt.x + menu.getExplicitOrMeasuredWidth() > screen.width + screen.x)
         {
            pt.x = screen.x + screen.width - menu.getExplicitOrMeasuredWidth();
         }
         pt = DisplayObject(sm.topLevelSystemManager).globalToLocal(pt);
         menu.move(pt.x,pt.y);
      }
      
      private function shiftSubMenu(menu:Menu, parentMenu:Menu) : void
      {
         if(this._direction == VerticalMenuBar.LEFT)
         {
            menu.move(parentMenu.x - menu.width,menu.y);
         }
      }
      
      override public function getMenuAt(index:int) : Menu
      {
         var menu:Menu = null;
         var wasNull:Boolean = false;
         menu = menus[index];
         wasNull = menu == null;
         menu = super.getMenuAt(index);
         if(this.direction == VerticalMenuBar.LEFT)
         {
            menu.itemRenderer = new ClassFactory(VerticalMenuItemRenderer);
         }
         else
         {
            menu.itemRenderer = new ClassFactory(MenuItemRenderer);
         }
         if(wasNull)
         {
            menu.setStyle("openDuration",1);
            menu.addEventListener("menuShow",moveMenuOnShow);
         }
         return menu;
      }
      
      override protected function measure() : void
      {
         var len:int = 0;
         var i:int = 0;
         super.measure();
         len = int(menuBarItems.length);
         measuredHeight = 0;
         measuredWidth = DEFAULT_MEASURED_MIN_WIDTH;
         for(i = 0; i < len; i++)
         {
            measuredHeight += menuBarItems[i].getExplicitOrMeasuredHeight();
            measuredWidth = Math.max(measuredWidth,menuBarItems[i].getExplicitOrMeasuredWidth());
         }
         if(len > 0)
         {
            measuredHeight += 2 * MARGIN_HEIGHT;
         }
         else
         {
            measuredHeight = DEFAULT_MEASURED_MIN_HEIGHT;
         }
         measuredMinWidth = measuredWidth;
         measuredMinHeight = measuredHeight;
      }
      
      private function moveMenuOnShow(event:MenuEvent) : void
      {
         var menu:Menu = null;
         var menuBar:MenuBar = null;
         var parentMenu:Menu = null;
         var item:IMenuBarItemRenderer = null;
         menu = event.menu;
         menuBar = event.menuBar;
         parentMenu = menu.parentMenu;
         if(parentMenu == null)
         {
            item = menuBar.menuBarItems[menuBar.selectedIndex];
            callLater(shiftRootMenu,[menu,menuBar,item]);
         }
         else
         {
            callLater(shiftSubMenu,[menu,parentMenu]);
         }
      }
      
      public function set direction(value:String) : void
      {
         if(this._direction != value)
         {
            this._direction = value;
         }
      }
      
      public function get direction() : String
      {
         return this._direction;
      }
      
      override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         var lastY:Number = NaN;
         var lastH:Number = NaN;
         var len:int = 0;
         var clipContent:Boolean = false;
         var hideItems:Boolean = false;
         var i:int = 0;
         var item:IMenuBarItemRenderer = null;
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         lastY = 0;
         lastH = 0;
         len = int(menuBarItems.length);
         clipContent = false;
         hideItems = unscaledWidth == 0 || unscaledHeight == 0;
         for(i = 0; i < len; i++)
         {
            item = menuBarItems[i];
            item.setActualSize(unscaledWidth,item.getExplicitOrMeasuredHeight());
            item.visible = !hideItems;
            item.move(0,lastY + lastH);
            lastY = Number(item.y = lastY + lastH);
            lastH = Number(item.height);
            if(!hideItems && (item.getExplicitOrMeasuredWidth() > unscaledWidth || lastY + lastH > unscaledHeight))
            {
               clipContent = true;
            }
         }
         scrollRect = clipContent ? new Rectangle(0,0,unscaledWidth,unscaledHeight) : null;
      }
   }
}

