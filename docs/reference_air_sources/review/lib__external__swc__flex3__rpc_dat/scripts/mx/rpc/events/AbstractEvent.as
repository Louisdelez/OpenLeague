package mx.rpc.events
{
   import mx.messaging.events.MessageEvent;
   import mx.messaging.messages.IMessage;
   import mx.rpc.AsyncToken;
   
   public class AbstractEvent extends MessageEvent
   {
      
      private var _token:AsyncToken;
      
      public function AbstractEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = true, token:AsyncToken = null, message:IMessage = null)
      {
         super(type,bubbles,cancelable,message);
         _token = token;
      }
      
      public function get token() : AsyncToken
      {
         return _token;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function callTokenResponders() : void
      {
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function setToken(t:AsyncToken) : void
      {
         _token = t;
      }
   }
}

