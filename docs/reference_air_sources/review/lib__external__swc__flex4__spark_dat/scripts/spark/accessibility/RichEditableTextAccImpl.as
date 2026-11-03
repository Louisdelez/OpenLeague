package spark.accessibility
{
   import flash.accessibility.Accessibility;
   import flash.events.Event;
   import mx.accessibility.AccConst;
   import mx.accessibility.AccImpl;
   import mx.core.UIComponent;
   import spark.components.RichEditableText;
   
   public class RichEditableTextAccImpl extends AccImpl
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      public function RichEditableTextAccImpl(master:UIComponent)
      {
         super(master);
         role = AccConst.ROLE_SYSTEM_TEXT;
      }
      
      public static function enableAccessibility() : void
      {
         RichEditableText.createAccessibilityImplementation = createAccessibilityImplementation;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static function createAccessibilityImplementation(component:UIComponent) : void
      {
         component.accessibilityImplementation = new RichEditableTextAccImpl(component);
      }
      
      override protected function get eventsToHandle() : Array
      {
         return super.eventsToHandle.concat([Event.CHANGE]);
      }
      
      public function get selectionActiveIndex() : int
      {
         return RichEditableText(master).selectionActivePosition;
      }
      
      public function get selectionAnchorIndex() : int
      {
         return RichEditableText(master).selectionAnchorPosition;
      }
      
      override public function get_accValue(childID:uint) : String
      {
         return RichEditableText(master).text;
      }
      
      override public function get_accState(childID:uint) : uint
      {
         var accState:uint = uint(getState(childID));
         if(!RichEditableText(master).editable)
         {
            accState |= AccConst.STATE_SYSTEM_READONLY;
         }
         if(RichEditableText(master).displayAsPassword)
         {
            accState |= AccConst.STATE_SYSTEM_PROTECTED;
         }
         return accState;
      }
      
      override protected function eventHandler(event:Event) : void
      {
         $eventHandler(event);
         switch(event.type)
         {
            case Event.CHANGE:
               Accessibility.sendEvent(master,0,AccConst.EVENT_OBJECT_VALUECHANGE,true);
         }
      }
      
      override protected function getName(childID:uint) : String
      {
         return "";
      }
   }
}

