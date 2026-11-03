package spark.accessibility
{
   import flash.accessibility.Accessibility;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.ui.Keyboard;
   import mx.accessibility.AccConst;
   import mx.accessibility.AccImpl;
   import mx.core.UIComponent;
   import spark.components.supportClasses.ButtonBase;
   
   public class ButtonBaseAccImpl extends AccImpl
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      public function ButtonBaseAccImpl(master:UIComponent)
      {
         super(master);
         role = AccConst.ROLE_SYSTEM_PUSHBUTTON;
      }
      
      public static function enableAccessibility() : void
      {
         ButtonBase.createAccessibilityImplementation = createAccessibilityImplementation;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static function createAccessibilityImplementation(component:UIComponent) : void
      {
         component.accessibilityImplementation = new ButtonBaseAccImpl(component);
      }
      
      override protected function get eventsToHandle() : Array
      {
         return super.eventsToHandle.concat(["click","labelChanged"]);
      }
      
      override public function get_accState(childID:uint) : uint
      {
         return uint(getState(childID));
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
         var label:String = ButtonBase(master).label;
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

