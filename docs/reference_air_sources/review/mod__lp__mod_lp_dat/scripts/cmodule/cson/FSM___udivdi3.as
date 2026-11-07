package cmodule.cson
{
   import avm2.intrinsics.memory.li32;
   import avm2.intrinsics.memory.si32;
   
   public final class FSM___udivdi3 extends Machine
   {
      
      public function FSM___udivdi3()
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
         _loc1_ = 0;
         cmodule.cson.mstate.esp -= 20;
         _loc2_ = li32(cmodule.cson.mstate.ebp + 8);
         _loc3_ = li32(cmodule.cson.mstate.ebp + 12);
         _loc4_ = li32(cmodule.cson.mstate.ebp + 16);
         _loc5_ = li32(cmodule.cson.mstate.ebp + 20);
         si32(_loc2_,cmodule.cson.mstate.esp);
         si32(_loc3_,cmodule.cson.mstate.esp + 4);
         si32(_loc4_,cmodule.cson.mstate.esp + 8);
         si32(_loc5_,cmodule.cson.mstate.esp + 12);
         si32(_loc1_,cmodule.cson.mstate.esp + 16);
         cmodule.cson.mstate.esp -= 4;
         FSM___qdivrem.start();
         _loc1_ = int(cmodule.cson.mstate.eax);
         _loc2_ = int(cmodule.cson.mstate.edx);
         cmodule.cson.mstate.esp += 20;
         cmodule.cson.mstate.edx = _loc2_;
         cmodule.cson.mstate.eax = _loc1_;
         cmodule.cson.mstate.esp = cmodule.cson.mstate.ebp;
         cmodule.cson.mstate.ebp = li32(cmodule.cson.mstate.esp);
         cmodule.cson.mstate.esp += 4;
         cmodule.cson.mstate.esp += 4;
      }
   }
}

