package cmodule.cson
{
   import avm2.intrinsics.memory.li32;
   import avm2.intrinsics.memory.li8;
   import avm2.intrinsics.memory.si32;
   
   public final class FSM_strtoul extends Machine
   {
      
      public function FSM_strtoul()
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
         var _loc11_:int = 0;
         cmodule.cson.mstate.esp -= 4;
         si32(cmodule.cson.mstate.ebp,cmodule.cson.mstate.esp);
         cmodule.cson.mstate.ebp = cmodule.cson.mstate.esp;
         cmodule.cson.mstate.esp -= 0;
         _loc1_ = 0;
         _loc2_ = li32(cmodule.cson.mstate.ebp + 8);
         _loc3_ = li32(cmodule.cson.mstate.ebp + 12);
         _loc4_ = li32(cmodule.cson.mstate.ebp + 16);
         _loc5_ = _loc2_;
         do
         {
            _loc6_ = 16384;
            _loc7_ = _loc5_ + _loc1_;
            _loc7_ = li8(_loc7_);
            cmodule.cson.mstate.esp -= 8;
            si32(_loc7_,cmodule.cson.mstate.esp);
            si32(_loc6_,cmodule.cson.mstate.esp + 4);
            cmodule.cson.mstate.esp -= 4;
            FSM___istype.start();
            _loc6_ = int(cmodule.cson.mstate.eax);
            cmodule.cson.mstate.esp += 8;
            _loc1_ += 1;
         }
         while(_loc6_ != 0);
         _loc5_ = _loc2_ + _loc1_;
         loop4:
         while(true)
         {
            while(true)
            {
               _loc6_ = _loc7_ & 0xFF;
               if(_loc6_ != 43)
               {
                  _loc6_ = _loc7_ & 0xFF;
                  if(_loc6_ == 45)
                  {
                     _loc1_ <<= 0;
                     _loc1_ += _loc2_;
                     _loc5_ = li8(_loc5_);
                     _loc1_ += 1;
                     _loc6_ = _loc4_ == 0 ? 1 : 0;
                     _loc7_ = _loc4_ == 16 ? 1 : 0;
                     _loc6_ |= _loc7_;
                     if(_loc5_ == 48)
                     {
                        _loc6_ &= 1;
                        if(_loc6_ != 0)
                        {
                           _loc6_ = 1;
                           break;
                        }
                     }
                     _loc6_ = 1;
                     break loop4;
                  }
                  _loc1_ = _loc7_;
               }
               else
               {
                  _loc1_ <<= 0;
                  _loc1_ += _loc2_;
                  _loc5_ = li8(_loc5_);
                  _loc6_ = _loc1_ + 1;
                  _loc1_ = _loc5_;
                  _loc5_ = _loc6_;
               }
               _loc7_ = _loc5_;
               _loc5_ = _loc4_ == 0 ? 1 : 0;
               _loc6_ = _loc4_ == 16 ? 1 : 0;
               _loc5_ |= _loc6_;
               _loc6_ = _loc1_ & 0xFF;
               if(_loc6_ == 48)
               {
                  _loc5_ &= 1;
                  if(_loc5_ != 0)
                  {
                     _loc6_ = 0;
                     _loc5_ = _loc1_;
                     _loc1_ = _loc7_;
                     break;
                  }
               }
               _loc6_ = _loc5_ = 0;
               _loc5_ = _loc1_;
               _loc1_ = _loc7_;
               break loop4;
            }
            while(true)
            {
               _loc7_ = li8(_loc1_);
               if(_loc7_ != 88)
               {
                  _loc7_ &= 255;
                  if(_loc7_ != 120)
                  {
                     break;
                  }
               }
               _loc7_ = li8(_loc1_ + 1);
               _loc8_ = _loc7_ + -48;
               _loc9_ = _loc7_ + -65;
               _loc8_ &= 255;
               if(uint(_loc8_) >= uint(10))
               {
                  _loc8_ = _loc9_ & 0xFF;
                  if(uint(_loc8_) >= uint(6))
                  {
                     _loc8_ = _loc7_ + -97;
                     _loc8_ = _loc8_ & 0xFF;
                     if(uint(_loc8_) > uint(5))
                     {
                        break;
                     }
                  }
               }
               _loc4_ = 16;
               _loc1_ += 2;
               _loc5_ = _loc7_;
               break loop4;
            }
            break;
         }
         if(_loc4_ == 0)
         {
            _loc4_ = _loc5_ & 0xFF;
            if(_loc4_ == 48)
            {
               _loc4_ = 8;
            }
            else
            {
               _loc4_ = 10;
            }
         }
         _loc7_ = _loc4_ + -2;
         while(true)
         {
            if(uint(_loc7_) >= uint(35))
            {
               _loc5_ = _loc4_ = 0;
               addr054a:
               _loc6_ = _loc4_;
               _loc4_ = 22;
               si32(_loc4_,cmodule.cson._val_2E_1088);
               if(_loc3_ != 0)
               {
                  _loc4_ = _loc5_;
                  _loc5_ = _loc6_;
                  addr05a7:
                  if(_loc4_ != 0)
                  {
                     _loc1_ += -1;
                     si32(_loc1_,_loc3_);
                  }
                  else
                  {
                     si32(_loc2_,_loc3_);
                  }
                  cmodule.cson.mstate.eax = _loc5_;
                  break;
               }
               _loc1_ = _loc6_;
            }
            else
            {
               _loc7_ = 0;
               _loc8_ = uint(-1) % uint(_loc4_);
               _loc9_ = uint(-1) / uint(_loc4_);
               _loc10_ = _loc7_;
               loop1:
               while(true)
               {
                  _loc11_ = _loc5_ + -48;
                  _loc11_ = _loc11_ & 0xFF;
                  loop7:
                  while(true)
                  {
                     loop8:
                     while(true)
                     {
                        if(uint(_loc11_) >= uint(10))
                        {
                           while(true)
                           {
                              _loc11_ = _loc5_ + -65;
                              _loc11_ = _loc11_ & 0xFF;
                              if(uint(_loc11_) <= uint(25))
                              {
                                 _loc5_ += -55;
                                 _loc11_ = _loc5_ << 24;
                                 _loc11_ = _loc11_ >> 24;
                                 if(_loc11_ >= _loc4_)
                                 {
                                    break loop8;
                                 }
                              }
                              else
                              {
                                 _loc11_ = _loc5_ + -97;
                                 _loc11_ = _loc11_ & 0xFF;
                                 if(uint(_loc11_) > uint(25))
                                 {
                                    break loop7;
                                 }
                                 _loc5_ += -87;
                                 _loc11_ = _loc5_ << 24;
                                 _loc11_ = _loc11_ >> 24;
                                 if(_loc11_ >= _loc4_)
                                 {
                                    break loop7;
                                 }
                              }
                              addr048c:
                              while(uint(_loc7_) <= uint(_loc9_))
                              {
                                 if(_loc10_ < 0)
                                 {
                                    _loc11_ = 1;
                                    _loc5_ = _loc10_;
                                    _loc10_ = _loc11_;
                                    break;
                                 }
                                 if(_loc7_ == _loc9_)
                                 {
                                    _loc10_ = _loc5_ << 24;
                                    _loc10_ = _loc10_ >> 24;
                                    if(_loc10_ > _loc8_)
                                    {
                                       _loc11_ = 1;
                                       _loc5_ = _loc10_;
                                       _loc10_ = _loc11_;
                                       break;
                                    }
                                 }
                                 _loc5_ <<= 24;
                                 _loc5_ = _loc5_ >> 24;
                                 _loc7_ *= _loc4_;
                                 _loc10_ = li8(_loc1_);
                                 _loc1_ += 1;
                                 _loc7_ += _loc5_;
                                 _loc5_ = _loc10_ + -48;
                                 _loc5_ = _loc5_ & 0xFF;
                                 if(uint(_loc5_) >= uint(10))
                                 {
                                    _loc11_ = 1;
                                    _loc5_ = _loc10_;
                                    _loc10_ = _loc11_;
                                    break;
                                 }
                                 _loc11_ = 1;
                                 _loc5_ = _loc10_;
                                 _loc10_ = _loc11_;
                              }
                           }
                           break loop7;
                        }
                        _loc5_ += -48;
                        _loc11_ = _loc5_ << 24;
                        _loc11_ = _loc11_ >> 24;
                        if(_loc11_ < _loc4_)
                        {
                           §§goto(addr048c);
                        }
                        _loc5_ = _loc10_;
                        break loop1;
                     }
                     §§goto(addr03d6);
                  }
                  _loc10_ = -1;
                  _loc5_ = li8(_loc1_);
                  _loc1_ += 1;
                  addr03d6:
                  _loc5_ = _loc10_;
                  break;
               }
               _loc4_ = _loc5_;
               if(_loc4_ <= -1)
               {
                  _loc5_ = 34;
                  si32(_loc5_,cmodule.cson._val_2E_1088);
                  if(_loc3_ != 0)
                  {
                     _loc5_ = -1;
                     §§goto(addr05a7);
                  }
                  else
                  {
                     _loc1_ = -1;
                  }
               }
               else if(_loc4_ == 0)
               {
                  _loc5_ = _loc4_;
                  _loc4_ = _loc7_;
                  §§goto(addr054a);
               }
               else
               {
                  _loc5_ = _loc6_ & 1;
                  _loc6_ = 0 - _loc7_;
                  _loc5_ = _loc5_ != 0 ? _loc6_ : _loc7_;
                  if(_loc3_ != 0)
                  {
                     §§goto(addr05a7);
                  }
                  else
                  {
                     _loc1_ = _loc5_;
                  }
               }
            }
            cmodule.cson.mstate.eax = _loc1_;
            break;
         }
         cmodule.cson.mstate.esp = cmodule.cson.mstate.ebp;
         cmodule.cson.mstate.ebp = li32(cmodule.cson.mstate.esp);
         cmodule.cson.mstate.esp += 4;
         cmodule.cson.mstate.esp += 4;
      }
   }
}

