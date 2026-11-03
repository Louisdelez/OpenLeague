package mx.accessibility
{
   import flash.accessibility.Accessibility;
   import flash.display.DisplayObject;
   import flash.events.Event;
   import mx.containers.Accordion;
   import mx.containers.accordionClasses.AccordionHeader;
   import mx.controls.Button;
   import mx.core.UIComponent;
   import mx.core.mx_internal;
   
   use namespace mx_internal;
   
   public class AccordionHeaderAccImpl extends AccImpl
   {
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      private static const STATE_SYSTEM_FOCUSED:uint = 4;
      
      private static const STATE_SYSTEM_SELECTABLE:uint = 2097152;
      
      private static const STATE_SYSTEM_SELECTED:uint = 2;
      
      private static const STATE_SYSTEM_UNAVAILABLE:uint = 1;
      
      private static const EVENT_OBJECT_FOCUS:uint = 32773;
      
      private static const EVENT_OBJECT_SELECTION:uint = 32774;
      
      public function AccordionHeaderAccImpl(master:UIComponent)
      {
         super(master);
         role = 37;
         master.parent.addEventListener("change",eventHandler);
         master.addEventListener("removed",removedHandler);
      }
      
      public static function enableAccessibility() : void
      {
         AccordionHeader.createAccessibilityImplementation = createAccessibilityImplementation;
      }
      
      mx_internal static function createAccessibilityImplementation(component:UIComponent) : void
      {
         component.accessibilityImplementation = new AccordionHeaderAccImpl(component);
      }
      
      override protected function eventHandler(event:Event) : void
      {
         var index:int = 0;
         $eventHandler(event);
         switch(event.type)
         {
            case "focusDraw":
               index = Accordion(event.currentTarget.parent).focusedIndex;
               if(index >= 0 && master == Accordion(event.currentTarget.parent).getHeaderAt(index))
               {
                  Accessibility.sendEvent(DisplayObject(event.currentTarget),index + 1,EVENT_OBJECT_FOCUS,true);
               }
               break;
            case "change":
               index = Accordion(event.currentTarget).selectedIndex;
               if(index >= 0 && master == Accordion(event.currentTarget).getHeaderAt(index))
               {
                  Accessibility.sendEvent(master,index + 1,EVENT_OBJECT_SELECTION,true);
               }
         }
      }
      
      override protected function getName(childID:uint) : String
      {
         var parentAccordion:Accordion = null;
         var tab:Button = Button(master);
         if(childID > 0)
         {
            parentAccordion = Accordion(master.parent);
            tab = parentAccordion.getHeaderAt(parentAccordion.focusedIndex);
         }
         return tab.label;
      }
      
      override public function get_accState(childID:uint) : uint
      {
         var index:int = 0;
         var accState:uint = getState(childID);
         var accordion:Accordion = Accordion(master.parent);
         if(accordion.enabled)
         {
            accState |= STATE_SYSTEM_SELECTABLE;
            if(Button(master).selected)
            {
               accState |= STATE_SYSTEM_SELECTED;
            }
            index = accordion.focusedIndex;
            if(index >= 0 && master == accordion.getHeaderAt(index))
            {
               accState |= STATE_SYSTEM_FOCUSED;
            }
         }
         else
         {
            accState |= STATE_SYSTEM_UNAVAILABLE;
         }
         return accState;
      }
      
      protected function removedHandler(event:Event) : void
      {
         master.parent.removeEventListener("change",eventHandler);
         master.removeEventListener("removed",removedHandler);
      }
      
      override protected function get eventsToHandle() : Array
      {
         return super.eventsToHandle.concat(["focusDraw"]);
      }
      
      override public function get_accDefaultAction(childID:uint) : String
      {
         return "Switch";
      }
   }
}

