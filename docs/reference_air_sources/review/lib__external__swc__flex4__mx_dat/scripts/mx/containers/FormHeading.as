package mx.containers
{
   import flash.events.Event;
   import mx.controls.Label;
   import mx.core.EdgeMetrics;
   import mx.core.UIComponent;
   
   [Alternative(replacement="spark.components.FormHeading",since="4.5")]
   [IconFile("FormHeading.png")]
   [Style(name="paddingTop",type="Number",format="Length",inherit="no")]
   [Style(name="labelWidth",type="Number",format="Length",inherit="yes")]
   [Style(name="indicatorGap",type="Number",format="Length",inherit="yes")]
   [Style(name="textIndent",type="Number",format="Length",inherit="yes")]
   [Style(name="textFieldClass",type="Class",inherit="no")]
   [Style(name="textDecoration",type="String",enumeration="none,underline",inherit="yes")]
   [Style(name="textAlign",type="String",enumeration="left,center,right",inherit="yes")]
   [Style(name="locale",type="String",inherit="yes")]
   [Style(name="letterSpacing",type="Number",inherit="yes")]
   [Style(name="kerning",type="Boolean",inherit="yes")]
   [Style(name="fontWeight",type="String",enumeration="normal,bold",inherit="yes")]
   [Style(name="fontThickness",type="Number",inherit="yes")]
   [Style(name="fontStyle",type="String",enumeration="normal,italic",inherit="yes")]
   [Style(name="fontSize",type="Number",format="Length",inherit="yes")]
   [Style(name="fontSharpness",type="Number",inherit="yes")]
   [Style(name="fontGridFitType",type="String",enumeration="none,pixel,subpixel",inherit="yes")]
   [Style(name="fontFamily",type="String",inherit="yes")]
   [Style(name="fontAntiAliasType",type="String",enumeration="normal,advanced",inherit="yes")]
   [Style(name="disabledColor",type="uint",format="Color",inherit="yes")]
   [Style(name="direction",type="String",enumeration="ltr,rtl,inherit",inherit="yes")]
   [Style(name="color",type="uint",format="Color",inherit="yes")]
   [Style(name="paddingRight",type="Number",format="Length",inherit="no")]
   [Style(name="paddingLeft",type="Number",format="Length",inherit="no")]
   [Style(name="leading",type="Number",format="Length",inherit="yes")]
   public class FormHeading extends UIComponent
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      private var labelObj:Label;
      
      private var _label:String = "";
      
      public function FormHeading()
      {
         super();
      }
      
      [Inspectable(category="General",defaultValue="")]
      [Bindable("labelChanged")]
      public function get label() : String
      {
         return this._label;
      }
      
      public function set label(value:String) : void
      {
         this._label = value;
         invalidateProperties();
         dispatchEvent(new Event("labelChanged"));
      }
      
      override protected function commitProperties() : void
      {
         super.commitProperties();
         this.createLabel();
      }
      
      override protected function measure() : void
      {
         var preferredWidth:Number = NaN;
         super.measure();
         preferredWidth = 0;
         var preferredHeight:Number = Number(getStyle("paddingTop"));
         if(Boolean(this.labelObj))
         {
            if(isNaN(this.labelObj.measuredWidth))
            {
               this.labelObj.validateSize();
            }
            preferredWidth = Number(this.labelObj.measuredWidth);
            preferredHeight += this.labelObj.measuredHeight;
         }
         preferredWidth += this.getLabelWidth() + getStyle("indicatorGap");
         measuredMinWidth = preferredWidth;
         measuredMinHeight = preferredHeight;
         measuredWidth = preferredWidth;
         measuredHeight = preferredHeight;
      }
      
      override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         var indicatorGap:Number = NaN;
         var paddingTop:Number = NaN;
         var labelWidth:Number = NaN;
         var vm:EdgeMetrics = null;
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         if(Boolean(this.labelObj))
         {
            indicatorGap = Number(getStyle("indicatorGap"));
            paddingTop = Number(getStyle("paddingTop"));
            labelWidth = Number(width);
            this.labelObj.move(this.getLabelWidth() + indicatorGap,paddingTop);
            if(Boolean(parent) && parent is Form)
            {
               vm = Form(parent).viewMetricsAndPadding;
               labelWidth = parent.width - (this.getLabelWidth() + indicatorGap + vm.left + vm.right);
            }
            this.labelObj.setActualSize(labelWidth,height);
         }
      }
      
      private function createLabel() : void
      {
         if(Boolean(this._label) && this._label.length > 0)
         {
            if(!this.labelObj)
            {
               this.labelObj = new Label();
               this.labelObj.styleName = this;
               addChild(this.labelObj);
            }
            if(this.labelObj.text != this._label)
            {
               this.labelObj.text = this._label;
               this.labelObj.validateSize();
               invalidateSize();
               invalidateDisplayList();
            }
         }
         if((this._label == null || this._label.length == 0) && Boolean(this.labelObj))
         {
            removeChild(this.labelObj);
            this.labelObj = null;
            invalidateSize();
            invalidateDisplayList();
         }
      }
      
      private function getLabelWidth() : Number
      {
         var labelWidth:Number = Number(getStyle("labelWidth"));
         if(labelWidth == 0)
         {
            labelWidth = NaN;
         }
         if(isNaN(labelWidth) && parent is Form)
         {
            labelWidth = Form(parent).calculateLabelWidth();
         }
         if(isNaN(labelWidth))
         {
            labelWidth = 0;
         }
         return labelWidth;
      }
   }
}

