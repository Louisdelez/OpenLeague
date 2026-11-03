package mx.accessibility
{
   import flash.accessibility.Accessibility;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.ui.Keyboard;
   import mx.controls.Button;
   import mx.core.UIComponent;
   
   public class ButtonAccImpl extends AccImpl
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      public function ButtonAccImpl(master:UIComponent)
      {
         super(master);
         role = AccConst.ROLE_SYSTEM_PUSHBUTTON;
      }
      
      public static function enableAccessibility() : void
      {
         Button.createAccessibilityImplementation = createAccessibilityImplementation;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static function createAccessibilityImplementation(component:UIComponent) : void
      {
         component.accessibilityImplementation = new ButtonAccImpl(component);
      }
      
      override protected function get eventsToHandle() : Array
      {
         return super.eventsToHandle.concat(["click","labelChanged"]);
      }
      
      override public function get_accState(childID:uint) : uint
      {
         var accState:uint = uint(getState(childID));
         if(Button(master).selected)
         {
            accState |= AccConst.STATE_SYSTEM_PRESSED;
         }
         return accState;
      }
      
      override public function get_accDefaultAction(childID:uint) : String
      {
         return "Press";
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
      
      override protected function getName(childID:uint) : String
      {
         var label:String = Button(master).label;
         return label != null && label != "" ? label : "";
      }
      
      override protected function eventHandler(event:Event) : void
      {
         $eventHandler(event);
         switch(event.type)
         {
            case "click":
               Accessibility.sendEvent(master,0,AccConst.EVENT_OBJECT_STATECHANGE);
               Accessibility.updateProperties();
               break;
            case "labelChanged":
               Accessibility.sendEvent(master,0,AccConst.EVENT_OBJECT_NAMECHANGE);
               Accessibility.updateProperties();
         }
      }
   }
}

