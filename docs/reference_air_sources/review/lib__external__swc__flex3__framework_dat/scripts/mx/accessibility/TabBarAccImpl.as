package mx.accessibility
{
   import flash.accessibility.Accessibility;
   import flash.events.Event;
   import mx.controls.TabBar;
   import mx.controls.tabBarClasses.Tab;
   import mx.core.UIComponent;
   import mx.core.mx_internal;
   
   use namespace mx_internal;
   
   public class TabBarAccImpl extends AccImpl
   {
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      private static const ROLE_SYSTEM_PAGETAB:uint = 37;
      
      private static const STATE_SYSTEM_FOCUSABLE:uint = 1048576;
      
      private static const STATE_SYSTEM_FOCUSED:uint = 4;
      
      private static const STATE_SYSTEM_SELECTABLE:uint = 2097152;
      
      private static const STATE_SYSTEM_SELECTED:uint = 2;
      
      private static const EVENT_OBJECT_FOCUS:uint = 32773;
      
      private static const EVENT_OBJECT_SELECTION:uint = 32774;
      
      public function TabBarAccImpl(master:UIComponent)
      {
         super(master);
         role = 60;
      }
      
      public static function enableAccessibility() : void
      {
         TabBar.createAccessibilityImplementation = createAccessibilityImplementation;
      }
      
      mx_internal static function createAccessibilityImplementation(component:UIComponent) : void
      {
         component.accessibilityImplementation = new TabBarAccImpl(component);
      }
      
      override public function get_accFocus() : uint
      {
         var index:int = TabBar(master).focusedIndex;
         return index >= 0 ? uint(index + 1) : 0;
      }
      
      override protected function getName(childID:uint) : String
      {
         if(childID == 0)
         {
            return "";
         }
         var tabBar:TabBar = TabBar(master);
         var index:int = childID - 1;
         if(index > tabBar.numChildren || index < 0)
         {
            index = tabBar.numChildren - 1;
         }
         var item:Tab = Tab(tabBar.getChildAt(index));
         return item.label;
      }
      
      override public function accLocation(childID:uint) : *
      {
         return TabBar(master).getChildAt(childID - 1);
      }
      
      override protected function eventHandler(event:Event) : void
      {
         var index:int = 0;
         $eventHandler(event);
         switch(event.type)
         {
            case "focusDraw":
               index = TabBar(master).focusedIndex;
               if(index >= 0)
               {
                  Accessibility.sendEvent(master,index + 1,EVENT_OBJECT_FOCUS);
               }
               break;
            case "itemClick":
               index = TabBar(master).selectedIndex;
               if(index >= 0)
               {
                  Accessibility.sendEvent(master,index + 1,EVENT_OBJECT_SELECTION);
               }
         }
      }
      
      override public function getChildIDArray() : Array
      {
         var n:int = TabBar(master).numChildren;
         return createChildIDArray(n);
      }
      
      override public function get_accState(childID:uint) : uint
      {
         var index:int = 0;
         var accState:uint = getState(childID);
         var tabBar:TabBar = TabBar(master);
         if(childID > 0)
         {
            accState = uint(STATE_SYSTEM_SELECTABLE | STATE_SYSTEM_FOCUSABLE);
            index = childID - 1;
            if(index == tabBar.selectedIndex)
            {
               accState |= STATE_SYSTEM_SELECTED;
            }
            if(index == tabBar.focusedIndex)
            {
               accState |= STATE_SYSTEM_FOCUSED;
            }
         }
         return accState;
      }
      
      override public function accDoDefaultAction(childID:uint) : void
      {
         if(childID > 0)
         {
            TabBar(master).selectButton(childID - 1,true);
         }
      }
      
      override protected function get eventsToHandle() : Array
      {
         return super.eventsToHandle.concat(["itemClick","focusDraw"]);
      }
      
      override public function get_accRole(childID:uint) : uint
      {
         return childID == 0 ? role : ROLE_SYSTEM_PAGETAB;
      }
      
      override public function get_accDefaultAction(childID:uint) : String
      {
         return "Switch";
      }
   }
}

