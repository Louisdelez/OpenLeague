package mx.rpc
{
   public class AsyncResponder implements IResponder
   {
      
      private var _faultHandler:Function;
      
      private var _token:Object;
      
      private var _resultHandler:Function;
      
      public function AsyncResponder(result:Function, fault:Function, token:Object = null)
      {
         super();
         _resultHandler = result;
         _faultHandler = fault;
         _token = token;
      }
      
      public function result(data:Object) : void
      {
         _resultHandler(data,_token);
      }
      
      public function fault(info:Object) : void
      {
         _faultHandler(info,_token);
      }
   }
}

