package spark.components
{
   import spark.components.supportClasses.ToggleButtonBase;
   
   [DiscouragedForProfile("mobileDevice")]
   [IconFile("ToggleButton.png")]
   [Exclude(name="textAlign",kind="style")]
   public class ToggleButton extends ToggleButtonBase
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      private static var _skinParts:Object = {
         "iconDisplay":false,
         "labelDisplay":false
      };
      
      public function ToggleButton()
      {
         super();
      }
   }
}

