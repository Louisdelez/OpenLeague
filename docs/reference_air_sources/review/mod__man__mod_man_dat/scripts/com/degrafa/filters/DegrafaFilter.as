package com.degrafa.filters
{
   import com.degrafa.core.DegrafaObject;
   import flash.filters.BitmapFilter;
   
   public class DegrafaFilter extends DegrafaObject
   {
      
      public function DegrafaFilter()
      {
         super();
      }
      
      protected function setValue(param1:String, param2:*) : void
      {
         var _loc3_:* = bitmapFilter[param1];
         if(_loc3_ == param2)
         {
            return;
         }
         bitmapFilter[param1] = param2;
         dispatchPropertyChange(false,param1,_loc3_,param2);
      }
      
      public function get bitmapFilter() : BitmapFilter
      {
         throw new Error("Subclass to override get bitmapFilter()");
      }
   }
}

