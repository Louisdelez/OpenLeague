package mx.rpc.xml
{
   import flash.events.EventDispatcher;
   import mx.rpc.AsyncToken;
   import mx.rpc.events.FaultEvent;
   import mx.rpc.events.ResultEvent;
   import mx.rpc.events.XMLLoadEvent;
   import mx.rpc.http.HTTPService;
   import mx.utils.URLUtil;
   
   [ExcludeClass]
   [Event(name="xmlLoad",type="mx.rpc.events.XMLLoadEvent")]
   [Event(name="fault",type="mx.rpc.events.FaultEvent")]
   public class XMLLoader extends EventDispatcher
   {
      
      protected var loader:HTTPService;
      
      public var loadsOutstanding:int;
      
      public function XMLLoader(httpService:HTTPService = null)
      {
         super();
         this.initializeService(httpService);
      }
      
      public function load(url:String) : void
      {
         url = this.getQualifiedLocation(url);
         this.internalLoad(url);
      }
      
      protected function initializeService(httpService:HTTPService = null) : void
      {
         this.loader = new HTTPService();
         if(httpService != null)
         {
            this.loader.asyncRequest = httpService.asyncRequest;
            if(httpService.destination != null)
            {
               this.loader.destination = httpService.destination;
            }
            this.loader.useProxy = httpService.useProxy;
            this.loader.rootURL = httpService.rootURL;
            this.loader.headers = httpService.headers;
         }
         this.loader.addEventListener(ResultEvent.RESULT,this.resultHandler);
         this.loader.addEventListener(FaultEvent.FAULT,this.faultHandler);
         this.loader.resultFormat = HTTPService.RESULT_FORMAT_E4X;
      }
      
      protected function internalLoad(location:String) : AsyncToken
      {
         ++this.loadsOutstanding;
         this.loader.url = location;
         var token:AsyncToken = this.loader.send();
         if(token != null)
         {
            token.location = location;
         }
         return token;
      }
      
      protected function getQualifiedLocation(location:String, parentLocation:String = null) : String
      {
         if(parentLocation != null)
         {
            location = URLUtil.getFullURL(parentLocation,location);
         }
         else
         {
            location = URLUtil.getFullURL(this.loader.rootURL,location);
         }
         return location;
      }
      
      protected function faultHandler(event:FaultEvent) : void
      {
         --this.loadsOutstanding;
         dispatchEvent(event);
      }
      
      protected function resultHandler(event:ResultEvent) : void
      {
         --this.loadsOutstanding;
         var xml:XML = XML(event.result);
         var token:AsyncToken = event.token;
         var location:String = token == null ? null : token.location;
         var xmlLoadEvent:XMLLoadEvent = XMLLoadEvent.createEvent(xml,location);
         dispatchEvent(xmlLoadEvent);
      }
   }
}

