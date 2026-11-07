package spark.layouts.supportClasses
{
   [ExcludeClass]
   public final class Block
   {
      
      internal const sizes:Vector.<Number> = new Vector.<Number>(LinearLayoutVector.BLOCK_SIZE,true);
      
      internal var sizesSum:Number = 0;
      
      internal var defaultCount:uint = LinearLayoutVector.BLOCK_SIZE;
      
      public function Block()
      {
         super();
         for(var i:int = 0; i < LinearLayoutVector.BLOCK_SIZE; i++)
         {
            this.sizes[i] = NaN;
         }
      }
   }
}

