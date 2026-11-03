package com.riotgames.rust.components.list
{
   import blix.assets.proxy.DisplayObjectProxy;
   import blix.components.renderer.IDataRenderer;
   import blix.signals.Signal;
   
   public class ListLayoutSmoothVariableNonVirtual extends ListLayoutBase implements IListLayout
   {
      
      public function ListLayoutSmoothVariableNonVirtual(param1:ListViewBehavior, param2:Signal = null)
      {
         super(param1,param2);
      }
      
      override public function doLayout() : void
      {
         var _loc3_:DisplayObjectProxy = null;
         var _loc4_:IDataRenderer = null;
         var _loc5_:Number = NaN;
         var _loc6_:int = 0;
         var _loc7_:Number = NaN;
         if(!data)
         {
            return;
         }
         var _loc1_:Boolean = true;
         var _loc2_:int = 0;
         while(_loc2_ < data.length)
         {
            _loc3_ = view.getItem(data[_loc2_]) as DisplayObjectProxy;
            if(_loc3_.getLinkage() != null && _loc3_.getLinkage().length > 0 && _loc3_.getAsset() == null)
            {
               _loc1_ = false;
               break;
            }
            _loc2_++;
         }
         if(!_loc1_)
         {
            return;
         }
         if(activeItems.length != data.length)
         {
            _loc5_ = 0;
            _loc6_ = 0;
            while(_loc6_ <= data.length - 1)
            {
               _loc4_ = addItem(_loc6_,_loc5_);
               _loc5_ += layoutHelper.getSpan(_loc4_ as DisplayObjectProxy) + view.itemPadding;
               _loc6_++;
            }
            _loc7_ = Math.max(0,view.getContentSpan() - view.getPageSize());
            view.scrollModel.setMax(_loc7_);
         }
      }
      
      public function snap() : void
      {
         var _loc1_:DisplayObjectProxy = activeItems[this.getSnapIndex()];
         if(Boolean(_loc1_))
         {
            view.scrollModel.setValue(layoutHelper.getPosition(_loc1_));
         }
      }
      
      private function getSnapIndex(param1:Number = 0) : int
      {
         var _loc2_:int = 0;
         var _loc6_:DisplayObjectProxy = null;
         var _loc7_:Number = NaN;
         var _loc3_:Number = int.MAX_VALUE;
         var _loc4_:Number = view.scrollModel.getClampedValue() + param1;
         var _loc5_:int = 0;
         while(_loc5_ < data.length)
         {
            _loc6_ = activeItems[_loc5_];
            _loc7_ = Math.abs(layoutHelper.getPosition(_loc6_) - _loc4_);
            if(_loc7_ >= _loc3_)
            {
               break;
            }
            _loc2_ = _loc5_;
            _loc3_ = _loc7_;
            _loc5_++;
         }
         return _loc2_;
      }
      
      public function step(param1:int) : void
      {
         var _loc2_:int = this.getSnapIndex() + param1;
         _loc2_ = Math.min(Math.max(0,_loc2_),data.length - 1);
         var _loc3_:DisplayObjectProxy = activeItems[_loc2_];
         if(Boolean(_loc3_))
         {
            view.scrollModel.setValue(layoutHelper.getPosition(_loc3_));
         }
      }
      
      public function page(param1:int) : void
      {
         var _loc2_:int = this.getSnapIndex(param1 * view.getPageSize());
         _loc2_ = Math.min(Math.max(0,_loc2_),data.length - 1);
         var _loc3_:DisplayObjectProxy = activeItems[_loc2_];
         if(Boolean(_loc3_))
         {
            view.scrollModel.setValue(layoutHelper.getPosition(_loc3_));
         }
      }
   }
}

