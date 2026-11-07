package flash.events
{
   public class HTTPStatusEvent extends Event
   {
      
      public static const HTTP_STATUS:String = "httpStatus";
      
      [API("661")]
      public static const HTTP_RESPONSE_STATUS:String = "httpResponseStatus";
      
      private var m_status:int;
      
      private var m_responseHeaders:Array;
      
      private var m_responseUrl:String;
      
      public function HTTPStatusEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, status:int = 0)
      {
         super(type,bubbles,cancelable);
         this.m_status = status;
         this.m_responseHeaders = [];
      }
      
      override public function clone() : Event
      {
         var result:HTTPStatusEvent = new HTTPStatusEvent(type,bubbles,cancelable,this.status);
         result.responseURL = this.responseURL;
         result.responseHeaders = this.responseHeaders;
         return result;
      }
      
      override public function toString() : String
      {
         return formatToString("HTTPStatusEvent","type","bubbles","cancelable","eventPhase","status","responseURL");
      }
      
      public function get status() : int
      {
         return this.m_status;
      }
      
      [API("661")]
      public function get responseURL() : String
      {
         return this.m_responseUrl;
      }
      
      [API("661")]
      public function set responseURL(value:String) : void
      {
         this.m_responseUrl = value;
      }
      
      [API("661")]
      public function get responseHeaders() : Array
      {
         return this.m_responseHeaders;
      }
      
      [API("661")]
      public function set responseHeaders(value:Array) : void
      {
         this.m_responseHeaders = value;
      }
   }
}

