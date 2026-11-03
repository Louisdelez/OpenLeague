package cmodule.cson
{
   import avm2.intrinsics.memory.li32;
   import avm2.intrinsics.memory.si32;
   import avm2.intrinsics.memory.si8;
   
   public final class FSM_expected extends Machine
   {
      
      public static const intRegCount:int = 16;
      
      public static const NumberRegCount:int = 0;
      
      public var i10:int;
      
      public var i11:int;
      
      public var i12:int;
      
      public var i13:int;
      
      public var i14:int;
      
      public var i15:int;
      
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
      
      public function FSM_expected()
      {
         super();
      }
      
      public static function start() : void
      {
         var _loc1_:FSM_expected = null;
         _loc1_ = new FSM_expected();
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
               this.i1 = li32(this.i0 + 4);
               this.i2 = this.i0 + 4;
               this.i3 = li32(mstate.ebp + 12);
               this.i4 = li32(mstate.ebp + 16);
               this.i5 = li32(mstate.ebp + 20);
               this.i6 = li32(mstate.ebp + 24);
               this.i7 = li32(mstate.ebp + 28);
               if(this.i1 != 0)
               {
                  this.i8 = li32(this.i0 + 8);
                  this.i9 = this.i0 + 8;
                  this.i10 = this.i1 + 2;
                  if(uint(this.i10) > uint(this.i8))
                  {
                     this.i8 = li32(this.i0);
                     this.i11 = this.i10 << 1;
                     this.i12 = this.i0;
                     this.i13 = this.i0 + 12;
                     if(this.i13 != this.i8)
                     {
                        mstate.esp -= 8;
                        si32(this.i8,mstate.esp);
                        si32(this.i11,mstate.esp + 4);
                        state = 1;
                        mstate.esp -= 4;
                        FSM_pubrealloc.start();
                        return;
                     }
                     this.i13 = 0;
                     mstate.esp -= 8;
                     si32(this.i13,mstate.esp);
                     si32(this.i11,mstate.esp + 4);
                     state = 2;
                     mstate.esp -= 4;
                     FSM_pubrealloc.start();
                     return;
                  }
                  addr0271:
                  this.i8 = 44;
                  this.i9 = li32(this.i0);
                  this.i1 = this.i9 + this.i1;
                  this.i9 = 32;
                  si8(this.i8,this.i1);
                  si8(this.i9,this.i1 + 1);
                  si32(this.i10,this.i2);
               }
               addr02b1:
               this.i1 = li32(this.i2);
               this.i8 = li32(this.i0 + 8);
               this.i9 = this.i0 + 8;
               this.i10 = this.i1 + 9;
               if(uint(this.i10) > uint(this.i8))
               {
                  this.i8 = li32(this.i0);
                  this.i11 = this.i10 << 1;
                  this.i12 = this.i0;
                  this.i13 = this.i0 + 12;
                  if(this.i13 != this.i8)
                  {
                     mstate.esp -= 8;
                     si32(this.i8,mstate.esp);
                     si32(this.i11,mstate.esp + 4);
                     state = 3;
                     mstate.esp -= 4;
                     FSM_pubrealloc.start();
                     return;
                  }
                  this.i13 = 0;
                  mstate.esp -= 8;
                  si32(this.i13,mstate.esp);
                  si32(this.i11,mstate.esp + 4);
                  state = 4;
                  mstate.esp -= 4;
                  FSM_pubrealloc.start();
                  return;
               }
               addr0446:
               this.i8 = cmodule.cson.__2E_str40139;
               this.i11 = li32(this.i0);
               this.i1 = this.i11 + this.i1;
               this.i11 = 9;
               cmodule.cson.memcpy(this.i1,this.i8,this.i11);
               si32(this.i10,this.i2);
               addr0486:
               this.i1 = li32(this.i3 + 4);
               this.i3 = li32(this.i3 + 12);
               if(this.i1 == this.i3)
               {
                  this.i3 = cmodule.cson.__2E_str41140;
                  mstate.esp -= 12;
                  si32(this.i0,mstate.esp);
                  si32(this.i3,mstate.esp + 4);
                  si32(this.i1,mstate.esp + 8);
                  state = 5;
                  mstate.esp -= 4;
                  FSM_buf_encode_printf.start();
                  return;
               }
               this.i8 = cmodule.cson.__2E_str42141;
               mstate.esp -= 16;
               si32(this.i0,mstate.esp);
               si32(this.i8,mstate.esp + 4);
               si32(this.i1,mstate.esp + 8);
               si32(this.i3,mstate.esp + 12);
               state = 6;
               mstate.esp -= 4;
               FSM_buf_encode_printf.start();
               return;
               break;
            case 1:
               this.i8 = mstate.eax;
               mstate.esp += 8;
               if(this.i8 != 0)
               {
                  addr025f:
                  si32(this.i8,this.i12);
                  si32(this.i11,this.i9);
                  §§goto(addr0271);
               }
               §§goto(addr02b1);
            case 2:
               this.i13 = mstate.eax;
               mstate.esp += 8;
               if(this.i13 != 0)
               {
                  this.i14 = this.i13;
                  this.i15 = this.i1;
                  cmodule.cson.memcpy(this.i14,this.i8,this.i15);
                  this.i8 = this.i13;
                  §§goto(addr025f);
               }
               §§goto(addr02b1);
            case 3:
               this.i8 = mstate.eax;
               mstate.esp += 8;
               if(this.i8 != 0)
               {
                  addr0434:
                  si32(this.i8,this.i12);
                  si32(this.i11,this.i9);
                  §§goto(addr0446);
               }
               §§goto(addr0486);
            case 4:
               this.i13 = mstate.eax;
               mstate.esp += 8;
               if(this.i13 != 0)
               {
                  this.i14 = this.i13;
                  this.i15 = this.i1;
                  cmodule.cson.memcpy(this.i14,this.i8,this.i15);
                  this.i8 = this.i13;
                  §§goto(addr0434);
               }
               §§goto(addr0486);
            case 5:
               mstate.esp += 12;
               addr0598:
               this.i1 = li32(this.i2);
               this.i3 = li32(this.i9);
               this.i8 = this.i1 + 26;
               if(uint(this.i8) > uint(this.i3))
               {
                  this.i3 = li32(this.i0);
                  this.i10 = this.i8 << 1;
                  this.i11 = this.i0;
                  this.i12 = this.i0 + 12;
                  if(this.i12 != this.i3)
                  {
                     mstate.esp -= 8;
                     si32(this.i3,mstate.esp);
                     si32(this.i10,mstate.esp + 4);
                     state = 7;
                     mstate.esp -= 4;
                     FSM_pubrealloc.start();
                     return;
                  }
                  this.i12 = 0;
                  mstate.esp -= 8;
                  si32(this.i12,mstate.esp);
                  si32(this.i10,mstate.esp + 4);
                  state = 8;
                  mstate.esp -= 4;
                  FSM_pubrealloc.start();
                  return;
               }
               addr071f:
               this.i3 = cmodule.cson.__2E_str43142;
               this.i10 = li32(this.i0);
               this.i1 = this.i10 + this.i1;
               this.i10 = 26;
               cmodule.cson.memcpy(this.i1,this.i3,this.i10);
               si32(this.i8,this.i2);
               addr075f:
               this.i1 = li32(this.i2);
               this.i3 = li32(this.i9);
               this.i8 = this.i1 + this.i7;
               if(uint(this.i8) > uint(this.i3))
               {
                  this.i3 = li32(this.i0);
                  this.i10 = this.i8 << 1;
                  this.i11 = this.i0;
                  this.i12 = this.i0 + 12;
                  if(this.i12 != this.i3)
                  {
                     mstate.esp -= 8;
                     si32(this.i3,mstate.esp);
                     si32(this.i10,mstate.esp + 4);
                     state = 9;
                     mstate.esp -= 4;
                     FSM_pubrealloc.start();
                     return;
                  }
                  this.i12 = 0;
                  mstate.esp -= 8;
                  si32(this.i12,mstate.esp);
                  si32(this.i10,mstate.esp + 4);
                  state = 10;
                  mstate.esp -= 4;
                  FSM_pubrealloc.start();
                  return;
               }
               addr08e8:
               this.i3 = li32(this.i0);
               this.i1 = this.i3 + this.i1;
               this.i3 = this.i6;
               this.i6 = this.i7;
               cmodule.cson.memcpy(this.i1,this.i3,this.i6);
               si32(this.i8,this.i2);
               addr092a:
               this.i1 = li32(this.i2);
               this.i3 = li32(this.i9);
               this.i6 = this.i1 + 11;
               if(uint(this.i6) > uint(this.i3))
               {
                  this.i3 = li32(this.i0);
                  this.i7 = this.i6 << 1;
                  this.i8 = this.i0;
                  this.i10 = this.i0 + 12;
                  if(this.i10 != this.i3)
                  {
                     mstate.esp -= 8;
                     si32(this.i3,mstate.esp);
                     si32(this.i7,mstate.esp + 4);
                     state = 11;
                     mstate.esp -= 4;
                     FSM_pubrealloc.start();
                     return;
                  }
                  this.i10 = 0;
                  mstate.esp -= 8;
                  si32(this.i10,mstate.esp);
                  si32(this.i7,mstate.esp + 4);
                  state = 12;
                  mstate.esp -= 4;
                  FSM_pubrealloc.start();
                  return;
               }
               addr0ab1:
               this.i3 = cmodule.cson.__2E_str44143;
               this.i7 = li32(this.i0);
               this.i1 = this.i7 + this.i1;
               this.i7 = 11;
               cmodule.cson.memcpy(this.i1,this.i3,this.i7);
               si32(this.i6,this.i2);
               addr0af1:
               this.i1 = li32(this.i2);
               this.i3 = li32(this.i9);
               this.i6 = this.i1 + this.i5;
               if(uint(this.i6) > uint(this.i3))
               {
                  this.i3 = li32(this.i0);
                  this.i7 = this.i6 << 1;
                  this.i8 = this.i0;
                  this.i10 = this.i0 + 12;
                  if(this.i10 != this.i3)
                  {
                     mstate.esp -= 8;
                     si32(this.i3,mstate.esp);
                     si32(this.i7,mstate.esp + 4);
                     state = 13;
                     mstate.esp -= 4;
                     FSM_pubrealloc.start();
                     return;
                  }
                  this.i10 = 0;
                  mstate.esp -= 8;
                  si32(this.i10,mstate.esp);
                  si32(this.i7,mstate.esp + 4);
                  state = 14;
                  mstate.esp -= 4;
                  FSM_pubrealloc.start();
                  return;
               }
               break;
            case 6:
               mstate.esp += 16;
               §§goto(addr0598);
            case 7:
               this.i3 = mstate.eax;
               mstate.esp += 8;
               if(this.i3 != 0)
               {
                  addr070d:
                  si32(this.i3,this.i11);
                  si32(this.i10,this.i9);
                  §§goto(addr071f);
               }
               §§goto(addr075f);
            case 8:
               this.i12 = mstate.eax;
               mstate.esp += 8;
               if(this.i12 != 0)
               {
                  this.i13 = this.i12;
                  this.i14 = this.i1;
                  cmodule.cson.memcpy(this.i13,this.i3,this.i14);
                  this.i3 = this.i12;
                  §§goto(addr070d);
               }
               §§goto(addr075f);
            case 9:
               this.i3 = mstate.eax;
               mstate.esp += 8;
               if(this.i3 != 0)
               {
                  addr08d6:
                  si32(this.i3,this.i11);
                  si32(this.i10,this.i9);
                  §§goto(addr08e8);
               }
               §§goto(addr092a);
            case 10:
               this.i12 = mstate.eax;
               mstate.esp += 8;
               if(this.i12 != 0)
               {
                  this.i13 = this.i12;
                  this.i14 = this.i1;
                  cmodule.cson.memcpy(this.i13,this.i3,this.i14);
                  this.i3 = this.i12;
                  §§goto(addr08d6);
               }
               §§goto(addr092a);
            case 11:
               this.i3 = mstate.eax;
               mstate.esp += 8;
               if(this.i3 != 0)
               {
                  addr0a9f:
                  si32(this.i3,this.i8);
                  si32(this.i7,this.i9);
                  §§goto(addr0ab1);
               }
               §§goto(addr0af1);
            case 12:
               this.i10 = mstate.eax;
               mstate.esp += 8;
               if(this.i10 != 0)
               {
                  this.i11 = this.i10;
                  this.i12 = this.i1;
                  cmodule.cson.memcpy(this.i11,this.i3,this.i12);
                  this.i3 = this.i10;
                  §§goto(addr0a9f);
               }
               §§goto(addr0af1);
            case 13:
               this.i3 = mstate.eax;
               mstate.esp += 8;
               if(this.i3 != 0)
               {
                  si32(this.i3,this.i8);
                  si32(this.i7,this.i9);
                  break;
               }
               §§goto(addr0cce);
            case 14:
               this.i10 = mstate.eax;
               mstate.esp += 8;
               if(this.i10 != 0)
               {
                  this.i11 = this.i10;
                  this.i12 = this.i1;
                  cmodule.cson.memcpy(this.i11,this.i3,this.i12);
                  si32(this.i10,this.i8);
                  si32(this.i7,this.i9);
                  break;
               }
               §§goto(addr0cce);
            default:
               throw "Invalid state in _expected";
         }
         this.i0 = li32(this.i0);
         this.i0 += this.i1;
         this.i1 = this.i4;
         this.i3 = this.i5;
         cmodule.cson.memcpy(this.i0,this.i1,this.i3);
         si32(this.i6,this.i2);
         addr0cce:
         mstate.esp = mstate.ebp;
         mstate.ebp = li32(mstate.esp);
         mstate.esp += 4;
         mstate.esp += 4;
         mstate.gworker = caller;
      }
   }
}

