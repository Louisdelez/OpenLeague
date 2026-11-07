package mx.controls
{
   import mx.core.UITextField;
   import mx.events.FlexEvent;
   
   [IconFile("Text.png")]
   [DefaultBindingProperty(source="text",destination="text")]
   [Exclude(name="verticalAlign",kind="style")]
   [Exclude(name="horizontalAlign",kind="style")]
   [Style(name="leading",type="Number",format="Length",inherit="yes")]
   public class Text extends Label
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      private var lastUnscaledWidth:Number = NaN;
      
      private var widthChanged:Boolean = true;
      
      public function Text()
      {
         super();
         selectable = true;
         truncateToFit = false;
         addEventListener(FlexEvent.UPDATE_COMPLETE,this.updateCompleteHandler);
      }
      
      override public function set explicitWidth(value:Number) : void
      {
         if(value != explicitWidth)
         {
            this.widthChanged = true;
            invalidateProperties();
            invalidateSize();
         }
         super.explicitWidth = value;
      }
      
      override public function set maxWidth(value:Number) : void
      {
         if(value != maxWidth)
         {
            this.widthChanged = true;
            invalidateProperties();
            invalidateSize();
         }
         super.maxWidth = value;
      }
      
      override public function set percentWidth(value:Number) : void
      {
         if(value != percentWidth)
         {
            this.widthChanged = true;
            invalidateProperties();
            invalidateSize();
         }
         super.percentWidth = value;
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
         if(this.widthChanged)
         {
            textField.wordWrap = !isNaN(explicitWidth) || !isNaN(explicitMaxWidth) || !isNaN(percentWidth);
            this.widthChanged = false;
         }
      }
      
      override protected function measure() : void
      {
         var availableWidth:Number = NaN;
         if(this.isSpecialCase())
         {
            if(!isNaN(this.lastUnscaledWidth))
            {
               this.measureUsingWidth(this.lastUnscaledWidth);
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
            availableWidth = Number(explicitMaxWidth);
         }
         this.measureUsingWidth(availableWidth);
      }
      
      override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         var firstTime:Boolean = false;
         if(this.isSpecialCase())
         {
            firstTime = isNaN(this.lastUnscaledWidth) || this.lastUnscaledWidth != unscaledWidth;
            this.lastUnscaledWidth = unscaledWidth;
            if(firstTime)
            {
               invalidateSize();
               return;
            }
         }
         var paddingLeft:Number = Number(getStyle("paddingLeft"));
         var paddingTop:Number = Number(getStyle("paddingTop"));
         var paddingRight:Number = Number(getStyle("paddingRight"));
         var paddingBottom:Number = Number(getStyle("paddingBottom"));
         textField.setActualSize(unscaledWidth - paddingLeft - paddingRight,unscaledHeight - paddingTop - paddingBottom);
         textField.x = paddingLeft;
         textField.y = paddingTop;
         if(Math.floor(width) < Math.floor(measuredWidth))
         {
            textField.wordWrap = true;
         }
      }
      
      private function isSpecialCase() : Boolean
      {
         var left:Number = Number(getStyle("left"));
         var right:Number = Number(getStyle("right"));
         return (!isNaN(percentWidth) || !isNaN(left) && !isNaN(right)) && isNaN(explicitHeight) && isNaN(percentHeight);
      }
      
      private function measureUsingWidth(w:Number) : void
      {
         var paddingRight:Number = NaN;
         var paddingBottom:Number = NaN;
         var oldWordWrap:Boolean = false;
         var paddingLeft:Number = Number(getStyle("paddingLeft"));
         var paddingTop:Number = Number(getStyle("paddingTop"));
         paddingRight = Number(getStyle("paddingRight"));
         paddingBottom = Number(getStyle("paddingBottom"));
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
            oldWordWrap = Boolean(textField.wordWrap);
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
      
      private function updateCompleteHandler(event:FlexEvent) : void
      {
         this.lastUnscaledWidth = NaN;
      }
   }
}

