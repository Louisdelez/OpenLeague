package flash.net.dns
{
   [Version("air2.0")]
   public class MXRecord extends ResourceRecord
   {
      
      private var _exchange:String = "";
      
      private var _preference:int = 0;
      
      public function MXRecord()
      {
         super();
      }
      
      public function get exchange() : String
      {
         return this._exchange;
      }
      
      public function set exchange(value:String) : void
      {
         this._exchange = value;
      }
      
      public function get preference() : int
      {
         return this._preference;
      }
      
      public function set preference(value:int) : void
      {
         this._preference = value;
      }
   }
}

