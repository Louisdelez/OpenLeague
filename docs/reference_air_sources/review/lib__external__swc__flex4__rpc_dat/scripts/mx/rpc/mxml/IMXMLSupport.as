package mx.rpc.mxml
{
   public interface IMXMLSupport
   {
      
      [Inspectable(enumeration="multiple,single,last",defaultValue="multiple",category="General")]
      function get concurrency() : String;
      
      function set concurrency(param1:String) : void;
      
      function get showBusyCursor() : Boolean;
      
      function set showBusyCursor(param1:Boolean) : void;
   }
}

