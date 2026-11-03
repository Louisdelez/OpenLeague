package mx.controls.videoClasses
{
   import mx.core.mx_internal;
   
   use namespace mx_internal;
   
   [ExcludeClass]
   public class NCManagerReconnectClient
   {
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      public var owner:NCManager;
      
      public function NCManagerReconnectClient(owner:NCManager = null)
      {
         super();
         this.owner = owner;
      }
      
      public function onBWCheck(... rest) : uint
      {
         return ++owner.payload;
      }
      
      public function onBWDone(... rest) : void
      {
         owner.onReconnected();
      }
   }
}

