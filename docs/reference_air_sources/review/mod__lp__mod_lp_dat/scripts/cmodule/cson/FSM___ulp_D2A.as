package cmodule.cson
{
   import avm2.intrinsics.memory.lf64;
   import avm2.intrinsics.memory.li32;
   import avm2.intrinsics.memory.si32;
   
   public final class FSM___ulp_D2A extends Machine
   {
      
      public function FSM___ulp_D2A()
      {
         super();
      }
      
      public static function start() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Number = NaN;
         cmodule.cson.mstate.esp -= 4;
         si32(cmodule.cson.mstate.ebp,cmodule.cson.mstate.esp);
         cmodule.cson.mstate.ebp = cmodule.cson.mstate.esp;
         cmodule.cson.mstate.esp -= 24;
         _loc1_ = li32(cmodule.cson.mstate.ebp + 12);
         _loc1_ &= 2146435072;
         _loc2_ = _loc1_ + -54525952;
         if(_loc2_ >= 1)
         {
            _loc1_ = 0;
            si32(_loc1_,cmodule.cson.mstate.ebp + -8);
            si32(_loc2_,cmodule.cson.mstate.ebp + -4);
            _loc4_ = lf64(cmodule.cson.mstate.ebp + -8);
         }
         else
         {
            _loc1_ = 54525952 - _loc1_;
            _loc1_ >>= 20;
            if(_loc1_ <= 19)
            {
               _loc2_ = 524288;
               _loc3_ = 0;
               _loc1_ = _loc2_ >>> _loc1_;
               si32(_loc3_,cmodule.cson.mstate.ebp + -16);
               si32(_loc1_,cmodule.cson.mstate.ebp + -12);
               _loc4_ = lf64(cmodule.cson.mstate.ebp + -16);
            }
            else
            {
               _loc2_ = _loc1_ + -20;
               if(_loc2_ <= 30)
               {
                  _loc2_ = 1;
                  _loc1_ = 51 - _loc1_;
                  _loc3_ = 0;
                  _loc1_ = _loc2_ << _loc1_;
                  si32(_loc1_,cmodule.cson.mstate.ebp + -24);
                  si32(_loc3_,cmodule.cson.mstate.ebp + -20);
                  _loc4_ = lf64(cmodule.cson.mstate.ebp + -24);
               }
               else
               {
                  _loc4_ = 4.9e-324;
               }
            }
         }
         cmodule.cson.mstate.st0 = _loc4_;
         cmodule.cson.mstate.esp = cmodule.cson.mstate.ebp;
         cmodule.cson.mstate.ebp = li32(cmodule.cson.mstate.esp);
         cmodule.cson.mstate.esp += 4;
         cmodule.cson.mstate.esp += 4;
      }
   }
}

