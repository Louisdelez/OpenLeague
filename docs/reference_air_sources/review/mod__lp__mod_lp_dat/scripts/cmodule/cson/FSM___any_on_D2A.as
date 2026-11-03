package cmodule.cson
{
   import avm2.intrinsics.memory.li32;
   import avm2.intrinsics.memory.si32;
   
   public final class FSM___any_on_D2A extends Machine
   {
      
      public function FSM___any_on_D2A()
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
         _loc1_ = li32(cmodule.cson.mstate.ebp + 12);
         _loc2_ = li32(cmodule.cson.mstate.ebp + 8);
         _loc3_ = li32(_loc2_ + 16);
         loop1:
         while(true)
         {
            _loc4_ = _loc1_ >> 5;
            if(_loc4_ > _loc3_)
            {
               _loc1_ = _loc3_;
            }
            else
            {
               if(_loc4_ < _loc3_)
               {
                  _loc1_ &= 31;
                  if(_loc1_ != 0)
                  {
                     _loc3_ = _loc4_ << 2;
                     _loc3_ = _loc2_ + _loc3_;
                     _loc3_ = li32(_loc3_ + 20);
                     _loc5_ = _loc3_ >>> _loc1_;
                     _loc1_ = _loc5_ << _loc1_;
                     if(_loc1_ != _loc3_)
                     {
                        break;
                     }
                  }
               }
               _loc1_ = _loc4_;
            }
            if(_loc1_ > 0)
            {
               _loc3_ = 0;
               while(true)
               {
                  _loc4_ = _loc3_ ^ -1;
                  _loc4_ = _loc1_ + _loc4_;
                  _loc5_ = _loc4_ << 2;
                  _loc5_ = _loc2_ + _loc5_;
                  _loc5_ = li32(_loc5_ + 20);
                  if(_loc5_ != 0)
                  {
                     break loop1;
                  }
                  _loc3_ += 1;
                  if(_loc4_ >= 1)
                  {
                     continue;
                  }
               }
               §§goto(addr00ec);
            }
            _loc1_ = 0;
            §§goto(addr00ec);
         }
         _loc1_ = 1;
         addr00ec:
         cmodule.cson.mstate.eax = _loc1_;
         cmodule.cson.mstate.esp = cmodule.cson.mstate.ebp;
         cmodule.cson.mstate.ebp = li32(cmodule.cson.mstate.esp);
         cmodule.cson.mstate.esp += 4;
         cmodule.cson.mstate.esp += 4;
      }
   }
}

