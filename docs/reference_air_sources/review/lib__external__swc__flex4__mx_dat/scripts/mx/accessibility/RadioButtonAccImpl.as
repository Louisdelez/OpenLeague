package mx.accessibility
{
   import mx.controls.RadioButton;
   import mx.core.UIComponent;
   
   public class RadioButtonAccImpl extends CheckBoxAccImpl
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      public function RadioButtonAccImpl(master:UIComponent)
      {
         super(master);
         role = AccConst.ROLE_SYSTEM_RADIOBUTTON;
      }
      
      public static function enableAccessibility() : void
      {
         RadioButton.createAccessibilityImplementation = createAccessibilityImplementation;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static function createAccessibilityImplementation(component:UIComponent) : void
      {
         component.accessibilityImplementation = new RadioButtonAccImpl(component);
      }
   }
}

