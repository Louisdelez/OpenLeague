package mx.rpc.xml
{
   [ExcludeClass]
   public interface IXMLEncoder
   {
      
      function get xmlSpecialCharsFilter() : Function;
      
      function encode(param1:*, param2:QName = null, param3:QName = null, param4:XML = null) : XMLList;
      
      function get strictNillability() : Boolean;
      
      function set strictNillability(param1:Boolean) : void;
      
      function set xmlSpecialCharsFilter(param1:Function) : void;
      
      function reset() : void;
   }
}

