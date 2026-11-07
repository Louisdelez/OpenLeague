package system.data.iterators
{
   import system.data.Iterator;
   import system.numeric.Mathematics;
   
   public class ArrayIterator implements Iterator
   {
      
      protected var _a:Array;
      
      protected var _k:Number;
      
      public function ArrayIterator(param1:Array)
      {
         super();
         if(param1 == null)
         {
            throw new ArgumentError(this + " constructor failed, the passed-in Array argument not must be \'null\'.");
         }
         _a = param1;
         _k = -1;
      }
      
      public function remove() : *
      {
         return _a.splice(_k--,1)[0];
      }
      
      public function hasNext() : Boolean
      {
         return _k < _a.length - 1;
      }
      
      public function reset() : void
      {
         _k = -1;
      }
      
      public function seek(param1:*) : void
      {
         _k = Mathematics.clamp(param1 - 1,-1,_a.length);
      }
      
      public function next() : *
      {
         return _a[++_k];
      }
      
      public function key() : *
      {
         return _k;
      }
   }
}

