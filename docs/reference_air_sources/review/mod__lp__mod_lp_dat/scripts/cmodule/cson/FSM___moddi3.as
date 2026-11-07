package cmodule.cson
{
   import avm2.intrinsics.memory.li32;
   import avm2.intrinsics.memory.si32;
   
   public final class FSM___moddi3 extends Machine
   {
      
      public function FSM___moddi3()
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
         cmodule.cson.mstate.esp -= 8;
         _loc1_ = cmodule.cson.mstate.ebp + -8;
         _loc2_ = li32(cmodule.cson.mstate.ebp + 12);
         _loc3_ = li32(cmodule.cson.mstate.ebp + 20);
         _loc4_ = li32(cmodule.cson.mstate.ebp + 8);
         _loc5_ = _loc2_ >> 31;
         _loc6_ = li32(cmodule.cson.mstate.ebp + 16);
         _loc7_ = _loc3_ >> 31;
         _loc4_ = int(cmodule.cson.__addc(_loc4_,_loc5_));
         _loc8_ = int(cmodule.cson.__adde(_loc2_,_loc5_));
         _loc6_ = int(cmodule.cson.__addc(_loc6_,_loc7_));
         _loc3_ = int(cmodule.cson.__adde(_loc3_,_loc7_));
         cmodule.cson.mstate.esp -= 20;
         _loc3_ ^= _loc7_;
         _loc6_ ^= _loc7_;
         _loc7_ = _loc8_ ^ _loc5_;
         _loc4_ ^= _loc5_;
         si32(_loc4_,cmodule.cson.mstate.esp);
         si32(_loc7_,cmodule.cson.mstate.esp + 4);
         si32(_loc6_,cmodule.cson.mstate.esp + 8);
         si32(_loc3_,cmodule.cson.mstate.esp + 12);
         si32(_loc1_,cmodule.cson.mstate.esp + 16);
         cmodule.cson.mstate.esp -= 4;
         FSM___qdivrem.start();
         _loc1_ = int(cmodule.cson.mstate.eax);
         _loc1_ = int(cmodule.cson.mstate.edx);
         cmodule.cson.mstate.esp += 20;
         _loc1_ = li32(cmodule.cson.mstate.ebp + -8);
         _loc3_ = li32(cmodule.cson.mstate.ebp + -4);
         if(_loc2_ <= -1)
         {
            _loc2_ = 0;
            _loc1_ = int(cmodule.cson.__subc(_loc2_,_loc1_));
            _loc3_ = int(cmodule.cson.__sube(_loc2_,_loc3_));
         }
         cmodule.cson.mstate.edx = _loc3_;
         cmodule.cson.mstate.eax = _loc1_;
         cmodule.cson.mstate.esp = cmodule.cson.mstate.ebp;
         cmodule.cson.mstate.ebp = li32(cmodule.cson.mstate.esp);
         cmodule.cson.mstate.esp += 4;
         cmodule.cson.mstate.esp += 4;
      }
   }
}

