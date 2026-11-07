package hr.binaria.asx3m.io.xml
{
   import hr.binaria.asx3m.io.IHierarchicalStreamReader;
   import mx.collections.XMLListCollection;
   import system.data.Iterator;
   import system.data.stacks.ArrayStack;
   
   public class E4XReader implements IHierarchicalStreamReader
   {
      
      private var _currentElement:XML;
      
      private var _pointers:ArrayStack;
      
      private var _current:XML;
      
      public function E4XReader(param1:XML)
      {
         super();
         _current = param1;
         _pointers = new ArrayStack();
         _pointers.push(new Pointer());
         reassignCurrentElement(_current);
      }
      
      public function underlyingReader() : IHierarchicalStreamReader
      {
         return null;
      }
      
      public function getValue() : String
      {
         return _currentElement.toString();
      }
      
      public function getCurrent() : *
      {
         return _current;
      }
      
      protected function reassignCurrentElement(param1:XML) : void
      {
         _currentElement = param1;
      }
      
      protected function getChildCount() : int
      {
         return new XMLListCollection(_currentElement.children()).length;
      }
      
      public function moveUp() : void
      {
         _current = getParent() as XML;
         _pointers.pop();
         reassignCurrentElement(_current);
      }
      
      public function getAttributeCount() : int
      {
         var _loc2_:XML = null;
         var _loc1_:int = 0;
         for each(_loc2_ in _currentElement.attributes())
         {
            _loc1_++;
         }
         return _loc1_;
      }
      
      public function getAttributeName(param1:int) : String
      {
         return null;
      }
      
      public function moveDown() : void
      {
         var _loc1_:Pointer = _pointers.peek() as Pointer;
         _pointers.push(new Pointer());
         _current = getChild(_loc1_.v) as XML;
         ++_loc1_.v;
         reassignCurrentElement(_current);
      }
      
      protected function getParent() : Object
      {
         return _currentElement.parent();
      }
      
      public function getNodeName() : String
      {
         return _currentElement.name();
      }
      
      public function getAttributeNames() : Iterator
      {
         return null;
      }
      
      protected function getChild(param1:int) : Object
      {
         return new XMLListCollection(_currentElement.children()).getItemAt(param1);
      }
      
      public function getAttribute(param1:String) : String
      {
         if(param1 != null)
         {
            return _currentElement.attribute(param1).toString();
         }
         return null;
      }
      
      public function close() : void
      {
      }
      
      public function hasMoreChildren() : Boolean
      {
         var _loc1_:Pointer = _pointers.peek() as Pointer;
         if(_loc1_.v < getChildCount())
         {
            return true;
         }
         return false;
      }
   }
}

class Pointer
{
   
   public var v:int;
   
   public function Pointer()
   {
      super();
   }
}
