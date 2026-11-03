package org.swizframework.utils.services
{
   import mx.rpc.AsyncToken;
   import org.swizframework.core.ISwiz;
   import org.swizframework.core.ISwizAware;
   
   public class ServiceHelper implements IServiceHelper, ISwizAware
   {
      
      protected var _swiz:ISwiz;
      
      public function ServiceHelper()
      {
         super();
      }
      
      public function set swiz(swiz:ISwiz) : void
      {
         this._swiz = swiz;
      }
      
      public function executeServiceCall(call:AsyncToken, resultHandler:Function, faultHandler:Function = null, handlerArgs:Array = null) : AsyncToken
      {
         if(faultHandler == null && this._swiz != null && this._swiz.config.defaultFaultHandler != null)
         {
            faultHandler = this._swiz.config.defaultFaultHandler;
         }
         call.addResponder(new SwizResponder(resultHandler,faultHandler,handlerArgs));
         return call;
      }
   }
}

