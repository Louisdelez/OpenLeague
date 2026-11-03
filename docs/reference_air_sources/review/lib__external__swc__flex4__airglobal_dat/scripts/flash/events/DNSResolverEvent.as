package flash.events
{
   [Version("air2.0")]
   public class DNSResolverEvent extends Event
   {
      
      public static const LOOKUP:String = "lookup";
      
      private var _host:String = "";
      
      private var _resourceRecords:Array = null;
      
      public function DNSResolverEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, host:String = "", resourceRecords:Array = null)
      {
         super(type,bubbles,cancelable);
         this.host = host;
         this.resourceRecords = resourceRecords;
      }
      
      override public function clone() : Event
      {
         return new DNSResolverEvent(type,bubbles,cancelable,this.host,this.resourceRecords);
      }
      
      override public function toString() : String
      {
         return formatToString("DNSResolverEvent","type","bubbles","cancelable","host","resourceRecords");
      }
      
      public function get host() : String
      {
         return this._host;
      }
      
      public function set host(value:String) : void
      {
         this._host = value;
      }
      
      public function get resourceRecords() : Array
      {
         return this._resourceRecords;
      }
      
      public function set resourceRecords(value:Array) : void
      {
         this._resourceRecords = value;
      }
   }
}

