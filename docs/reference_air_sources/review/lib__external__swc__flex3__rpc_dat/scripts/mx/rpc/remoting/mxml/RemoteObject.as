package mx.rpc.remoting.mxml
{
   import flash.events.ErrorEvent;
   import flash.events.Event;
   import mx.core.IMXMLObject;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   import mx.rpc.AbstractOperation;
   import mx.rpc.events.FaultEvent;
   import mx.rpc.mxml.IMXMLSupport;
   import mx.rpc.remoting.RemoteObject;
   
   [ResourceBundle("rpc")]
   public dynamic class RemoteObject extends mx.rpc.remoting.RemoteObject implements IMXMLSupport, IMXMLObject
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var document:Object;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var id:String;
      
      private var resourceManager:IResourceManager = ResourceManager.getInstance();
      
      public function RemoteObject(destination:String = null)
      {
         super(destination);
      }
      
      override public function dispatchEvent(event:Event) : Boolean
      {
         var reason:String = null;
         var evt:ErrorEvent = null;
         var message:String = null;
         if(hasEventListener(event.type))
         {
            return super.dispatchEvent(event);
         }
         if(event is FaultEvent && !hasTokenResponders(event) || event is ErrorEvent)
         {
            reason = event is FaultEvent ? FaultEvent(event).fault.faultString : ErrorEvent(event).text;
            if(Boolean(document) && Boolean(document.willTrigger(ErrorEvent.ERROR)))
            {
               evt = new ErrorEvent(ErrorEvent.ERROR,true,true);
               evt.text = reason;
               return document.dispatchEvent(evt);
            }
            if(event is FaultEvent)
            {
               throw FaultEvent(event).fault;
            }
            message = resourceManager.getString("rpc","noListenerForEvent",[reason]);
            throw new Error(message);
         }
         return false;
      }
      
      override public function getOperation(name:String) : AbstractOperation
      {
         var o:Object = _operations[name];
         var op:AbstractOperation = o is AbstractOperation ? AbstractOperation(o) : null;
         if(op == null)
         {
            op = new Operation(this,name);
            _operations[name] = op;
            op.asyncRequest = asyncRequest;
         }
         return op;
      }
      
      public function initialized(document:Object, id:String) : void
      {
         this.document = document;
         this.id = id;
         initialize();
      }
   }
}

