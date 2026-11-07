package blix.action
{
   import flash.events.ErrorEvent;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.SecurityErrorEvent;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   
   public class UrlLoaderAction extends BasicAction
   {
      
      public var unmarshallDataFunction:Function;
      
      public var unmarshalledData:*;
      
      public var data:*;
      
      public var unmarshallErrorFunction:Function;
      
      public var urlRequest:URLRequest;
      
      public var dataFormat:String;
      
      protected var _urlLoader:URLLoader;
      
      public function UrlLoaderAction(param1:URLRequest = null, param2:String = null, param3:Boolean = false)
      {
         super(param3);
         this._urlLoader = new URLLoader();
         this._urlLoader.addEventListener(Event.COMPLETE,this.completedHandler);
         this._urlLoader.addEventListener(IOErrorEvent.IO_ERROR,this.erredHandler);
         this._urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.erredHandler);
         this.urlRequest = param1;
         this.dataFormat = param2;
      }
      
      public function getUrlLoader() : URLLoader
      {
         return this._urlLoader;
      }
      
      override protected function doInvocation() : void
      {
         if(this.urlRequest == null)
         {
            err(new Error("urlRequest not set."));
            return;
         }
         this._urlLoader.dataFormat = this.dataFormat;
         this._urlLoader.load(this.urlRequest);
      }
      
      protected function completedHandler(param1:Event) : void
      {
         var event:Event = param1;
         this.data = this._urlLoader.data;
         if(this.unmarshallDataFunction != null)
         {
            try
            {
               this.unmarshalledData = this.unmarshallDataFunction(this.data);
            }
            catch(error:Error)
            {
               err(error);
               return;
            }
         }
         complete();
      }
      
      protected function erredHandler(param1:ErrorEvent) : void
      {
         var _loc2_:Error = null;
         this.data = this._urlLoader.data;
         if(this.unmarshallErrorFunction != null)
         {
            try
            {
               _loc2_ = this.unmarshallErrorFunction(this.data);
               if(_loc2_ != null)
               {
                  err(_loc2_);
                  return;
               }
            }
            catch(error:Error)
            {
            }
         }
         err(new Error(param1.text));
      }
      
      override public function abort() : void
      {
         if(getIsFinished())
         {
            return;
         }
         if(_hasBeenInvoked)
         {
            this._urlLoader.close();
         }
         super.abort();
      }
   }
}

