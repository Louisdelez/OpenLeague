package system.data.iterators
{
   import flash.errors.IllegalOperationError;
   import system.data.ListIterator;
   import system.data.lists.ArrayList;
   import system.errors.ConcurrencyError;
   import system.errors.NoSuchElementError;
   import system.numeric.Mathematics;
   
   public class ArrayListIterator implements ListIterator
   {
      
      private var _key:uint;
      
      private var _expectedModCount:Number;
      
      private var _listast:int;
      
      private var _list:ArrayList;
      
      public function ArrayListIterator(param1:ArrayList, param2:uint = 0)
      {
         super();
         if(param1 == null)
         {
            throw new ArgumentError("ListIterator constructor failed, the \'list\' argument not must be \'null\' or \'undefined\'.");
         }
         _list = param1;
         _key = 0;
         _listast = -1;
         _expectedModCount = _list.modCount;
         seek(param2);
      }
      
      public function remove() : *
      {
         if(_listast == -1)
         {
            throw new IllegalOperationError("ListIterator.remove() failed, the iterator state is not valid.");
         }
         checkForComodification();
         try
         {
            _list.removeAt(_listast);
            if(_listast < _key)
            {
               --_key;
            }
            _listast = -1;
            _expectedModCount = _list.modCount;
         }
         catch(e:ConcurrencyError)
         {
            throw new ConcurrencyError("ListIterator.remove() method failed.");
         }
      }
      
      public function checkForComodification() : void
      {
         if(_list.modCount != _expectedModCount)
         {
            throw new ConcurrencyError("ListIterator modification failed, the list is changed during the iteration.");
         }
      }
      
      public function reset() : void
      {
         _key = 0;
      }
      
      public function key() : *
      {
         return _key;
      }
      
      public function set(param1:*) : void
      {
         var o:* = param1;
         if(_listast == -1)
         {
            throw new IllegalOperationError("ListIterator.set() failed, the iterator state is not valid.");
         }
         checkForComodification();
         try
         {
            _list.set(_listast,o);
            _expectedModCount = _list.modCount;
         }
         catch(e:Error)
         {
            throw e;
         }
      }
      
      public function nextIndex() : uint
      {
         return _key;
      }
      
      public function add(param1:*) : void
      {
         var o:* = param1;
         checkForComodification();
         try
         {
            _list.addAt(_key++,o);
            _listast = -1;
            _expectedModCount = _list.modCount;
         }
         catch(e:Error)
         {
            throw e;
         }
      }
      
      public function previousIndex() : int
      {
         return _key - 1;
      }
      
      public function hasNext() : Boolean
      {
         return _key < _list.size();
      }
      
      public function hasPrevious() : Boolean
      {
         return _key != 0;
      }
      
      public function next() : *
      {
         var _loc1_:* = undefined;
         if(hasNext())
         {
            _loc1_ = _list.get(_key);
            _listast = _key;
            ++_key;
            return _loc1_;
         }
         throw new NoSuchElementError("ListIterator.next() method failed.");
      }
      
      public function previous() : *
      {
         var i:Number = NaN;
         var prev:* = undefined;
         checkForComodification();
         try
         {
            i = _key - 1;
            prev = _list.get(i);
            _listast = _key = i;
            return prev;
         }
         catch(e:Error)
         {
            checkForComodification();
            throw new NoSuchElementError("ListIterator.previous method failed.");
         }
      }
      
      public function seek(param1:*) : void
      {
         _key = Mathematics.clamp(param1,0,_list.size());
         _listast = _key - 1;
      }
   }
}

