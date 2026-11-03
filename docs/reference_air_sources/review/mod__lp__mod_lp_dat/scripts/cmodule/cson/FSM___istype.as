package cmodule.cson
{
   import avm2.intrinsics.memory.li32;
   import avm2.intrinsics.memory.si32;
   
   public final class FSM___istype extends Machine
   {
      
      public function FSM___istype()
      {
         super();
      }
      
      public static function start() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         cmodule.cson.mstate.esp -= 4;
         si32(cmodule.cson.mstate.ebp,cmodule.cson.mstate.esp);
         cmodule.cson.mstate.ebp = cmodule.cson.mstate.esp;
         cmodule.cson.mstate.esp -= 0;
         _loc1_ = li32(cmodule.cson.mstate.ebp + 8);
         _loc2_ = li32(cmodule.cson.mstate.ebp + 12);
         if(uint(_loc1_) >= uint(256))
         {
            _loc1_ = 0;
         }
         else
         {
            _loc3_ = cmodule.cson.__DefaultRuneLocale;
            _loc1_ <<= 2;
            _loc1_ = _loc3_ + _loc1_;
            _loc1_ = li32(_loc1_ + 52);
         }
         _loc1_ &= _loc2_;
         _loc1_ = _loc1_ != 0 ? 1 : 0;
         _loc1_ &= 1;
         cmodule.cson.mstate.eax = _loc1_;
         cmodule.cson.mstate.esp = cmodule.cson.mstate.ebp;
         cmodule.cson.mstate.ebp = li32(cmodule.cson.mstate.esp);
         cmodule.cson.mstate.esp += 4;
         cmodule.cson.mstate.esp += 4;
      }
   }
}

