package mx.accessibility
{
   import flash.accessibility.Accessibility;
   import flash.events.Event;
   import mx.controls.Menu;
   import mx.core.UIComponent;
   import mx.events.MenuEvent;
   
   public class MenuAccImpl extends ListBaseAccImpl
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      public function MenuAccImpl(master:UIComponent)
      {
         super(master);
         role = AccConst.ROLE_SYSTEM_MENUPOPUP;
      }
      
      public static function enableAccessibility() : void
      {
         Menu.createAccessibilityImplementation = createAccessibilityImplementation;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static function createAccessibilityImplementation(component:UIComponent) : void
      {
         component.accessibilityImplementation = new MenuAccImpl(component);
      }
      
      override protected function get eventsToHandle() : Array
      {
         return super.eventsToHandle.concat(["itemRollOver","menuShow","menuHide"]);
      }
      
      override public function get_accRole(childID:uint) : uint
      {
         return childID == 0 ? uint(role) : uint(AccConst.ROLE_SYSTEM_MENUITEM);
      }
      
      override public function get_accState(childID:uint) : uint
      {
         var item:Object = null;
         var accState:uint = uint(getState(childID));
         if(childID > 0 && childID < 100000)
         {
            item = Menu(master).dataProvider[childID - 1];
            if(!Menu(master).dataDescriptor.isEnabled(item))
            {
               return uint(accState | AccConst.STATE_SYSTEM_UNAVAILABLE);
            }
            accState |= AccConst.STATE_SYSTEM_HOTTRACKED | AccConst.STATE_SYSTEM_FOCUSED;
            if(Menu(master).dataDescriptor.isToggled(item))
            {
               accState |= AccConst.STATE_SYSTEM_CHECKED;
            }
            if(Menu(master).dataDescriptor.isBranch(item))
            {
               accState |= AccConst.STATE_SYSTEM_HASPOPUP;
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
         var item:Object = Menu(master).dataProvider[childID - 1];
         return Menu(master).dataDescriptor.isBranch(item) ? "Open" : "Execute";
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
                  Accessibility.sendEvent(MenuEvent(event).menu,childID,AccConst.EVENT_OBJECT_FOCUS);
                  Accessibility.sendEvent(MenuEvent(event).menu,childID,AccConst.EVENT_OBJECT_SELECTION);
               }
               break;
            case MenuEvent.ITEM_CLICK:
               index = MenuEvent(event).menu.selectedIndex;
               if(index >= 0)
               {
                  childID = index + 1;
                  Accessibility.sendEvent(MenuEvent(event).menu,childID,AccConst.EVENT_OBJECT_FOCUS);
                  Accessibility.sendEvent(MenuEvent(event).menu,childID,AccConst.EVENT_OBJECT_SELECTION);
               }
               break;
            case MenuEvent.MENU_SHOW:
               Accessibility.sendEvent(MenuEvent(event).menu,0,AccConst.EVENT_SYSTEM_MENUPOPUPSTART);
               break;
            case MenuEvent.MENU_HIDE:
               Accessibility.sendEvent(MenuEvent(event).menu,0,AccConst.EVENT_SYSTEM_MENUPOPUPEND);
         }
      }
   }
}

