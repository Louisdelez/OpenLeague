package flash.net.dns
{
   [Version("air2.0")]
   public class AAAARecord extends ResourceRecord
   {
      
      private var _address:String = "";
      
      public function AAAARecord()
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

