package system.reflection
{
   public interface ClassInfo extends TypeInfo
   {
      
      function inheritFrom(... rest) : Boolean;
      
      function isInstance() : Boolean;
      
      function isStatic() : Boolean;
      
      function get name() : String;
      
      function get accessors() : Array;
      
      function get constants() : Array;
      
      function set filter(param1:FilterType) : void;
      
      function get methods() : Array;
      
      function get properties() : Array;
      
      function isDynamic() : Boolean;
      
      function get variables() : Array;
      
      function get filter() : FilterType;
      
      function get members() : Array;
      
      function isFinal() : Boolean;
      
      function toXML() : XML;
      
      function get superClass() : ClassInfo;
      
      function hasInterface(... rest) : Boolean;
   }
}

