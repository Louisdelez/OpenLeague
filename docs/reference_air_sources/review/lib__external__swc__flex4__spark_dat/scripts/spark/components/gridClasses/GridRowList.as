package spark.components.gridClasses
{
   import mx.collections.ArrayCollection;
   
   [ExcludeClass]
   public class GridRowList
   {
      
      private var _head:GridRowNode;
      
      private var _tail:GridRowNode;
      
      private var _length:Number = 0;
      
      private var recentNode:GridRowNode;
      
      private var _numColumns:uint = 0;
      
      public function GridRowList()
      {
         super();
      }
      
      public function get first() : GridRowNode
      {
         return this._head;
      }
      
      public function get last() : GridRowNode
      {
         return this._tail;
      }
      
      public function get tail() : GridRowNode
      {
         return this._tail;
      }
      
      public function get head() : GridRowNode
      {
         return this._head;
      }
      
      public function get length() : Number
      {
         return this._length;
      }
      
      public function get numColumns() : uint
      {
         return this._numColumns;
      }
      
      public function set numColumns(value:uint) : void
      {
         if(this._numColumns == value)
         {
            return;
         }
         this._numColumns = value;
         var cur:GridRowNode = this._head;
         while(Boolean(cur))
         {
            cur.numColumns = value;
            cur = cur.next;
         }
      }
      
      public function insert(index:int) : GridRowNode
      {
         if(this._head == null)
         {
            this._head = new GridRowNode(this.numColumns,index);
            this._tail = this._head;
            ++this._length;
            return this._head;
         }
         var cur:GridRowNode = this.findNearestLTE(index);
         if(Boolean(cur) && cur.rowIndex == index)
         {
            return cur;
         }
         var newNode:GridRowNode = new GridRowNode(this.numColumns,index);
         if(!cur)
         {
            this.insertBefore(this._head,newNode);
         }
         else
         {
            this.insertAfter(cur,newNode);
         }
         this.recentNode = newNode;
         return newNode;
      }
      
      public function insertAfter(node:GridRowNode, newNode:GridRowNode) : void
      {
         newNode.prev = node;
         newNode.next = node.next;
         if(node.next == null)
         {
            this._tail = newNode;
         }
         else
         {
            node.next.prev = newNode;
         }
         node.next = newNode;
         ++this._length;
      }
      
      public function insertBefore(node:GridRowNode, newNode:GridRowNode) : void
      {
         newNode.prev = node.prev;
         newNode.next = node;
         if(node.prev == null)
         {
            this._head = newNode;
         }
         else
         {
            node.prev.next = newNode;
         }
         node.prev = newNode;
         ++this._length;
      }
      
      public function find(index:int) : GridRowNode
      {
         var indexToRecent:int = 0;
         var temp:int = 0;
         if(!this._head)
         {
            return null;
         }
         var lastToIndex:int = this._tail.rowIndex - index;
         var result:GridRowNode = null;
         if(Boolean(this.recentNode))
         {
            if(this.recentNode.rowIndex == index)
            {
               return this.recentNode;
            }
            indexToRecent = this.recentNode.rowIndex - index;
            temp = Math.abs(indexToRecent);
         }
         if(lastToIndex < 0)
         {
            return null;
         }
         if(Boolean(this.recentNode) && Boolean(temp < lastToIndex) && temp < index)
         {
            if(indexToRecent > 0)
            {
               result = this.findBefore(index,this.recentNode);
            }
            else
            {
               result = this.findAfter(index,this.recentNode);
            }
         }
         else if(lastToIndex < index)
         {
            result = this.findBefore(index,this._tail);
         }
         else
         {
            result = this.findAfter(index,this._head);
         }
         if(Boolean(result))
         {
            this.recentNode = result;
         }
         return result;
      }
      
      private function findAfter(index:int, node:GridRowNode) : GridRowNode
      {
         var cur:GridRowNode = node;
         var result:GridRowNode = null;
         while(Boolean(cur) && cur.rowIndex <= index)
         {
            if(cur.rowIndex == index)
            {
               result = cur;
               break;
            }
            cur = cur.next;
         }
         return result;
      }
      
      private function findBefore(index:int, node:GridRowNode) : GridRowNode
      {
         var cur:GridRowNode = node;
         var result:GridRowNode = null;
         while(Boolean(cur) && cur.rowIndex >= index)
         {
            if(cur.rowIndex == index)
            {
               result = cur;
               break;
            }
            cur = cur.prev;
         }
         return result;
      }
      
      public function findNearestLTE(index:int) : GridRowNode
      {
         var indexToRecent:int = 0;
         var temp:int = 0;
         var lastToIndex:int = 0;
         if(!this._head || index < 0)
         {
            return null;
         }
         var result:GridRowNode = null;
         if(Boolean(this.recentNode))
         {
            if(this.recentNode.rowIndex == index)
            {
               return this.recentNode;
            }
            indexToRecent = this.recentNode.rowIndex - index;
            temp = Math.abs(indexToRecent);
         }
         lastToIndex = this._tail.rowIndex - index;
         if(index < this._head.rowIndex)
         {
            result = null;
         }
         else if(lastToIndex < 0)
         {
            result = this._tail;
         }
         else if(Boolean(this.recentNode) && Boolean(temp < lastToIndex) && temp < index)
         {
            if(indexToRecent > 0)
            {
               result = this.findNearestLTEBefore(index,this.recentNode);
            }
            else
            {
               result = this.findNearestLTEAfter(index,this.recentNode);
            }
         }
         else if(lastToIndex < index)
         {
            result = this.findNearestLTEBefore(index,this._tail);
         }
         else
         {
            result = this.findNearestLTEAfter(index,this._head);
         }
         this.recentNode = result;
         return result;
      }
      
      private function findNearestLTEAfter(index:int, node:GridRowNode) : GridRowNode
      {
         var cur:GridRowNode = node;
         while(Boolean(cur) && cur.rowIndex < index)
         {
            if(cur.next == null)
            {
               break;
            }
            if(cur.next.rowIndex > index)
            {
               break;
            }
            cur = cur.next;
         }
         return cur;
      }
      
      private function findNearestLTEBefore(index:int, node:GridRowNode) : GridRowNode
      {
         var cur:GridRowNode = node;
         while(Boolean(cur) && cur.rowIndex > index)
         {
            cur = cur.prev;
         }
         return cur;
      }
      
      public function push(node:GridRowNode) : void
      {
         if(Boolean(this._tail))
         {
            node.prev = this._tail;
            node.next = null;
            this._tail.next = node;
            this._tail = node;
            ++this._length;
         }
         else
         {
            node.prev = null;
            node.next = null;
            this._head = node;
            this._tail = node;
            this._length = 1;
         }
      }
      
      public function remove(index:int) : GridRowNode
      {
         var node:GridRowNode = this.find(index);
         if(Boolean(node))
         {
            this.removeNode(node);
         }
         return node;
      }
      
      public function removeNode(node:GridRowNode) : void
      {
         if(node.prev == null)
         {
            this._head = node.next;
         }
         else
         {
            node.prev.next = node.next;
         }
         if(node.next == null)
         {
            this._tail = node.prev;
         }
         else
         {
            node.next.prev = node.prev;
         }
         node.next = null;
         node.prev = null;
         if(node == this.recentNode)
         {
            this.recentNode = null;
         }
         --this._length;
      }
      
      public function removeAll() : void
      {
         this._head = null;
         this._tail = null;
         this._length = 0;
         this.recentNode = null;
      }
      
      public function insertColumns(startColumn:int, count:int) : void
      {
         this._numColumns += count;
         var node:GridRowNode = this.first;
         while(Boolean(node))
         {
            node.insertColumns(startColumn,count);
            node = node.next;
         }
      }
      
      public function removeColumns(startColumn:int, count:int) : void
      {
         this._numColumns -= count;
         var node:GridRowNode = this.first;
         while(Boolean(node))
         {
            node.removeColumns(startColumn,count);
            node = node.next;
         }
      }
      
      public function moveColumns(fromCol:int, toCol:int, count:int) : void
      {
         var node:GridRowNode = this.first;
         while(Boolean(node))
         {
            node.moveColumns(fromCol,toCol,count);
            node = node.next;
         }
      }
      
      public function clearColumns(startColumn:int, count:int) : void
      {
         var node:GridRowNode = this.first;
         while(Boolean(node))
         {
            node.clearColumns(startColumn,count);
            node = node.next;
         }
      }
      
      public function toString() : String
      {
         var s:String = "[ ";
         var node:GridRowNode = this.first;
         while(Boolean(node))
         {
            s += "(" + node.rowIndex + "," + node.maxCellHeight + ") -> ";
            node = node.next;
         }
         return s + "]";
      }
      
      public function toArray() : ArrayCollection
      {
         var arr:ArrayCollection = new ArrayCollection();
         var node:GridRowNode = this.first;
         var index:int = 0;
         while(Boolean(node))
         {
            arr.addItem(node);
            node = node.next;
         }
         return arr;
      }
   }
}

