package mx.accessibility
{
   import flash.accessibility.Accessibility;
   import flash.events.Event;
   import mx.controls.MenuBar;
   import mx.core.UIComponent;
   import mx.events.MenuEvent;
   
   public class MenuBarAccImpl extends AccImpl
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      public function MenuBarAccImpl(master:UIComponent)
      {
         super(master);
         role = AccConst.ROLE_SYSTEM_MENUBAR;
      }
      
      public static function enableAccessibility() : void
      {
         MenuBar.createAccessibilityImplementation = createAccessibilityImplementation;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static function createAccessibilityImplementation(component:UIComponent) : void
      {
         component.accessibilityImplementation = new MenuBarAccImpl(component);
      }
      
      override protected function get eventsToHandle() : Array
      {
         return super.eventsToHandle.concat(["menuShow","menuHide","focusIn","focusOut"]);
      }
      
      override public function get_accRole(childID:uint) : uint
      {
         return childID == 0 ? uint(role) : uint(AccConst.ROLE_SYSTEM_MENUITEM);
      }
      
      override public function get_accState(childID:uint) : uint
      {
         var menuBar:MenuBar = null;
         var index:int = 0;
         var accState:uint = uint(getState(childID));
         if(childID > 0)
         {
            menuBar = MenuBar(master);
            index = childID - 1;
            if(!menuBar.menuBarItems[index] || !menuBar.menuBarItems[index].enabled)
            {
               accState |= AccConst.STATE_SYSTEM_UNAVAILABLE;
            }
            else
            {
               accState |= AccConst.STATE_SYSTEM_SELECTABLE | AccConst.STATE_SYSTEM_FOCUSABLE;
               accState |= AccConst.STATE_SYSTEM_HASPOPUP;
               if(index == menuBar.selectedIndex)
               {
                  accState |= AccConst.STATE_SYSTEM_HOTTRACKED | AccConst.STATE_SYSTEM_FOCUSED;
               }
            }
         }
         return accState;
      }
      
      override public function get_accDefaultAction(childID:uint) : String
      {
         if(childID == 0)
         {
            return null;
         }
         return childID - 1 == MenuBar(master).selectedIndex ? "Close" : "Open";
      }
      
      override public function accDoDefaultAction(childID:uint) : void
      {
         var index:int = 0;
         if(childID > 0)
         {
            index = childID - 1;
         }
      }
      
      override public function getChildIDArray() : Array
      {
         var n:int = Boolean(MenuBar(master).menuBarItems) ? int(MenuBar(master).menuBarItems.length) : 0;
         return createChildIDArray(n);
      }
      
      override public function accLocation(childID:uint) : *
      {
         return MenuBar(master).menuBarItems[childID - 1];
      }
      
      override public function get_accFocus() : uint
      {
         var index:int = MenuBar(master).selectedIndex;
         return index >= 0 ? uint(index + 1) : 0;
      }
      
      override protected function getName(childID:uint) : String
      {
         if(childID == 0)
         {
            return "";
         }
         var menuBar:MenuBar = MenuBar(master);
         var index:int = childID - 1;
         if(Boolean(menuBar.menuBarItems) && menuBar.menuBarItems.length > index)
         {
            if(Boolean(menuBar.menuBarItems[index]) && Boolean(menuBar.menuBarItems[index].data))
            {
               return menuBar.itemToLabel(menuBar.menuBarItems[index].data);
            }
         }
         return "";
      }
      
      override protected function eventHandler(event:Event) : void
      {
         var index:int = 0;
         var childID:uint = 0;
         $eventHandler(event);
         switch(event.type)
         {
            case "menuShow":
               index = MenuBar(master).selectedIndex;
               if(index >= 0 && !MenuEvent(event).menu.parentMenu)
               {
                  childID = index + 1;
                  Accessibility.sendEvent(master,childID,AccConst.EVENT_OBJECT_FOCUS);
                  Accessibility.sendEvent(master,childID,AccConst.EVENT_OBJECT_SELECTION);
               }
               break;
            case "menuHide":
               if(!MenuEvent(event).menu.parentMenu)
               {
                  Accessibility.sendEvent(master,0,AccConst.EVENT_SYSTEM_MENUEND);
               }
               break;
            case "focusIn":
               Accessibility.sendEvent(master,0,AccConst.EVENT_SYSTEM_MENUSTART);
               break;
            case "focusOut":
               if(MenuBar(master).selectedIndex == -1)
               {
                  Accessibility.sendEvent(master,0,AccConst.EVENT_SYSTEM_MENUEND);
               }
         }
      }
   }
}

