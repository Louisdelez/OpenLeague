package cmodule.cson
{
   import avm2.intrinsics.memory.li32;
   import avm2.intrinsics.memory.si32;
   
   public final class FSM__exit extends Machine
   {
      
      public function FSM__exit()
      {
         super();
      }
      
      public static function start() : void
      {
         var _loc1_:int = 0;
         cmodule.cson.mstate.esp -= 4;
         si32(cmodule.cson.mstate.ebp,cmodule.cson.mstate.esp);
         cmodule.cson.mstate.ebp = cmodule.cson.mstate.esp;
         cmodule.cson.mstate.esp -= 0;
         _loc1_ = li32(cmodule.cson.mstate.ebp + 8);
         throw new AlchemyExit(_loc1_);
      }
   }
}

