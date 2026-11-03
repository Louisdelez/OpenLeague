package mx.collections
{
   import mx.core.mx_internal;
   
   use namespace mx_internal;
   
   public class ItemWrapper
   {
      
      mx_internal static const VERSION:String = "4.6.0.23201";
      
      public var data:Object;
      
      public function ItemWrapper(data:Object)
      {
         super();
         this.data = data;
      }
   }
}

