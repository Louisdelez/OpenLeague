package flash.net
{
   import flash.desktop.*;
   import flash.events.*;
   import flash.system.*;
   
   [native(cls="NetworkInfoClass",instance="NetworkInfoObject",methods="auto",construct="native")]
   [Version("air2.0")]
   [Event(name="networkChange",type="flash.events.Event")]
   public class NetworkInfo extends EventDispatcher
   {
      
      public function NetworkInfo()
      {
         super();
         NativeApplication.nativeApplication.addEventListener(Event.NETWORK_CHANGE,this.onNetworkChange);
      }
      
      public static function get isSupported() : Boolean
      {
         return true;
      }
      
      public static function get networkInfo() : NetworkInfo
      {
         var sandboxType:String = Security.sandboxType;
         if(sandboxType != Security.APPLICATION)
         {
            Error.throwError(SecurityError,3205);
         }
         return getInstance();
      }
      
      private static native function getInstance() : NetworkInfo;
      
      private function onNetworkChange(event:Event) : *
      {
         dispatchEvent(event);
      }
      
      public native function findInterfaces() : Vector.<NetworkInterface>;
   }
}

