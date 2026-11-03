package mx.accessibility
{
   import flash.accessibility.Accessibility;
   import flash.events.Event;
   import mx.controls.ComboBase;
   import mx.core.UIComponent;
   import mx.core.mx_internal;
   
   use namespace mx_internal;
   
   public class ComboBaseAccImpl extends AccImpl
   {
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      private static const ROLE_SYSTEM_LISTITEM:uint = 34;
      
      private static const STATE_SYSTEM_FOCUSED:uint = 4;
      
      private static const STATE_SYSTEM_SELECTABLE:uint = 2097152;
      
      private static const STATE_SYSTEM_SELECTED:uint = 2;
      
      private static const EVENT_OBJECT_VALUECHANGE:uint = 32782;
      
      private static const EVENT_OBJECT_SELECTION:uint = 32774;
      
      public function ComboBaseAccImpl(master:UIComponent)
      {
         super(master);
         role = 46;
      }
      
      mx_internal static function createAccessibilityImplementation(component:UIComponent) : void
      {
         component.accessibilityImplementation = new ComboBaseAccImpl(component);
      }
      
      public static function enableAccessibility() : void
      {
         ComboBase.createAccessibilityImplementation = createAccessibilityImplementation;
      }
      
      override public function get_accValue(childID:uint) : String
      {
         if(childID == 0)
         {
            return ComboBase(master).text;
         }
         return null;
      }
      
      override protected function eventHandler(event:Event) : void
      {
         var index:int = 0;
         var childID:uint = 0;
         $eventHandler(event);
         switch(event.type)
         {
            case "change":
               index = ComboBase(master).selectedIndex;
               if(index >= 0)
               {
                  childID = index + 1;
                  Accessibility.sendEvent(master,childID,EVENT_OBJECT_SELECTION);
                  Accessibility.sendEvent(master,0,EVENT_OBJECT_VALUECHANGE);
               }
               break;
            case "valueCommit":
               Accessibility.sendEvent(master,0,EVENT_OBJECT_VALUECHANGE);
         }
      }
      
      override public function getChildIDArray() : Array
      {
         var n:int = Boolean(ComboBase(master).dataProvider) ? int(ComboBase(master).dataProvider.length) : 0;
         return createChildIDArray(n);
      }
      
      override public function get_accState(childID:uint) : uint
      {
         var accState:uint = getState(childID);
         if(childID > 0)
         {
            accState |= STATE_SYSTEM_SELECTABLE;
            if(ComboBase(master).selectedIndex == childID - 1)
            {
               accState |= STATE_SYSTEM_SELECTED | STATE_SYSTEM_FOCUSED;
            }
         }
         return accState;
      }
      
      override protected function get eventsToHandle() : Array
      {
         return super.eventsToHandle.concat(["change","valueCommit"]);
      }
      
      override public function get_accRole(childID:uint) : uint
      {
         return childID == 0 ? role : ROLE_SYSTEM_LISTITEM;
      }
   }
}

