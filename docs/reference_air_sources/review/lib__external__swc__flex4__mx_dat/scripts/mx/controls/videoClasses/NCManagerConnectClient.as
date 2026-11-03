package mx.controls.videoClasses
{
   import flash.net.NetConnection;
   
   [ExcludeClass]
   public class NCManagerConnectClient
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      public var owner:NCManager;
      
      public var netConnection:NetConnection;
      
      public var connIndex:uint;
      
      public var pending:Boolean;
      
      public function NCManagerConnectClient(nc:NetConnection, owner:NCManager = null, connIndex:uint = 0)
      {
         super();
         this.owner = owner;
         this.netConnection = nc;
         this.connIndex = connIndex;
         this.pending = false;
      }
      
      public function onBWDone(... rest) : void
      {
         var p_bw:Number = NaN;
         if(rest.length > 0)
         {
            p_bw = Number(rest[0]);
         }
         this.owner.onConnected(this.netConnection,p_bw);
      }
      
      public function onBWCheck(... rest) : uint
      {
         return ++this.owner.payload;
      }
      
      public function onMetaData(... rest) : void
      {
      }
      
      public function onPlayStatus(... rest) : void
      {
      }
      
      public function close() : void
      {
      }
   }
}

