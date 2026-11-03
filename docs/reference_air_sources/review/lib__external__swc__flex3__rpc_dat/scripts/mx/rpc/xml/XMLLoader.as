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
         initializeService(httpService);
      }
      
      protected function internalLoad(location:String) : AsyncToken
      {
         ++loadsOutstanding;
         loader.url = location;
         var token:AsyncToken = loader.send();
         if(token != null)
         {
            token.location = location;
         }
         return token;
      }
      
      protected function initializeService(httpService:HTTPService = null) : void
      {
         loader = new HTTPService();
         if(httpService != null)
         {
            loader.asyncRequest = httpService.asyncRequest;
            if(httpService.destination != null)
            {
               loader.destination = httpService.destination;
            }
            loader.useProxy = httpService.useProxy;
            loader.rootURL = httpService.rootURL;
            loader.headers = httpService.headers;
         }
         loader.addEventListener(ResultEvent.RESULT,resultHandler);
         loader.addEventListener(FaultEvent.FAULT,faultHandler);
         loader.resultFormat = HTTPService.RESULT_FORMAT_E4X;
      }
      
      public function load(url:String) : void
      {
         url = getQualifiedLocation(url);
         internalLoad(url);
      }
      
      protected function faultHandler(event:FaultEvent) : void
      {
         --loadsOutstanding;
         dispatchEvent(event);
      }
      
      protected function getQualifiedLocation(location:String, parentLocation:String = null) : String
      {
         if(parentLocation != null)
         {
            location = URLUtil.getFullURL(parentLocation,location);
         }
         else
         {
            location = URLUtil.getFullURL(loader.rootURL,location);
         }
         return location;
      }
      
      protected function resultHandler(event:ResultEvent) : void
      {
         --loadsOutstanding;
         var xml:XML = XML(event.result);
         var token:AsyncToken = event.token;
         var location:String = token == null ? null : token.location;
         var xmlLoadEvent:XMLLoadEvent = XMLLoadEvent.createEvent(xml,location);
         dispatchEvent(xmlLoadEvent);
      }
   }
}

