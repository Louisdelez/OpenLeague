package flash.net.dns
{
   [Version("air2.0")]
   public class ARecord extends ResourceRecord
   {
      
      private var _address:String = "";
      
      public function ARecord()
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
   }
}

