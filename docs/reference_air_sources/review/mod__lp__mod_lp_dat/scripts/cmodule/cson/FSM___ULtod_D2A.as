package cmodule.cson
{
   import avm2.intrinsics.memory.li32;
   import avm2.intrinsics.memory.si32;
   
   public final class FSM___ULtod_D2A extends Machine
   {
      
      public function FSM___ULtod_D2A()
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
         cmodule.cson.mstate.esp -= 4;
         si32(cmodule.cson.mstate.ebp,cmodule.cson.mstate.esp);
         cmodule.cson.mstate.ebp = cmodule.cson.mstate.esp;
         cmodule.cson.mstate.esp -= 0;
         _loc1_ = li32(cmodule.cson.mstate.ebp + 20);
         _loc2_ = li32(cmodule.cson.mstate.ebp + 8);
         _loc3_ = li32(cmodule.cson.mstate.ebp + 12);
         _loc4_ = li32(cmodule.cson.mstate.ebp + 16);
         loop0:
         while(true)
         {
            while(true)
            {
               _loc5_ = _loc1_ & 7;
               if(_loc5_ <= 2)
               {
                  if(_loc5_ == 0)
                  {
                     addr012b:
                     _loc3_ = 0;
                     si32(_loc3_,_loc2_ + 4);
                     si32(_loc3_,_loc2_);
                     _loc1_ &= 8;
                     if(_loc1_ != 0)
                     {
                        break;
                     }
                     break loop0;
                  }
                  if(_loc5_ != 1)
                  {
                     if(_loc5_ != 2)
                     {
                        addr0107:
                        _loc1_ &= 8;
                        if(_loc1_ != 0)
                        {
                           break;
                        }
                        break loop0;
                     }
                     _loc4_ = li32(_loc3_);
                     si32(_loc4_,_loc2_);
                     _loc3_ = li32(_loc3_ + 4);
                     si32(_loc3_,_loc2_ + 4);
                     _loc1_ &= 8;
                     if(_loc1_ != 0)
                     {
                        break;
                     }
                     break loop0;
                  }
               }
               else
               {
                  if(_loc5_ <= 4)
                  {
                     if(_loc5_ == 3)
                     {
                        _loc3_ = 2146435072;
                        si32(_loc3_,_loc2_ + 4);
                        _loc3_ = 0;
                        si32(_loc3_,_loc2_);
                        _loc1_ &= 8;
                        if(_loc1_ != 0)
                        {
                           break;
                        }
                        break loop0;
                     }
                     if(_loc5_ == 4)
                     {
                        _loc3_ = 2147483647;
                        si32(_loc3_,_loc2_ + 4);
                        _loc3_ = -1;
                        si32(_loc3_,_loc2_);
                     }
                  }
                  else
                  {
                     if(_loc5_ == 5)
                     {
                        addr0148:
                        _loc5_ = li32(_loc3_);
                        si32(_loc5_,_loc2_);
                        _loc3_ = li32(_loc3_ + 4);
                        _loc4_ <<= 20;
                        _loc4_ = _loc4_ + 1127219200;
                        _loc3_ &= -1048577;
                        _loc3_ |= _loc4_;
                        si32(_loc3_,_loc2_ + 4);
                        _loc1_ &= 8;
                        if(_loc1_ != 0)
                        {
                           break;
                        }
                        break loop0;
                     }
                     if(_loc5_ == 6)
                     {
                        §§goto(addr012b);
                     }
                  }
                  §§goto(addr0107);
               }
               §§goto(addr0148);
            }
            _loc1_ = li32(_loc2_ + 4);
            _loc1_ |= -2147483648;
            si32(_loc1_,_loc2_ + 4);
            break;
         }
         cmodule.cson.mstate.esp = cmodule.cson.mstate.ebp;
         cmodule.cson.mstate.ebp = li32(cmodule.cson.mstate.esp);
         cmodule.cson.mstate.esp += 4;
         cmodule.cson.mstate.esp += 4;
      }
   }
}

