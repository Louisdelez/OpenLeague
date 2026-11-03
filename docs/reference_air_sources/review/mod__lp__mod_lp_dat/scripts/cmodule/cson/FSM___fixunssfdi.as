package cmodule.cson
{
   import avm2.intrinsics.memory.lf32;
   import avm2.intrinsics.memory.li32;
   import avm2.intrinsics.memory.si32;
   import flash.display.*;
   import flash.events.*;
   import flash.net.*;
   import flash.system.*;
   import flash.text.*;
   import flash.utils.*;
   
   public final class FSM___fixunssfdi extends Machine
   {
      
      public function FSM___fixunssfdi()
      {
         super();
      }
      
      public static function start() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         cmodule.cson.mstate.esp -= 4;
         si32(cmodule.cson.mstate.ebp,cmodule.cson.mstate.esp);
         cmodule.cson.mstate.ebp = cmodule.cson.mstate.esp;
         cmodule.cson.mstate.esp -= 0;
         _loc5_ = 18446700000000000000;
         _loc6_ = lf32(cmodule.cson.mstate.ebp + 8);
         _loc5_ = _loc5_ = _loc5_;
         while(true)
         {
            _loc7_ = _loc6_;
            if(_loc7_ < _loc5_)
            {
               _loc5_ = _loc5_ = _loc5_ = 0;
               _loc7_ = _loc6_;
               if(_loc7_ >= _loc5_)
               {
                  _loc1_ = 0;
                  _loc5_ = _loc6_;
                  _loc6_ = _loc5_ + -2147480000;
                  _loc6_ = _loc6_ * 2.32831e-10;
                  cmodule.cson.mstate.esp -= 8;
                  _loc2_ = int(uint(_loc6_));
                  si32(_loc1_,cmodule.cson.mstate.esp);
                  si32(_loc2_,cmodule.cson.mstate.esp + 4);
                  cmodule.cson.mstate.esp -= 4;
                  cmodule.cson.mstate.funcs[cmodule.cson.___floatdidf]();
                  _loc6_ = Number(cmodule.cson.mstate.st0);
                  _loc5_ -= _loc6_;
                  _loc6_ = 0;
                  _loc7_ = _loc5_ + 4294970000;
                  _loc7_ = _loc5_ < _loc6_ ? _loc7_ : _loc5_;
                  _loc3_ = _loc2_ + -1;
                  _loc8_ = 4294970000;
                  _loc9_ = _loc7_ - 4294970000;
                  _loc9_ = _loc7_ > _loc8_ ? _loc9_ : _loc7_;
                  _loc2_ = _loc5_ >= _loc6_ ? _loc2_ : _loc3_;
                  _loc1_ = _loc5_ >= _loc6_ ? 0 : _loc1_;
                  _loc3_ = _loc2_ + 1;
                  _loc1_ = _loc7_ <= _loc8_ ? _loc1_ : _loc1_;
                  _loc4_ = int(uint(_loc9_));
                  cmodule.cson.mstate.esp += 8;
                  _loc1_ |= _loc4_;
                  _loc2_ = _loc7_ <= _loc8_ ? _loc2_ : _loc3_;
                  cmodule.cson.mstate.edx = _loc2_;
                  break;
               }
            }
            _loc1_ = -1;
            cmodule.cson.mstate.edx = _loc1_;
            break;
         }
         cmodule.cson.mstate.eax = _loc1_;
         cmodule.cson.mstate.esp = cmodule.cson.mstate.ebp;
         cmodule.cson.mstate.ebp = li32(cmodule.cson.mstate.esp);
         cmodule.cson.mstate.esp += 4;
         cmodule.cson.mstate.esp += 4;
      }
   }
}

