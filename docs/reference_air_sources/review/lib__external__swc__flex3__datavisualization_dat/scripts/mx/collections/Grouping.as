package mx.collections
{
   [DefaultProperty("fields")]
   public class Grouping
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "3.0.0.0";
      
      public var label:String = "GroupLabel";
      
      private var _fields:Array;
      
      public var groupingObjectFunction:Function;
      
      private var _compareFunction:Function;
      
      public function Grouping()
      {
         super();
      }
      
      public function set compareFunction(value:Function) : void
      {
         _compareFunction = value;
      }
      
      public function set fields(value:Array) : void
      {
         _fields = value;
      }
      
      [Inspectable(category="General",arrayType="mx.collections.GroupingField")]
      public function get fields() : Array
      {
         return _fields;
      }
      
      [Inspectable(category="General")]
      public function get compareFunction() : Function
      {
         return _compareFunction;
      }
   }
}

