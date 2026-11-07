package flash.events
{
   [API("661")]
   public class HTMLUncaughtScriptExceptionEvent extends Event
   {
      
      public static const UNCAUGHT_SCRIPT_EXCEPTION:* = "uncaughtScriptException";
      
      public var exceptionValue:*;
      
      private var m_stackTraceToCopy:Array;
      
      private var m_stackTrace:Array;
      
      public function HTMLUncaughtScriptExceptionEvent(exceptionValue:*)
      {
         super(UNCAUGHT_SCRIPT_EXCEPTION,false,true);
         this.exceptionValue = exceptionValue;
         if("stackTrace" in exceptionValue)
         {
            this.m_stackTraceToCopy = exceptionValue.stackTrace;
            this.m_stackTrace = null;
         }
         else
         {
            this.stackTrace = null;
         }
      }
      
      override public function clone() : Event
      {
         return new HTMLUncaughtScriptExceptionEvent(this.exceptionValue);
      }
      
      public function get stackTrace() : Array
      {
         var stackTraceToCopy:* = undefined;
         var stackFrame:* = undefined;
         if(Boolean(this.m_stackTraceToCopy))
         {
            stackTraceToCopy = this.m_stackTraceToCopy;
            this.m_stackTraceToCopy = null;
            this.m_stackTrace = new Array();
            for each(stackFrame in stackTraceToCopy)
            {
               this.m_stackTrace.push(stackFrame);
            }
         }
         return this.m_stackTrace;
      }
      
      public function set stackTrace(newValue:Array) : void
      {
         this.m_stackTrace = newValue;
         this.m_stackTraceToCopy = null;
      }
   }
}

