package mx.accessibility
{
   import flash.accessibility.Accessibility;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.ui.Keyboard;
   import mx.controls.Button;
   import mx.core.UIComponent;
   import mx.core.mx_internal;
   
   use namespace mx_internal;
   
   public class ButtonAccImpl extends AccImpl
   {
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      private static const STATE_SYSTEM_PRESSED:uint = 8;
      
      private static const EVENT_OBJECT_NAMECHANGE:uint = 32780;
      
      private static const EVENT_OBJECT_STATECHANGE:uint = 32778;
      
      public function ButtonAccImpl(master:UIComponent)
      {
         super(master);
         role = 43;
      }
      
      mx_internal static function createAccessibilityImplementation(component:UIComponent) : void
      {
         component.accessibilityImplementation = new ButtonAccImpl(component);
      }
      
      public static function enableAccessibility() : void
      {
         Button.createAccessibilityImplementation = createAccessibilityImplementation;
      }
      
      override protected function eventHandler(event:Event) : void
      {
         $eventHandler(event);
         switch(event.type)
         {
            case "click":
               Accessibility.sendEvent(master,0,EVENT_OBJECT_STATECHANGE);
               Accessibility.updateProperties();
               break;
            case "labelChanged":
               Accessibility.sendEvent(master,0,EVENT_OBJECT_NAMECHANGE);
               Accessibility.updateProperties();
         }
      }
      
      override protected function getName(childID:uint) : String
      {
         var label:String = Button(master).label;
         return label != null && label != "" ? label : "";
      }
      
      override public function get_accState(childID:uint) : uint
      {
         var accState:uint = getState(childID);
         if(Button(master).selected)
         {
            accState |= STATE_SYSTEM_PRESSED;
         }
         return accState;
      }
      
      override public function accDoDefaultAction(childID:uint) : void
      {
         var event:KeyboardEvent = null;
         if(master.enabled)
         {
            event = new KeyboardEvent(KeyboardEvent.KEY_DOWN);
            event.keyCode = Keyboard.SPACE;
            master.dispatchEvent(event);
            event = new KeyboardEvent(KeyboardEvent.KEY_UP);
            event.keyCode = Keyboard.SPACE;
            master.dispatchEvent(event);
         }
      }
      
      override protected function get eventsToHandle() : Array
      {
         return super.eventsToHandle.concat(["click","labelChanged"]);
      }
      
      override public function get_accDefaultAction(childID:uint) : String
      {
         return "Press";
      }
   }
}

