package mx.accessibility
{
   import flash.accessibility.Accessibility;
   import flash.events.Event;
   import mx.controls.DateChooser;
   import mx.core.UIComponent;
   
   public class DateChooserAccImpl extends AccImpl
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      private var calFlag:Boolean = true;
      
      private var monthFlag:Boolean = true;
      
      private var lastSelectedDate:Date;
      
      private var selDateFallsInCurrMonth:Boolean;
      
      public function DateChooserAccImpl(master:UIComponent)
      {
         super(master);
         role = AccConst.ROLE_SYSTEM_WINDOW;
      }
      
      public static function enableAccessibility() : void
      {
         DateChooser.createAccessibilityImplementation = createAccessibilityImplementation;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static function createAccessibilityImplementation(component:UIComponent) : void
      {
         component.accessibilityImplementation = new DateChooserAccImpl(component);
      }
      
      override protected function get eventsToHandle() : Array
      {
         return super.eventsToHandle.concat(["focusIn","change","scroll"]);
      }
      
      override public function get_accState(childID:uint) : uint
      {
         return getState(childID);
      }
      
      override public function accDoDefaultAction(childID:uint) : void
      {
      }
      
      override protected function getName(childID:uint) : String
      {
         var name:String = null;
         var todayDate:Date = null;
         var dateChooser:DateChooser = DateChooser(master);
         var selDate:Date = dateChooser.selectedDate;
         this.selDateFallsInCurrMonth = selDate != null && selDate.getMonth() == dateChooser.displayedMonth && selDate.getFullYear() == dateChooser.displayedYear;
         if(selDate != null && this.selDateFallsInCurrMonth)
         {
            if(this.monthFlag)
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
         if(this.calFlag)
         {
            name = " Calendar View, " + name;
         }
         return name;
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
               this.calFlag = true;
               this.monthFlag = true;
               break;
            case "change":
               this.calFlag = false;
               selDate = dateChooser.selectedDate;
               if(Boolean(selDate))
               {
                  if(Boolean(this.lastSelectedDate))
                  {
                     this.monthFlag = this.lastSelectedDate.getDate() == selDate.getDate();
                  }
                  Accessibility.sendEvent(master,randomDate + selDate.getDate() + 100,AccConst.EVENT_OBJECT_FOCUS);
                  Accessibility.sendEvent(master,randomDate + selDate.getDate() + 100,AccConst.EVENT_OBJECT_SELECTION);
               }
               this.lastSelectedDate = selDate;
               break;
            case "scroll":
               this.calFlag = false;
               this.monthFlag = true;
               Accessibility.sendEvent(master,randomDate,AccConst.EVENT_OBJECT_FOCUS);
               Accessibility.sendEvent(master,randomDate,AccConst.EVENT_OBJECT_SELECTION);
         }
      }
   }
}

