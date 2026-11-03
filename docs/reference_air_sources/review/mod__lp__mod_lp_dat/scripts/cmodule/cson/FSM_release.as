package cmodule.cson
{
   import avm2.intrinsics.memory.li32;
   import avm2.intrinsics.memory.si32;
   
   public final class FSM_release extends Machine
   {
      
      public static const intRegCount:int = 3;
      
      public static const NumberRegCount:int = 0;
      
      public var i0:int;
      
      public var i1:int;
      
      public var i2:int;
      
      public function FSM_release()
      {
         super();
      }
      
      public static function start() : void
      {
         var _loc1_:FSM_release = null;
         _loc1_ = new FSM_release();
         cmodule.cson.gstate.gworker = _loc1_;
      }
      
      final override public function work() : void
      {
         switch(state)
         {
            case 0:
               mstate.esp -= 4;
               si32(mstate.ebp,mstate.esp);
               mstate.ebp = mstate.esp;
               mstate.esp -= 0;
               this.i0 = cmodule.cson._out;
               this.i1 = li32(cmodule.cson._out);
               this.i0 += 12;
               if(this.i1 != this.i0)
               {
                  this.i0 = 0;
                  mstate.esp -= 8;
                  si32(this.i1,mstate.esp);
                  si32(this.i0,mstate.esp + 4);
                  this.i1 = cmodule.cson._out;
                  state = 1;
                  mstate.esp -= 4;
                  FSM_pubrealloc.start();
                  return;
               }
               this.i0 = cmodule.cson._out;
               this.i0 += 12;
               si32(this.i0,cmodule.cson._out);
               this.i0 = 0;
               break;
            case 1:
               this.i2 = mstate.eax;
               mstate.esp += 8;
               this.i1 += 12;
               si32(this.i1,cmodule.cson._out);
               break;
            default:
               throw "Invalid state in _release";
         }
         si32(this.i0,cmodule.cson._out + 4);
         this.i1 = 100;
         si32(this.i1,cmodule.cson._out + 8);
         mstate.eax = this.i0;
         mstate.esp = mstate.ebp;
         mstate.ebp = li32(mstate.esp);
         mstate.esp += 4;
         mstate.esp += 4;
         mstate.gworker = caller;
      }
   }
}

