package mx.containers
{
   import flash.events.Event;
   import mx.controls.Label;
   import mx.core.EdgeMetrics;
   import mx.core.UIComponent;
   import mx.core.mx_internal;
   
   use namespace mx_internal;
   
   [IconFile("FormHeading.png")]
   [Style(name="paddingTop",type="Number",format="Length",inherit="no")]
   [Style(name="labelWidth",type="Number",format="Length",inherit="yes")]
   [Style(name="indicatorGap",type="Number",format="Length",inherit="yes")]
   [Style(name="textIndent",type="Number",format="Length",inherit="yes")]
   [Style(name="textDecoration",type="String",enumeration="none,underline",inherit="yes")]
   [Style(name="textAlign",type="String",enumeration="left,center,right",inherit="yes")]
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
   [Style(name="color",type="uint",format="Color",inherit="yes")]
   [Style(name="paddingRight",type="Number",format="Length",inherit="no")]
   [Style(name="paddingLeft",type="Number",format="Length",inherit="no")]
   [Style(name="leading",type="Number",format="Length",inherit="yes")]
   public class FormHeading extends UIComponent
   {
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      private var labelObj:Label;
      
      private var _label:String = "";
      
      public function FormHeading()
      {
         super();
      }
      
      private function getLabelWidth() : Number
      {
         var labelWidth:Number = getStyle("labelWidth");
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
      
      override protected function commitProperties() : void
      {
         super.commitProperties();
         createLabel();
      }
      
      [Inspectable(category="General",defaultValue="")]
      [Bindable("labelChanged")]
      public function get label() : String
      {
         return _label;
      }
      
      override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         var indicatorGap:Number = NaN;
         var paddingTop:Number = NaN;
         var labelWidth:Number = NaN;
         var vm:EdgeMetrics = null;
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         if(Boolean(labelObj))
         {
            indicatorGap = getStyle("indicatorGap");
            paddingTop = getStyle("paddingTop");
            labelWidth = width;
            labelObj.move(getLabelWidth() + indicatorGap,paddingTop);
            if(Boolean(parent) && parent is Form)
            {
               vm = Form(parent).viewMetricsAndPadding;
               labelWidth = parent.width - (getLabelWidth() + indicatorGap + vm.left + vm.right);
            }
            labelObj.setActualSize(labelWidth,height);
         }
      }
      
      public function set label(value:String) : void
      {
         _label = value;
         invalidateProperties();
         dispatchEvent(new Event("labelChanged"));
      }
      
      override protected function measure() : void
      {
         super.measure();
         var preferredWidth:Number = 0;
         var preferredHeight:Number = getStyle("paddingTop");
         if(Boolean(labelObj))
         {
            if(isNaN(labelObj.measuredWidth))
            {
               labelObj.validateSize();
            }
            preferredWidth = labelObj.measuredWidth;
            preferredHeight += labelObj.measuredHeight;
         }
         preferredWidth += getLabelWidth() + getStyle("indicatorGap");
         measuredMinWidth = preferredWidth;
         measuredMinHeight = preferredHeight;
         measuredWidth = preferredWidth;
         measuredHeight = preferredHeight;
      }
      
      private function createLabel() : void
      {
         if(Boolean(_label) && _label.length > 0)
         {
            if(!labelObj)
            {
               labelObj = new Label();
               labelObj.styleName = this;
               addChild(labelObj);
            }
            if(labelObj.text != _label)
            {
               labelObj.text = _label;
               labelObj.validateSize();
               invalidateSize();
               invalidateDisplayList();
            }
         }
         if((_label == null || _label.length == 0) && Boolean(labelObj))
         {
            removeChild(labelObj);
            labelObj = null;
            invalidateSize();
            invalidateDisplayList();
         }
      }
   }
}

