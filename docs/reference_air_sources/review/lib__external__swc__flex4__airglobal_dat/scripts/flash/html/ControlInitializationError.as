package flash.html
{
   public class ControlInitializationError extends Error
   {
      
      public function ControlInitializationError()
      {
         super("HTMLLoader failed to initialize");
      }
   }
}

