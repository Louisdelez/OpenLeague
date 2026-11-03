package blix.ds
{
   public final class LinkedList
   {
      
      private var head:*;
      
      private var tail:*;
      
      public function LinkedList()
      {
         super();
      }
      
      public function getHead() : *
      {
         return this.head;
      }
      
      public function getTail() : *
      {
         return this.tail;
      }
      
      public function shift(param1:*) : void
      {
         if(this.head == null)
         {
            this.tail = param1;
         }
         else
         {
            this.head.previous = param1;
            param1.next = this.head;
         }
         this.head = param1;
      }
      
      public function push(param1:*) : void
      {
         if(this.tail == null)
         {
            this.head = param1;
         }
         else
         {
            this.tail.next = param1;
            param1.previous = this.tail;
         }
         this.tail = param1;
      }
      
      public function prepend(param1:LinkedList) : void
      {
         if(param1.head == null)
         {
            return;
         }
         this.head.previous = param1.tail;
         param1.tail.next = this.head;
         this.head = param1.head;
      }
      
      public function append(param1:LinkedList) : void
      {
         if(param1.head == null)
         {
            return;
         }
         this.tail.next = param1.head;
         param1.head.previous = this.tail;
         this.tail = param1.tail;
      }
      
      public function removeItem(param1:*) : void
      {
         if(param1 == null)
         {
            return;
         }
         if(param1 === this.head)
         {
            this.head = param1.next;
         }
         if(param1 === this.tail)
         {
            this.tail = param1.previous;
         }
         if(param1.previous != null && param1.previous.next === param1)
         {
            param1.previous.next = param1.next;
         }
         if(param1.next != null && param1.next.previous === param1)
         {
            param1.next.previous = param1.previous;
         }
      }
      
      public function shiftItem(param1:*) : void
      {
         param1.previous = null;
         param1.next = this.head;
         if(this.head == null)
         {
            this.tail = param1;
         }
         else
         {
            this.head.previous = param1;
         }
         this.head = param1;
      }
      
      public function addItem(param1:*) : void
      {
         param1.previous = this.tail;
         param1.next = null;
         if(this.tail == null)
         {
            this.head = param1;
         }
         else
         {
            this.tail.next = param1;
         }
         this.tail = param1;
      }
      
      public function removeAll() : void
      {
         this.head = null;
         this.tail = null;
      }
      
      public function find(param1:*, param2:String = "value") : *
      {
         var _loc3_:* = this.head;
         while(_loc3_ != null)
         {
            if(_loc3_[param2] == param1)
            {
               return _loc3_;
            }
            _loc3_ = _loc3_.next;
         }
         return null;
      }
      
      public function findByCompare(param1:Function) : *
      {
         var _loc2_:* = this.head;
         while(_loc2_ != null)
         {
            if(Boolean(param1(_loc2_)))
            {
               return _loc2_;
            }
            _loc2_ = _loc2_.next;
         }
         return null;
      }
      
      public function getIsEmpty() : Boolean
      {
         return this.head == null;
      }
      
      public function setToHead(param1:*) : void
      {
         if(param1 == null)
         {
            this.head = null;
            this.tail = null;
            return;
         }
         if(param1.previous != null)
         {
            param1.previous.next = null;
            param1.previous = null;
         }
         this.head = param1;
      }
      
      public function setToTail(param1:*) : void
      {
         if(param1 == null)
         {
            this.head = null;
            this.tail = null;
            return;
         }
         if(param1.next != null)
         {
            param1.next.previous = null;
            param1.next = null;
         }
         this.tail = param1;
      }
   }
}

