package cmodule.cson
{
   import avm2.intrinsics.memory.li32;
   import avm2.intrinsics.memory.si32;
   
   public final class FSM___ashrdi3 extends Machine
   {
      
      public function FSM___ashrdi3()
      {
         super();
      }
      
      public static function start() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         cmodule.cson.mstate.esp -= 4;
         si32(cmodule.cson.mstate.ebp,cmodule.cson.mstate.esp);
         cmodule.cson.mstate.ebp = cmodule.cson.mstate.esp;
         cmodule.cson.mstate.esp -= 0;
         _loc1_ = li32(cmodule.cson.mstate.ebp + 16);
         _loc2_ = li32(cmodule.cson.mstate.ebp + 20);
         _loc3_ = li32(cmodule.cson.mstate.ebp + 8);
         _loc4_ = li32(cmodule.cson.mstate.ebp + 12);
         _loc5_ = uint(_loc1_) < uint(32) ? 1 : 0;
         while(true)
         {
            _loc6_ = _loc2_ == 0 ? 1 : 0;
            _loc5_ = _loc6_ != 0 ? _loc5_ : 0;
            if(_loc5_ == 0)
            {
               _loc3_ = 0;
               _loc5_ = _loc4_ >> 31;
               _loc6_ = _loc2_ != 0 ? 1 : 0;
               _loc7_ = uint(_loc1_) > uint(63) ? 1 : 0;
               _loc2_ = _loc2_ == 0 ? 1 : 0;
               _loc8_ = _loc3_;
               _loc9_ = _loc5_;
               _loc2_ = _loc2_ != 0 ? _loc7_ : _loc6_;
               if(_loc2_ != 0)
               {
                  _loc1_ = _loc5_ | _loc3_;
                  _loc2_ = _loc8_ | _loc9_;
                  cmodule.cson.mstate.edx = _loc1_;
                  cmodule.cson.mstate.eax = _loc2_;
                  break;
               }
               _loc3_ = _loc1_ + -32;
               _loc3_ = _loc4_ >> _loc3_;
               _loc3_ |= _loc8_;
               cmodule.cson.mstate.edx = _loc5_;
            }
            else
            {
               _loc2_ = _loc1_ | _loc2_;
               if(_loc2_ != 0)
               {
                  _loc2_ = 32 - _loc1_;
                  _loc2_ = _loc4_ << _loc2_;
                  _loc3_ >>>= _loc1_;
                  _loc4_ >>= _loc1_;
                  _loc3_ = _loc2_ | _loc3_;
               }
               cmodule.cson.mstate.edx = _loc4_;
            }
            cmodule.cson.mstate.eax = _loc3_;
            break;
         }
         cmodule.cson.mstate.esp = cmodule.cson.mstate.ebp;
         cmodule.cson.mstate.ebp = li32(cmodule.cson.mstate.esp);
         cmodule.cson.mstate.esp += 4;
         cmodule.cson.mstate.esp += 4;
      }
   }
}

