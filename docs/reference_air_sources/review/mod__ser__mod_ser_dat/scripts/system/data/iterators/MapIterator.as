package system.data.iterators
{
   import flash.errors.IllegalOperationError;
   import system.data.Iterator;
   import system.data.Map;
   
   public class MapIterator implements Iterator
   {
      
      private var _i:ArrayIterator;
      
      private var _k:*;
      
      private var _m:Map;
      
      public function MapIterator(param1:Map)
      {
         super();
         if(param1 == null)
         {
            throw new ArgumentError(this + " constructor failed, the passed-in Map argument not must be \'null\'.");
         }
         _m = param1;
         _i = new ArrayIterator(param1.getKeys());
         _k = null;
      }
      
      public function remove() : *
      {
         _i.remove();
         return _m.remove(_k);
      }
      
      public function hasNext() : Boolean
      {
         return _i.hasNext();
      }
      
      public function reset() : void
      {
         _i.reset();
      }
      
      public function seek(param1:*) : void
      {
         throw new IllegalOperationError("This Iterator does not support the seek() method.");
      }
      
      public function next() : *
      {
         _k = _i.next();
         return _m.get(_k);
      }
      
      public function key() : *
      {
         return _k;
      }
   }
}

