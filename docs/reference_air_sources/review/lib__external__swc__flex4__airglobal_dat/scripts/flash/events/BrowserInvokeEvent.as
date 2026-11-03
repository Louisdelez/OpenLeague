package flash.events
{
   [API("661")]
   public class BrowserInvokeEvent extends Event
   {
      
      public static const BROWSER_INVOKE:String = "browserInvoke";
      
      private var m_arguments:Array;
      
      private var m_sandboxType:String;
      
      private var m_securityDomain:String;
      
      private var m_isHTTPS:Boolean;
      
      private var m_isUserEvent:Boolean;
      
      public function BrowserInvokeEvent(type:String, bubbles:Boolean, cancelable:Boolean, arguments:Array, sandboxType:String, securityDomain:String, isHTTPS:Boolean, isUserEvent:Boolean)
      {
         super(type,bubbles,cancelable);
         this.m_arguments = arguments;
         this.m_sandboxType = sandboxType;
         this.m_securityDomain = securityDomain;
         this.m_isHTTPS = isHTTPS;
         this.m_isUserEvent = isUserEvent;
      }
      
      override public function clone() : Event
      {
         return new BrowserInvokeEvent(type,bubbles,cancelable,this.m_arguments,this.m_sandboxType,this.m_securityDomain,this.m_isHTTPS,this.m_isUserEvent);
      }
      
      public function get arguments() : Array
      {
         return this.m_arguments;
      }
      
      public function get sandboxType() : String
      {
         return this.m_sandboxType;
      }
      
      public function get securityDomain() : String
      {
         return this.m_securityDomain;
      }
      
      public function get isHTTPS() : Boolean
      {
         return this.m_isHTTPS;
      }
      
      public function get isUserEvent() : Boolean
      {
         return this.m_isUserEvent;
      }
   }
}

