package com.riotgames.rust.components.list
{
   import blix.assets.proxy.DisplayObjectProxy;
   import blix.components.renderer.IDataRenderer;
   import blix.signals.Signal;
   
   public class ListLayoutSmoothFixedVirtual extends ListLayoutBase implements IListLayout
   {
      
      public var explicitItemSpan:Number;
      
      protected var measuredItemSpan:Number;
      
      protected var firstActiveItem:int = 0;
      
      protected var lastActiveItem:int = -1;
      
      public function ListLayoutSmoothFixedVirtual(param1:ListViewBehavior, param2:Signal = null)
      {
         super(param1,param2);
      }
      
      override public function resetLayout() : void
      {
         super.resetLayout();
         this.firstActiveItem = 0;
         this.lastActiveItem = -1;
      }
      
      protected function calculateTotalSpan() : Number
      {
         var _loc1_:IDataRenderer = null;
         if(!isNaN(this.explicitItemSpan))
         {
            return this.explicitItemSpan + view.itemPadding;
         }
         if(isNaN(this.measuredItemSpan))
         {
            _loc1_ = view.getItem(data[0]);
            this.measuredItemSpan = layoutHelper.getSpan(_loc1_ as DisplayObjectProxy);
            view.removeItem(_loc1_);
         }
         if(isNaN(this.measuredItemSpan))
         {
            return view.itemPadding;
         }
         return this.measuredItemSpan + view.itemPadding;
      }
      
      override public function doLayout() : void
      {
         var _loc7_:int = 0;
         var _loc8_:IDataRenderer = null;
         if(!data || data.length == 0)
         {
            return;
         }
         var _loc1_:Number = this.calculateTotalSpan();
         var _loc2_:int = 0;
         var _loc3_:int = data.length - 1;
         var _loc4_:Number = view.getMinVisiblePosition();
         var _loc5_:Number = view.getMaxVisiblePosition();
         _loc2_ = Math.max(0,Math.floor(_loc4_ / _loc1_));
         _loc3_ = Math.min(data.length - 1,Math.ceil(_loc5_ / _loc1_));
         if(this.firstActiveItem != _loc2_ || this.lastActiveItem != _loc3_)
         {
            _loc7_ = this.firstActiveItem;
            while(_loc7_ <= this.lastActiveItem)
            {
               if(_loc7_ < _loc2_ || _loc7_ > _loc3_)
               {
                  removeItem(_loc7_);
               }
               _loc7_++;
            }
            _loc7_ = _loc2_;
            while(_loc7_ <= _loc3_)
            {
               if(activeItems[_loc7_] == null)
               {
                  addItem(_loc7_,_loc7_ * _loc1_);
               }
               _loc7_++;
            }
            this.firstActiveItem = _loc2_;
            this.lastActiveItem = _loc3_;
         }
         var _loc6_:Number = data.length * _loc1_ - view.getPageSize();
         view.scrollModel.setMax(Math.max(0,_loc6_));
      }
      
      public function snap() : void
      {
         var _loc1_:int = Math.round(view.scrollModel.getClampedValue() / this.calculateTotalSpan());
         view.scrollModel.setValue(_loc1_ * this.calculateTotalSpan());
      }
      
      public function step(param1:int) : void
      {
         var _loc2_:int = Math.round(view.scrollModel.getClampedValue() / this.calculateTotalSpan());
         _loc2_ += param1;
         view.scrollModel.setValue(_loc2_ * this.calculateTotalSpan());
      }
      
      public function page(param1:int) : void
      {
         var _loc2_:int = Math.round((view.scrollModel.getClampedValue() + param1 * view.getPageSize()) / this.calculateTotalSpan());
         _loc2_ -= param1;
         view.scrollModel.setValue(_loc2_ * this.calculateTotalSpan());
      }
   }
}

