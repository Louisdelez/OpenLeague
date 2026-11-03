package blix.layout.util
{
   import blix.layout.vo.Size;
   
   public final class FitSizesUtil
   {
      
      public function FitSizesUtil()
      {
         super();
      }
      
      public static function fitSizesToValue(param1:Vector.<Size>, param2:Number) : void
      {
         var _loc3_:Size = null;
         var _loc7_:Number = NaN;
         if(!param1.length)
         {
            return;
         }
         var _loc4_:Vector.<Size> = new Vector.<Size>();
         var _loc5_:Vector.<Size> = new Vector.<Size>();
         var _loc6_:Vector.<Size> = new Vector.<Size>();
         for each(_loc3_ in param1)
         {
            if(isNaN(_loc3_.getActual()))
            {
               _loc6_.push(_loc3_);
            }
            if(_loc3_.getIsSet())
            {
               _loc4_.push(_loc3_);
            }
            else
            {
               _loc5_.push(_loc3_);
            }
         }
         _loc7_ = (param2 - calculateTotal(param1)) / _loc6_.length;
         for each(_loc3_ in _loc6_)
         {
            _loc3_.setActual(_loc7_);
         }
         fitSizesToValueNotExplicit(_loc5_,param2 - calculateIdealTotalSize(_loc4_));
         fitSizesToValueExplicit(_loc4_,param2 - calculateTotal(_loc5_));
      }
      
      private static function fitSizesToValueNotExplicit(param1:Vector.<Size>, param2:Number) : void
      {
         var _loc6_:Size = null;
         var _loc7_:Number = NaN;
         if(!param1.length)
         {
            return;
         }
         var _loc3_:Number = param2 / calculateTotal(param1);
         var _loc4_:Number = param2;
         var _loc5_:Vector.<Size> = new Vector.<Size>();
         for each(_loc6_ in param1)
         {
            _loc7_ = _loc6_.getActual() * _loc3_;
            if(_loc7_ < _loc6_.getMin())
            {
               _loc7_ = _loc6_.getMin();
               _loc4_ -= _loc7_;
            }
            else if(_loc7_ > _loc6_.getMax())
            {
               _loc7_ = _loc6_.getMax();
               _loc4_ -= _loc7_;
            }
            else
            {
               _loc5_.push(_loc6_);
            }
            _loc6_.setActual(_loc7_);
         }
         if(_loc4_ < param2)
         {
            fitSizesToValueNotExplicit(_loc5_,_loc4_);
         }
      }
      
      private static function fitSizesToValueExplicit(param1:Vector.<Size>, param2:Number) : void
      {
         var _loc3_:Number = NaN;
         var _loc7_:Size = null;
         if(!param1.length)
         {
            return;
         }
         var _loc4_:Number = param2 / calculateIdealTotalSize(param1);
         var _loc5_:Number = param2;
         var _loc6_:Vector.<Size> = new Vector.<Size>();
         for each(_loc7_ in param1)
         {
            _loc3_ = Math.min(Math.max(_loc7_.getValue(),_loc7_.getMin()),_loc7_.getMax());
            if(_loc7_.getIsFlexible())
            {
               _loc3_ *= _loc4_;
               if(_loc3_ < _loc7_.getMin())
               {
                  _loc3_ = _loc7_.getMin();
                  _loc5_ -= _loc3_;
               }
               else if(_loc3_ > _loc7_.getMax())
               {
                  _loc3_ = _loc7_.getMax();
                  _loc5_ -= _loc3_;
               }
               else
               {
                  _loc6_.push(_loc7_);
               }
            }
            else
            {
               _loc5_ -= _loc3_;
            }
            _loc7_.setActual(_loc3_);
         }
         if(_loc5_ < param2)
         {
            fitSizesToValueExplicit(_loc6_,_loc5_);
         }
      }
      
      public static function calculateTotal(param1:Vector.<Size>) : Number
      {
         var _loc3_:Size = null;
         var _loc2_:Number = 0;
         for each(_loc3_ in param1)
         {
            if(!isNaN(_loc3_.getActual()))
            {
               _loc2_ += _loc3_.getActual();
            }
         }
         return _loc2_;
      }
      
      public static function calculateIdealTotalSize(param1:Vector.<Size>) : Number
      {
         var _loc3_:Number = NaN;
         var _loc4_:Size = null;
         var _loc2_:Number = 0;
         for each(_loc4_ in param1)
         {
            if(!isNaN(_loc4_.getValue()))
            {
               _loc3_ = _loc4_.getValue();
               _loc3_ = Math.max(_loc3_,_loc4_.getMin());
               if(!isNaN(_loc4_.getMax()))
               {
                  _loc3_ = Math.min(_loc3_,_loc4_.getMax());
               }
               _loc2_ += _loc3_;
            }
         }
         return _loc2_;
      }
      
      public static function resize(param1:Size, param2:Vector.<Size>, param3:Number, param4:Number) : void
      {
         var _loc9_:Size = null;
         var _loc10_:Size = null;
         var _loc5_:int = param2.indexOf(param1);
         if(_loc5_ == -1)
         {
            return;
         }
         param1.setSize(param3);
         var _loc6_:Vector.<Size> = param2.slice(_loc5_ + 1);
         var _loc7_:Number = param4;
         var _loc8_:uint = 0;
         while(_loc8_ <= _loc5_)
         {
            _loc10_ = param2[_loc8_];
            if(isNaN(_loc10_.getActual()))
            {
               _loc10_.setActual(_loc10_.getValue());
            }
            _loc7_ -= _loc10_.getActual();
            _loc8_++;
         }
         fitSizesToValue(_loc6_,_loc7_);
         for each(_loc9_ in param2)
         {
            _loc9_.setSize(_loc9_.getActual());
         }
      }
   }
}

