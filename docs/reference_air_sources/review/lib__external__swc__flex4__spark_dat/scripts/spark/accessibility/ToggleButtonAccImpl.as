package spark.accessibility
{
   import mx.accessibility.AccConst;
   import mx.accessibility.AccImpl;
   import mx.core.UIComponent;
   import spark.components.supportClasses.ToggleButtonBase;
   
   public class ToggleButtonAccImpl extends ButtonBaseAccImpl
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      public function ToggleButtonAccImpl(master:UIComponent)
      {
         super(master);
      }
      
      public static function enableAccessibility() : void
      {
         ToggleButtonBase.createAccessibilityImplementation = createAccessibilityImplementation;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static function createAccessibilityImplementation(component:UIComponent) : void
      {
         component.accessibilityImplementation = new ToggleButtonAccImpl(component);
      }
      
      override public function get_accName(childID:uint) : String
      {
         var accName:String = null;
         var stateNames:Array = null;
         if(Boolean(master.accessibilityName) && master.accessibilityName.indexOf(",") != -1)
         {
            accName = AccImpl.getFormName(master);
            stateNames = master.accessibilityName.split(",");
            accName += " " + (ToggleButtonBase(master).selected ? stateNames[1] : stateNames[0]);
         }
         else
         {
            accName = super.get_accName(0);
         }
         return accName;
      }
      
      override public function get_accState(childID:uint) : uint
      {
         var accState:uint = uint(getState(childID));
         if(ToggleButtonBase(master).selected && (!master.accessibilityName || master.accessibilityName.indexOf(",") == -1))
         {
            accState |= AccConst.STATE_SYSTEM_PRESSED;
         }
         return accState;
      }
   }
}

