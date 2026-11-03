package cmodule.cson
{
   import avm2.intrinsics.memory.li32;
   import avm2.intrinsics.memory.si32;
   import avm2.intrinsics.memory.si8;
   
   public final class FSM__UTF8_wcrtomb extends Machine
   {
      
      public function FSM__UTF8_wcrtomb()
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
         cmodule.cson.mstate.esp -= 4;
         si32(cmodule.cson.mstate.ebp,cmodule.cson.mstate.esp);
         cmodule.cson.mstate.ebp = cmodule.cson.mstate.esp;
         cmodule.cson.mstate.esp -= 0;
         _loc1_ = li32(cmodule.cson.mstate.ebp + 16);
         _loc2_ = li32(cmodule.cson.mstate.ebp + 8);
         _loc1_ = li32(_loc1_ + 4);
         _loc3_ = li32(cmodule.cson.mstate.ebp + 12);
         _loc4_ = _loc2_;
         if(_loc1_ != 0)
         {
            _loc2_ = 22;
            si32(_loc2_,cmodule.cson._val_2E_1088);
            _loc2_ = -1;
            cmodule.cson.mstate.eax = _loc2_;
         }
         else
         {
            while(true)
            {
               if(_loc2_ != 0)
               {
                  if(uint(_loc3_) <= uint(127))
                  {
                     _loc4_ = 1;
                     si8(_loc3_,_loc2_);
                     cmodule.cson.mstate.eax = _loc4_;
                     break;
                  }
                  if(uint(_loc3_) <= uint(2047))
                  {
                     _loc1_ = 192;
                     _loc5_ = 2;
                  }
                  else if(uint(_loc3_) <= uint(65535))
                  {
                     _loc1_ = 224;
                     _loc5_ = 3;
                  }
                  else if(uint(_loc3_) <= uint(2097151))
                  {
                     _loc1_ = 240;
                     _loc5_ = 4;
                  }
                  else if(uint(_loc3_) <= uint(67108863))
                  {
                     _loc1_ = 248;
                     _loc5_ = 5;
                  }
                  else
                  {
                     if(_loc3_ < 0)
                     {
                        _loc1_ = 86;
                        si32(_loc1_,cmodule.cson._val_2E_1088);
                        _loc1_ = -1;
                        addr01e2:
                        cmodule.cson.mstate.eax = _loc1_;
                        break;
                     }
                     _loc1_ = 252;
                     _loc5_ = 6;
                  }
                  _loc6_ = _loc3_;
                  _loc7_ = _loc5_ + -1;
                  if(_loc7_ <= 0)
                  {
                     _loc3_ = _loc6_;
                  }
                  else
                  {
                     _loc7_ = _loc5_ + -1;
                     while(true)
                     {
                        _loc6_ |= -128;
                        _loc6_ = _loc6_ & -65;
                        _loc8_ = _loc4_ + _loc7_;
                        si8(_loc6_,_loc8_);
                        _loc6_ = _loc3_ >> 6;
                        _loc3_ = _loc7_ + -1;
                        _loc8_ = _loc6_;
                        if(_loc3_ <= 0)
                        {
                           break;
                        }
                        _loc7_ = _loc3_;
                        _loc3_ = _loc8_;
                     }
                     _loc3_ = _loc6_;
                  }
                  _loc1_ = _loc3_ | _loc1_;
                  si8(_loc1_,_loc2_);
                  cmodule.cson.mstate.eax = _loc5_;
                  break;
               }
               _loc1_ = 1;
               §§goto(addr01e2);
            }
         }
         cmodule.cson.mstate.esp = cmodule.cson.mstate.ebp;
         cmodule.cson.mstate.ebp = li32(cmodule.cson.mstate.esp);
         cmodule.cson.mstate.esp += 4;
         cmodule.cson.mstate.esp += 4;
      }
   }
}

