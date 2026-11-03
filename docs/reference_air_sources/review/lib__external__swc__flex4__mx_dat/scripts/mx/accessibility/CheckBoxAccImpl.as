package mx.accessibility
{
   import mx.controls.Button;
   import mx.controls.CheckBox;
   import mx.core.UIComponent;
   
   public class CheckBoxAccImpl extends ButtonAccImpl
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      public function CheckBoxAccImpl(master:UIComponent)
      {
         super(master);
         role = AccConst.ROLE_SYSTEM_CHECKBUTTON;
      }
      
      public static function enableAccessibility() : void
      {
         CheckBox.createAccessibilityImplementation = createAccessibilityImplementation;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static function createAccessibilityImplementation(component:UIComponent) : void
      {
         component.accessibilityImplementation = new CheckBoxAccImpl(component);
      }
      
      override public function get_accState(childID:uint) : uint
      {
         var accState:uint = uint(getState(childID));
         if(Button(master).selected)
         {
            accState |= AccConst.STATE_SYSTEM_CHECKED;
         }
         return accState;
      }
      
      override public function get_accDefaultAction(childID:uint) : String
      {
         return Button(master).selected ? "UnCheck" : "Check";
      }
   }
}

