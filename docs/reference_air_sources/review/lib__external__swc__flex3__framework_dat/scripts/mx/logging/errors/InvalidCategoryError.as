package mx.logging.errors
{
   import mx.core.mx_internal;
   
   use namespace mx_internal;
   
   public class InvalidCategoryError extends Error
   {
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      public function InvalidCategoryError(message:String)
      {
         super(message);
      }
      
      public function toString() : String
      {
         return String(message);
      }
   }
}

