package flash.events
{
   import flash.utils.ByteArray;
   
   [Version("air2.0")]
   public class DatagramSocketDataEvent extends Event
   {
      
      public static const DATA:String = "data";
      
      private var _srcAddress:String = "";
      
      private var _srcPort:int = 0;
      
      private var _dstAddress:String = "";
      
      private var _dstPort:int = 0;
      
      private var _data:ByteArray = null;
      
      public function DatagramSocketDataEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, srcAddress:String = "", srcPort:int = 0, dstAddress:String = "", dstPort:int = 0, data:ByteArray = null)
      {
         super(type,bubbles,cancelable);
         this.srcAddress = srcAddress;
         this.srcPort = srcPort;
         this.dstAddress = dstAddress;
         this.dstPort = dstPort;
         this.data = data;
      }
      
      override public function clone() : Event
      {
         return new DatagramSocketDataEvent(type,bubbles,cancelable,this.srcAddress,this.srcPort,this.dstAddress,this.dstPort,this.data);
      }
      
      override public function toString() : String
      {
         return formatToString("DatagramSocketDataEvent","type","bubbles","cancelable","srcAddress","srcPort","dstAddress","dstPort","data");
      }
      
      public function get srcAddress() : String
      {
         return this._srcAddress;
      }
      
      public function set srcAddress(value:String) : void
      {
         this._srcAddress = value;
      }
      
      public function get srcPort() : int
      {
         return this._srcPort;
      }
      
      public function set srcPort(value:int) : void
      {
         this._srcPort = value;
      }
      
      public function get dstAddress() : String
      {
         return this._dstAddress;
      }
      
      public function set dstAddress(value:String) : void
      {
         this._dstAddress = value;
      }
      
      public function get dstPort() : int
      {
         return this._dstPort;
      }
      
      public function set dstPort(value:int) : void
      {
         this._dstPort = value;
      }
      
      public function get data() : ByteArray
      {
         return this._data;
      }
      
      public function set data(value:ByteArray) : void
      {
         this._data = value;
      }
   }
}

