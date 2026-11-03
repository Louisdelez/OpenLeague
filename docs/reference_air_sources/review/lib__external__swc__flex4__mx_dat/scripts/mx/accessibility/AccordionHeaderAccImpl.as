package mx.accessibility
{
   import flash.accessibility.Accessibility;
   import flash.display.DisplayObject;
   import flash.events.Event;
   import mx.containers.Accordion;
   import mx.containers.accordionClasses.AccordionHeader;
   import mx.controls.Button;
   import mx.core.UIComponent;
   
   public class AccordionHeaderAccImpl extends AccImpl
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      public function AccordionHeaderAccImpl(master:UIComponent)
      {
         super(master);
         role = AccConst.ROLE_SYSTEM_PAGETAB;
         master.parent.addEventListener("change",this.eventHandler);
         master.addEventListener("removed",this.removedHandler);
      }
      
      public static function enableAccessibility() : void
      {
         AccordionHeader.createAccessibilityImplementation = createAccessibilityImplementation;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static function createAccessibilityImplementation(component:UIComponent) : void
      {
         component.accessibilityImplementation = new AccordionHeaderAccImpl(component);
      }
      
      override protected function get eventsToHandle() : Array
      {
         return super.eventsToHandle.concat(["focusDraw"]);
      }
      
      override public function get_accState(childID:uint) : uint
      {
         var index:int = 0;
         var accState:uint = uint(getState(childID));
         var accordion:Accordion = Accordion(master.parent);
         if(accordion.enabled)
         {
            accState |= AccConst.STATE_SYSTEM_SELECTABLE;
            if(Button(master).selected)
            {
               accState |= AccConst.STATE_SYSTEM_SELECTED;
            }
            index = accordion.focusedIndex;
            if(index >= 0 && master == accordion.getHeaderAt(index))
            {
               accState |= AccConst.STATE_SYSTEM_FOCUSED;
            }
         }
         else
         {
            accState |= AccConst.STATE_SYSTEM_UNAVAILABLE;
         }
         return accState;
      }
      
      override public function get_accDefaultAction(childID:uint) : String
      {
         return "Switch";
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
                  Accessibility.sendEvent(DisplayObject(event.currentTarget),index + 1,AccConst.EVENT_OBJECT_FOCUS,true);
               }
               break;
            case "change":
               index = Accordion(event.currentTarget).selectedIndex;
               if(index >= 0 && master == Accordion(event.currentTarget).getHeaderAt(index))
               {
                  Accessibility.sendEvent(master,index + 1,AccConst.EVENT_OBJECT_SELECTION,true);
               }
         }
      }
      
      protected function removedHandler(event:Event) : void
      {
         master.parent.removeEventListener("change",this.eventHandler);
         master.removeEventListener("removed",this.removedHandler);
      }
   }
}

