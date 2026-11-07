package mx.rpc
{
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   import mx.rpc.events.AbstractEvent;
   
   [ResourceBundle("rpc")]
   [Event(name="fault",type="mx.rpc.events.FaultEvent")]
   [Event(name="result",type="mx.rpc.events.ResultEvent")]
   public class AbstractOperation extends AbstractInvoker
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _service:AbstractService;
      
      private var _name:String;
      
      public var properties:Object;
      
      public var arguments:Object;
      
      private var resourceManager:IResourceManager = ResourceManager.getInstance();
      
      public function AbstractOperation(service:AbstractService = null, name:String = null)
      {
         super();
         _service = service;
         _name = name;
         this.arguments = {};
      }
      
      public function send(... args) : AsyncToken
      {
         return null;
      }
      
      public function get name() : String
      {
         return _name;
      }
      
      override §§namespace("http://www.adobe.com/2006/flex/mx/internal") function dispatchRpcEvent(event:AbstractEvent) : void
      {
         event.callTokenResponders();
         if(!event.isDefaultPrevented())
         {
            if(hasEventListener(event.type))
            {
               dispatchEvent(event);
            }
            else if(_service != null)
            {
               _service.dispatchEvent(event);
            }
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function setService(s:AbstractService) : void
      {
         var message:String = null;
         if(!_service)
         {
            _service = s;
            return;
         }
         message = resourceManager.getString("rpc","cannotResetService");
         throw new Error(message);
      }
      
      public function get service() : AbstractService
      {
         return _service;
      }
      
      public function set name(n:String) : void
      {
         var message:String = null;
         if(!_name)
         {
            _name = n;
            return;
         }
         message = resourceManager.getString("rpc","cannotResetOperationName");
         throw new Error(message);
      }
   }
}

