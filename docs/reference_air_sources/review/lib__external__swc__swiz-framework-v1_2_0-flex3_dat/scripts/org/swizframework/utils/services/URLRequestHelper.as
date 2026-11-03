package org.swizframework.utils.services
{
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import org.swizframework.core.ISwiz;
   import org.swizframework.core.ISwizAware;
   
   public class URLRequestHelper implements IURLRequestHelper, ISwizAware
   {
      
      protected var _swiz:ISwiz;
      
      public function URLRequestHelper()
      {
         super();
      }
      
      public function set swiz(swiz:ISwiz) : void
      {
         this._swiz = swiz;
      }
      
      public function executeURLRequest(request:URLRequest, resultHandler:Function, faultHandler:Function = null, progressHandler:Function = null, httpStatusHandler:Function = null, handlerArgs:Array = null) : URLLoader
      {
         if(faultHandler == null && this._swiz.config.defaultFaultHandler != null)
         {
            faultHandler = this._swiz.config.defaultFaultHandler;
         }
         return new SwizURLRequest(request,resultHandler,faultHandler,progressHandler,httpStatusHandler,handlerArgs).loader;
      }
   }
}

