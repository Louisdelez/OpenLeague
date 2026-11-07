package mx.rpc.mxml
{
   public interface IMXMLSupport
   {
      
      function set showBusyCursor(param1:Boolean) : void;
      
      [Inspectable(enumeration="multiple,single,last",defaultValue="multiple",category="General")]
      function get concurrency() : String;
      
      function get showBusyCursor() : Boolean;
      
      function set concurrency(param1:String) : void;
   }
}

