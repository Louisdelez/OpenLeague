package mx.charts.chartClasses
{
   import flash.geom.Point;
   
   public class PolarTransform extends DataTransform
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "3.0.0.0";
      
      public static const RADIAL_AXIS:String = "r";
      
      public static const ANGULAR_AXIS:String = "a";
      
      private static const TWO_PI:Number = 2 * Math.PI;
      
      private var _radius:Number;
      
      private var _origin:Point;
      
      public function PolarTransform()
      {
         super();
      }
      
      [Inspectable(environment="none")]
      public function get origin() : Point
      {
         return _origin;
      }
      
      [Inspectable(environment="none")]
      public function get radius() : Number
      {
         return _radius;
      }
      
      public function setSize(width:Number, height:Number) : void
      {
         _radius = Math.min(width / 2,height / 2);
         _origin = new Point(width / 2,height / 2);
      }
      
      override public function invertTransform(... values) : Array
      {
         var result:Array = [];
         if(values.length > 0 && values[0] != null)
         {
            result[0] = getAxis(ANGULAR_AXIS).invertTransform(values[0] / TWO_PI);
         }
         if(values.length > 1 && values[1] != null)
         {
            result[1] = getAxis(RADIAL_AXIS).invertTransform(values[1] / _radius);
         }
         return result;
      }
      
      override public function transformCache(cache:Array, aField:String, aConvertedField:String, rField:String, rConvertedField:String) : void
      {
         var i:int = 0;
         var v:Object = null;
         if(aField != null)
         {
            getAxis(ANGULAR_AXIS).transformCache(cache,aField,aConvertedField);
            for(i = 0; i < cache.length; i++)
            {
               v = cache[i][aConvertedField];
               if(v != null)
               {
                  cache[i][aConvertedField] = Number(v) * TWO_PI;
               }
            }
         }
         if(rField != null)
         {
            getAxis(RADIAL_AXIS).transformCache(cache,rField,rConvertedField);
            for(i = 0; i < cache.length; i++)
            {
               v = cache[i][rConvertedField];
               if(v != null)
               {
                  cache[i][rConvertedField] = Number(v) * _radius;
               }
            }
         }
      }
   }
}

