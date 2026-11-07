package cmodule.cson
{
   import avm2.intrinsics.memory.li32;
   import avm2.intrinsics.memory.li8;
   import avm2.intrinsics.memory.si32;
   
   public final class FSM_strtol extends Machine
   {
      
      public function FSM_strtol()
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
         _loc1_ = 0;
         _loc2_ = li32(cmodule.cson.mstate.ebp + 8);
         _loc3_ = _loc2_;
         do
         {
            _loc4_ = 16384;
            _loc5_ = _loc3_ + _loc1_;
            _loc5_ = li8(_loc5_);
            cmodule.cson.mstate.esp -= 8;
            si32(_loc5_,cmodule.cson.mstate.esp);
            si32(_loc4_,cmodule.cson.mstate.esp + 4);
            cmodule.cson.mstate.esp -= 4;
            FSM___istype.start();
            _loc4_ = int(cmodule.cson.mstate.eax);
            cmodule.cson.mstate.esp += 8;
            _loc1_ += 1;
         }
         while(_loc4_ != 0);
         _loc3_ = _loc2_ + _loc1_;
         _loc4_ = _loc5_ & 0xFF;
         if(_loc4_ != 43)
         {
            _loc4_ = _loc5_ & 0xFF;
            if(_loc4_ != 45)
            {
               _loc1_ = 1;
               _loc2_ = _loc3_;
               _loc3_ = _loc5_;
            }
            else
            {
               _loc4_ = 0;
               _loc1_ <<= 0;
               _loc1_ += _loc2_;
               _loc3_ = li8(_loc3_);
               _loc2_ = _loc1_ + 1;
               _loc1_ = _loc4_;
            }
         }
         else
         {
            _loc4_ = 1;
            _loc1_ <<= 0;
            _loc1_ += _loc2_;
            _loc3_ = li8(_loc3_);
            _loc2_ = _loc1_ + 1;
            _loc1_ = _loc4_;
         }
         _loc4_ = 0;
         _loc5_ = _loc1_ & 1;
         _loc5_ = _loc5_ != 0 ? 2147483647 : -2147483648;
         _loc6_ = uint(_loc5_) / uint(10);
         _loc7_ = _loc6_ * 10;
         _loc7_ = _loc5_ - _loc7_;
         _loc8_ = _loc4_;
         loop1:
         while(true)
         {
            _loc9_ = _loc3_ + -48;
            _loc9_ = _loc9_ & 0xFF;
            loop4:
            while(true)
            {
               loop5:
               while(true)
               {
                  if(uint(_loc9_) >= uint(10))
                  {
                     while(true)
                     {
                        _loc9_ = _loc3_ + -65;
                        _loc9_ = _loc9_ & 0xFF;
                        if(uint(_loc9_) <= uint(25))
                        {
                           _loc3_ += -55;
                           _loc9_ = _loc3_ << 24;
                           _loc9_ = _loc9_ >> 24;
                           if(_loc9_ >= 10)
                           {
                              break loop5;
                           }
                        }
                        else
                        {
                           _loc9_ = _loc3_ + -97;
                           _loc9_ = _loc9_ & 0xFF;
                           if(uint(_loc9_) > uint(25))
                           {
                              break loop4;
                           }
                           _loc3_ += -87;
                           _loc9_ = _loc3_ << 24;
                           _loc9_ = _loc9_ >> 24;
                           if(_loc9_ > 9)
                           {
                              break loop4;
                           }
                        }
                        addr02bf:
                        while(_loc4_ >= 0)
                        {
                           if(uint(_loc8_) > uint(_loc6_))
                           {
                              _loc9_ = 1;
                              _loc8_ = _loc3_;
                              _loc3_ = _loc4_;
                              _loc4_ = _loc9_;
                              break;
                           }
                           if(_loc8_ == _loc6_)
                           {
                              _loc4_ = _loc3_ << 24;
                              _loc4_ = _loc4_ >> 24;
                              if(_loc4_ > _loc7_)
                              {
                                 _loc9_ = 1;
                                 _loc8_ = _loc3_;
                                 _loc3_ = _loc4_;
                                 _loc4_ = _loc9_;
                                 break;
                              }
                           }
                           _loc3_ <<= 24;
                           _loc3_ >>= 24;
                           _loc8_ *= 10;
                           _loc4_ = li8(_loc2_);
                           _loc2_ += 1;
                           _loc3_ = _loc8_ + _loc3_;
                           _loc8_ = _loc4_ + -48;
                           _loc8_ = _loc8_ & 0xFF;
                           if(uint(_loc8_) >= uint(10))
                           {
                              _loc9_ = 1;
                              _loc8_ = _loc3_;
                              _loc3_ = _loc4_;
                              _loc4_ = _loc9_;
                              break;
                           }
                           _loc9_ = 1;
                           _loc8_ = _loc3_;
                           _loc3_ = _loc4_;
                           _loc4_ = _loc9_;
                        }
                     }
                     break loop4;
                  }
                  _loc3_ += -48;
                  _loc9_ = _loc3_ << 24;
                  _loc9_ = _loc9_ >> 24;
                  if(_loc9_ < 10)
                  {
                     §§goto(addr02bf);
                  }
                  _loc2_ = _loc8_;
                  _loc3_ = _loc4_;
                  break loop1;
               }
               §§goto(addr0213);
            }
            _loc4_ = -1;
            _loc3_ = li8(_loc2_);
            _loc2_ += 1;
            addr0213:
            _loc2_ = _loc8_;
            _loc3_ = _loc4_;
            break;
         }
         if(_loc3_ <= -1)
         {
            _loc1_ = 34;
            si32(_loc1_,cmodule.cson._val_2E_1088);
            cmodule.cson.mstate.eax = _loc5_;
         }
         else if(_loc3_ == 0)
         {
            _loc1_ = 22;
            si32(_loc1_,cmodule.cson._val_2E_1088);
            cmodule.cson.mstate.eax = _loc2_;
         }
         else
         {
            _loc1_ &= 1;
            _loc3_ = 0 - _loc2_;
            _loc1_ = _loc1_ != 0 ? _loc2_ : _loc3_;
            cmodule.cson.mstate.eax = _loc1_;
         }
         cmodule.cson.mstate.esp = cmodule.cson.mstate.ebp;
         cmodule.cson.mstate.ebp = li32(cmodule.cson.mstate.esp);
         cmodule.cson.mstate.esp += 4;
         cmodule.cson.mstate.esp += 4;
      }
   }
}

