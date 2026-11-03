package mx.accessibility
{
   import flash.accessibility.Accessibility;
   import flash.events.Event;
   import mx.controls.MenuBar;
   import mx.core.UIComponent;
   import mx.core.mx_internal;
   import mx.events.MenuEvent;
   
   use namespace mx_internal;
   
   public class MenuBarAccImpl extends AccImpl
   {
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      private static const ROLE_SYSTEM_MENUITEM:uint = 12;
      
      private static const STATE_SYSTEM_FOCUSABLE:uint = 1048576;
      
      private static const STATE_SYSTEM_FOCUSED:uint = 4;
      
      private static const STATE_SYSTEM_HASPOPUP:uint = 1073741824;
      
      private static const STATE_SYSTEM_HOTTRACKED:uint = 128;
      
      private static const STATE_SYSTEM_SELECTABLE:uint = 2097152;
      
      private static const STATE_SYSTEM_UNAVAILABLE:uint = 1;
      
      private static const EVENT_OBJECT_FOCUS:uint = 32773;
      
      private static const EVENT_SYSTEM_MENUEND:uint = 5;
      
      private static const EVENT_SYSTEM_MENUSTART:uint = 4;
      
      private static const EVENT_OBJECT_SELECTION:uint = 32774;
      
      public function MenuBarAccImpl(master:UIComponent)
      {
         super(master);
         role = 2;
      }
      
      mx_internal static function createAccessibilityImplementation(component:UIComponent) : void
      {
         component.accessibilityImplementation = new MenuBarAccImpl(component);
      }
      
      public static function enableAccessibility() : void
      {
         MenuBar.createAccessibilityImplementation = createAccessibilityImplementation;
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
      
      override public function accLocation(childID:uint) : *
      {
         return MenuBar(master).menuBarItems[childID - 1];
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
                  Accessibility.sendEvent(master,childID,EVENT_OBJECT_FOCUS);
                  Accessibility.sendEvent(master,childID,EVENT_OBJECT_SELECTION);
               }
               break;
            case "menuHide":
               if(!MenuEvent(event).menu.parentMenu)
               {
                  Accessibility.sendEvent(master,0,EVENT_SYSTEM_MENUEND);
               }
               break;
            case "focusIn":
               Accessibility.sendEvent(master,0,EVENT_SYSTEM_MENUSTART);
               break;
            case "focusOut":
               if(MenuBar(master).selectedIndex == -1)
               {
                  Accessibility.sendEvent(master,0,EVENT_SYSTEM_MENUEND);
               }
         }
      }
      
      override public function getChildIDArray() : Array
      {
         var n:int = Boolean(MenuBar(master).menuBarItems) ? int(MenuBar(master).menuBarItems.length) : 0;
         return createChildIDArray(n);
      }
      
      override public function get_accState(childID:uint) : uint
      {
         var menuBar:MenuBar = null;
         var index:int = 0;
         var accState:uint = getState(childID);
         if(childID > 0)
         {
            menuBar = MenuBar(master);
            index = childID - 1;
            if(!menuBar.menuBarItems[index] || !menuBar.menuBarItems[index].enabled)
            {
               accState |= STATE_SYSTEM_UNAVAILABLE;
            }
            else
            {
               accState |= STATE_SYSTEM_SELECTABLE | STATE_SYSTEM_FOCUSABLE;
               accState |= STATE_SYSTEM_HASPOPUP;
               if(index == menuBar.selectedIndex)
               {
                  accState |= STATE_SYSTEM_HOTTRACKED | STATE_SYSTEM_FOCUSED;
               }
            }
         }
         return accState;
      }
      
      override public function accDoDefaultAction(childID:uint) : void
      {
         var index:int = 0;
         if(childID > 0)
         {
            index = childID - 1;
         }
      }
      
      override protected function get eventsToHandle() : Array
      {
         return super.eventsToHandle.concat(["menuShow","menuHide","focusIn","focusOut"]);
      }
      
      override public function get_accRole(childID:uint) : uint
      {
         return childID == 0 ? role : ROLE_SYSTEM_MENUITEM;
      }
      
      override public function get_accDefaultAction(childID:uint) : String
      {
         if(childID == 0)
         {
            return null;
         }
         return childID - 1 == MenuBar(master).selectedIndex ? "Close" : "Open";
      }
   }
}

