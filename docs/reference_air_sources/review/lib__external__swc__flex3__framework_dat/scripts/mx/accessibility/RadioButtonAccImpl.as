package mx.accessibility
{
   import mx.controls.RadioButton;
   import mx.core.UIComponent;
   import mx.core.mx_internal;
   
   use namespace mx_internal;
   
   public class RadioButtonAccImpl extends CheckBoxAccImpl
   {
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      public function RadioButtonAccImpl(master:UIComponent)
      {
         super(master);
         role = 45;
      }
      
      public static function enableAccessibility() : void
      {
         RadioButton.createAccessibilityImplementation = createAccessibilityImplementation;
      }
      
      mx_internal static function createAccessibilityImplementation(component:UIComponent) : void
      {
         component.accessibilityImplementation = new RadioButtonAccImpl(component);
      }
   }
}

