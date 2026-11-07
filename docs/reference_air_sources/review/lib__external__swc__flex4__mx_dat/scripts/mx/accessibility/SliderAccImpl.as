package mx.accessibility
{
   import flash.accessibility.Accessibility;
   import flash.events.Event;
   import flash.events.FocusEvent;
   import mx.controls.sliderClasses.Slider;
   import mx.core.UIComponent;
   import mx.events.SliderEvent;
   
   public class SliderAccImpl extends AccImpl
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      public function SliderAccImpl(master:UIComponent)
      {
         super(master);
         role = AccConst.ROLE_SYSTEM_SLIDER;
         master.addEventListener(FocusEvent.FOCUS_IN,this.focusInHandler);
      }
      
      public static function enableAccessibility() : void
      {
         Slider.createAccessibilityImplementation = createAccessibilityImplementation;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static function createAccessibilityImplementation(component:UIComponent) : void
      {
         component.accessibilityImplementation = new SliderAccImpl(component);
      }
      
      override protected function get eventsToHandle() : Array
      {
         return super.eventsToHandle.concat(["change"]);
      }
      
      override public function get_accRole(childID:uint) : uint
      {
         return role;
      }
      
      override public function get_accValue(childID:uint) : String
      {
         var val:Number = Number(Slider(master).values[Math.max(childID - 1,0)]);
         val = (val - Slider(master).minimum) / (Slider(master).maximum - Slider(master).minimum) * 100;
         return String(val) + " percent";
      }
      
      override public function getChildIDArray() : Array
      {
         var n:int = Slider(master).thumbCount;
         return createChildIDArray(n);
      }
      
      override protected function getName(childID:uint) : String
      {
         return "";
      }
      
      override public function get_accState(childID:uint) : uint
      {
         var accState:uint = this.getState(childID);
         accState |= AccConst.STATE_SYSTEM_SELECTABLE;
         if(childID == 0)
         {
            accState |= AccConst.STATE_SYSTEM_SELECTED;
         }
         else
         {
            accState |= AccConst.STATE_SYSTEM_SELECTED | AccConst.STATE_SYSTEM_FOCUSED;
         }
         return accState;
      }
      
      override protected function getState(childID:uint) : uint
      {
         var i:uint = 0;
         var accState:uint = uint(AccConst.STATE_SYSTEM_NORMAL);
         if(!UIComponent(master).enabled)
         {
            accState |= AccConst.STATE_SYSTEM_UNAVAILABLE;
         }
         else
         {
            accState |= AccConst.STATE_SYSTEM_FOCUSABLE;
            for(i = 0; i < Slider(master).thumbCount; i++)
            {
               if(Slider(master).getThumbAt(i) == Slider(master).focusManager.getFocus())
               {
                  accState |= AccConst.STATE_SYSTEM_FOCUSED;
                  break;
               }
            }
         }
         return accState;
      }
      
      override protected function eventHandler(event:Event) : void
      {
         var childID:uint = 0;
         $eventHandler(event);
         switch(event.type)
         {
            case "change":
               childID = SliderEvent(event).thumbIndex + 1;
               Accessibility.sendEvent(master,0,AccConst.EVENT_OBJECT_SELECTION);
               Accessibility.sendEvent(master,0,AccConst.EVENT_OBJECT_VALUECHANGE,true);
         }
      }
      
      private function focusInHandler(event:Event) : void
      {
         Accessibility.sendEvent(master,0,AccConst.EVENT_OBJECT_FOCUS);
      }
   }
}

