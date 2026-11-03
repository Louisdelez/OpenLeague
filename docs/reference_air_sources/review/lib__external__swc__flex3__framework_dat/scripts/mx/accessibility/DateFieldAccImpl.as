package mx.accessibility
{
   import flash.accessibility.Accessibility;
   import flash.events.Event;
   import mx.controls.DateField;
   import mx.core.UIComponent;
   import mx.core.mx_internal;
   
   use namespace mx_internal;
   
   public class DateFieldAccImpl extends AccImpl
   {
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      private static const EVENT_OBJECT_FOCUS:uint = 32773;
      
      private static const EVENT_OBJECT_SELECTION:uint = 32774;
      
      private var instructionsFlag:Boolean = false;
      
      public function DateFieldAccImpl(master:UIComponent)
      {
         super(master);
         role = 46;
      }
      
      mx_internal static function createAccessibilityImplementation(component:UIComponent) : void
      {
         component.accessibilityImplementation = new DateFieldAccImpl(component);
      }
      
      public static function enableAccessibility() : void
      {
         DateField.createAccessibilityImplementation = createAccessibilityImplementation;
         DateChooserAccImpl.enableAccessibility();
      }
      
      override protected function eventHandler(event:Event) : void
      {
         var childID:uint = 0;
         var dateField:DateField = null;
         $eventHandler(event);
         switch(event.type)
         {
            case "change":
               childID = 289;
               dateField = DateField(master);
               if(dateField.selectedDate != null)
               {
                  childID += dateField.selectedDate.getDate();
               }
               Accessibility.sendEvent(master,childID,EVENT_OBJECT_FOCUS);
               Accessibility.sendEvent(master,childID,EVENT_OBJECT_SELECTION);
               break;
            case "close":
            case "focusIn":
               instructionsFlag = true;
               break;
            case "open":
            case "focusOut":
               instructionsFlag = false;
         }
      }
      
      override protected function getName(childID:uint) : String
      {
         var tDate:String = null;
         var name:String = "Drop Down Calendar, ";
         var dateField:DateField = DateField(master);
         if(Boolean(dateField.displayedMonth) && !isNaN(dateField.displayedYear))
         {
            name += dateField.monthNames[dateField.displayedMonth] + " " + dateField.displayedYear;
         }
         var instrString:String = ", to open press control down";
         var selDate:Date = dateField.selectedDate;
         if(Boolean(selDate))
         {
            tDate = "" + selDate.getDate() + " " + dateField.monthNames[selDate.getMonth()] + " " + selDate.getFullYear();
            name = "Drop Down Calendar, " + tDate;
         }
         if(instructionsFlag)
         {
            name += instrString;
         }
         return name;
      }
      
      override public function get_accState(childID:uint) : uint
      {
         return getState(childID);
      }
      
      override protected function get eventsToHandle() : Array
      {
         return super.eventsToHandle.concat(["change","focusIn","focusOut","open","close"]);
      }
   }
}

