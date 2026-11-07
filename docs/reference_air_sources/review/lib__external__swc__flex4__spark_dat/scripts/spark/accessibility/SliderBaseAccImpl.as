package spark.accessibility
{
   import flash.accessibility.Accessibility;
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flash.utils.getQualifiedClassName;
   import mx.accessibility.AccConst;
   import mx.accessibility.AccImpl;
   import mx.core.UIComponent;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   import spark.components.supportClasses.SliderBase;
   
   [ResourceBundle("components")]
   public class SliderBaseAccImpl extends AccImpl
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      public function SliderBaseAccImpl(master:UIComponent)
      {
         super(master);
         role = AccConst.ROLE_SYSTEM_SLIDER;
      }
      
      public static function enableAccessibility() : void
      {
         SliderBase.createAccessibilityImplementation = createAccessibilityImplementation;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static function createAccessibilityImplementation(component:UIComponent) : void
      {
         component.accessibilityImplementation = new SliderBaseAccImpl(component);
      }
      
      override public function get_accRole(childID:uint) : uint
      {
         var childRole:uint = 0;
         switch(childID)
         {
            case 1:
            case 3:
               childRole = uint(AccConst.ROLE_SYSTEM_PUSHBUTTON);
               break;
            case 2:
               childRole = uint(AccConst.ROLE_SYSTEM_INDICATOR);
               break;
            default:
               childRole = uint(role);
         }
         return childRole;
      }
      
      override protected function get eventsToHandle() : Array
      {
         return super.eventsToHandle.concat(["change",FocusEvent.FOCUS_IN]);
      }
      
      override public function get_accDefaultAction(childID:uint) : String
      {
         if(childID == 1 || childID == 3)
         {
            return "Press";
         }
         return null;
      }
      
      override public function accDoDefaultAction(childID:uint) : void
      {
         var slider:SliderBase = SliderBase(master);
         if(childID == 1 && slider.enabled)
         {
            slider.value -= slider.stepSize;
         }
         else if(childID == 3 && slider.enabled)
         {
            slider.value += slider.stepSize;
         }
      }
      
      override public function accLocation(childID:uint) : *
      {
         if(childID == 2)
         {
            return SliderBase(master).thumb;
         }
      }
      
      override public function get_accValue(childID:uint) : String
      {
         if(childID > 0)
         {
            return null;
         }
         var val:Number = SliderBase(master).value;
         val = (val - SliderBase(master).minimum) / (SliderBase(master).maximum - SliderBase(master).minimum) * 100;
         return String(Math.floor(val));
      }
      
      override public function getChildIDArray() : Array
      {
         return createChildIDArray(3);
      }
      
      override protected function getName(childID:uint) : String
      {
         var resourceManager:IResourceManager = ResourceManager.getInstance();
         var isHSlider:Boolean = getQualifiedClassName(master) == "spark.components::HSlider";
         switch(childID)
         {
            case 1:
               return resourceManager.getString("components",isHSlider ? "sliderPageLeftAccName" : "sliderPageDownAccName");
            case 2:
               return resourceManager.getString("components","sliderPositiontAccName");
            case 3:
               return resourceManager.getString("components",isHSlider ? "sliderPageRightAccName" : "sliderPageUpAccName");
            default:
               return "";
         }
      }
      
      override public function get_accState(childID:uint) : uint
      {
         var accState:uint = 0;
         if(childID == 0)
         {
            accState = uint(getState(childID));
         }
         else if(!master.enabled)
         {
            accState = uint(AccConst.STATE_SYSTEM_UNAVAILABLE);
         }
         return accState;
      }
      
      override protected function eventHandler(event:Event) : void
      {
         $eventHandler(event);
         switch(event.type)
         {
            case "change":
               Accessibility.sendEvent(master,0,AccConst.EVENT_OBJECT_VALUECHANGE,true);
               break;
            case "focusIn":
               Accessibility.sendEvent(master,0,AccConst.EVENT_OBJECT_FOCUS);
         }
      }
   }
}

