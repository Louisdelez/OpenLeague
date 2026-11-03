package spark.accessibility
{
   import flash.accessibility.Accessibility;
   import flash.events.Event;
   import mx.accessibility.AccConst;
   import mx.accessibility.AccImpl;
   import mx.core.UIComponent;
   import mx.events.FlexEvent;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   import spark.components.Spinner;
   
   [ResourceBundle("components")]
   public class SpinnerAccImpl extends AccImpl
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      public function SpinnerAccImpl(master:UIComponent)
      {
         super(master);
         role = AccConst.ROLE_SYSTEM_SPINBUTTON;
      }
      
      public static function enableAccessibility() : void
      {
         Spinner.createAccessibilityImplementation = createAccessibilityImplementation;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static function createAccessibilityImplementation(component:UIComponent) : void
      {
         component.accessibilityImplementation = new SpinnerAccImpl(component);
      }
      
      override protected function get eventsToHandle() : Array
      {
         return super.eventsToHandle.concat([Event.CHANGE]);
      }
      
      override public function get_accRole(childID:uint) : uint
      {
         return childID == 0 ? uint(role) : uint(AccConst.ROLE_SYSTEM_PUSHBUTTON);
      }
      
      override public function getChildIDArray() : Array
      {
         return createChildIDArray(2);
      }
      
      override public function accLocation(childID:uint) : *
      {
         switch(childID)
         {
            case 0:
               return master;
            case 1:
               return Spinner(master).incrementButton;
            case 2:
               return Spinner(master).decrementButton;
            default:
               return;
         }
      }
      
      override public function get_accState(childID:uint) : uint
      {
         var accState:uint = 0;
         switch(childID)
         {
            case 0:
               accState = uint(getState(childID));
               break;
            case 1:
               if(!Spinner(master).enabled)
               {
                  accState = uint(AccConst.STATE_SYSTEM_UNAVAILABLE);
               }
               break;
            case 2:
               if(!Spinner(master).enabled)
               {
                  accState = uint(AccConst.STATE_SYSTEM_UNAVAILABLE);
               }
         }
         return accState;
      }
      
      override public function get_accValue(childID:uint) : String
      {
         if(childID > 0)
         {
            return null;
         }
         return Spinner(master).value.toString();
      }
      
      override public function get_accDefaultAction(childID:uint) : String
      {
         return childID == 0 ? "" : "Press";
      }
      
      override public function accDoDefaultAction(childID:uint) : void
      {
         var prevValue:Number = Spinner(master).value;
         switch(childID)
         {
            case 1:
               if(Spinner(master).enabled)
               {
                  Spinner(master).changeValueByStep(true);
               }
               break;
            case 2:
               if(Spinner(master).enabled)
               {
                  Spinner(master).changeValueByStep(false);
               }
         }
         if(Spinner(master).value != prevValue)
         {
            master.dispatchEvent(new Event(Event.CHANGE));
            master.dispatchEvent(new FlexEvent(FlexEvent.VALUE_COMMIT));
         }
      }
      
      override protected function getName(childID:uint) : String
      {
         var resourceManager:IResourceManager = ResourceManager.getInstance();
         if(childID == 1)
         {
            return resourceManager.getString("components","spinnerMoreAccName");
         }
         if(childID == 2)
         {
            return resourceManager.getString("components","spinnerLessAccName");
         }
         return "";
      }
      
      override protected function eventHandler(event:Event) : void
      {
         $eventHandler(event);
         switch(event.type)
         {
            case Event.CHANGE:
               Accessibility.sendEvent(master,0,AccConst.EVENT_OBJECT_VALUECHANGE,true);
               Accessibility.sendEvent(master,0,AccConst.EVENT_OBJECT_STATECHANGE,true);
         }
      }
   }
}

