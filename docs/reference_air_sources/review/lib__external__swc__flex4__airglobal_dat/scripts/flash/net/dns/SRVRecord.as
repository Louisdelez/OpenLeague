package flash.net.dns
{
   [Version("air2.0")]
   public class SRVRecord extends ResourceRecord
   {
      
      private var _priority:int = 0;
      
      private var _weight:int = 0;
      
      private var _port:int = 0;
      
      private var _target:String = "";
      
      public function SRVRecord()
      {
         super();
      }
      
      public function get priority() : int
      {
         return this._priority;
      }
      
      public function set priority(value:int) : void
      {
         this._priority = value;
      }
      
      public function get weight() : int
      {
         return this._weight;
      }
      
      public function set weight(value:int) : void
      {
         this._weight = value;
      }
      
      public function get port() : int
      {
         return this._port;
      }
      
      public function set port(value:int) : void
      {
         this._port = value;
      }
      
      public function get target() : String
      {
         return this._target;
      }
      
      public function set target(value:String) : void
      {
         this._target = value;
      }
   }
}

