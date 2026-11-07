package blix.ds
{
   import flash.utils.Proxy;
   import flash.utils.flash_proxy;
   
   use namespace flash_proxy;
   
   public class Iterator extends Proxy implements IIterator
   {
      
      private var dataSource:IListX;
      
      private var currentIndex:int;
      
      public function Iterator(param1:IListX, param2:int)
      {
         super();
         this.dataSource = param1;
         this.currentIndex = param2;
      }
      
      public function hasNext() : Boolean
      {
         return this.currentIndex < this.dataSource.getLength() - 1;
      }
      
      public function getNext() : Object
      {
         if(this.currentIndex >= this.dataSource.getLength())
         {
            return null;
         }
         return this.dataSource.getItemAt(++this.currentIndex);
      }
      
      public function hasPrevious() : Boolean
      {
         return this.currentIndex > 0;
      }
      
      public function getPrevious() : Object
      {
         if(this.currentIndex <= 0)
         {
            return null;
         }
         return this.dataSource.getItemAt(--this.currentIndex);
      }
      
      public function getCurrent() : Object
      {
         return this.dataSource.getItemAt(this.currentIndex);
      }
      
      override flash_proxy function getProperty(param1:*) : *
      {
         return this.dataSource.getItemAt(this.currentIndex + 1 + (param1 as uint));
      }
      
      override flash_proxy function nextNameIndex(param1:int) : int
      {
         if(this.currentIndex + 1 >= this.dataSource.getLength())
         {
            return 0;
         }
         return 1;
      }
      
      override flash_proxy function nextName(param1:int) : String
      {
         return String(param1);
      }
      
      override flash_proxy function nextValue(param1:int) : *
      {
         return this.dataSource.getItemAt(++this.currentIndex);
      }
   }
}

