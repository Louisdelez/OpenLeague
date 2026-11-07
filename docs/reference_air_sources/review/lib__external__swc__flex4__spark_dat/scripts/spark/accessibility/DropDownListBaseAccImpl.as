package spark.accessibility
{
   import flash.accessibility.Accessibility;
   import flash.events.Event;
   import mx.accessibility.AccConst;
   import mx.core.UIComponent;
   import spark.components.supportClasses.DropDownListBase;
   import spark.components.supportClasses.ListBase;
   
   public class DropDownListBaseAccImpl extends ListBaseAccImpl
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      public function DropDownListBaseAccImpl(master:UIComponent)
      {
         super(master);
         role = AccConst.ROLE_SYSTEM_COMBOBOX;
      }
      
      public static function enableAccessibility() : void
      {
         DropDownListBase.createAccessibilityImplementation = createAccessibilityImplementation;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static function createAccessibilityImplementation(component:UIComponent) : void
      {
         component.accessibilityImplementation = new DropDownListBaseAccImpl(component);
      }
      
      override protected function get eventsToHandle() : Array
      {
         return super.eventsToHandle.concat(["open","close"]);
      }
      
      override public function get_accValue(childID:uint) : String
      {
         if(childID == 0)
         {
            return getName(DropDownListBase(master).selectedIndex + 1);
         }
         return null;
      }
      
      override public function get_accState(childID:uint) : uint
      {
         var accState:uint = super.get_accState(childID);
         if(childID == 0)
         {
            if(DropDownListBase(master).isDropDownOpen)
            {
               accState |= AccConst.STATE_SYSTEM_EXPANDED;
            }
            else
            {
               accState |= AccConst.STATE_SYSTEM_COLLAPSED;
            }
         }
         else if(!DropDownListBase(master).isDropDownOpen)
         {
            if(childID - 1 == ListBase(master).caretIndex)
            {
               accState |= AccConst.STATE_SYSTEM_SELECTED;
            }
            accState = uint(AccConst.STATE_SYSTEM_INVISIBLE);
         }
         return accState;
      }
      
      override protected function eventHandler(event:Event) : void
      {
         var index:uint = 0;
         switch(event.type)
         {
            case "open":
               Accessibility.sendEvent(master,0,AccConst.EVENT_OBJECT_STATECHANGE);
               index = uint(DropDownListBase(master).selectedIndex);
               if(index >= 0)
               {
                  Accessibility.sendEvent(master,index + 1,AccConst.EVENT_OBJECT_FOCUS);
               }
               break;
            case "close":
               Accessibility.sendEvent(master,0,AccConst.EVENT_OBJECT_STATECHANGE);
               Accessibility.sendEvent(master,0,AccConst.EVENT_OBJECT_FOCUS);
               break;
            case "change":
               if(!DropDownListBase(master).isDropDownOpen)
               {
                  Accessibility.sendEvent(master,0,AccConst.EVENT_OBJECT_VALUECHANGE,true);
                  break;
               }
            case "caretChange":
               if(!DropDownListBase(master).isDropDownOpen)
               {
                  break;
               }
            default:
               super.eventHandler(event);
         }
      }
   }
}

