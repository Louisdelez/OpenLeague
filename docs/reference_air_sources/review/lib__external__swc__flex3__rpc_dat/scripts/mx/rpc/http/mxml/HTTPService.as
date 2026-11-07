package mx.rpc.http.mxml
{
   import flash.events.ErrorEvent;
   import mx.core.IMXMLObject;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   import mx.rpc.events.AbstractEvent;
   import mx.rpc.events.FaultEvent;
   import mx.rpc.http.HTTPService;
   import mx.rpc.mxml.IMXMLSupport;
   
   [ResourceBundle("rpc")]
   public class HTTPService extends mx.rpc.http.HTTPService implements IMXMLSupport, IMXMLObject
   {
      
      private var id:String;
      
      private var document:Object;
      
      private var resourceManager:IResourceManager = ResourceManager.getInstance();
      
      public function HTTPService(rootURL:String = null, destination:String = null)
      {
         super(rootURL,destination);
      }
      
      override §§namespace("http://www.adobe.com/2006/flex/mx/internal") function dispatchRpcEvent(event:AbstractEvent) : void
      {
         var evt:ErrorEvent = null;
         event.callTokenResponders();
         if(!event.isDefaultPrevented())
         {
            if(hasEventListener(event.type))
            {
               dispatchEvent(event);
            }
            else if(event is FaultEvent && (event.token == null || !event.token.hasResponder()))
            {
               if(!(Boolean(document) && Boolean(document.willTrigger(ErrorEvent.ERROR))))
               {
                  monitorRpcEvent(event);
                  throw FaultEvent(event).fault;
               }
               evt = new ErrorEvent(ErrorEvent.ERROR,true,true);
               evt.text = FaultEvent(event).fault.faultString;
               document.dispatchEvent(evt);
            }
            monitorRpcEvent(event);
         }
      }
      
      public function initialized(document:Object, id:String) : void
      {
         this.id = id;
         this.document = document;
      }
   }
}

