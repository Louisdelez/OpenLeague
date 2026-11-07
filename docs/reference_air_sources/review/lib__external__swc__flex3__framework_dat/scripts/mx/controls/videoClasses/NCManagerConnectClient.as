package mx.controls.videoClasses
{
   import flash.net.NetConnection;
   import mx.core.mx_internal;
   
   use namespace mx_internal;
   
   [ExcludeClass]
   public class NCManagerConnectClient
   {
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      public var connIndex:uint;
      
      public var owner:NCManager;
      
      public var pending:Boolean;
      
      public var netConnection:NetConnection;
      
      public function NCManagerConnectClient(nc:NetConnection, owner:NCManager = null, connIndex:uint = 0)
      {
         super();
         this.owner = owner;
         this.netConnection = nc;
         this.connIndex = connIndex;
         this.pending = false;
      }
      
      public function onPlayStatus(... rest) : void
      {
      }
      
      public function onMetaData(... rest) : void
      {
      }
      
      public function onBWCheck(... rest) : uint
      {
         return ++owner.payload;
      }
      
      public function onBWDone(... rest) : void
      {
         var p_bw:Number = NaN;
         if(rest.length > 0)
         {
            p_bw = Number(rest[0]);
         }
         owner.onConnected(netConnection,p_bw);
      }
      
      public function close() : void
      {
      }
   }
}

