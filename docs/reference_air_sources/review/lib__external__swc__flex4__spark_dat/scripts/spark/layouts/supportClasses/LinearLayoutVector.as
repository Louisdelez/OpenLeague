package spark.layouts.supportClasses
{
   import flash.geom.Rectangle;
   import mx.core.ILayoutElement;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   
   [ExcludeClass]
   [ResourceBundle("layout")]
   public final class LinearLayoutVector
   {
      
      public static const VERTICAL:uint = 0;
      
      public static const HORIZONTAL:uint = 1;
      
      internal static const BLOCK_SIZE:uint = 128;
      
      internal static const BLOCK_SHIFT:uint = 7;
      
      internal static const BLOCK_MASK:uint = 127;
      
      private const blockTable:Vector.<Block> = new Vector.<Block>(0,false);
      
      private var pendingRemoves:Vector.<int> = null;
      
      private var pendingInserts:Vector.<int> = null;
      
      private var pendingLength:int = -1;
      
      private var _length:uint = 0;
      
      private var _defaultMajorSize:Number = 0;
      
      private var _defaultMinorSize:Number = 0;
      
      private var _minorSize:Number = 0;
      
      private var _minMinorSize:Number = 0;
      
      private var _majorAxis:uint = 0;
      
      private var _majorAxisOffset:Number = 0;
      
      private var _gap:Number = 6;
      
      public function LinearLayoutVector(majorAxis:uint = 0)
      {
         super();
         this.majorAxis = majorAxis;
      }
      
      private function get resourceManager() : IResourceManager
      {
         return ResourceManager.getInstance();
      }
      
      public function get length() : uint
      {
         return this.pendingLength == -1 ? this._length : uint(this.pendingLength);
      }
      
      public function set length(value:uint) : void
      {
         this.flushPendingChanges();
         this.setLength(value);
      }
      
      private function setLength(newLength:uint) : void
      {
         var blockIndex:uint = 0;
         var endIndex:int = 0;
         if(newLength < this._length)
         {
            blockIndex = uint(newLength >> BLOCK_SHIFT);
            endIndex = Math.min(blockIndex * BLOCK_SIZE + BLOCK_SIZE,this._length) - 1;
            this.clearInterval(newLength,endIndex);
         }
         this._length = newLength;
         var partialBlock:uint = (this._length & BLOCK_MASK) == 0 ? 0 : 1;
         this.blockTable.length = (this._length >> BLOCK_SHIFT) + partialBlock;
      }
      
      public function get defaultMajorSize() : Number
      {
         return this._defaultMajorSize;
      }
      
      public function set defaultMajorSize(value:Number) : void
      {
         this._defaultMajorSize = value;
      }
      
      public function get defaultMinorSize() : Number
      {
         return this._defaultMinorSize;
      }
      
      public function set defaultMinorSize(value:Number) : void
      {
         this._defaultMinorSize = value;
      }
      
      public function get minorSize() : Number
      {
         return Math.max(this.defaultMinorSize,this._minorSize);
      }
      
      public function set minorSize(value:Number) : void
      {
         this._minorSize = value;
      }
      
      public function get minMinorSize() : Number
      {
         return this._minMinorSize;
      }
      
      public function set minMinorSize(value:Number) : void
      {
         this._minMinorSize = value;
      }
      
      public function get majorAxis() : uint
      {
         return this._majorAxis;
      }
      
      public function set majorAxis(value:uint) : void
      {
         this._majorAxis = value;
      }
      
      public function get majorAxisOffset() : Number
      {
         return this._majorAxisOffset;
      }
      
      public function set majorAxisOffset(value:Number) : void
      {
         this._majorAxisOffset = value;
      }
      
      public function get gap() : Number
      {
         return this._gap;
      }
      
      public function set gap(value:Number) : void
      {
         this._gap = value;
      }
      
      public function getMajorSize(index:uint) : Number
      {
         var value:Number = NaN;
         this.flushPendingChanges();
         var block:Block = this.blockTable[index >> BLOCK_SHIFT];
         if(Boolean(block))
         {
            value = block.sizes[index & BLOCK_MASK];
            return isNaN(value) ? this._defaultMajorSize : value;
         }
         return this._defaultMajorSize;
      }
      
      public function setMajorSize(index:uint, value:Number) : void
      {
         this.flushPendingChanges();
         if(index >= this.length)
         {
            throw new Error(this.resourceManager.getString("layout","invalidIndex"));
         }
         var blockIndex:uint = uint(index >> BLOCK_SHIFT);
         var block:Block = this.blockTable[blockIndex];
         if(!block)
         {
            block = this.blockTable[blockIndex] = new Block();
         }
         var sizesIndex:uint = uint(index & BLOCK_MASK);
         var sizes:Vector.<Number> = block.sizes;
         var oldValue:Number = sizes[sizesIndex];
         if(oldValue == value)
         {
            return;
         }
         if(isNaN(oldValue))
         {
            block.defaultCount -= 1;
            block.sizesSum += value;
         }
         else if(isNaN(value))
         {
            block.defaultCount += 1;
            block.sizesSum -= oldValue;
         }
         else
         {
            block.sizesSum += value - oldValue;
         }
         block.sizes[sizesIndex] = value;
      }
      
      public function insert(index:uint) : void
      {
         var lastIndex:int = 0;
         var intervalEnd:int = 0;
         if(Boolean(this.pendingRemoves))
         {
            this.flushPendingChanges();
         }
         if(Boolean(this.pendingInserts))
         {
            lastIndex = this.pendingInserts.length - 1;
            intervalEnd = this.pendingInserts[lastIndex];
            if(index == intervalEnd + 1)
            {
               this.pendingInserts[lastIndex] = index;
            }
            else if(index > intervalEnd)
            {
               this.pendingInserts.push(index);
               this.pendingInserts.push(index);
            }
            else
            {
               this.flushPendingChanges();
            }
         }
         this.pendingLength = Math.max(this.length + 1,index + 1);
         if(!this.pendingInserts)
         {
            this.pendingInserts = new Vector.<int>();
            this.pendingInserts.push(index);
            this.pendingInserts.push(index);
         }
      }
      
      public function remove(index:uint) : void
      {
         var lastIndex:int = 0;
         var intervalStart:int = 0;
         if(Boolean(this.pendingInserts))
         {
            this.flushPendingChanges();
         }
         if(index >= this.length)
         {
            throw new Error(this.resourceManager.getString("layout","invalidIndex"));
         }
         if(Boolean(this.pendingRemoves))
         {
            lastIndex = this.pendingRemoves.length - 1;
            intervalStart = this.pendingRemoves[lastIndex];
            if(index == intervalStart - 1)
            {
               this.pendingRemoves[lastIndex] = index;
            }
            else if(index < intervalStart)
            {
               this.pendingRemoves.push(index);
               this.pendingRemoves.push(index);
            }
            else
            {
               this.flushPendingChanges();
            }
         }
         this.pendingLength = this.pendingLength == -1 ? int(this.length - 1) : int(this.pendingLength - 1);
         if(!this.pendingRemoves)
         {
            this.pendingRemoves = new Vector.<int>();
            this.pendingRemoves.push(index);
            this.pendingRemoves.push(index);
         }
      }
      
      private function isIntervalClear(block:Block, index:int, count:int) : Boolean
      {
         var sizesSrc:Vector.<Number> = block.sizes;
         for(var i:int = 0; i < count; i++)
         {
            if(!isNaN(sizesSrc[index + i]))
            {
               return true;
            }
         }
         return false;
      }
      
      private function inBlockCopy(dstBlock:Block, dstIndexStart:int, srcBlock:Block, srcIndexStart:int, count:int) : void
      {
         var ascending:Boolean = dstIndexStart < srcIndexStart;
         var srcIndex:int = ascending ? srcIndexStart : int(srcIndexStart + count - 1);
         var dstIndex:int = ascending ? dstIndexStart : int(dstIndexStart + count - 1);
         var increment:int = ascending ? 1 : -1;
         var dstSizes:Vector.<Number> = dstBlock.sizes;
         var srcSizes:Vector.<Number> = Boolean(srcBlock) ? srcBlock.sizes : null;
         var dstValue:Number = NaN;
         var srcValue:Number = NaN;
         var sizesSumDelta:Number = 0;
         var defaultCountDelta:int = 0;
         while(count > 0)
         {
            if(Boolean(srcSizes))
            {
               srcValue = srcSizes[srcIndex];
            }
            dstValue = dstSizes[dstIndex];
            if(srcValue !== dstValue)
            {
               if(isNaN(dstValue))
               {
                  defaultCountDelta--;
               }
               else
               {
                  sizesSumDelta -= dstValue;
               }
               if(isNaN(srcValue))
               {
                  defaultCountDelta++;
               }
               else
               {
                  sizesSumDelta += srcValue;
               }
               dstSizes[dstIndex] = srcValue;
            }
            srcIndex += increment;
            dstIndex += increment;
            count--;
         }
         dstBlock.sizesSum += sizesSumDelta;
         dstBlock.defaultCount += defaultCountDelta;
      }
      
      private function copyInterval(dstIndex:int, srcIndex:int, count:int) : void
      {
         var dstBlockIndex:uint = 0;
         var dstSizesIndex:uint = 0;
         var dstBlock:Block = null;
         var srcBlockIndex:uint = 0;
         var srcSizesIndex:uint = 0;
         var srcBlock:Block = null;
         var copyCount:int = 0;
         var dstStartIndex:int = 0;
         var srcStartIndex:int = 0;
         var blockEndReached:Boolean = false;
         var ascending:Boolean = dstIndex < srcIndex;
         if(!ascending)
         {
            dstIndex += count - 1;
            srcIndex += count - 1;
         }
         while(count > 0)
         {
            dstBlockIndex = uint(dstIndex >> BLOCK_SHIFT);
            dstSizesIndex = uint(dstIndex & BLOCK_MASK);
            dstBlock = this.blockTable[dstBlockIndex];
            srcBlockIndex = uint(srcIndex >> BLOCK_SHIFT);
            srcSizesIndex = uint(srcIndex & BLOCK_MASK);
            srcBlock = this.blockTable[srcBlockIndex];
            if(ascending)
            {
               copyCount = Math.min(BLOCK_SIZE - dstSizesIndex,BLOCK_SIZE - srcSizesIndex);
            }
            else
            {
               copyCount = 1 + Math.min(dstSizesIndex,srcSizesIndex);
            }
            copyCount = Math.min(copyCount,count);
            dstStartIndex = ascending ? int(dstSizesIndex) : int(dstSizesIndex - copyCount + 1);
            srcStartIndex = ascending ? int(srcSizesIndex) : int(srcSizesIndex - copyCount + 1);
            if(Boolean(srcBlock) && Boolean(!dstBlock) && this.isIntervalClear(srcBlock,srcStartIndex,copyCount))
            {
               dstBlock = new Block();
               this.blockTable[dstBlockIndex] = dstBlock;
            }
            if(Boolean(dstBlock))
            {
               this.inBlockCopy(dstBlock,dstStartIndex,srcBlock,srcStartIndex,copyCount);
               if(dstBlock.defaultCount == BLOCK_SIZE)
               {
                  blockEndReached = ascending ? dstStartIndex + copyCount == BLOCK_SIZE : dstStartIndex == 0;
                  if(blockEndReached || count == copyCount)
                  {
                     this.blockTable[dstBlockIndex] = null;
                  }
               }
            }
            dstIndex += ascending ? copyCount : -copyCount;
            srcIndex += ascending ? copyCount : -copyCount;
            count -= copyCount;
         }
      }
      
      private function clearInterval(start:int, end:int) : void
      {
         var blockIndex:uint = 0;
         var sizesIndex:uint = 0;
         var block:Block = null;
         var clearCount:int = 0;
         while(start <= end)
         {
            blockIndex = uint(start >> BLOCK_SHIFT);
            sizesIndex = uint(start & BLOCK_MASK);
            block = this.blockTable[blockIndex];
            clearCount = BLOCK_SIZE - sizesIndex;
            clearCount = Math.min(clearCount,end - start + 1);
            if(Boolean(block))
            {
               if(clearCount == BLOCK_SIZE)
               {
                  this.blockTable[blockIndex] = null;
               }
               else
               {
                  this.inBlockCopy(block,sizesIndex,null,0,clearCount);
                  if(block.defaultCount == BLOCK_SIZE)
                  {
                     this.blockTable[blockIndex] = null;
                  }
               }
            }
            start += clearCount;
         }
      }
      
      private function removeIntervals(intervals:Vector.<int>) : void
      {
         var srcStart:int = 0;
         var count:int = 0;
         var intervalEnd:int = 0;
         var nextIntervalStart:int = 0;
         var intervalsCount:int = int(intervals.length);
         if(intervalsCount == 0)
         {
            return;
         }
         intervals.reverse();
         intervals.push(this.length);
         var dstStart:int = intervals[0];
         var i:int = 0;
         do
         {
            intervalEnd = intervals[i + 1];
            nextIntervalStart = intervals[i + 2];
            i += 2;
            srcStart = intervalEnd + 1;
            count = nextIntervalStart - srcStart;
            this.copyInterval(dstStart,srcStart,count);
            dstStart += count;
         }
         while(i < intervalsCount);
         this.setLength(dstStart);
      }
      
      private function insertIntervals(intervals:Vector.<int>, newLength:int) : void
      {
         var intervalStart:int = 0;
         var intervalEnd:int = 0;
         var dstStart:int = 0;
         var copyCount:int = 0;
         var srcStart:int = 0;
         var intervalsCount:int = int(intervals.length);
         if(intervalsCount == 0)
         {
            return;
         }
         var oldLength:int = int(this.length);
         this.setLength(newLength);
         var srcEnd:int = oldLength - 1;
         var dstEnd:int = newLength - 1;
         var i:int = intervalsCount - 2;
         while(i >= 0)
         {
            intervalStart = intervals[i];
            intervalEnd = intervals[i + 1];
            i -= 2;
            dstStart = intervalEnd + 1;
            copyCount = dstEnd - dstStart + 1;
            srcStart = srcEnd - copyCount + 1;
            this.copyInterval(dstStart,srcStart,copyCount);
            srcEnd -= copyCount;
            dstEnd = intervalStart - 1;
            this.clearInterval(intervalStart,intervalEnd);
         }
      }
      
      private function flushPendingChanges() : void
      {
         var intervals:Vector.<int> = null;
         var newLength:int = 0;
         if(Boolean(this.pendingRemoves))
         {
            intervals = this.pendingRemoves;
            this.pendingRemoves = null;
            this.pendingLength = -1;
            this.removeIntervals(intervals);
         }
         else if(Boolean(this.pendingInserts))
         {
            intervals = this.pendingInserts;
            newLength = this.pendingLength;
            this.pendingInserts = null;
            this.pendingLength = -1;
            this.insertIntervals(intervals,newLength);
         }
      }
      
      public function start(index:uint) : Number
      {
         var block:Block = null;
         var sizes:Vector.<Number> = null;
         var size:Number = NaN;
         this.flushPendingChanges();
         if(this._length == 0 || index == 0)
         {
            return this.majorAxisOffset;
         }
         if(index >= this._length)
         {
            throw new Error(this.resourceManager.getString("layout","invalidIndex"));
         }
         var distance:Number = this.majorAxisOffset;
         var blockIndex:uint = uint(index >> BLOCK_SHIFT);
         for(var i:int = 0; i < blockIndex; i++)
         {
            block = this.blockTable[i];
            if(Boolean(block))
            {
               distance += block.sizesSum + block.defaultCount * this._defaultMajorSize;
            }
            else
            {
               distance += BLOCK_SIZE * this._defaultMajorSize;
            }
         }
         var lastBlock:Block = this.blockTable[blockIndex];
         var lastBlockOffset:uint = uint(index & ~BLOCK_MASK);
         var lastBlockLength:uint = index - lastBlockOffset;
         if(Boolean(lastBlock))
         {
            sizes = lastBlock.sizes;
            for(i = 0; i < lastBlockLength; i++)
            {
               size = sizes[i];
               distance += isNaN(size) ? this._defaultMajorSize : size;
            }
         }
         else
         {
            distance += this._defaultMajorSize * lastBlockLength;
         }
         return distance + index * this.gap;
      }
      
      public function end(index:uint) : Number
      {
         this.flushPendingChanges();
         return this.start(index) + this.getMajorSize(index);
      }
      
      public function indexOf(distance:Number) : int
      {
         this.flushPendingChanges();
         var index:int = this.indexOfInternal(distance);
         return index >= this._length ? -1 : index;
      }
      
      private function indexOfInternal(distance:Number) : int
      {
         var blockDistance:Number = NaN;
         var sizes:Vector.<Number> = null;
         var i:int = 0;
         var size:Number = NaN;
         if(this._length == 0 || distance < 0)
         {
            return -1;
         }
         var curDistance:Number = this.majorAxisOffset;
         if(distance < curDistance)
         {
            return 0;
         }
         var index:int = -1;
         var block:Block = null;
         var blockGap:Number = this._gap * BLOCK_SIZE;
         for(var blockIndex:uint = 0; blockIndex < this.blockTable.length; blockIndex++)
         {
            block = this.blockTable[blockIndex];
            blockDistance = blockGap;
            if(Boolean(block))
            {
               blockDistance += block.sizesSum + block.defaultCount * this._defaultMajorSize;
            }
            else
            {
               blockDistance += BLOCK_SIZE * this._defaultMajorSize;
            }
            if(distance == curDistance || distance >= curDistance && distance < curDistance + blockDistance)
            {
               index = blockIndex << BLOCK_SHIFT;
               break;
            }
            curDistance += blockDistance;
         }
         if(index == -1 || distance == curDistance)
         {
            return index;
         }
         if(Boolean(block))
         {
            sizes = block.sizes;
            for(i = 0; i < BLOCK_SIZE - 1; i++)
            {
               size = sizes[i];
               curDistance += this._gap + (isNaN(size) ? this._defaultMajorSize : size);
               if(curDistance > distance)
               {
                  return index + i;
               }
            }
            return index + BLOCK_SIZE - 1;
         }
         return index + Math.floor(Number(distance - curDistance) / Number(this._defaultMajorSize + this._gap));
      }
      
      public function cacheDimensions(index:uint, elt:ILayoutElement) : void
      {
         var w:Number = NaN;
         var h:Number = NaN;
         this.flushPendingChanges();
         if(!elt || index >= this._length)
         {
            return;
         }
         if(this.majorAxis == VERTICAL)
         {
            this.setMajorSize(index,elt.getLayoutBoundsHeight());
            w = Math.min(elt.getPreferredBoundsWidth(),elt.getLayoutBoundsWidth());
            this._minorSize = Math.max(this._minorSize,w);
            this.minMinorSize = Math.max(this.minMinorSize,elt.getMinBoundsWidth());
         }
         else
         {
            this.setMajorSize(index,elt.getLayoutBoundsWidth());
            h = Math.min(elt.getPreferredBoundsHeight(),elt.getLayoutBoundsHeight());
            this._minorSize = Math.max(this._minorSize,h);
            this.minMinorSize = Math.max(this.minMinorSize,elt.getMinBoundsHeight());
         }
      }
      
      public function getBounds(index:uint, bounds:Rectangle = null) : Rectangle
      {
         this.flushPendingChanges();
         if(!bounds)
         {
            bounds = new Rectangle();
         }
         var major:Number = this.getMajorSize(index);
         var minor:Number = this.minorSize;
         if(this.majorAxis == VERTICAL)
         {
            bounds.x = 0;
            bounds.y = this.start(index);
            bounds.height = major;
            bounds.width = minor;
         }
         else
         {
            bounds.x = this.start(index);
            bounds.y = 0;
            bounds.height = minor;
            bounds.width = major;
         }
         return bounds;
      }
      
      public function clear() : void
      {
         this.pendingRemoves = null;
         this.pendingInserts = null;
         this.pendingLength = -1;
         this.length = 0;
         this.minorSize = 0;
         this.minMinorSize = 0;
      }
      
      public function toString() : String
      {
         return "LinearLayoutVector{" + "length=" + this._length + " [blocks=" + this.blockTable.length + "]" + " " + (this.majorAxis == VERTICAL ? "VERTICAL" : "HORIZONTAL") + " gap=" + this._gap + " defaultMajorSize=" + this._defaultMajorSize + " pendingRemoves=" + (Boolean(this.pendingRemoves) ? this.pendingRemoves.length : 0) + " pendingInserts=" + (Boolean(this.pendingInserts) ? this.pendingInserts.length : 0) + "}";
      }
   }
}

