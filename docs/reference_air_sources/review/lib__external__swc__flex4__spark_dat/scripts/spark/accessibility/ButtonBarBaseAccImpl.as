package spark.accessibility
{
   import flash.accessibility.Accessibility;
   import flash.events.Event;
   import mx.accessibility.AccConst;
   import mx.core.UIComponent;
   import spark.components.supportClasses.ButtonBarBase;
   import spark.components.supportClasses.ListBase;
   
   public class ButtonBarBaseAccImpl extends ListBaseAccImpl
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      public function ButtonBarBaseAccImpl(master:UIComponent)
      {
         super(master);
         role = AccConst.ROLE_SYSTEM_TOOLBAR;
      }
      
      public static function enableAccessibility() : void
      {
         ButtonBarBase.createAccessibilityImplementation = createAccessibilityImplementation;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static function createAccessibilityImplementation(component:UIComponent) : void
      {
         component.accessibilityImplementation = new ButtonBarBaseAccImpl(component);
      }
      
      override public function get_accRole(childID:uint) : uint
      {
         return childID == 0 ? uint(role) : uint(AccConst.ROLE_SYSTEM_PUSHBUTTON);
      }
      
      override public function get_accState(childID:uint) : uint
      {
         var index:int = 0;
         var accState:uint = uint(getState(childID));
         if(childID > 0)
         {
            index = childID - 1;
            if(ListBase(master).isItemIndexSelected(index))
            {
               accState |= AccConst.STATE_SYSTEM_PRESSED;
            }
            if(index == ListBase(master).caretIndex)
            {
               accState |= AccConst.STATE_SYSTEM_FOCUSED;
            }
         }
         return accState;
      }
      
      override public function get_accDefaultAction(childID:uint) : String
      {
         if(childID == 0)
         {
            return null;
         }
         return "Press";
      }
      
      override protected function eventHandler(event:Event) : void
      {
         var pressed:int = 0;
         $eventHandler(event);
         switch(event.type)
         {
            case "change":
               pressed = ButtonBarBase(master).selectedIndex;
               Accessibility.sendEvent(master,pressed + 1,AccConst.EVENT_OBJECT_STATECHANGE,true);
               break;
            default:
               super.eventHandler(event);
         }
      }
   }
}

