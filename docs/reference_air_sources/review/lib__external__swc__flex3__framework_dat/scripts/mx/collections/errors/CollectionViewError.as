package mx.collections.errors
{
   import mx.core.mx_internal;
   
   use namespace mx_internal;
   
   public class CollectionViewError extends Error
   {
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      public function CollectionViewError(message:String)
      {
         super(message);
      }
   }
}

