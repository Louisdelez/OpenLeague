package cmodule.cson
{
   import avm2.intrinsics.memory.lf64;
   import avm2.intrinsics.memory.li32;
   import avm2.intrinsics.memory.si32;
   
   public final class FSM___b2d_D2A extends Machine
   {
      
      public function FSM___b2d_D2A()
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
         var _loc10_:int = 0;
         var _loc11_:Number = NaN;
         cmodule.cson.mstate.esp -= 4;
         si32(cmodule.cson.mstate.ebp,cmodule.cson.mstate.esp);
         cmodule.cson.mstate.ebp = cmodule.cson.mstate.esp;
         cmodule.cson.mstate.esp -= 8;
         _loc1_ = li32(cmodule.cson.mstate.ebp + 8);
         _loc2_ = li32(_loc1_ + 16);
         _loc3_ = _loc2_ + -1;
         _loc4_ = _loc3_ << 2;
         _loc5_ = _loc1_ + 20;
         _loc4_ = _loc5_ + _loc4_;
         _loc6_ = li32(_loc4_);
         _loc7_ = uint(_loc6_) < uint(65536) ? 16 : 0;
         _loc8_ = _loc6_ << _loc7_;
         _loc9_ = uint(_loc8_) < uint(16777216) ? 8 : 0;
         _loc8_ <<= _loc9_;
         _loc10_ = uint(_loc8_) < uint(268435456) ? 4 : 0;
         _loc7_ = _loc9_ | _loc7_;
         _loc8_ <<= _loc10_;
         _loc9_ = uint(_loc8_) < uint(1073741824) ? 2 : 0;
         _loc7_ |= _loc10_;
         _loc7_ = _loc7_ | _loc9_;
         _loc8_ <<= _loc9_;
         _loc9_ = li32(cmodule.cson.mstate.ebp + 12);
         if(_loc8_ > -1)
         {
            _loc8_ &= 1073741824;
            _loc7_ += 1;
            _loc7_ = _loc8_ == 0 ? 32 : _loc7_;
         }
         _loc8_ = 32 - _loc7_;
         si32(_loc8_,_loc9_);
         if(_loc7_ <= 10)
         {
            _loc4_ = _loc7_ + 21;
            _loc5_ = 11 - _loc7_;
            _loc4_ = _loc6_ << _loc4_;
            _loc6_ >>>= _loc5_;
            if(_loc3_ <= 0)
            {
               _loc5_ = _loc6_;
            }
            else
            {
               _loc2_ <<= 2;
               _loc1_ = _loc2_ + _loc1_;
               _loc1_ = li32(_loc1_ + 12);
               _loc5_ = _loc1_ >>> _loc5_;
               _loc4_ = _loc5_ | _loc4_;
               _loc5_ = _loc6_;
            }
         }
         else
         {
            if(_loc3_ <= 0)
            {
               _loc1_ = 0;
               _loc2_ = _loc4_;
            }
            else
            {
               _loc2_ <<= 2;
               _loc1_ = _loc2_ + _loc1_;
               _loc4_ = li32(_loc1_ + 12);
               _loc1_ += 12;
               _loc2_ = _loc1_;
               _loc1_ = _loc4_;
            }
            _loc4_ = _loc2_;
            _loc2_ = _loc7_ + -11;
            if(_loc7_ == 11)
            {
               _loc5_ = _loc6_;
               _loc4_ = _loc1_;
            }
            else
            {
               _loc3_ = 43 - _loc7_;
               _loc7_ = _loc1_ >>> _loc3_;
               _loc6_ <<= _loc2_;
               _loc6_ = _loc7_ | _loc6_;
               if(uint(_loc4_) <= uint(_loc5_))
               {
                  _loc4_ = 0;
               }
               else
               {
                  _loc4_ = li32(_loc4_ + -4);
               }
               _loc4_ >>>= _loc3_;
               _loc5_ = _loc1_ << _loc2_;
               _loc4_ |= _loc5_;
               _loc5_ = _loc6_;
            }
         }
         _loc1_ = _loc5_;
         _loc2_ = _loc4_;
         _loc1_ |= 1072693248;
         si32(_loc2_,cmodule.cson.mstate.ebp + -8);
         si32(_loc1_,cmodule.cson.mstate.ebp + -4);
         _loc11_ = lf64(cmodule.cson.mstate.ebp + -8);
         cmodule.cson.mstate.st0 = _loc11_;
         cmodule.cson.mstate.esp = cmodule.cson.mstate.ebp;
         cmodule.cson.mstate.ebp = li32(cmodule.cson.mstate.esp);
         cmodule.cson.mstate.esp += 4;
         cmodule.cson.mstate.esp += 4;
      }
   }
}

