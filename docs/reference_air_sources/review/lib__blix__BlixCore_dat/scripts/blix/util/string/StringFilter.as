package blix.util.string
{
   public class StringFilter
   {
      
      protected var excludeFilters:Vector.<String> = new Vector.<String>();
      
      protected var includeFilters:Vector.<String> = new Vector.<String>();
      
      public function StringFilter()
      {
         super();
      }
      
      public function filter(param1:String) : Boolean
      {
         var _loc2_:String = null;
         var _loc3_:Boolean = false;
         var _loc4_:String = null;
         for each(_loc2_ in this.excludeFilters)
         {
            _loc3_ = false;
            if(param1.search(_loc2_) == 0)
            {
               for each(_loc4_ in this.includeFilters)
               {
                  if(param1.search(_loc4_) == 0)
                  {
                     _loc3_ = true;
                     break;
                  }
               }
               if(_loc3_)
               {
                  break;
               }
               return false;
            }
         }
         return true;
      }
      
      public function addExcludeFilter(param1:String) : void
      {
         this.excludeFilters[this.excludeFilters.length] = param1;
      }
      
      public function removeExcludeFilter(param1:String) : void
      {
         var _loc2_:int = this.excludeFilters.indexOf(param1);
         if(_loc2_ != -1)
         {
            this.excludeFilters.splice(_loc2_,1);
         }
      }
      
      public function addIncludeFilter(param1:String) : void
      {
         this.includeFilters[this.includeFilters.length] = param1;
      }
      
      public function removeIncludeFilter(param1:String) : void
      {
         var _loc2_:int = this.includeFilters.indexOf(param1);
         if(_loc2_ != -1)
         {
            this.includeFilters.splice(_loc2_,1);
         }
      }
   }
}

