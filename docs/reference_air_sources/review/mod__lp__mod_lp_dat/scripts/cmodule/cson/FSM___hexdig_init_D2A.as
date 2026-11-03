package cmodule.cson
{
   import avm2.intrinsics.memory.li32;
   import avm2.intrinsics.memory.li8;
   import avm2.intrinsics.memory.si32;
   import avm2.intrinsics.memory.si8;
   
   public final class FSM___hexdig_init_D2A extends Machine
   {
      
      public function FSM___hexdig_init_D2A()
      {
         super();
      }
      
      public static function start() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         cmodule.cson.mstate.esp -= 4;
         si32(cmodule.cson.mstate.ebp,cmodule.cson.mstate.esp);
         cmodule.cson.mstate.ebp = cmodule.cson.mstate.esp;
         cmodule.cson.mstate.esp -= 0;
         _loc1_ = cmodule.cson.__2E_str2661;
         _loc2_ = 48;
         _loc1_ += 1;
         _loc3_ = 16;
         do
         {
            _loc4_ = cmodule.cson.___hexdig_D2A;
            _loc2_ &= 255;
            _loc2_ = _loc4_ + _loc2_;
            si8(_loc3_,_loc2_);
            _loc2_ = li8(_loc1_);
            _loc3_ += 1;
            _loc1_ += 1;
         }
         while(_loc2_ != 0);
         _loc1_ = cmodule.cson.__2E_str127;
         _loc2_ = 97;
         _loc1_ += 1;
         _loc3_ = 26;
         do
         {
            _loc4_ = cmodule.cson.___hexdig_D2A;
            _loc2_ &= 255;
            _loc2_ = _loc4_ + _loc2_;
            si8(_loc3_,_loc2_);
            _loc2_ = li8(_loc1_);
            _loc3_ += 1;
            _loc1_ += 1;
         }
         while(_loc2_ != 0);
         _loc1_ = cmodule.cson.__2E_str228;
         _loc2_ = 65;
         _loc1_ += 1;
         _loc3_ = 26;
         do
         {
            _loc4_ = cmodule.cson.___hexdig_D2A;
            _loc2_ &= 255;
            _loc2_ = _loc4_ + _loc2_;
            si8(_loc3_,_loc2_);
            _loc2_ = li8(_loc1_);
            _loc3_ += 1;
            _loc1_ += 1;
         }
         while(_loc2_ != 0);
         cmodule.cson.mstate.esp = cmodule.cson.mstate.ebp;
         cmodule.cson.mstate.ebp = li32(cmodule.cson.mstate.esp);
         cmodule.cson.mstate.esp += 4;
         cmodule.cson.mstate.esp += 4;
      }
   }
}

