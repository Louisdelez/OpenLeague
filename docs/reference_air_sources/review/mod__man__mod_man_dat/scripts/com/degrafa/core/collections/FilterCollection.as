package com.degrafa.core.collections
{
   import com.degrafa.filters.DegrafaFilter;
   import flash.filters.BitmapFilter;
   import mx.events.PropertyChangeEvent;
   
   public class FilterCollection extends DegrafaCollection
   {
      
      private var degrafaFilters:Array = [];
      
      public function FilterCollection(param1:Array = null, param2:Boolean = false)
      {
         super(BitmapFilter,param1,param2);
      }
      
      override public function set items(param1:Array) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:* = undefined;
         var _loc5_:DegrafaFilter = null;
         if(!param1)
         {
            param1 = [];
         }
         removeAllWatchers();
         degrafaFilters = [];
         var _loc2_:Array = [];
         _loc3_ = 0;
         while(_loc3_ < param1.length)
         {
            _loc4_ = param1[_loc3_];
            _loc5_ = _loc4_ as DegrafaFilter;
            if(_loc5_)
            {
               _loc2_.push(_loc5_.bitmapFilter);
               degrafaFilters.push(_loc5_);
               addWatcher(_loc5_);
            }
            else
            {
               _loc2_.push(_loc4_);
            }
            _loc3_++;
         }
         super.items = _loc2_;
      }
      
      public function addItem(param1:BitmapFilter) : BitmapFilter
      {
         return super._addItem(param1);
      }
      
      public function addItemAt(param1:BitmapFilter, param2:Number) : BitmapFilter
      {
         return super._addItemAt(param1,param2);
      }
      
      public function getItemIndex(param1:BitmapFilter) : int
      {
         return super._getItemIndex(param1);
      }
      
      public function removeItemAt(param1:Number) : BitmapFilter
      {
         return super._removeItemAt(param1);
      }
      
      private function filterPropertyChangeHandler(param1:PropertyChangeEvent) : void
      {
         var _loc2_:BitmapFilter = DegrafaFilter(param1.target).bitmapFilter;
         dispatchPropertyChange(false,param1.property,param1.oldValue,param1.newValue,_loc2_);
      }
      
      private function removeAllWatchers() : void
      {
         var _loc1_:DegrafaFilter = null;
         for each(_loc1_ in degrafaFilters)
         {
            _loc1_.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE,filterPropertyChangeHandler);
         }
      }
      
      public function removeItem(param1:BitmapFilter) : BitmapFilter
      {
         return super._removeItem(param1);
      }
      
      private function addWatcher(param1:DegrafaFilter) : void
      {
         param1.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,filterPropertyChangeHandler,false,0,true);
      }
      
      public function getItemAt(param1:Number) : BitmapFilter
      {
         return super._getItemAt(param1);
      }
      
      public function setItemIndex(param1:BitmapFilter, param2:Number) : Boolean
      {
         return super._setItemIndex(param1,param2);
      }
      
      public function addItems(param1:FilterCollection) : FilterCollection
      {
         super.concat(param1.items);
         return this;
      }
   }
}

