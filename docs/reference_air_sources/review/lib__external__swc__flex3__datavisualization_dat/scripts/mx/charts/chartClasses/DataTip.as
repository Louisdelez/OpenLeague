package mx.charts.chartClasses
{
   import flash.display.DisplayObject;
   import flash.display.Graphics;
   import flash.geom.Rectangle;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import mx.charts.HitData;
   import mx.charts.styles.HaloDefaults;
   import mx.core.IDataRenderer;
   import mx.core.IUITextField;
   import mx.core.UIComponent;
   import mx.core.UITextField;
   import mx.graphics.IFill;
   import mx.graphics.SolidColor;
   import mx.graphics.Stroke;
   import mx.styles.CSSStyleDeclaration;
   
   [Style(name="shadowColor",type="uint",format="Color",inherit="yes")]
   [Style(name="paddingTop",type="Number",format="Length",inherit="no")]
   [Style(name="paddingBottom",type="Number",format="Length",inherit="no")]
   [Style(name="borderStyle",type="String",enumeration="inset,outset,solid,none",inherit="no")]
   [Style(name="borderColor",type="uint",format="Color",inherit="no")]
   [Style(name="backgroundColor",type="uint",format="Color",inherit="no")]
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
   [Event(name="show",type="mx.events.FlexEvent")]
   [Event(name="hide",type="mx.events.FlexEvent")]
   public class DataTip extends UIComponent implements IDataRenderer
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "3.0.0.0";
      
      private static var stylesInited:Boolean = initStyles();
      
      [Inspectable(environment="none")]
      public static var maxTipWidth:Number = 300;
      
      private var _labelHeight:Number;
      
      private var _labelWidth:Number;
      
      private var _format:TextFormat;
      
      private var _hitData:HitData;
      
      private var _shadowFill:IFill = IFill(new SolidColor(11184810,0.55));
      
      private const HEX_DIGITS:String = "0123456789ABCDEF";
      
      private var _label:IUITextField;
      
      private var stroke:Stroke = new Stroke(0,0,1);
      
      public function DataTip()
      {
         super();
         mouseChildren = false;
         mouseEnabled = false;
      }
      
      private static function initStyles() : Boolean
      {
         var dtStyle:CSSStyleDeclaration;
         HaloDefaults.init();
         dtStyle = HaloDefaults.createSelector("DataTip");
         dtStyle.defaultFactory = function():void
         {
            this.backgroundColor = 16777215;
         };
         return true;
      }
      
      private function decToColor(v:Number) : String
      {
         var str:String = "#";
         for(var i:int = 5; i >= 0; i--)
         {
            str += HEX_DIGITS.charAt(v >> i * 4 & 0x0F);
         }
         return str;
      }
      
      override protected function measure() : void
      {
         super.measure();
         var borderMetrics:Rectangle = new Rectangle(1,1,0,0);
         var leftInset:Number = borderMetrics.left + getStyle("paddingLeft");
         var topInset:Number = borderMetrics.top + getStyle("paddingTop");
         var rightInset:Number = borderMetrics.right + getStyle("paddingRight");
         var bottomInset:Number = borderMetrics.bottom + getStyle("paddingBottom");
         var widthSlop:Number = leftInset + rightInset;
         var heightSlop:Number = topInset + bottomInset;
         _label.wordWrap = false;
         if(_label.textWidth + widthSlop > DataTip.maxTipWidth)
         {
            _label.width = DataTip.maxTipWidth - widthSlop;
            _label.wordWrap = true;
            _label.width = _label.textWidth + widthSlop;
         }
         _labelWidth = _label.width + widthSlop;
         _labelHeight = _label.height + heightSlop;
         measuredWidth = _labelWidth + 6;
         measuredHeight = _labelHeight + 6;
      }
      
      public function set data(value:Object) : void
      {
         _hitData = HitData(value);
         stroke = new Stroke(_hitData.contextColor,0,100);
         setText(_hitData.displayText);
         invalidateDisplayList();
      }
      
      private function setText(t:String) : void
      {
         var _format:TextFormat = _label.getTextFormat();
         _format.leftMargin = 0;
         _format.rightMargin = 0;
         _label.defaultTextFormat = _format;
         _label.htmlText = t;
         invalidateSize();
      }
      
      override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         var g:Graphics = graphics;
         g.clear();
         var xpos:Number = 0;
         var ypos:Number = 0;
         g.moveTo(measuredWidth,2);
         _shadowFill.begin(g,new Rectangle(xpos,ypos,measuredWidth,measuredHeight));
         g.lineTo(measuredWidth + 2,2);
         g.lineTo(measuredWidth + 2,measuredHeight + 2);
         g.lineTo(2,measuredHeight + 2);
         g.lineTo(2,measuredHeight);
         g.lineTo(measuredWidth - 2,measuredHeight - 2);
         g.lineTo(measuredWidth - 2,2);
         _shadowFill.end(g);
         var fill:IFill = IFill(new SolidColor(getStyle("backgroundColor"),0.8));
         GraphicsUtilities.fillRect(g,xpos,ypos,measuredWidth,measuredHeight,fill,stroke);
         _label.x = xpos + getStyle("paddingLeft");
         _label.y = ypos + getStyle("paddingTop");
      }
      
      [Inspectable(environment="none")]
      public function get data() : Object
      {
         return _hitData;
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         if(!_label)
         {
            _label = IUITextField(createInFontContext(UITextField));
            _label.x = getStyle("paddingLeft");
            _label.y = getStyle("paddingTop");
            _label.autoSize = TextFieldAutoSize.LEFT;
            _label.selectable = false;
            _label.multiline = true;
            addChild(DisplayObject(_label));
         }
      }
   }
}

