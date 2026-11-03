package spark.accessibility
{
   import flash.accessibility.Accessibility;
   import flash.events.Event;
   import flash.events.FocusEvent;
   import mx.accessibility.AccConst;
   import mx.core.UIComponent;
   import spark.components.NumericStepper;
   import spark.components.TextInput;
   import spark.events.SkinPartEvent;
   
   public class NumericStepperAccImpl extends SpinnerAccImpl
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      public function NumericStepperAccImpl(master:UIComponent)
      {
         super(master);
         role = AccConst.ROLE_SYSTEM_TEXT;
         var textDisplay:TextInput = NumericStepper(master).textDisplay;
         if(Boolean(textDisplay))
         {
            textDisplay.addEventListener(Event.CHANGE,this.eventHandler);
            textDisplay.addEventListener(FocusEvent.FOCUS_IN,this.focusInHandler);
         }
      }
      
      public static function enableAccessibility() : void
      {
         NumericStepper.createAccessibilityImplementation = createAccessibilityImplementation;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static function createAccessibilityImplementation(component:UIComponent) : void
      {
         component.accessibilityImplementation = new NumericStepperAccImpl(component);
      }
      
      override protected function get eventsToHandle() : Array
      {
         return super.eventsToHandle.concat([SkinPartEvent.PART_ADDED,SkinPartEvent.PART_REMOVED]);
      }
      
      override protected function eventHandler(event:Event) : void
      {
         var textDisplay:TextInput = null;
         switch(event.type)
         {
            case SkinPartEvent.PART_ADDED:
               textDisplay = NumericStepper(master).textDisplay;
               if(SkinPartEvent(event).instance == textDisplay)
               {
                  textDisplay.addEventListener(Event.CHANGE,this.eventHandler);
                  textDisplay.addEventListener(FocusEvent.FOCUS_IN,this.focusInHandler);
               }
               break;
            case SkinPartEvent.PART_REMOVED:
               textDisplay = NumericStepper(master).textDisplay;
               if(SkinPartEvent(event).instance == textDisplay)
               {
                  textDisplay.removeEventListener(Event.CHANGE,this.eventHandler);
                  textDisplay.removeEventListener(FocusEvent.FOCUS_IN,this.focusInHandler);
               }
               break;
            default:
               super.eventHandler(event);
         }
      }
      
      private function focusInHandler(event:Event) : void
      {
         Accessibility.sendEvent(master,0,AccConst.EVENT_OBJECT_FOCUS);
      }
   }
}

