package mx.olap
{
   public class OLAPTrace
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "3.0.0.0";
      
      public static var traceOn:Boolean = true;
      
      public static var traceLevel:int = 1;
      
      public static const TRACE_LEVEL_1:int = 1;
      
      public static const TRACE_LEVEL_2:int = 2;
      
      public static const TRACE_LEVEL_3:int = 3;
      
      public function OLAPTrace()
      {
         super();
      }
      
      public static function traceMsg(msg:String, level:int = 1) : void
      {
         if(traceOn && level <= traceLevel)
         {
            trace(msg);
         }
      }
   }
}

