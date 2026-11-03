package mx.controls.videoClasses
{
   [ExcludeClass]
   public class NCManagerReconnectClient
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      public var owner:NCManager;
      
      public function NCManagerReconnectClient(owner:NCManager = null)
      {
         super();
         this.owner = owner;
      }
      
      public function onBWCheck(... rest) : uint
      {
         return ++this.owner.payload;
      }
      
      public function onBWDone(... rest) : void
      {
         this.owner.onReconnected();
      }
   }
}

