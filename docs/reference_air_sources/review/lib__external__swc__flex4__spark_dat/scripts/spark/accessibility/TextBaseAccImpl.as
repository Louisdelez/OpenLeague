package spark.accessibility
{
   import flash.accessibility.Accessibility;
   import flash.events.Event;
   import mx.accessibility.AccConst;
   import mx.accessibility.AccImpl;
   import mx.core.UIComponent;
   import spark.components.supportClasses.TextBase;
   
   public class TextBaseAccImpl extends AccImpl
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      public function TextBaseAccImpl(master:UIComponent)
      {
         super(master);
         role = AccConst.ROLE_SYSTEM_STATICTEXT;
      }
      
      public static function enableAccessibility() : void
      {
         TextBase.createAccessibilityImplementation = createAccessibilityImplementation;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static function createAccessibilityImplementation(component:UIComponent) : void
      {
         component.accessibilityImplementation = new TextBaseAccImpl(component);
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
         var label:String = TextBase(master).text;
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

