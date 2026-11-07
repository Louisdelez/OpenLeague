package blix.signals
{
   import com.riotgames.platform.proxy.IProxyObject;
   
   public class ISignal_proxy extends SignalPromise implements IProxyObject
   {
      
      public function ISignal_proxy()
      {
         super();
      }
      
      public function __setTarget(param1:Object) : void
      {
         setSignalTarget(ISignal(param1));
      }
   }
}

