package mx.rpc.events
{
   import flash.events.Event;
   import mx.messaging.messages.IMessage;
   import mx.rpc.AsyncToken;
   
   public class HeaderEvent extends AbstractEvent
   {
      
      public static const HEADER:String = "header";
      
      private var _header:Object;
      
      public function HeaderEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = true, header:Object = null, token:AsyncToken = null, message:IMessage = null)
      {
         super(type,bubbles,cancelable,token,message);
         this._header = header;
      }
      
      public static function createEvent(header:Object, token:AsyncToken, message:IMessage) : HeaderEvent
      {
         return new HeaderEvent(HeaderEvent.HEADER,false,true,header,token,message);
      }
      
      public function get header() : Object
      {
         return this._header;
      }
      
      override public function clone() : Event
      {
         return new HeaderEvent(type,bubbles,cancelable,this.header,token,message);
      }
      
      override public function toString() : String
      {
         return formatToString("HeaderEvent","type","bubbles","cancelable","eventPhase");
      }
   }
}

