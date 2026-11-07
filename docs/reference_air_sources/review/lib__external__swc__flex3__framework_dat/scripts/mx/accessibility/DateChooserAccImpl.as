package mx.accessibility
{
   import flash.accessibility.Accessibility;
   import flash.events.Event;
   import mx.controls.DateChooser;
   import mx.core.UIComponent;
   import mx.core.mx_internal;
   
   use namespace mx_internal;
   
   public class DateChooserAccImpl extends AccImpl
   {
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      private static const EVENT_OBJECT_FOCUS:uint = 32773;
      
      private static const EVENT_OBJECT_SELECTION:uint = 32774;
      
      private var selDateFallsInCurrMonth:Boolean;
      
      private var monthFlag:Boolean = true;
      
      private var calFlag:Boolean = true;
      
      private var lastSelectedDate:Date;
      
      public function DateChooserAccImpl(master:UIComponent)
      {
         super(master);
         role = 9;
      }
      
      mx_internal static function createAccessibilityImplementation(component:UIComponent) : void
      {
         component.accessibilityImplementation = new DateChooserAccImpl(component);
      }
      
      public static function enableAccessibility() : void
      {
         DateChooser.createAccessibilityImplementation = createAccessibilityImplementation;
      }
      
      override protected function getName(childID:uint) : String
      {
         var name:String = null;
         var todayDate:Date = null;
         var dateChooser:DateChooser = DateChooser(master);
         var selDate:Date = dateChooser.selectedDate;
         selDateFallsInCurrMonth = selDate != null && selDate.getMonth() == dateChooser.displayedMonth && selDate.getFullYear() == dateChooser.displayedYear;
         if(selDate != null && selDateFallsInCurrMonth)
         {
            if(monthFlag)
            {
               name = "" + selDate.getDate() + " " + dateChooser.dayNames[selDate.getDay()] + ", " + dateChooser.monthNames[dateChooser.displayedMonth] + " " + dateChooser.displayedYear;
            }
            else
            {
               name = "" + selDate.getDate() + " " + dateChooser.dayNames[selDate.getDay()];
            }
            todayDate = new Date();
            if(todayDate.getDate() == selDate.getDate() && todayDate.getMonth() == selDate.getMonth() && todayDate.getFullYear() == selDate.getFullYear())
            {
               name += ", today";
            }
         }
         else
         {
            name = dateChooser.monthNames[dateChooser.displayedMonth] + " " + dateChooser.displayedYear;
         }
         if(calFlag)
         {
            name = " Calendar View, " + name;
         }
         return name;
      }
      
      override public function accDoDefaultAction(childID:uint) : void
      {
      }
      
      override protected function eventHandler(event:Event) : void
      {
         var selDate:Date = null;
         $eventHandler(event);
         var dateChooser:DateChooser = DateChooser(master);
         var randomDate:int = dateChooser.displayedMonth + dateChooser.displayedYear;
         switch(event.type)
         {
            case "focusIn":
               calFlag = true;
               monthFlag = true;
               break;
            case "change":
               calFlag = false;
               selDate = dateChooser.selectedDate;
               if(Boolean(selDate))
               {
                  if(Boolean(lastSelectedDate))
                  {
                     monthFlag = lastSelectedDate.getDate() == selDate.getDate();
                  }
                  Accessibility.sendEvent(master,randomDate + selDate.getDate() + 100,EVENT_OBJECT_FOCUS);
                  Accessibility.sendEvent(master,randomDate + selDate.getDate() + 100,EVENT_OBJECT_SELECTION);
               }
               lastSelectedDate = selDate;
               break;
            case "scroll":
               calFlag = false;
               monthFlag = true;
               Accessibility.sendEvent(master,randomDate,EVENT_OBJECT_FOCUS);
               Accessibility.sendEvent(master,randomDate,EVENT_OBJECT_SELECTION);
         }
      }
      
      override public function get_accState(childID:uint) : uint
      {
         return getState(childID);
      }
      
      override protected function get eventsToHandle() : Array
      {
         return super.eventsToHandle.concat(["focusIn","change","scroll"]);
      }
   }
}

