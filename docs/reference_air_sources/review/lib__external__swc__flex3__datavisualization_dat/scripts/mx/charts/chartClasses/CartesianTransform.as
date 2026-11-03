package mx.charts.chartClasses
{
   public class CartesianTransform extends DataTransform
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "3.0.0.0";
      
      public static const HORIZONTAL_AXIS:String = "h";
      
      public static const VERTICAL_AXIS:String = "v";
      
      private var _height:Number = 0;
      
      private var _width:Number = 0;
      
      public function CartesianTransform()
      {
         super();
      }
      
      [Inspectable(environment="none")]
      public function set pixelWidth(value:Number) : void
      {
         _width = value;
      }
      
      override public function transformCache(cache:Array, xField:String, xConvertedField:String, yField:String, yConvertedField:String) : void
      {
         var c:Object = null;
         var w:Number = _width;
         var h:Number = _height;
         var len:uint = cache.length;
         if(len == 0)
         {
            return;
         }
         if(Boolean(xField) && xField != "")
         {
            axes[HORIZONTAL_AXIS].transformCache(cache,xField,xConvertedField);
         }
         if(Boolean(yField) && yField != "")
         {
            axes[VERTICAL_AXIS].transformCache(cache,yField,yConvertedField);
         }
         var i:int = len - 1;
         if(Boolean(xConvertedField && xConvertedField.length) && Boolean(yConvertedField) && Boolean(yConvertedField.length))
         {
            do
            {
               c = cache[i];
               c[xConvertedField] *= w;
               c[yConvertedField] = (1 - c[yConvertedField]) * h;
               i--;
            }
            while(i >= 0);
         }
         else if(Boolean(xConvertedField) && Boolean(xConvertedField.length))
         {
            do
            {
               c = cache[i];
               c[xConvertedField] *= w;
               i--;
            }
            while(i >= 0);
         }
         else
         {
            do
            {
               c = cache[i];
               c[yConvertedField] = (1 - c[yConvertedField]) * h;
               i--;
            }
            while(i >= 0);
         }
      }
      
      [Inspectable(environment="none")]
      public function set pixelHeight(value:Number) : void
      {
         _height = value;
      }
      
      override public function invertTransform(... values) : Array
      {
         var xPos:Number = values[0] / _width;
         var yPos:Number = 1 - values[1] / _height;
         var xValue:Object = axes[HORIZONTAL_AXIS].invertTransform(xPos);
         var yValue:Object = axes[VERTICAL_AXIS].invertTransform(yPos);
         return [xValue,yValue];
      }
   }
}

