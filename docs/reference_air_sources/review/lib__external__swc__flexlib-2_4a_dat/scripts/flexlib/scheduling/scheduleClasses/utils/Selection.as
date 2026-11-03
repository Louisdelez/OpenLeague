package flexlib.scheduling.scheduleClasses.utils
{
   import flash.utils.Dictionary;
   
   public class Selection
   {
      
      protected var items:Dictionary;
      
      public var allowMultipleSelection:Boolean = false;
      
      protected var item:Object;
      
      public function Selection()
      {
         super();
         items = new Dictionary();
      }
      
      private function setItem(value:Object) : void
      {
         item = value;
         items[value] = value;
      }
      
      public function get selectedItems() : Array
      {
         var result:Array = null;
         var item:Object = null;
         result = new Array();
         for each(item in items)
         {
            result.push(item);
         }
         return result;
      }
      
      public function set selectedItems(newItems:Array) : void
      {
         var item:Object = null;
         clear();
         if(newItems == null)
         {
            return;
         }
         for each(item in newItems)
         {
            items[item] = item;
         }
      }
      
      public function hasItem(item:Object) : Boolean
      {
         return items[item];
      }
      
      public function get selectedItem() : Object
      {
         return item;
      }
      
      public function clear() : void
      {
         item = null;
         items = new Dictionary();
      }
      
      public function addItem(item:Object) : void
      {
         if(allowMultipleSelection)
         {
            items[item] = item;
         }
         else
         {
            clear();
            setItem(item);
         }
      }
      
      public function removeItem(item:Object) : void
      {
         delete items[item];
         this.item = null;
      }
      
      public function set selectedItem(value:Object) : void
      {
         clear();
         setItem(value);
      }
      
      public function getNumberOfSelectedItems() : Number
      {
         var size:Number = NaN;
         var item:Object = null;
         size = 0;
         for each(item in items)
         {
            size++;
         }
         return size;
      }
   }
}

