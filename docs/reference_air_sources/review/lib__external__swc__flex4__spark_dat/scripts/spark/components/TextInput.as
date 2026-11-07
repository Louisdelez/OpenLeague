package spark.components
{
   import flash.events.Event;
   import spark.components.supportClasses.SkinnableTextBase;
   
   [IconFile("TextInput.png")]
   [DefaultTriggerEvent("change")]
   [DefaultProperty("text")]
   [Exclude(name="lineBreak",kind="style")]
   [Exclude(name="verticalAlign",kind="style")]
   [Event(name="enter",type="mx.events.FlexEvent")]
   public class TextInput extends SkinnableTextBase
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      private static const focusExclusions:Array = ["textDisplay"];
      
      private static var _skinParts:Object = {
         "promptDisplay":false,
         "textDisplay":false
      };
      
      public function TextInput()
      {
         super();
      }
      
      override public function get suggestedFocusSkinExclusions() : Array
      {
         return focusExclusions;
      }
      
      [CollapseWhiteSpace]
      [Bindable("textChanged")]
      [Bindable("change")]
      override public function set text(value:String) : void
      {
         super.text = value;
         dispatchEvent(new Event("textChanged"));
      }
      
      [Inspectable(category="General",minValue="0.0")]
      public function get widthInChars() : Number
      {
         return getWidthInChars();
      }
      
      public function set widthInChars(value:Number) : void
      {
         setWidthInChars(value);
      }
      
      override protected function partAdded(partName:String, instance:Object) : void
      {
         super.partAdded(partName,instance);
         if(instance == textDisplay)
         {
            textDisplay.multiline = false;
            textDisplay.lineBreak = "explicit";
            if(textDisplay is RichEditableText)
            {
               RichEditableText(textDisplay).heightInLines = 1;
            }
         }
      }
   }
}

