package cmodule.cson
{
   import avm2.intrinsics.memory.li32;
   import avm2.intrinsics.memory.si16;
   import avm2.intrinsics.memory.si32;
   import avm2.intrinsics.memory.si8;
   
   public final class FSM_buf_encode_printf extends Machine
   {
      
      public static const intRegCount:int = 12;
      
      public static const NumberRegCount:int = 0;
      
      public var i10:int;
      
      public var i11:int;
      
      public var i0:int;
      
      public var i1:int;
      
      public var i2:int;
      
      public var i3:int;
      
      public var i4:int;
      
      public var i5:int;
      
      public var i6:int;
      
      public var i7:int;
      
      public var i8:int;
      
      public var i9:int;
      
      public function FSM_buf_encode_printf()
      {
         super();
      }
      
      public static function start() : void
      {
         var _loc1_:FSM_buf_encode_printf = null;
         _loc1_ = new FSM_buf_encode_printf();
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
               mstate.esp -= 520;
               this.i0 = mstate.ebp + 16;
               si32(this.i0,mstate.ebp + -520);
               this.i1 = -1;
               si16(this.i1,mstate.ebp + -498);
               this.i1 = 520;
               si16(this.i1,mstate.ebp + -500);
               this.i1 = mstate.ebp + -514;
               si32(this.i1,mstate.ebp + -512);
               si32(this.i1,mstate.ebp + -496);
               this.i1 = 1;
               si32(this.i1,mstate.ebp + -504);
               this.i2 = mstate.ebp + -416;
               si32(this.i1,mstate.ebp + -492);
               si32(this.i2,mstate.ebp + -456);
               this.i1 = 0;
               si32(this.i1,mstate.ebp + -416);
               si32(this.i1,mstate.ebp + -412);
               si32(this.i1,mstate.ebp + -408);
               si32(this.i1,mstate.ebp + -404);
               si32(this.i1,mstate.ebp + -400);
               this.i2 += 20;
               this.i3 = 128;
               cmodule.cson.memset(this.i2,this.i1,this.i3);
               mstate.esp -= 12;
               this.i1 = li32(mstate.ebp + 12);
               this.i2 = mstate.ebp + -512;
               si32(this.i2,mstate.esp);
               si32(this.i1,mstate.esp + 4);
               si32(this.i0,mstate.esp + 8);
               state = 1;
               mstate.esp -= 4;
               FSM___vfprintf.start();
               return;
            case 1:
               this.i0 = mstate.eax;
               mstate.esp += 12;
               this.i2 = li32(mstate.ebp + 8);
               this.i3 = mstate.ebp + -520;
               this.i4 = this.i2;
               if(this.i0 == -1)
               {
                  break;
               }
               this.i5 = li32(this.i2 + 4);
               this.i6 = li32(this.i2 + 8);
               this.i7 = this.i5 + this.i0;
               this.i8 = this.i2 + 8;
               this.i9 = this.i7 + 1;
               this.i10 = this.i2 + 4;
               if(uint(this.i9) > uint(this.i6))
               {
                  this.i6 = li32(this.i4);
                  this.i9 <<= 1;
                  this.i2 += 12;
                  if(this.i2 != this.i6)
                  {
                     mstate.esp -= 8;
                     si32(this.i6,mstate.esp);
                     si32(this.i9,mstate.esp + 4);
                     state = 2;
                     mstate.esp -= 4;
                     FSM_pubrealloc.start();
                     return;
                  }
                  this.i2 = 0;
                  mstate.esp -= 8;
                  si32(this.i2,mstate.esp);
                  si32(this.i9,mstate.esp + 4);
                  state = 3;
                  mstate.esp -= 4;
                  FSM_pubrealloc.start();
                  return;
               }
               §§goto(addr0411);
               break;
            case 2:
               this.i5 = mstate.eax;
               mstate.esp += 8;
               if(this.i5 == 0)
               {
                  break;
               }
               §§goto(addr03f7);
               break;
            case 3:
               this.i2 = mstate.eax;
               mstate.esp += 8;
               if(this.i2 != 0)
               {
                  this.i11 = this.i2;
                  cmodule.cson.memcpy(this.i11,this.i6,this.i5);
                  this.i5 = this.i2;
                  addr03f7:
                  this.i2 = this.i5;
                  si32(this.i2,this.i4);
                  si32(this.i9,this.i8);
                  addr0411:
                  this.i2 = mstate.ebp + 16;
                  si32(this.i2,this.i3);
                  this.i2 = this.i0 + 1;
                  this.i0 = this.i2 == 0 ? this.i2 : this.i0;
                  this.i3 = li32(this.i4);
                  this.i4 = li32(this.i10);
                  this.i0 = this.i0 < 0 ? 2147483647 : this.i0;
                  this.i5 = li32(mstate.ebp + -520);
                  this.i6 = mstate.ebp + -258;
                  this.i3 += this.i4;
                  this.i4 = this.i0 == 0 ? this.i6 : this.i3;
                  this.i8 = this.i0 == 0 ? 1 : this.i0;
                  this.i0 = this.i0 != 0 ? 1 : 0;
                  while(true)
                  {
                     if(this.i2 != 0)
                     {
                        this.i0 ^= 1;
                        this.i0 &= 1;
                        if(this.i0 != 0)
                        {
                           this.i0 = 0;
                           si8(this.i0,this.i3);
                           this.i3 = 1;
                           break;
                        }
                     }
                     this.i3 = this.i8;
                     this.i6 = this.i4;
                     break;
                  }
                  this.i0 = this.i3;
                  this.i3 = this.i6;
                  this.i4 = -1;
                  si16(this.i4,mstate.ebp + -242);
                  this.i4 = 520;
                  si16(this.i4,mstate.ebp + -244);
                  si32(this.i3,mstate.ebp + -256);
                  si32(this.i3,mstate.ebp + -240);
                  si32(this.i0,mstate.ebp + -248);
                  this.i3 = mstate.ebp + -160;
                  si32(this.i0,mstate.ebp + -236);
                  si32(this.i3,mstate.ebp + -200);
                  this.i0 = 0;
                  si32(this.i0,mstate.ebp + -160);
                  si32(this.i0,mstate.ebp + -156);
                  si32(this.i0,mstate.ebp + -152);
                  si32(this.i0,mstate.ebp + -148);
                  si32(this.i0,mstate.ebp + -144);
                  this.i3 += 20;
                  this.i4 = 128;
                  cmodule.cson.memset(this.i3,this.i0,this.i4);
                  mstate.esp -= 12;
                  this.i0 = mstate.ebp + -256;
                  si32(this.i0,mstate.esp);
                  si32(this.i1,mstate.esp + 4);
                  si32(this.i5,mstate.esp + 8);
                  state = 4;
                  mstate.esp -= 4;
                  FSM___vfprintf.start();
                  return;
               }
               break;
            case 4:
               this.i1 = mstate.eax;
               mstate.esp += 12;
               if(this.i2 != 0)
               {
                  this.i1 = 0;
                  this.i0 = li32(this.i0);
                  si8(this.i1,this.i0);
               }
               si32(this.i7,this.i10);
               break;
            default:
               throw "Invalid state in _buf_encode_printf";
         }
         mstate.esp = mstate.ebp;
         mstate.ebp = li32(mstate.esp);
         mstate.esp += 4;
         mstate.esp += 4;
         mstate.gworker = caller;
      }
   }
}

