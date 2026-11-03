package mx.logging.targets
{
   import mx.core.mx_internal;
   
   use namespace mx_internal;
   
   public class TraceTarget extends LineFormattedTarget
   {
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      public function TraceTarget()
      {
         super();
      }
      
      override mx_internal function internalLog(message:String) : void
      {
         trace(message);
      }
   }
}

