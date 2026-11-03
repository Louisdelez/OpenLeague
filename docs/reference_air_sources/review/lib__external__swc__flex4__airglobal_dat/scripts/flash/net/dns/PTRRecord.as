package flash.net.dns
{
   [Version("air2.0")]
   public class PTRRecord extends ResourceRecord
   {
      
      private var _ptrdName:String = "";
      
      public function PTRRecord()
      {
         super();
      }
      
      public function get ptrdName() : String
      {
         return this._ptrdName;
      }
      
      public function set ptrdName(value:String) : void
      {
         this._ptrdName = value;
      }
   }
}

