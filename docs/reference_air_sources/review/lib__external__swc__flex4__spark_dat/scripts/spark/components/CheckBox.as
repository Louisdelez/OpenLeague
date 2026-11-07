package spark.components
{
   import spark.components.supportClasses.ToggleButtonBase;
   
   [IconFile("CheckBox.png")]
   [AccessibilityClass(implementation="spark.accessibility.CheckBoxAccImpl")]
   [Exclude(name="textAlign",kind="style")]
   [Exclude(name="icon",kind="style")]
   [Exclude(name="cornerRadius",kind="style")]
   [Style(name="symbolColor",type="uint",format="Color",inherit="yes",theme="spark, mobile")]
   [Style(name="iconPlacement",type="String",enumeration="top,bottom,right,left",inherit="no",theme="mobile")]
   public class CheckBox extends ToggleButtonBase
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static var createAccessibilityImplementation:Function;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      private static const focusExclusions:Array = ["labelDisplay"];
      
      private static var _skinParts:Object = {
         "iconDisplay":false,
         "labelDisplay":false
      };
      
      public function CheckBox()
      {
         super();
      }
      
      override public function get suggestedFocusSkinExclusions() : Array
      {
         return focusExclusions;
      }
      
      override protected function initializeAccessibility() : void
      {
         if(CheckBox.createAccessibilityImplementation != null)
         {
            CheckBox.createAccessibilityImplementation(this);
         }
      }
   }
}

