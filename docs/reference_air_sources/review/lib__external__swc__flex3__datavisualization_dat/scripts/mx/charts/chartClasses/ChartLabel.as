package mx.charts.chartClasses
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import mx.charts.AxisLabel;
   import mx.charts.AxisRenderer;
   import mx.core.FlexBitmap;
   import mx.core.IDataRenderer;
   import mx.core.IUITextField;
   import mx.core.UIComponent;
   import mx.core.UITextField;
   
   public class ChartLabel extends UIComponent implements IDataRenderer
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "3.0.0.0";
      
      private static var ORIGIN:Point = new Point(0,0);
      
      private static var X_UNIT:Point = new Point(1,0);
      
      private var _data:Object;
      
      private var _text:String;
      
      private var _bitmap:Bitmap;
      
      private var _label:IUITextField;
      
      private var _capturedText:BitmapData;
      
      public function ChartLabel()
      {
         super();
      }
      
      override protected function measure() : void
      {
         var oldRotation:Number = Number(rotation);
         if(Boolean(parent) && parent.rotation == 90)
         {
            rotation = -90;
         }
         _label.validateNow();
         if(_label.embedFonts)
         {
            measuredWidth = _label.measuredWidth + 6;
            measuredHeight = _label.measuredHeight + UITextField.TEXT_HEIGHT_PADDING;
         }
         else
         {
            measuredWidth = _label.textWidth + 6;
            measuredHeight = _label.textHeight + UITextField.TEXT_HEIGHT_PADDING;
         }
         rotation = oldRotation;
      }
      
      override public function invalidateSize() : void
      {
         super.invalidateSize();
      }
      
      [Inspectable(environment="none")]
      public function get data() : Object
      {
         return _data;
      }
      
      override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         var localX:Point = null;
         var localO:Point = null;
         var p:AxisRenderer = null;
         if(Boolean(parent && parent is AxisRenderer) && Boolean(parent.rotation == 90) && _label.embedFonts == true)
         {
            p = AxisRenderer(parent);
            if(p.getStyle("verticalAxisTitleAlignment") == "vertical")
            {
               _label.rotation = 180;
               _label.y += _label.height;
               _label.x += _label.width;
            }
         }
         _label.validateNow();
         _label.setActualSize(unscaledWidth,unscaledHeight);
         var useLabel:Boolean = true;
         if(_label.embedFonts == false && unscaledWidth > 0 && unscaledHeight > 0)
         {
            localX = globalToLocal(X_UNIT);
            localO = globalToLocal(ORIGIN);
            useLabel = localX.x - localO.x == 1 && localX.y - localO.y == 0;
         }
         if(useLabel)
         {
            if(Boolean(_bitmap))
            {
               removeChild(_bitmap);
               _bitmap = null;
            }
            _label.visible = true;
         }
         else
         {
            _label.visible = false;
            if(!_capturedText || _capturedText.width != unscaledWidth || _capturedText.height != unscaledHeight)
            {
               _capturedText = new BitmapData(unscaledWidth,unscaledHeight);
               if(Boolean(_bitmap))
               {
                  removeChild(_bitmap);
                  _bitmap = null;
               }
            }
            if(!_bitmap)
            {
               _bitmap = new FlexBitmap(_capturedText);
               _bitmap.smoothing = true;
               addChild(_bitmap);
            }
            _capturedText.fillRect(new Rectangle(0,0,unscaledWidth,unscaledHeight),0);
            _capturedText.draw(_label);
            if(Boolean(parent) && Boolean(parent.rotation == 90) && parent is AxisRenderer)
            {
               p = AxisRenderer(parent);
               if(p.getStyle("verticalAxisTitleAlignment") == "vertical")
               {
                  _bitmap.rotation = 180;
                  _bitmap.y = _label.x + _bitmap.height;
                  _bitmap.x = _label.y + _bitmap.width;
               }
            }
         }
      }
      
      public function set data(value:Object) : void
      {
         if(value == _data)
         {
            return;
         }
         _data = value;
         if(value is AxisLabel)
         {
            _text = AxisLabel(value).text;
         }
         else if(value is String)
         {
            _text = String(value);
         }
         _label.text = _text == null ? "" : _text;
         invalidateSize();
         invalidateDisplayList();
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         _label = IUITextField(createInFontContext(UITextField));
         _label.multiline = true;
         _label.selectable = false;
         _label.autoSize = "left";
         _label.styleName = this;
         addChild(DisplayObject(_label));
      }
   }
}

