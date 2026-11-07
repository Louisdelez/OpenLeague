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
      
      private var _token:AsyncToken;
      
      private var _1897299539lastResult:*;
      
      public function CallResponder()
      {
         super();
      }
      
      private function set _110541305token(t:AsyncToken) : void
      {
         var resps:Array = null;
         var ix:int = 0;
         if(this._token != null)
         {
            resps = this._token.responders;
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
         this._token = t;
      }
      
      public function get token() : AsyncToken
      {
         return this._token;
      }
      
      public function result(data:Object) : void
      {
         var resultEvent:ResultEvent = ResultEvent(data);
         this.lastResult = resultEvent.result;
         dispatchEvent(resultEvent);
      }
      
      public function fault(data:Object) : void
      {
         var faultEvent:FaultEvent = FaultEvent(data);
         dispatchEvent(faultEvent);
      }
      
      [Bindable(event="propertyChange")]
      public function get lastResult() : *
      {
         return this._1897299539lastResult;
      }
      
      public function set lastResult(param1:*) : void
      {
         var _loc3_:Object = this._1897299539lastResult;
         if(_loc3_ !== param1)
         {
            this._1897299539lastResult = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"lastResult",_loc3_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function set token(param1:AsyncToken) : void
      {
         var _loc3_:Object = this.token;
         if(_loc3_ !== param1)
         {
            this._110541305token = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"token",_loc3_,param1));
            }
         }
      }
   }
}

