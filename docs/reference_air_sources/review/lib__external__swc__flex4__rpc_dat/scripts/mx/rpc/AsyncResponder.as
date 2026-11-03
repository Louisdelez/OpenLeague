package mx.rpc
{
   public class AsyncResponder implements IResponder
   {
      
      private var _resultHandler:Function;
      
      private var _faultHandler:Function;
      
      private var _token:Object;
      
      public function AsyncResponder(result:Function, fault:Function, token:Object = null)
      {
         super();
         this._resultHandler = result;
         this._faultHandler = fault;
         this._token = token;
      }
      
      public function result(data:Object) : void
      {
         this._resultHandler(data,this._token);
      }
      
      public function fault(info:Object) : void
      {
         this._faultHandler(info,this._token);
      }
   }
}

