package spark.components
{
   import flash.events.Event;
   import flashx.textLayout.elements.TextFlow;
   import flashx.textLayout.formats.TextLayoutFormat;
   import spark.components.supportClasses.SkinnableTextBase;
   
   [IconFile("TextArea.png")]
   [DefaultTriggerEvent("change")]
   [DefaultProperty("content")]
   [Style(name="verticalScrollPolicy",type="String",inherit="no",enumeration="off,on,auto")]
   [Style(name="horizontalScrollPolicy",type="String",inherit="no",enumeration="off,on,auto")]
   [Style(name="symbolColor",type="uint",format="Color",inherit="yes",theme="spark")]
   public class TextArea extends SkinnableTextBase
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      private static const focusExclusions:Array = ["scroller","textDisplay"];
      
      private static var _skinParts:Object = {
         "scroller":false,
         "promptDisplay":false,
         "textDisplay":false
      };
      
      private var horizontalScrollPolicyChanged:Boolean = false;
      
      private var verticalScrollPolicyChanged:Boolean = false;
      
      [SkinPart(required="false")]
      public var scroller:Scroller;
      
      public function TextArea()
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
      
      [RichTextContent]
      public function get content() : Object
      {
         return this.textFlow;
      }
      
      public function set content(value:Object) : void
      {
         setContent(value);
      }
      
      [Inspectable(category="General",minValue="0.0")]
      public function get heightInLines() : Number
      {
         return getHeightInLines();
      }
      
      public function set heightInLines(value:Number) : void
      {
         setHeightInLines(value);
      }
      
      public function get textFlow() : TextFlow
      {
         return getTextFlow();
      }
      
      public function set textFlow(value:TextFlow) : void
      {
         setTextFlow(value);
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
      
      override protected function commitProperties() : void
      {
         super.commitProperties();
         if(this.horizontalScrollPolicyChanged)
         {
            if(Boolean(this.scroller))
            {
               this.scroller.setStyle("horizontalScrollPolicy",getStyle("horizontalScrollPolicy"));
            }
            this.horizontalScrollPolicyChanged = false;
         }
         if(this.verticalScrollPolicyChanged)
         {
            if(Boolean(this.scroller))
            {
               this.scroller.setStyle("verticalScrollPolicy",getStyle("verticalScrollPolicy"));
            }
            this.verticalScrollPolicyChanged = false;
         }
      }
      
      override public function styleChanged(styleProp:String) : void
      {
         var allStyles:Boolean = styleProp == null || styleProp == "styleName";
         super.styleChanged(styleProp);
         if(allStyles || styleProp == "horizontalScrollPolicy")
         {
            this.horizontalScrollPolicyChanged = true;
            invalidateProperties();
         }
         if(allStyles || styleProp == "verticalScrollPolicy")
         {
            this.verticalScrollPolicyChanged = true;
            invalidateProperties();
         }
      }
      
      override protected function partAdded(partName:String, instance:Object) : void
      {
         super.partAdded(partName,instance);
         if(instance == textDisplay)
         {
            textDisplay.multiline = true;
         }
         else if(instance == this.scroller)
         {
            this.scroller.focusEnabled = false;
            if(Boolean(this.scroller.horizontalScrollBar))
            {
               this.scroller.horizontalScrollBar.snapInterval = 0;
            }
            if(Boolean(this.scroller.verticalScrollBar))
            {
               this.scroller.verticalScrollBar.snapInterval = 0;
            }
         }
      }
      
      public function getFormatOfRange(requestedFormats:Vector.<String> = null, anchorPosition:int = -1, activePosition:int = -1) : TextLayoutFormat
      {
         if(!(textDisplay is RichEditableText))
         {
            return null;
         }
         return RichEditableText(textDisplay).getFormatOfRange(requestedFormats,anchorPosition,activePosition);
      }
      
      public function setFormatOfRange(format:TextLayoutFormat, anchorPosition:int = -1, activePosition:int = -1) : void
      {
         if(!(textDisplay is RichEditableText))
         {
            return;
         }
         RichEditableText(textDisplay).setFormatOfRange(format,anchorPosition,activePosition);
      }
      
      public function scrollToRange(anchorPosition:int = 0, activePosition:int = 2147483647) : void
      {
         if(!textDisplay)
         {
            return;
         }
         textDisplay.scrollToRange(anchorPosition,activePosition);
      }
   }
}

