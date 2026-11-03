package mx.controls
{
   import mx.core.UITextField;
   import mx.core.mx_internal;
   import mx.events.FlexEvent;
   
   use namespace mx_internal;
   
   [IconFile("Text.png")]
   [DefaultBindingProperty(source="text",destination="text")]
   [Exclude(name="verticalAlign",kind="style")]
   [Exclude(name="horizontalAlign",kind="style")]
   [Style(name="leading",type="Number",format="Length",inherit="yes")]
   public class Text extends Label
   {
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      private var widthChanged:Boolean = true;
      
      private var lastUnscaledWidth:Number = NaN;
      
      public function Text()
      {
         super();
         selectable = true;
         truncateToFit = false;
         addEventListener(FlexEvent.UPDATE_COMPLETE,updateCompleteHandler);
      }
      
      private function measureUsingWidth(w:Number) : void
      {
         var paddingRight:Number = NaN;
         var paddingBottom:Number = NaN;
         var oldWordWrap:Boolean = false;
         var paddingLeft:Number = getStyle("paddingLeft");
         var paddingTop:Number = getStyle("paddingTop");
         paddingRight = getStyle("paddingRight");
         paddingBottom = getStyle("paddingBottom");
         textField.validateNow();
         textField.autoSize = "left";
         if(!isNaN(w))
         {
            textField.width = w - paddingLeft - paddingRight;
            measuredWidth = Math.ceil(textField.textWidth) + UITextField.TEXT_WIDTH_PADDING;
            measuredHeight = Math.ceil(textField.textHeight) + UITextField.TEXT_HEIGHT_PADDING;
         }
         else
         {
            oldWordWrap = textField.wordWrap;
            textField.wordWrap = false;
            measuredWidth = Math.ceil(textField.textWidth) + UITextField.TEXT_WIDTH_PADDING;
            measuredHeight = Math.ceil(textField.textHeight) + UITextField.TEXT_HEIGHT_PADDING;
            textField.wordWrap = oldWordWrap;
         }
         textField.autoSize = "none";
         measuredWidth += paddingLeft + paddingRight;
         measuredHeight += paddingTop + paddingBottom;
         if(isNaN(explicitWidth))
         {
            measuredMinWidth = DEFAULT_MEASURED_MIN_WIDTH;
            measuredMinHeight = DEFAULT_MEASURED_MIN_HEIGHT;
         }
         else
         {
            measuredMinWidth = measuredWidth;
            measuredMinHeight = measuredHeight;
         }
      }
      
      override public function set percentWidth(value:Number) : void
      {
         if(value != percentWidth)
         {
            widthChanged = true;
            invalidateProperties();
            invalidateSize();
         }
         super.percentWidth = value;
      }
      
      override public function set explicitWidth(value:Number) : void
      {
         if(value != explicitWidth)
         {
            widthChanged = true;
            invalidateProperties();
            invalidateSize();
         }
         super.explicitWidth = value;
      }
      
      private function updateCompleteHandler(event:FlexEvent) : void
      {
         lastUnscaledWidth = NaN;
      }
      
      override protected function childrenCreated() : void
      {
         super.childrenCreated();
         textField.wordWrap = true;
         textField.multiline = true;
         textField.mouseWheelEnabled = false;
      }
      
      override protected function commitProperties() : void
      {
         super.commitProperties();
         if(widthChanged)
         {
            textField.wordWrap = !isNaN(explicitWidth) || !isNaN(explicitMaxWidth) || !isNaN(percentWidth);
            widthChanged = false;
         }
      }
      
      override public function set maxWidth(value:Number) : void
      {
         if(value != maxWidth)
         {
            widthChanged = true;
            invalidateProperties();
            invalidateSize();
         }
         super.maxWidth = value;
      }
      
      override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         var firstTime:Boolean = false;
         if(isSpecialCase())
         {
            firstTime = isNaN(lastUnscaledWidth) || lastUnscaledWidth != unscaledWidth;
            lastUnscaledWidth = unscaledWidth;
            if(firstTime)
            {
               invalidateSize();
               return;
            }
         }
         var paddingLeft:Number = getStyle("paddingLeft");
         var paddingTop:Number = getStyle("paddingTop");
         var paddingRight:Number = getStyle("paddingRight");
         var paddingBottom:Number = getStyle("paddingBottom");
         textField.setActualSize(unscaledWidth - paddingLeft - paddingRight,unscaledHeight - paddingTop - paddingBottom);
         textField.x = paddingLeft;
         textField.y = paddingTop;
         if(Math.floor(width) < Math.floor(measuredWidth))
         {
            textField.wordWrap = true;
         }
      }
      
      override protected function measure() : void
      {
         var availableWidth:Number = NaN;
         if(isSpecialCase())
         {
            if(!isNaN(lastUnscaledWidth))
            {
               measureUsingWidth(lastUnscaledWidth);
            }
            else
            {
               measuredWidth = 0;
               measuredHeight = 0;
            }
            return;
         }
         if(!isNaN(explicitWidth))
         {
            availableWidth = explicitWidth;
         }
         else if(!isNaN(explicitMaxWidth))
         {
            availableWidth = explicitMaxWidth;
         }
         measureUsingWidth(availableWidth);
      }
      
      private function isSpecialCase() : Boolean
      {
         var left:Number = getStyle("left");
         var right:Number = getStyle("right");
         return (!isNaN(percentWidth) || !isNaN(left) && !isNaN(right)) && isNaN(explicitHeight) && isNaN(percentHeight);
      }
   }
}

