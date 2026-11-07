package mx.rpc
{
   import flash.events.EventDispatcher;
   import mx.events.PropertyChangeEvent;
   import mx.rpc.events.FaultEvent;
   import mx.rpc.events.ResultEvent;
   import mx.utils.ArrayUtil;
   
   [Event(name="fault",type="mx.rpc.events.FaultEvent")]
   [Event(name="result",type="mx.rpc.events.ResultEvent")]
   public class CallResponder extends EventDispatcher implements IResponder
   {
      
      private var _1897299539lastResult:*;
      
      private var _token:AsyncToken;
      
      public function CallResponder()
      {
         super();
      }
      
      private function set _110541305token(t:AsyncToken) : void
      {
         var resps:Array = null;
         var ix:int = 0;
         if(_token != null)
         {
            resps = _token.responders;
            ix = int(ArrayUtil.getItemIndex(this,resps));
            if(ix != -1)
            {
               resps.splice(ix,1);
            }
         }
         if(t != null)
         {
            t.addResponder(this);
         }
         _token = t;
      }
      
      public function set lastResult(value:*) : void
      {
         var oldValue:Object = this._1897299539lastResult;
         if(oldValue !== value)
         {
            this._1897299539lastResult = value;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"lastResult",oldValue,value));
         }
      }
      
      public function fault(data:Object) : void
      {
         var faultEvent:FaultEvent = FaultEvent(data);
         dispatchEvent(faultEvent);
      }
      
      public function result(data:Object) : void
      {
         var resultEvent:ResultEvent = ResultEvent(data);
         lastResult = resultEvent.result;
         dispatchEvent(resultEvent);
      }
      
      [Bindable(event="propertyChange")]
      public function set token(value:AsyncToken) : void
      {
         var oldValue:Object = this.token;
         if(oldValue !== value)
         {
            this._110541305token = value;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"token",oldValue,value));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get lastResult() : *
      {
         return this._1897299539lastResult;
      }
      
      public function get token() : AsyncToken
      {
         return _token;
      }
   }
}

