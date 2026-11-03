package spark.accessibility
{
   import mx.accessibility.AccConst;
   import mx.core.UIComponent;
   import spark.components.RadioButton;
   import spark.components.RadioButtonGroup;
   
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
      
      override protected function getName(childID:uint) : String
      {
         var index:int = 0;
         var n:int = 0;
         var i:int = 0;
         var radioButton:RadioButton = null;
         var name:String = RadioButton(master).label;
         var radioGroup:RadioButtonGroup = RadioButton(master).group;
         if(Boolean(radioGroup))
         {
            index = 0;
            n = radioGroup.numRadioButtons;
            for(i = 0; i < n; i++)
            {
               radioButton = radioGroup.getRadioButtonAt(i);
               if(radioButton === master)
               {
                  index = i + 1;
                  break;
               }
            }
            name += " " + index + " of " + n;
         }
         return name;
      }
   }
}

