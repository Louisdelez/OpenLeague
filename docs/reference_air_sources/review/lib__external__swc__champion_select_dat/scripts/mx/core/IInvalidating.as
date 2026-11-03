package mx.core
{
   public interface IInvalidating
   {
      
      function validateNow() : void;
      
      function invalidateDisplayList() : void;
      
      function invalidateSize() : void;
      
      function invalidateProperties() : void;
   }
}

