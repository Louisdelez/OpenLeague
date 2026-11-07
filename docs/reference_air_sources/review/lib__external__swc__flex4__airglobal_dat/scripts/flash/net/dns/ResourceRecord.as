package flash.net.dns
{
   [Version("air2.0")]
   public class ResourceRecord
   {
      
      private var _name:String = "";
      
      private var _ttl:int = 0;
      
      public function ResourceRecord()
      {
         super();
      }
      
      public function get name() : String
      {
         return this._name;
      }
      
      public function set name(value:String) : void
      {
         this._name = value;
      }
      
      public function get ttl() : int
      {
         return this._ttl;
      }
      
      public function set ttl(value:int) : void
      {
         this._ttl = value;
      }
   }
}

