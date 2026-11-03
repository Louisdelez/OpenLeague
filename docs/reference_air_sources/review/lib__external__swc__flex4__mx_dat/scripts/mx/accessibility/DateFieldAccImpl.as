package mx.accessibility
{
   import flash.accessibility.Accessibility;
   import flash.events.Event;
   import mx.controls.DateField;
   import mx.core.UIComponent;
   
   public class DateFieldAccImpl extends AccImpl
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      private var instructionsFlag:Boolean = false;
      
      public function DateFieldAccImpl(master:UIComponent)
      {
         super(master);
         role = AccConst.ROLE_SYSTEM_COMBOBOX;
      }
      
      public static function enableAccessibility() : void
      {
         DateField.createAccessibilityImplementation = createAccessibilityImplementation;
         DateChooserAccImpl.enableAccessibility();
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static function createAccessibilityImplementation(component:UIComponent) : void
      {
         component.accessibilityImplementation = new DateFieldAccImpl(component);
      }
      
      override protected function get eventsToHandle() : Array
      {
         return super.eventsToHandle.concat(["change","focusIn","focusOut","open","close"]);
      }
      
      override public function get_accState(childID:uint) : uint
      {
         return getState(childID);
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
         if(this.instructionsFlag)
         {
            name += instrString;
         }
         return name;
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
               Accessibility.sendEvent(master,childID,AccConst.EVENT_OBJECT_FOCUS);
               Accessibility.sendEvent(master,childID,AccConst.EVENT_OBJECT_SELECTION);
               break;
            case "close":
            case "focusIn":
               this.instructionsFlag = true;
               break;
            case "open":
            case "focusOut":
               this.instructionsFlag = false;
         }
      }
   }
}

