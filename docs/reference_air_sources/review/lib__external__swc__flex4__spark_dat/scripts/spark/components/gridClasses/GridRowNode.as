package spark.components.gridClasses
{
   [ExcludeClass]
   public final class GridRowNode
   {
      
      public var rowIndex:int;
      
      private var cellHeights:Vector.<Number>;
      
      public var maxCellHeight:Number = -1;
      
      public var fixedHeight:Number = -1;
      
      public var next:GridRowNode;
      
      public var prev:GridRowNode;
      
      private var _numColumns:uint;
      
      public function GridRowNode(numColumns:uint, rowIndex:int)
      {
         super();
         this.rowIndex = rowIndex;
         this._numColumns = numColumns;
         this.cellHeights = new Vector.<Number>(numColumns);
         GridDimensions.clearVector(this.cellHeights,-1);
      }
      
      public function get numColumns() : uint
      {
         return this._numColumns;
      }
      
      public function set numColumns(value:uint) : void
      {
         var i:int = 0;
         if(value == this._numColumns)
         {
            return;
         }
         this.cellHeights.length = value;
         if(value > this._numColumns)
         {
            for(i = value - this._numColumns; i < value; i++)
            {
               this.cellHeights[i] = -1;
            }
         }
         else
         {
            this.updateMaxHeight();
         }
         this._numColumns = value;
      }
      
      private function updateMaxHeight() : Boolean
      {
         var cellHeight:Number = NaN;
         var changed:Boolean = false;
         var max:Number = -1;
         for each(cellHeight in this.cellHeights)
         {
            if(cellHeight > max)
            {
               max = cellHeight;
            }
         }
         changed = this.maxCellHeight != max;
         if(changed)
         {
            this.maxCellHeight = max;
         }
         return changed;
      }
      
      public function getCellHeight(index:int) : Number
      {
         if(index < 0 || index >= this.cellHeights.length)
         {
            return NaN;
         }
         return this.cellHeights[index];
      }
      
      public function setCellHeight(index:int, value:Number) : Boolean
      {
         if(this.cellHeights[index] == value)
         {
            return false;
         }
         this.cellHeights[index] = value;
         if(value == this.maxCellHeight)
         {
            return false;
         }
         if(value > this.maxCellHeight)
         {
            this.maxCellHeight = value;
            return true;
         }
         return this.updateMaxHeight();
      }
      
      public function insertColumns(startColumn:int, count:int) : void
      {
         GridDimensions.insertValueToVector(this.cellHeights,startColumn,count,-1);
      }
      
      public function moveColumns(fromCol:int, toCol:int, count:int) : void
      {
         GridDimensions.insertElementsToVector(this.cellHeights,toCol,this.cellHeights.splice(fromCol,count));
      }
      
      public function clearColumns(startColumn:int, count:int) : void
      {
         GridDimensions.clearVector(this.cellHeights,-1,startColumn,count);
         this.updateMaxHeight();
      }
      
      public function removeColumns(startColumn:int, count:int) : void
      {
         this.cellHeights.splice(startColumn,count);
         this.updateMaxHeight();
      }
      
      public function toString() : String
      {
         var s:String = "";
         s += "(" + this.rowIndex + ", " + this.maxCellHeight + ") ";
         s += this.cellHeights + "\n";
         if(Boolean(this.prev))
         {
            s += this.prev.rowIndex;
         }
         else
         {
            s += "null";
         }
         s += " <- -> ";
         if(Boolean(this.next))
         {
            s += this.next.rowIndex;
         }
         else
         {
            s += "null";
         }
         return s;
      }
   }
}

