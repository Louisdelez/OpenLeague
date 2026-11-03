package mx.accessibility
{
   import mx.controls.Button;
   import mx.controls.CheckBox;
   import mx.core.UIComponent;
   import mx.core.mx_internal;
   
   use namespace mx_internal;
   
   public class CheckBoxAccImpl extends ButtonAccImpl
   {
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      private static const STATE_SYSTEM_CHECKED:uint = 16;
      
      public function CheckBoxAccImpl(master:UIComponent)
      {
         super(master);
         role = 44;
      }
      
      mx_internal static function createAccessibilityImplementation(component:UIComponent) : void
      {
         component.accessibilityImplementation = new CheckBoxAccImpl(component);
      }
      
      public static function enableAccessibility() : void
      {
         CheckBox.createAccessibilityImplementation = createAccessibilityImplementation;
      }
      
      override public function get_accState(childID:uint) : uint
      {
         var accState:uint = getState(childID);
         if(Button(master).selected)
         {
            accState |= STATE_SYSTEM_CHECKED;
         }
         return accState;
      }
      
      override public function get_accDefaultAction(childID:uint) : String
      {
         return Button(master).selected ? "UnCheck" : "Check";
      }
   }
}

