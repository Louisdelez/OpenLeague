package flexlib.controls
{
   import flash.events.Event;
   import mx.controls.Menu;
   import mx.controls.MenuBar;
   import mx.controls.menuClasses.IMenuBarItemRenderer;
   import mx.events.MenuEvent;
   import mx.styles.CSSStyleDeclaration;
   import mx.styles.StyleManager;
   
   [IconFile("ScrollableMenu.png")]
   public class ScrollableMenuBar extends MenuBar
   {
      
      private var _arrowScrollPolicy:String;
      
      private var _verticalScrollPolicy:String;
      
      public function ScrollableMenuBar()
      {
         super();
      }
      
      override public function getMenuAt(index:int) : Menu
      {
         var item:IMenuBarItemRenderer = null;
         var mdp:Object = null;
         var menu:ScrollableArrowMenu = null;
         var menuStyleName:Object = null;
         var styleDecl:CSSStyleDeclaration = null;
         item = menuBarItems[index];
         mdp = item.data;
         menu = menus[index];
         if(menu == null)
         {
            menu = new ScrollableArrowMenu();
            menu.verticalScrollPolicy = this.verticalScrollPolicy;
            menu.arrowScrollPolicy = this.arrowScrollPolicy;
            menu.maxHeight = this.maxHeight;
            menu.showRoot = false;
            menu.styleName = this;
            menuStyleName = getStyle("menuStyleName");
            if(Boolean(menuStyleName))
            {
               styleDecl = StyleManager.getStyleDeclaration("." + menuStyleName);
               if(Boolean(styleDecl))
               {
                  menu.styleDeclaration = styleDecl;
               }
            }
            menu.sourceMenuBar = this;
            menu.owner = this;
            menu.addEventListener("menuHide",eventHandler);
            menu.addEventListener("itemRollOver",eventHandler);
            menu.addEventListener("itemRollOut",eventHandler);
            menu.addEventListener("menuShow",eventHandler);
            menu.addEventListener("itemClick",eventHandler);
            menu.addEventListener("change",eventHandler);
            menu.iconField = this.iconField;
            menu.labelField = this.labelField;
            menu.labelFunction = labelFunction;
            menu.dataDescriptor = _dataDescriptor;
            menu.invalidateSize();
            menus[index] = menu;
            menu.sourceMenuBarItem = item;
            Menu.popUpMenu(menu,null,mdp);
         }
         if(menu.maxHeight != this.maxHeight)
         {
            menu.maxHeight = this.maxHeight;
         }
         if(menu.verticalScrollPolicy != this.verticalScrollPolicy)
         {
            menu.verticalScrollPolicy = this.verticalScrollPolicy;
         }
         if(menu.arrowScrollPolicy != this.arrowScrollPolicy)
         {
            menu.arrowScrollPolicy = this.arrowScrollPolicy;
         }
         return super.getMenuAt(index);
      }
      
      public function get verticalScrollPolicy() : String
      {
         return this._verticalScrollPolicy;
      }
      
      public function get arrowScrollPolicy() : String
      {
         return this._arrowScrollPolicy;
      }
      
      public function set verticalScrollPolicy(value:String) : void
      {
         var newPolicy:String = null;
         newPolicy = value.toLowerCase();
         if(_verticalScrollPolicy != newPolicy)
         {
            _verticalScrollPolicy = newPolicy;
         }
         invalidateDisplayList();
      }
      
      public function set arrowScrollPolicy(value:String) : void
      {
         var newPolicy:String = null;
         newPolicy = value.toLowerCase();
         if(_arrowScrollPolicy != newPolicy)
         {
            _arrowScrollPolicy = newPolicy;
         }
         invalidateDisplayList();
      }
      
      private function eventHandler(event:Event) : void
      {
         var t:String = null;
         var openMenuIndex:Number = NaN;
         if(event is MenuEvent)
         {
            t = event.type;
            openMenuIndex = Number(this.selectedIndex);
            if(event.type == MenuEvent.MENU_HIDE && MenuEvent(event).menu == menus[openMenuIndex])
            {
               menuBarItems[openMenuIndex].menuBarItemState = "itemUpSkin";
               openMenuIndex = -1;
               dispatchEvent(event as MenuEvent);
            }
            else
            {
               dispatchEvent(event);
            }
         }
      }
   }
}

