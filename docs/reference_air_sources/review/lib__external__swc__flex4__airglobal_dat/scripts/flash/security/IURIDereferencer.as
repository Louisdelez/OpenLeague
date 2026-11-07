package flash.security
{
   import flash.utils.IDataInput;
   
   [API("661")]
   public interface IURIDereferencer
   {
      
      function dereference(param1:String) : IDataInput;
   }
}

