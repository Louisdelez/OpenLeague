package spark.layouts.supportClasses
{
   [ExcludeClass]
   public class LayoutElementHelper
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      public function LayoutElementHelper()
      {
         super();
      }
      
      public static function pinBetween(val:Number, min:Number, max:Number) : Number
      {
         return Math.min(max,Math.max(min,val));
      }
      
      public static function parseConstraintValue(value:Object) : Number
      {
         if(value is Number)
         {
            return Number(value);
         }
         var str:String = value as String;
         if(!str)
         {
            return NaN;
         }
         var result:Array = parseConstraintExp(str);
         return result[0];
      }
      
      public static function parseConstraintExp(val:Object) : Array
      {
         if(val is Number)
         {
            return [Number(val),null];
         }
         if(!val)
         {
            return [NaN,null];
         }
         var temp:String = String(val).replace(/:/g," ");
         var args:Array = temp.split(/\s+/);
         if(args.length == 1)
         {
            return args;
         }
         return [args[1],args[0]];
      }
   }
}

