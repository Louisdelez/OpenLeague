package mx.collections
{
   [DefaultProperty("summaries")]
   public class GroupingField
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "3.0.0.0";
      
      private var _caseInsensitive:Boolean;
      
      private var _numeric:Boolean;
      
      public var summaries:Array;
      
      private var _descending:Boolean;
      
      public var groupingObjectFunction:Function;
      
      private var _compareFunction:Function;
      
      private var _name:String;
      
      public var groupingFunction:Function;
      
      public function GroupingField(name:String = null, caseInsensitive:Boolean = false, descending:Boolean = false, numeric:Boolean = false)
      {
         super();
         _name = name;
         _caseInsensitive = caseInsensitive;
         _descending = descending;
         _numeric = numeric;
      }
      
      [Inspectable(category="General")]
      public function get caseInsensitive() : Boolean
      {
         return _caseInsensitive;
      }
      
      public function set caseInsensitive(value:Boolean) : void
      {
         if(value != _caseInsensitive)
         {
            _caseInsensitive = value;
         }
      }
      
      [Inspectable(category="General")]
      public function get name() : String
      {
         return _name;
      }
      
      [Inspectable(category="General")]
      public function get numeric() : Boolean
      {
         return _numeric;
      }
      
      public function set name(n:String) : void
      {
         _name = n;
      }
      
      [Inspectable(category="General")]
      public function get compareFunction() : Function
      {
         return _compareFunction;
      }
      
      public function set numeric(value:Boolean) : void
      {
         if(_numeric != value)
         {
            _numeric = value;
         }
      }
      
      public function set descending(value:Boolean) : void
      {
         if(_descending != value)
         {
            _descending = value;
         }
      }
      
      [Inspectable(category="General")]
      public function get descending() : Boolean
      {
         return _descending;
      }
      
      public function set compareFunction(c:Function) : void
      {
         _compareFunction = c;
      }
   }
}

