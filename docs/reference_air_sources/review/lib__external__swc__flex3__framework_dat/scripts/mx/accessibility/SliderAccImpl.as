package mx.accessibility
{
   import flash.accessibility.Accessibility;
   import flash.events.Event;
   import flash.events.FocusEvent;
   import mx.controls.sliderClasses.Slider;
   import mx.core.UIComponent;
   import mx.core.mx_internal;
   import mx.events.SliderEvent;
   
   use namespace mx_internal;
   
   public class SliderAccImpl extends AccImpl
   {
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      private static const STATE_SYSTEM_NORMAL:uint = 0;
      
      private static const STATE_SYSTEM_FOCUSABLE:uint = 1048576;
      
      private static const STATE_SYSTEM_FOCUSED:uint = 4;
      
      private static const STATE_SYSTEM_SELECTABLE:uint = 2097152;
      
      private static const STATE_SYSTEM_SELECTED:uint = 2;
      
      private static const STATE_SYSTEM_UNAVAILABLE:uint = 1;
      
      private static const EVENT_OBJECT_FOCUS:uint = 32773;
      
      private static const EVENT_OBJECT_VALUECHANGE:uint = 32782;
      
      private static const EVENT_OBJECT_SELECTION:uint = 32774;
      
      private static const ROLE_SLIDER:uint = 51;
      
      public function SliderAccImpl(master:UIComponent)
      {
         super(master);
         role = 51;
         master.addEventListener(FocusEvent.FOCUS_IN,focusInHandler);
      }
      
      public static function enableAccessibility() : void
      {
         Slider.createAccessibilityImplementation = createAccessibilityImplementation;
      }
      
      mx_internal static function createAccessibilityImplementation(component:UIComponent) : void
      {
         component.accessibilityImplementation = new SliderAccImpl(component);
      }
      
      override public function get_accState(childID:uint) : uint
      {
         var accState:uint = getState(childID);
         accState |= STATE_SYSTEM_SELECTABLE;
         if(childID == 0)
         {
            accState |= STATE_SYSTEM_SELECTED;
         }
         else
         {
            accState |= STATE_SYSTEM_SELECTED | STATE_SYSTEM_FOCUSED;
         }
         return accState;
      }
      
      override protected function getName(childID:uint) : String
      {
         return "";
      }
      
      override protected function eventHandler(event:Event) : void
      {
         var childID:uint = 0;
         $eventHandler(event);
         switch(event.type)
         {
            case "change":
               childID = SliderEvent(event).thumbIndex + 1;
               Accessibility.sendEvent(master,0,EVENT_OBJECT_SELECTION);
               Accessibility.sendEvent(master,0,EVENT_OBJECT_VALUECHANGE,true);
         }
      }
      
      override public function getChildIDArray() : Array
      {
         var n:int = Slider(master).thumbCount;
         return createChildIDArray(n);
      }
      
      override public function get_accValue(childID:uint) : String
      {
         var val:Number = Number(Slider(master).values[Math.max(childID - 1,0)]);
         val = (val - Slider(master).minimum) / (Slider(master).maximum - Slider(master).minimum) * 100;
         return String(val) + " percent";
      }
      
      override protected function getState(childID:uint) : uint
      {
         var i:uint = 0;
         var accState:uint = STATE_SYSTEM_NORMAL;
         if(!UIComponent(master).enabled)
         {
            accState |= STATE_SYSTEM_UNAVAILABLE;
         }
         else
         {
            accState |= STATE_SYSTEM_FOCUSABLE;
            for(i = 0; i < Slider(master).thumbCount; i++)
            {
               if(Slider(master).getThumbAt(i) == Slider(master).focusManager.getFocus())
               {
                  accState |= STATE_SYSTEM_FOCUSED;
                  break;
               }
            }
         }
         return accState;
      }
      
      override protected function get eventsToHandle() : Array
      {
         return super.eventsToHandle.concat(["change"]);
      }
      
      private function focusInHandler(event:Event) : void
      {
         Accessibility.sendEvent(master,0,EVENT_OBJECT_FOCUS);
      }
      
      override public function get_accRole(childID:uint) : uint
      {
         return role;
      }
   }
}

