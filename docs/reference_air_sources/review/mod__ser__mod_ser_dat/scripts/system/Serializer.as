package system
{
   public interface Serializer
   {
      
      function serialize(param1:*) : String;
      
      function get prettyIndent() : int;
      
      function set prettyIndent(param1:int) : void;
      
      function set prettyPrinting(param1:Boolean) : void;
      
      function deserialize(param1:String) : *;
      
      function get prettyPrinting() : Boolean;
      
      function set indentor(param1:String) : void;
      
      function get indentor() : String;
   }
}

