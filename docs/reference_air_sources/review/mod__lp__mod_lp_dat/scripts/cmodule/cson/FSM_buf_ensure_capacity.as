package cmodule.cson
{
   import avm2.intrinsics.memory.li32;
   import avm2.intrinsics.memory.si32;
   
   public final class FSM_buf_ensure_capacity extends Machine
   {
      
      public static const intRegCount:int = 8;
      
      public static const NumberRegCount:int = 0;
      
      public var i0:int;
      
      public var i1:int;
      
      public var i2:int;
      
      public var i3:int;
      
      public var i4:int;
      
      public var i5:int;
      
      public var i6:int;
      
      public var i7:int;
      
      public function FSM_buf_ensure_capacity()
      {
         super();
      }
      
      public static function start() : void
      {
         var _loc1_:FSM_buf_ensure_capacity = null;
         _loc1_ = new FSM_buf_ensure_capacity();
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
               this.i0 = li32(mstate.ebp + 8);
               this.i1 = li32(mstate.ebp + 12);
               this.i2 = li32(this.i0 + 8);
               this.i3 = this.i0 + 8;
               if(uint(this.i2) >= uint(this.i1))
               {
                  this.i0 = 0;
                  break;
               }
               this.i2 = li32(this.i0);
               this.i1 <<= 1;
               this.i4 = this.i0;
               this.i5 = this.i0 + 12;
               if(this.i5 != this.i2)
               {
                  mstate.esp -= 8;
                  si32(this.i2,mstate.esp);
                  si32(this.i1,mstate.esp + 4);
                  state = 1;
                  mstate.esp -= 4;
                  FSM_pubrealloc.start();
                  return;
               }
               this.i5 = 0;
               mstate.esp -= 8;
               si32(this.i5,mstate.esp);
               si32(this.i1,mstate.esp + 4);
               state = 2;
               mstate.esp -= 4;
               FSM_pubrealloc.start();
               return;
               break;
            case 1:
               this.i0 = mstate.eax;
               mstate.esp += 8;
               if(this.i0 == 0)
               {
                  addr0158:
                  this.i0 = 2;
                  break;
               }
               this.i2 = 0;
               si32(this.i0,this.i4);
               si32(this.i1,this.i3);
               mstate.eax = this.i2;
               §§goto(addr0247);
               break;
            case 2:
               this.i5 = mstate.eax;
               mstate.esp += 8;
               if(this.i5 != 0)
               {
                  this.i6 = 0;
                  this.i0 = li32(this.i0 + 4);
                  this.i7 = this.i5;
                  cmodule.cson.memcpy(this.i7,this.i2,this.i0);
                  si32(this.i5,this.i4);
                  si32(this.i1,this.i3);
                  mstate.eax = this.i6;
                  §§goto(addr0247);
               }
               else
               {
                  §§goto(addr0158);
               }
            default:
               throw "Invalid state in _buf_ensure_capacity";
         }
         mstate.eax = this.i0;
         addr0247:
         mstate.esp = mstate.ebp;
         mstate.ebp = li32(mstate.esp);
         mstate.esp += 4;
         mstate.esp += 4;
         mstate.gworker = caller;
      }
   }
}

