package cmodule.cson
{
   import avm2.intrinsics.memory.lf64;
   import avm2.intrinsics.memory.li32;
   import avm2.intrinsics.memory.sf64;
   import avm2.intrinsics.memory.si32;
   import flash.display.*;
   import flash.events.*;
   import flash.net.*;
   import flash.system.*;
   import flash.text.*;
   import flash.utils.*;
   
   public final class FSM___fixdfdi extends Machine
   {
      
      public function FSM___fixdfdi()
      {
         super();
      }
      
      public static function start() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         cmodule.cson.mstate.esp -= 4;
         si32(cmodule.cson.mstate.ebp,cmodule.cson.mstate.esp);
         cmodule.cson.mstate.ebp = cmodule.cson.mstate.esp;
         cmodule.cson.mstate.esp -= 0;
         _loc4_ = 0;
         _loc5_ = lf64(cmodule.cson.mstate.ebp + 8);
         if(_loc5_ < _loc4_)
         {
            _loc4_ = -9223370000000000000;
            if(_loc5_ <= _loc4_)
            {
               _loc1_ = -2147483648;
               _loc2_ = 0;
            }
            else
            {
               _loc1_ = 0;
               cmodule.cson.mstate.esp -= 8;
               _loc5_ = -_loc5_;
               sf64(_loc5_,cmodule.cson.mstate.esp);
               cmodule.cson.mstate.esp -= 4;
               cmodule.cson.mstate.funcs[cmodule.cson.___fixunsdfdi]();
               _loc2_ = int(cmodule.cson.mstate.eax);
               _loc3_ = int(cmodule.cson.mstate.edx);
               cmodule.cson.mstate.esp += 8;
               _loc2_ = int(cmodule.cson.__subc(_loc1_,_loc2_));
               _loc1_ = int(cmodule.cson.__sube(_loc1_,_loc3_));
            }
            addr0177:
            cmodule.cson.mstate.edx = _loc1_;
            cmodule.cson.mstate.eax = _loc2_;
         }
         else
         {
            _loc4_ = 9223370000000000000;
            if(_loc5_ >= _loc4_)
            {
               _loc1_ = 2147483647;
               _loc2_ = -1;
               §§goto(addr0177);
            }
            else
            {
               cmodule.cson.mstate.esp -= 8;
               sf64(_loc5_,cmodule.cson.mstate.esp);
               cmodule.cson.mstate.esp -= 4;
               cmodule.cson.mstate.funcs[cmodule.cson.___fixunsdfdi]();
               _loc1_ = int(cmodule.cson.mstate.eax);
               _loc2_ = int(cmodule.cson.mstate.edx);
               cmodule.cson.mstate.esp += 8;
               cmodule.cson.mstate.edx = _loc2_;
               cmodule.cson.mstate.eax = _loc1_;
            }
         }
         cmodule.cson.mstate.esp = cmodule.cson.mstate.ebp;
         cmodule.cson.mstate.ebp = li32(cmodule.cson.mstate.esp);
         cmodule.cson.mstate.esp += 4;
         cmodule.cson.mstate.esp += 4;
      }
   }
}

