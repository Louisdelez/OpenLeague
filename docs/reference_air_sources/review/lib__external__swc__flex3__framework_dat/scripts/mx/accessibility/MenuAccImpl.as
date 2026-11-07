package mx.accessibility
{
   import flash.accessibility.Accessibility;
   import flash.events.Event;
   import mx.controls.Menu;
   import mx.core.UIComponent;
   import mx.core.mx_internal;
   import mx.events.MenuEvent;
   
   use namespace mx_internal;
   
   public class MenuAccImpl extends ListBaseAccImpl
   {
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      private static const ROLE_SYSTEM_MENUITEM:uint = 12;
      
      private static const STATE_SYSTEM_CHECKED:uint = 16;
      
      private static const STATE_SYSTEM_FOCUSED:uint = 4;
      
      private static const STATE_SYSTEM_HASPOPUP:uint = 1073741824;
      
      private static const STATE_SYSTEM_HOTTRACKED:uint = 128;
      
      private static const STATE_SYSTEM_UNAVAILABLE:uint = 1;
      
      private static const EVENT_OBJECT_FOCUS:uint = 32773;
      
      private static const EVENT_OBJECT_SELECTION:uint = 32774;
      
      private static const EVENT_SYSTEM_MENUPOPUPSTART:uint = 6;
      
      private static const EVENT_SYSTEM_MENUPOPUPEND:uint = 7;
      
      public function MenuAccImpl(master:UIComponent)
      {
         super(master);
         role = 11;
      }
      
      mx_internal static function createAccessibilityImplementation(component:UIComponent) : void
      {
         component.accessibilityImplementation = new MenuAccImpl(component);
      }
      
      public static function enableAccessibility() : void
      {
         Menu.createAccessibilityImplementation = createAccessibilityImplementation;
      }
      
      override protected function eventHandler(event:Event) : void
      {
         var childID:uint = 0;
         $eventHandler(event);
         var index:int = 0;
         switch(event.type)
         {
            case MenuEvent.ITEM_ROLL_OVER:
               index = MenuEvent(event).index;
               if(index >= 0)
               {
                  childID = index + 1;
                  Accessibility.sendEvent(MenuEvent(event).menu,childID,EVENT_OBJECT_FOCUS);
                  Accessibility.sendEvent(MenuEvent(event).menu,childID,EVENT_OBJECT_SELECTION);
               }
               break;
            case MenuEvent.ITEM_CLICK:
               index = MenuEvent(event).menu.selectedIndex;
               if(index >= 0)
               {
                  childID = index + 1;
                  Accessibility.sendEvent(MenuEvent(event).menu,childID,EVENT_OBJECT_FOCUS);
                  Accessibility.sendEvent(MenuEvent(event).menu,childID,EVENT_OBJECT_SELECTION);
               }
               break;
            case MenuEvent.MENU_SHOW:
               Accessibility.sendEvent(MenuEvent(event).menu,0,EVENT_SYSTEM_MENUPOPUPSTART);
               break;
            case MenuEvent.MENU_HIDE:
               Accessibility.sendEvent(MenuEvent(event).menu,0,EVENT_SYSTEM_MENUPOPUPEND);
         }
      }
      
      override protected function getName(childID:uint) : String
      {
         if(childID == 0)
         {
            return "";
         }
         var menu:Menu = Menu(master);
         var item:Object = menu.dataProvider[childID - 1];
         return menu.itemToLabel(item);
      }
      
      override public function get_accState(childID:uint) : uint
      {
         var item:Object = null;
         var accState:uint = getState(childID);
         if(childID > 0 && childID < 100000)
         {
            item = Menu(master).dataProvider[childID - 1];
            if(!Menu(master).dataDescriptor.isEnabled(item))
            {
               return uint(accState | STATE_SYSTEM_UNAVAILABLE);
            }
            accState |= STATE_SYSTEM_HOTTRACKED | STATE_SYSTEM_FOCUSED;
            if(Menu(master).dataDescriptor.isToggled(item))
            {
               accState |= STATE_SYSTEM_CHECKED;
            }
            if(Menu(master).dataDescriptor.isBranch(item))
            {
               accState |= STATE_SYSTEM_HASPOPUP;
            }
         }
         return accState;
      }
      
      override protected function get eventsToHandle() : Array
      {
         return super.eventsToHandle.concat(["itemRollOver","menuShow","menuHide"]);
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
         var item:Object = Menu(master).dataProvider[childID - 1];
         return Menu(master).dataDescriptor.isBranch(item) ? "Open" : "Execute";
      }
   }
}

