package mx.accessibility
{
   import flash.accessibility.Accessibility;
   import flash.events.Event;
   import mx.controls.Label;
   import mx.core.UIComponent;
   
   public class LabelAccImpl extends AccImpl
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      public function LabelAccImpl(master:UIComponent)
      {
         super(master);
         role = AccConst.ROLE_SYSTEM_STATICTEXT;
      }
      
      public static function enableAccessibility() : void
      {
         Label.createAccessibilityImplementation = createAccessibilityImplementation;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static function createAccessibilityImplementation(component:UIComponent) : void
      {
         component.accessibilityImplementation = new LabelAccImpl(component);
      }
      
      override protected function get eventsToHandle() : Array
      {
         return super.eventsToHandle.concat(["updateComplete"]);
      }
      
      override public function get_accState(childID:uint) : uint
      {
         var accState:uint = uint(getState(childID));
         accState &= ~AccConst.STATE_SYSTEM_FOCUSABLE;
         return uint(accState | AccConst.STATE_SYSTEM_READONLY);
      }
      
      override protected function getName(childID:uint) : String
      {
         var label:String = Label(master).text;
         return label != null && label != "" ? label : "";
      }
      
      override protected function eventHandler(event:Event) : void
      {
         $eventHandler(event);
         switch(event.type)
         {
            case "updateComplete":
               Accessibility.sendEvent(master,0,AccConst.EVENT_OBJECT_NAMECHANGE);
               Accessibility.updateProperties();
         }
      }
   }
}

