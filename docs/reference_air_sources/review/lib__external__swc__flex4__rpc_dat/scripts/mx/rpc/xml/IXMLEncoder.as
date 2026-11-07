package mx.rpc.xml
{
   public interface IXMLEncoder
   {
      
      function encode(param1:*, param2:QName = null, param3:QName = null, param4:XML = null) : XMLList;
      
      function reset() : void;
      
      function get xmlSpecialCharsFilter() : Function;
      
      function set xmlSpecialCharsFilter(param1:Function) : void;
      
      function get strictNillability() : Boolean;
      
      function set strictNillability(param1:Boolean) : void;
   }
}

