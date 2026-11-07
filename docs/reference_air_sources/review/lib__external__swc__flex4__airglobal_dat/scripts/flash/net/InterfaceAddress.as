package flash.net
{
   [Version("air2.0")]
   public class InterfaceAddress
   {
      
      private var _address:String = "";
      
      private var _broadcast:String = "";
      
      private var _prefixLength:int = -1;
      
      private var _ipVersion:String = IPVersion.IPV4;
      
      public function InterfaceAddress()
      {
         super();
      }
      
      public function get address() : String
      {
         return this._address;
      }
      
      public function set address(value:String) : void
      {
         this._address = value;
      }
      
      public function get broadcast() : String
      {
         return this._broadcast;
      }
      
      public function set broadcast(value:String) : void
      {
         this._broadcast = value;
      }
      
      public function get prefixLength() : int
      {
         return this._prefixLength;
      }
      
      public function set prefixLength(value:int) : void
      {
         this._prefixLength = value;
      }
      
      public function get ipVersion() : String
      {
         return this._ipVersion;
      }
      
      public function set ipVersion(value:String) : void
      {
         this._ipVersion = value;
      }
   }
}

