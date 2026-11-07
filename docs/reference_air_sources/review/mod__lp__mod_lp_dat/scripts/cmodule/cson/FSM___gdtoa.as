package cmodule.cson
{
   import avm2.intrinsics.memory.lf64;
   import avm2.intrinsics.memory.li32;
   import avm2.intrinsics.memory.li8;
   import avm2.intrinsics.memory.sf64;
   import avm2.intrinsics.memory.si32;
   import avm2.intrinsics.memory.si8;
   
   public final class FSM___gdtoa extends Machine
   {
      
      public static const intRegCount:int = 32;
      
      public static const NumberRegCount:int = 4;
      
      public var i21:int;
      
      public var i30:int;
      
      public var i31:int;
      
      public var f0:Number;
      
      public var f1:Number;
      
      public var f3:Number;
      
      public var f2:Number;
      
      public var i10:int;
      
      public var i11:int;
      
      public var i12:int;
      
      public var i13:int;
      
      public var i14:int;
      
      public var i15:int;
      
      public var i17:int;
      
      public var i19:int;
      
      public var i16:int;
      
      public var i18:int;
      
      public var i0:int;
      
      public var i1:int;
      
      public var i22:int;
      
      public var i3:int;
      
      public var i4:int;
      
      public var i5:int;
      
      public var i6:int;
      
      public var i7:int;
      
      public var i8:int;
      
      public var i2:int;
      
      public var i23:int;
      
      public var i24:int;
      
      public var i25:int;
      
      public var i26:int;
      
      public var i27:int;
      
      public var i20:int;
      
      public var i9:int;
      
      public var i28:int;
      
      public var i29:int;
      
      public function FSM___gdtoa()
      {
         super();
      }
      
      public static function start() : void
      {
         var _loc1_:FSM___gdtoa = null;
         _loc1_ = new FSM___gdtoa();
         cmodule.cson.gstate.gworker = _loc1_;
      }
      
      final override public function work() : void
      {
         loop22:
         switch(state)
         {
            case 0:
               mstate.esp -= 4;
               si32(mstate.ebp,mstate.esp);
               mstate.ebp = mstate.esp;
               mstate.esp -= 216;
               this.i0 = li32(mstate.ebp + 16);
               this.i1 = li32(this.i0);
               this.i2 = this.i1 & -49;
               this.i3 = li32(mstate.ebp + 8);
               this.i4 = li32(mstate.ebp + 12);
               si32(this.i2,this.i0);
               this.i1 &= 7;
               this.i2 = li32(mstate.ebp + 20);
               this.i5 = li32(mstate.ebp + 24);
               this.i6 = li32(mstate.ebp + 28);
               this.i7 = li32(mstate.ebp + 32);
               this.i8 = this.i4;
               while(true)
               {
                  if(this.i1 > 2)
                  {
                     if(this.i1 != 3)
                     {
                        if(this.i1 != 4)
                        {
                           addr5173:
                           this.i0 = 0;
                           break;
                        }
                        addr055a:
                        this.i0 = -32768;
                        si32(this.i0,this.i6);
                        this.i0 = li32(cmodule.cson._freelist);
                        if(this.i0 != 0)
                        {
                           this.i1 = li32(this.i0);
                           si32(this.i1,cmodule.cson._freelist);
                        }
                        else
                        {
                           this.i0 = cmodule.cson._private_mem;
                           this.i1 = li32(cmodule.cson._pmem_next);
                           this.i0 = this.i1 - this.i0;
                           this.i0 >>= 3;
                           this.i0 += 3;
                           if(uint(this.i0) > uint(288))
                           {
                              this.i0 = 24;
                              mstate.esp -= 4;
                              si32(this.i0,mstate.esp);
                              state = 2;
                              mstate.esp -= 4;
                              FSM_malloc.start();
                              return;
                           }
                           this.i0 = 0;
                           this.i2 = this.i1 + 24;
                           si32(this.i2,cmodule.cson._pmem_next);
                           si32(this.i0,this.i1 + 4);
                           this.i0 = 1;
                           si32(this.i0,this.i1 + 8);
                           this.i0 = this.i1;
                        }
                        this.i1 = 0;
                        si32(this.i1,this.i0 + 16);
                        si32(this.i1,this.i0 + 12);
                        si32(this.i1,this.i0);
                        this.i2 = 78;
                        si8(this.i2,this.i0 + 4);
                        this.i0 += 4;
                        this.i2 = cmodule.cson.__2E_str260;
                        this.i3 = this.i0;
                        do
                        {
                           this.i4 = this.i2 + this.i1;
                           this.i4 = li8(this.i4 + 1);
                           this.i5 = this.i0 + this.i1;
                           si8(this.i4,this.i5 + 1);
                           this.i1 += 1;
                        }
                        while(this.i4 != 0);
                        if(this.i7 != 0)
                        {
                           addr041a:
                           this.i0 += this.i1;
                           si32(this.i0,this.i7);
                        }
                     }
                     else
                     {
                        this.i0 = -32768;
                        si32(this.i0,this.i6);
                        this.i0 = li32(cmodule.cson._freelist);
                        if(this.i0 != 0)
                        {
                           this.i1 = li32(this.i0);
                           si32(this.i1,cmodule.cson._freelist);
                        }
                        else
                        {
                           this.i0 = cmodule.cson._private_mem;
                           this.i1 = li32(cmodule.cson._pmem_next);
                           this.i0 = this.i1 - this.i0;
                           this.i0 >>= 3;
                           this.i0 += 3;
                           if(uint(this.i0) > uint(288))
                           {
                              this.i0 = 24;
                              mstate.esp -= 4;
                              si32(this.i0,mstate.esp);
                              state = 1;
                              mstate.esp -= 4;
                              FSM_malloc.start();
                              return;
                           }
                           this.i0 = 0;
                           this.i2 = this.i1 + 24;
                           si32(this.i2,cmodule.cson._pmem_next);
                           si32(this.i0,this.i1 + 4);
                           this.i0 = 1;
                           si32(this.i0,this.i1 + 8);
                           this.i0 = this.i1;
                        }
                        addr0365:
                        this.i1 = 0;
                        si32(this.i1,this.i0 + 16);
                        si32(this.i1,this.i0 + 12);
                        si32(this.i1,this.i0);
                        this.i2 = 73;
                        si8(this.i2,this.i0 + 4);
                        this.i0 += 4;
                        this.i2 = cmodule.cson.__2E_str159;
                        this.i3 = this.i0;
                        do
                        {
                           this.i4 = this.i2 + this.i1;
                           this.i4 = li8(this.i4 + 1);
                           this.i5 = this.i0 + this.i1;
                           si8(this.i4,this.i5 + 1);
                           this.i1 += 1;
                        }
                        while(this.i4 != 0);
                        if(this.i7 != 0)
                        {
                           §§goto(addr041a);
                        }
                     }
                     mstate.eax = this.i3;
                     break loop22;
                  }
                  if(this.i1 == 0)
                  {
                     this.i0 = 1;
                     si32(this.i0,this.i6);
                     this.i0 = li32(cmodule.cson._freelist);
                     if(this.i0 != 0)
                     {
                        this.i1 = li32(this.i0);
                        si32(this.i1,cmodule.cson._freelist);
                     }
                     else
                     {
                        this.i0 = cmodule.cson._private_mem;
                        this.i1 = li32(cmodule.cson._pmem_next);
                        this.i0 = this.i1 - this.i0;
                        this.i0 >>= 3;
                        this.i0 += 3;
                        if(uint(this.i0) > uint(288))
                        {
                           this.i0 = 24;
                           mstate.esp -= 4;
                           si32(this.i0,mstate.esp);
                           state = 8;
                           mstate.esp -= 4;
                           FSM_malloc.start();
                           return;
                        }
                        this.i0 = 0;
                        this.i2 = this.i1 + 24;
                        si32(this.i2,cmodule.cson._pmem_next);
                        si32(this.i0,this.i1 + 4);
                        this.i0 = 1;
                        si32(this.i0,this.i1 + 8);
                        this.i0 = this.i1;
                     }
                     addr0e65:
                     this.i1 = 0;
                     si32(this.i1,this.i0 + 16);
                     si32(this.i1,this.i0 + 12);
                     si32(this.i1,this.i0);
                     this.i2 = 48;
                     si8(this.i2,this.i0 + 4);
                     si8(this.i1,this.i0 + 5);
                     this.i1 = this.i0 + 5;
                     this.i0 += 4;
                     if(this.i7 != 0)
                     {
                        addr0cf4:
                        si32(this.i1,this.i7);
                     }
                     break;
                  }
                  this.i1 += -1;
                  if(uint(this.i1) < uint(2))
                  {
                     this.i1 = 32;
                     this.i9 = 0;
                     do
                     {
                        this.i9 += 1;
                        this.i1 <<= 1;
                     }
                     while(this.i1 <= 63);
                     this.i1 = 0;
                     mstate.esp -= 4;
                     si32(this.i9,mstate.esp);
                     state = 3;
                     mstate.esp -= 4;
                     FSM___Balloc_D2A.start();
                     return;
                  }
                  §§goto(addr5173);
               }
               addr0d13:
               mstate.eax = this.i0;
               break;
            case 1:
               this.i0 = mstate.eax;
               mstate.esp += 4;
               this.i1 = 0;
               si32(this.i1,this.i0 + 4);
               this.i1 = 1;
               si32(this.i1,this.i0 + 8);
               §§goto(addr0365);
            case 2:
               this.i0 = mstate.eax;
               mstate.esp += 4;
               this.i1 = 0;
               si32(this.i1,this.i0 + 4);
               this.i1 = 1;
               si32(this.i1,this.i0 + 8);
               §§goto(addr055a);
            case 3:
               this.i9 = mstate.eax;
               mstate.esp += 4;
               this.i10 = this.i9 + 20;
               this.i11 = this.i9;
               this.i12 = this.i1;
               do
               {
                  this.i13 = this.i8 + this.i12;
                  this.i13 = li32(this.i13);
                  this.i14 = this.i9 + this.i12;
                  si32(this.i13,this.i14 + 20);
                  this.i12 += 4;
                  this.i1 += 1;
               }
               while(this.i1 <= 1);
               this.i1 <<= 2;
               this.i8 = this.i11 + 20;
               this.i1 = this.i8 + this.i1;
               this.i1 -= this.i10;
               this.i1 >>= 2;
               this.i10 = this.i1 + -1;
               this.i12 = this.i10 << 2;
               this.i8 += this.i12;
               this.i8 = li32(this.i8);
               loop24:
               while(true)
               {
                  while(true)
                  {
                     if(this.i8 == 0)
                     {
                        this.i8 = this.i1 << 2;
                        this.i9 += this.i8;
                        this.i9 += 12;
                        while(true)
                        {
                           this.i8 = this.i9;
                           if(this.i1 == 1)
                           {
                              break;
                           }
                           this.i8 = li32(this.i8);
                           this.i9 += -4;
                           this.i1 += -1;
                           if(this.i8 == 0)
                           {
                              continue;
                           }
                           this.i9 = this.i1 + -1;
                        }
                        this.i1 = 0;
                        si32(this.i1,this.i11 + 16);
                        mstate.esp -= 4;
                        si32(this.i11,mstate.esp);
                        mstate.esp -= 4;
                        FSM___trailz_D2A.start();
                        addr07d8:
                        this.i1 = mstate.eax;
                        mstate.esp += 4;
                        si32(this.i1,mstate.ebp + -4);
                        if(this.i1 != 0)
                        {
                           this.i9 = 0;
                           break;
                        }
                        this.i1 = 0;
                        this.i9 = this.i3;
                        break loop24;
                     }
                     this.i9 = this.i10;
                     this.i8 = this.i9 << 2;
                     si32(this.i1,this.i11 + 16);
                     this.i1 = this.i11 + this.i8;
                     this.i1 = li32(this.i1 + 20);
                     this.i8 = uint(this.i1) < uint(65536) ? 16 : 0;
                     this.i1 <<= this.i8;
                     this.i10 = uint(this.i1) < uint(16777216) ? 8 : 0;
                     this.i1 <<= this.i10;
                     this.i12 = uint(this.i1) < uint(268435456) ? 4 : 0;
                     this.i8 = this.i10 | this.i8;
                     this.i1 <<= this.i12;
                     this.i10 = uint(this.i1) < uint(1073741824) ? 2 : 0;
                     this.i8 |= this.i12;
                     this.i8 |= this.i10;
                     this.i1 <<= this.i10;
                     if(this.i1 <= -1)
                     {
                        this.i1 = this.i8;
                     }
                     else
                     {
                        this.i1 &= 1073741824;
                        this.i8 += 1;
                        this.i1 = this.i1 == 0 ? 32 : this.i8;
                     }
                     mstate.esp -= 4;
                     si32(this.i11,mstate.esp);
                     mstate.esp -= 4;
                     FSM___trailz_D2A.start();
                  }
                  addr0a48:
                  mstate.esp -= 8;
                  si32(this.i11,mstate.esp);
                  si32(this.i1,mstate.esp + 4);
                  mstate.esp -= 4;
                  FSM___rshift_D2A.start();
               }
               this.i8 = this.i9;
               this.i9 = li32(this.i11 + 16);
               if(this.i9 == 0)
               {
                  if(this.i11 != 0)
                  {
                     this.i0 = cmodule.cson._freelist;
                     this.i1 = li32(this.i11 + 4);
                     this.i1 <<= 2;
                     this.i0 += this.i1;
                     this.i1 = li32(this.i0);
                     si32(this.i1,this.i11);
                     si32(this.i11,this.i0);
                  }
                  this.i0 = 1;
                  si32(this.i0,this.i6);
                  this.i0 = li32(cmodule.cson._freelist);
                  if(this.i0 != 0)
                  {
                     this.i1 = li32(this.i0);
                     si32(this.i1,cmodule.cson._freelist);
                  }
                  else
                  {
                     this.i0 = cmodule.cson._private_mem;
                     this.i1 = li32(cmodule.cson._pmem_next);
                     this.i0 = this.i1 - this.i0;
                     this.i0 >>= 3;
                     this.i0 += 3;
                     if(uint(this.i0) > uint(288))
                     {
                        this.i0 = 24;
                        mstate.esp -= 4;
                        si32(this.i0,mstate.esp);
                        state = 7;
                        mstate.esp -= 4;
                        FSM_malloc.start();
                        return;
                     }
                     this.i0 = 0;
                     this.i2 = this.i1 + 24;
                     si32(this.i2,cmodule.cson._pmem_next);
                     si32(this.i0,this.i1 + 4);
                     this.i0 = 1;
                     si32(this.i0,this.i1 + 8);
                     this.i0 = this.i1;
                  }
                  addr0c89:
                  this.i1 = 0;
                  si32(this.i1,this.i0 + 16);
                  si32(this.i1,this.i0 + 12);
                  si32(this.i1,this.i0);
                  this.i2 = 48;
                  si8(this.i2,this.i0 + 4);
                  si8(this.i1,this.i0 + 5);
                  this.i1 = this.i0 + 5;
                  this.i0 += 4;
                  if(this.i7 != 0)
                  {
                     §§goto(addr0cf4);
                  }
                  §§goto(addr0d13);
               }
               else
               {
                  this.i9 = mstate.ebp + -4;
                  mstate.esp -= 8;
                  si32(this.i11,mstate.esp);
                  si32(this.i9,mstate.esp + 4);
                  mstate.esp -= 4;
                  FSM___b2d_D2A.start();
               }
            case 5:
               addr09e7:
               this.i8 = mstate.eax;
               this.i9 <<= 5;
               mstate.esp += 4;
               this.i9 += 32;
               si32(this.i8,mstate.ebp + -4);
               this.i9 -= this.i1;
               if(this.i8 == 0)
               {
                  this.i1 = this.i9;
                  this.i9 = this.i3;
                  break loop24;
               }
               this.i1 = this.i8;
               §§goto(addr0a48);
               break;
            case 4:
               §§goto(addr07d8);
            case 6:
               mstate.esp += 8;
               this.i1 = li32(mstate.ebp + -4);
               this.i9 -= this.i1;
               this.i8 = this.i1 + this.i3;
               this.i1 = this.i9;
               this.i9 = this.i8;
               break loop24;
            case 9:
               this.f0 = mstate.st0;
               sf64(this.f0,mstate.ebp + -16);
               this.i9 = li32(mstate.ebp + -12);
               this.i9 |= 1072693248;
               this.i10 = li32(mstate.ebp + -16);
               this.i9 &= 1073741823;
               si32(this.i10,mstate.ebp + -24);
               si32(this.i9,mstate.ebp + -20);
               this.i12 = this.i1 + this.i8;
               this.i12 += -1;
               this.f0 = lf64(mstate.ebp + -24);
               this.f0 += -1.5;
               this.i13 = this.i12 >> 31;
               this.i14 = this.i12 + this.i13;
               this.f1 = Number(this.i12);
               this.f0 *= 0.28953;
               mstate.esp += 8;
               this.i13 = this.i14 ^ this.i13;
               this.f1 *= 0.30103;
               this.f0 += 0.176091;
               si32(this.i12,mstate.ebp + -4);
               this.i13 += -1077;
               this.f0 += this.f1;
               if(this.i13 > 0)
               {
                  this.f1 = Number(this.i13);
                  this.f1 *= 7e-17;
                  this.f0 = this.f1 + this.f0;
               }
               this.f1 = 0;
               this.i13 = int(this.f0);
               while(true)
               {
                  if(this.f0 < this.f1)
                  {
                     this.f1 = Number(this.i13);
                     if(this.f1 != this.f0)
                     {
                        this.i13 += -1;
                        break;
                     }
                  }
                  break;
               }
               this.i14 = this.i8 + this.i1;
               this.i14 <<= 20;
               this.i9 = this.i14 + this.i9;
               this.i9 += -1048576;
               if(uint(this.i13) >= uint(23))
               {
                  this.i14 = 1;
               }
               else
               {
                  this.i14 = cmodule.cson.___tens_D2A;
                  this.i15 = this.i13 << 3;
                  si32(this.i10,mstate.ebp + -32);
                  si32(this.i9,mstate.ebp + -28);
                  this.i14 += this.i15;
                  this.f0 = lf64(mstate.ebp + -32);
                  this.f1 = lf64(this.i14);
                  if(this.f0 >= this.f1)
                  {
                     this.i14 = 0;
                  }
                  else
                  {
                     this.i14 = 0;
                     this.i13 += -1;
                  }
               }
               this.i15 = this.i1 - this.i12;
               this.i16 = this.i15 + -1;
               this.i15 = 1 - this.i15;
               this.i17 = this.i16 > -1 ? this.i16 : 0;
               this.i15 = this.i16 > -1 ? 0 : this.i15;
               if(this.i13 >= 0)
               {
                  this.i16 = 0;
                  this.i17 += this.i13;
                  this.i18 = this.i13;
               }
               else
               {
                  this.i16 = 0;
                  this.i19 = 0 - this.i13;
                  this.i15 -= this.i13;
                  this.i18 = this.i16;
                  this.i16 = this.i19;
               }
               this.i2 = uint(this.i2) > uint(9) ? 0 : this.i2;
               this.i19 = this.i2 + -4;
               this.i19 = this.i2 < 6 ? this.i2 : this.i19;
               this.i2 = this.i2 < 6 ? 1 : 0;
               this.i20 = this.i5 < 1 ? 1 : this.i5;
               if(this.i19 <= 2)
               {
                  if(uint(this.i19) >= uint(2))
                  {
                     if(this.i19 != 2)
                     {
                        addr12e6:
                        this.i21 = 1;
                        this.i22 = this.i20;
                        this.i23 = this.i20;
                     }
                     else
                     {
                        this.i5 = 0;
                        si32(this.i20,mstate.ebp + -4);
                        this.i12 = this.i20;
                        this.i21 = this.i5;
                        this.i22 = this.i20;
                        this.i23 = this.i20;
                        this.i5 = this.i20;
                     }
                  }
                  else
                  {
                     this.i5 = 22;
                     si32(this.i5,mstate.ebp + -4);
                     this.i20 = 0;
                     this.i23 = -1;
                     this.i21 = 1;
                     this.i12 = this.i5;
                     this.i22 = this.i23;
                     this.i5 = this.i20;
                  }
               }
               else
               {
                  while(true)
                  {
                     if(this.i19 != 3)
                     {
                        if(this.i19 == 4)
                        {
                           this.i5 = 1;
                           si32(this.i20,mstate.ebp + -4);
                           this.i12 = this.i20;
                           this.i21 = this.i5;
                           this.i22 = this.i20;
                           this.i23 = this.i20;
                           this.i5 = this.i20;
                           break;
                        }
                        if(this.i19 == 5)
                        {
                           this.i12 = 1;
                        }
                        else
                        {
                           §§goto(addr12e6);
                        }
                     }
                     else
                     {
                        this.i12 = 0;
                     }
                     this.i21 = this.i12;
                     this.i22 = this.i13 + this.i5;
                     this.i23 = this.i22 + 1;
                     si32(this.i23,mstate.ebp + -4);
                     if(this.i23 >= 1)
                     {
                        this.i12 = this.i23;
                        break;
                     }
                     this.i12 = 1;
                     si32(this.i12,mstate.ebp + -4);
                     break;
                  }
               }
               this.i20 = this.i21;
               this.i21 = this.i22;
               this.i22 = this.i23;
               if(uint(this.i12) >= uint(20))
               {
                  this.i23 = 4;
                  this.i24 = 0;
                  do
                  {
                     this.i23 <<= 1;
                     this.i24 += 1;
                     this.i25 = this.i23 + 16;
                  }
                  while(uint(this.i25) <= uint(this.i12));
                  this.i12 = this.i24;
               }
               else
               {
                  this.i12 = 0;
               }
               mstate.esp -= 4;
               si32(this.i12,mstate.esp);
               state = 10;
               mstate.esp -= 4;
               FSM___Balloc_D2A.start();
               return;
            case 7:
               this.i0 = mstate.eax;
               mstate.esp += 4;
               this.i1 = 0;
               si32(this.i1,this.i0 + 4);
               this.i1 = 1;
               si32(this.i1,this.i0 + 8);
               §§goto(addr0c89);
            case 8:
               this.i0 = mstate.eax;
               mstate.esp += 4;
               this.i1 = 0;
               si32(this.i1,this.i0 + 4);
               this.i1 = 1;
               si32(this.i1,this.i0 + 8);
               §§goto(addr0e65);
            case 10:
               this.i23 = mstate.eax;
               mstate.esp += 4;
               si32(this.i12,this.i23);
               this.i12 = this.i23 + 4;
               this.i23 = uint(this.i22) > uint(14) ? 1 : 0;
               this.i2 ^= 1;
               this.i2 = this.i23 | this.i2;
               this.i23 = this.i12;
               this.i2 &= 1;
               while(true)
               {
                  loop29:
                  while(true)
                  {
                     loop30:
                     while(true)
                     {
                        loop31:
                        while(true)
                        {
                           while(true)
                           {
                              if(this.i2 == 0)
                              {
                                 if(this.i13 == 0)
                                 {
                                    this.i2 = 0;
                                    si32(this.i2,mstate.ebp + -4);
                                    loop33:
                                    while(true)
                                    {
                                       if(this.i13 >= 1)
                                       {
                                          this.i2 = cmodule.cson.___tens_D2A;
                                          this.i24 = this.i13 & 0x0F;
                                          this.i24 <<= 3;
                                          this.i2 += this.i24;
                                          this.f0 = lf64(this.i2);
                                          this.i2 = this.i13 >> 4;
                                          this.i24 = this.i2 & 0x10;
                                          loop34:
                                          while(true)
                                          {
                                             if(this.i24 == 0)
                                             {
                                                this.i24 = 2;
                                                this.i25 = 0;
                                                this.i26 = this.i10;
                                                this.i27 = this.i9;
                                                while(true)
                                                {
                                                   this.i28 = this.i27;
                                                   this.i29 = this.i24;
                                                   if(this.i2 == 0)
                                                   {
                                                      break loop34;
                                                   }
                                                   this.i27 = this.i25;
                                                   this.i24 = this.i26;
                                                   this.i25 = this.i28;
                                                   this.i26 = this.i29;
                                                }
                                                break;
                                                addr1771:
                                             }
                                             else
                                             {
                                                si32(this.i10,mstate.ebp + -40);
                                                si32(this.i9,mstate.ebp + -36);
                                                this.f1 = lf64(mstate.ebp + -40);
                                                this.f1 /= 1e+256;
                                                sf64(this.f1,mstate.ebp + -48);
                                                this.i24 = li32(mstate.ebp + -48);
                                                this.i25 = li32(mstate.ebp + -44);
                                                this.i2 &= 15;
                                                if(this.i2 == 0)
                                                {
                                                   this.i2 = 3;
                                                   addr19cf:
                                                   break loop33;
                                                }
                                                this.i26 = 3;
                                                this.i27 = 0;
                                             }
                                             this.i28 = this.i25;
                                             this.i25 = this.i26;
                                             this.i26 = this.i2 & 1;
                                             if(this.i26 == 0)
                                             {
                                                addr172d:
                                                this.i29 = this.i25;
                                                this.i25 = this.i27 + 1;
                                                si32(this.i25,mstate.ebp + -4);
                                                this.i2 >>= 1;
                                                this.i26 = this.i24;
                                                this.i27 = this.i28;
                                                this.i24 = this.i29;
                                                §§goto(addr1771);
                                             }
                                             this.i26 = cmodule.cson.___bigtens_D2A;
                                             this.i29 = this.i27 << 3;
                                             this.i26 += this.i29;
                                             this.f1 = lf64(this.i26);
                                             this.f0 = this.f1 * this.f0;
                                             this.i25 += 1;
                                             §§goto(addr172d);
                                          }
                                          this.i24 = this.i26;
                                          this.i25 = this.i28;
                                          this.i2 = this.i29;
                                          break;
                                       }
                                       this.i2 = 0 - this.i13;
                                       if(this.i13 == 0)
                                       {
                                          this.f0 = 1;
                                          this.i2 = 2;
                                          this.i24 = this.i10;
                                          this.i25 = this.i9;
                                          break;
                                       }
                                       this.i24 = cmodule.cson.___tens_D2A;
                                       this.i25 = this.i2 & 0x0F;
                                       this.i25 <<= 3;
                                       si32(this.i10,mstate.ebp + -56);
                                       si32(this.i9,mstate.ebp + -52);
                                       this.i24 += this.i25;
                                       this.f0 = lf64(this.i24);
                                       this.f1 = lf64(mstate.ebp + -56);
                                       this.f0 = this.f1 * this.f0;
                                       sf64(this.f0,mstate.ebp + -64);
                                       this.i24 = li32(mstate.ebp + -64);
                                       this.i25 = li32(mstate.ebp + -60);
                                       this.i26 = this.i2 >> 4;
                                       if(uint(this.i2) >= uint(16))
                                       {
                                          this.i2 = cmodule.cson.___bigtens_D2A;
                                          this.i27 = 2;
                                          this.i28 = 0;
                                          while(true)
                                          {
                                             this.i29 = this.i2;
                                             this.i30 = this.i26 & 1;
                                             if(this.i30 != 0)
                                             {
                                                si32(this.i24,mstate.ebp + -72);
                                                si32(this.i25,mstate.ebp + -68);
                                                this.f0 = lf64(this.i29);
                                                this.f1 = lf64(mstate.ebp + -72);
                                                this.f0 = this.f1 * this.f0;
                                                sf64(this.f0,mstate.ebp + -80);
                                                this.i24 = li32(mstate.ebp + -80);
                                                this.i25 = li32(mstate.ebp + -76);
                                                this.i27 += 1;
                                             }
                                             this.i2 += 8;
                                             this.i28 += 1;
                                             this.i29 = this.i26 >> 1;
                                             if(uint(this.i26) < uint(2))
                                             {
                                                break;
                                             }
                                             this.i26 = this.i29;
                                          }
                                          this.f0 = 1;
                                          si32(this.i28,mstate.ebp + -4);
                                          this.i2 = this.i27;
                                          break;
                                       }
                                       this.f0 = 1;
                                       this.i2 = 2;
                                       §§goto(addr19cf);
                                    }
                                    while(true)
                                    {
                                       if(this.i14 != 0)
                                       {
                                          this.f1 = 1;
                                          si32(this.i24,mstate.ebp + -88);
                                          si32(this.i25,mstate.ebp + -84);
                                          this.f2 = lf64(mstate.ebp + -88);
                                          if(this.f2 < this.f1)
                                          {
                                             if(this.i22 >= 1)
                                             {
                                                if(this.i21 >= 1)
                                                {
                                                   this.f1 = this.f2 * 10;
                                                   sf64(this.f1,mstate.ebp + -96);
                                                   this.i24 = li32(mstate.ebp + -96);
                                                   this.i25 = li32(mstate.ebp + -92);
                                                   this.i2 += 1;
                                                   this.i26 = this.i13 + -1;
                                                   this.i27 = this.i21;
                                                   break;
                                                }
                                                §§goto(addr22c4);
                                             }
                                          }
                                       }
                                       this.i26 = this.i13;
                                       this.i27 = this.i22;
                                       break;
                                    }
                                    si32(this.i24,mstate.ebp + -104);
                                    si32(this.i25,mstate.ebp + -100);
                                    this.f1 = lf64(mstate.ebp + -104);
                                    this.f2 = Number(this.i2);
                                    this.f2 *= this.f1;
                                    this.f2 += 7;
                                    sf64(this.f2,mstate.ebp + -112);
                                    this.i2 = li32(mstate.ebp + -108);
                                    this.i28 = li32(mstate.ebp + -112);
                                    this.i2 += -54525952;
                                    if(this.i27 == 0)
                                    {
                                       si32(this.i28,mstate.ebp + -120);
                                       si32(this.i2,mstate.ebp + -116);
                                       this.f0 = lf64(mstate.ebp + -120);
                                       this.f1 += -5;
                                       if(this.f1 > this.f0)
                                       {
                                          this.i1 = 0;
                                          this.i2 = this.i11;
                                          this.i3 = this.i1;
                                          this.i4 = this.i26;
                                          break;
                                       }
                                       this.f0 = -this.f0;
                                       if(this.f1 < this.f0)
                                       {
                                          break loop29;
                                       }
                                    }
                                    else
                                    {
                                       if(this.i20 != 0)
                                       {
                                          this.i29 = cmodule.cson.___tens_D2A;
                                          this.i30 = this.i27 << 3;
                                          si32(this.i28,mstate.ebp + -128);
                                          si32(this.i2,mstate.ebp + -124);
                                          this.i2 = this.i30 + this.i29;
                                          this.f1 = lf64(this.i2 + -8);
                                          this.f2 = this.f0 * 0.5;
                                          this.i2 = 0;
                                          this.f3 = lf64(mstate.ebp + -128);
                                          this.f1 = this.f2 / this.f1;
                                          si32(this.i2,mstate.ebp + -4);
                                          this.f1 -= this.f3;
                                          while(true)
                                          {
                                             si32(this.i24,mstate.ebp + -136);
                                             si32(this.i25,mstate.ebp + -132);
                                             this.f2 = lf64(mstate.ebp + -136);
                                             this.f3 = this.f2 / this.f0;
                                             this.i24 = int(this.f3);
                                             this.f3 = Number(this.i24);
                                             this.f3 *= this.f0;
                                             this.i24 += 48;
                                             this.i25 = this.i23 + this.i2;
                                             si8(this.i24,this.i25);
                                             this.i24 = this.i2 + 1;
                                             this.f2 -= this.f3;
                                             if(this.f2 < this.f1)
                                             {
                                                this.f1 = 0;
                                                this.i2 = this.i12 + this.i24;
                                                if(this.f2 == this.f1)
                                                {
                                                   this.i1 = 0;
                                                   this.i3 = this.i11;
                                                   this.i24 = this.i26;
                                                   break loop30;
                                                }
                                                if(this.i11 != 0)
                                                {
                                                   this.i1 = cmodule.cson._freelist;
                                                   this.i3 = li32(this.i11 + 4);
                                                   this.i3 <<= 2;
                                                   this.i1 += this.i3;
                                                   this.i3 = li32(this.i1);
                                                   si32(this.i3,this.i11);
                                                   si32(this.i11,this.i1);
                                                }
                                                this.i1 = 0;
                                                si8(this.i1,this.i2);
                                                this.i1 = this.i26 + 1;
                                                si32(this.i1,this.i6);
                                                if(this.i7 != 0)
                                                {
                                                   this.i1 = 16;
                                                   §§goto(addr50c6);
                                                }
                                                else
                                                {
                                                   this.i2 = 16;
                                                   §§goto(addr5101);
                                                }
                                             }
                                             else
                                             {
                                                this.f3 = this.f0 - this.f2;
                                                if(this.f3 < this.f1)
                                                {
                                                   this.i1 = this.i12 + this.i24;
                                                   this.i2 = this.i1;
                                                   this.i1 = this.i26;
                                                   break loop31;
                                                }
                                                this.i24 = li32(mstate.ebp + -4);
                                                this.i24 += 1;
                                                si32(this.i24,mstate.ebp + -4);
                                                if(this.i24 < this.i27)
                                                {
                                                   continue;
                                                }
                                             }
                                             this.f2 *= 10;
                                             sf64(this.f2,mstate.ebp + -144);
                                             this.i24 = li32(mstate.ebp + -144);
                                             this.i25 = li32(mstate.ebp + -140);
                                             this.i2 += 1;
                                             this.f1 *= 10;
                                          }
                                          break loop31;
                                       }
                                       this.i29 = cmodule.cson.___tens_D2A;
                                       this.i30 = this.i27 << 3;
                                       si32(this.i28,mstate.ebp + -152);
                                       si32(this.i2,mstate.ebp + -148);
                                       this.i2 = this.i30 + this.i29;
                                       this.f1 /= this.f0;
                                       this.f2 = lf64(this.i2 + -8);
                                       this.f3 = lf64(mstate.ebp + -152);
                                       this.i2 = 1;
                                       si32(this.i2,mstate.ebp + -4);
                                       this.i2 = int(this.f1);
                                       this.f1 = this.f3 * this.f2;
                                       if(this.i2 != 0)
                                       {
                                          this.i28 = this.i12;
                                          while(true)
                                          {
                                             si32(this.i24,mstate.ebp + -160);
                                             si32(this.i25,mstate.ebp + -156);
                                             this.f2 = Number(this.i2);
                                             this.f3 = lf64(mstate.ebp + -160);
                                             this.f2 *= this.f0;
                                             this.f2 = this.f3 - this.f2;
                                             sf64(this.f2,mstate.ebp + -168);
                                             this.i24 = li32(mstate.ebp + -168);
                                             this.i25 = li32(mstate.ebp + -164);
                                             this.i2 = this.i28 + this.i2;
                                             this.i28 = this.i2;
                                             this.i2 = this.i29;
                                          }
                                          §§goto(addr09e7);
                                          addr1fa2:
                                       }
                                       else
                                       {
                                          this.i28 = this.i12;
                                       }
                                       this.i29 = 0;
                                       this.i30 = this.i28;
                                       this.i31 = this.i29;
                                       while(true)
                                       {
                                          this.i29 = this.i31;
                                          this.i2 += 48;
                                          this.i31 = this.i30 + this.i29;
                                          si8(this.i2,this.i31);
                                          this.i2 = li32(mstate.ebp + -4);
                                          this.i31 = this.i29 + 1;
                                          if(this.i2 == this.i27)
                                          {
                                             break;
                                          }
                                          si32(this.i24,mstate.ebp + -184);
                                          si32(this.i25,mstate.ebp + -180);
                                          this.f2 = lf64(mstate.ebp + -184);
                                          this.f2 *= 10;
                                          sf64(this.f2,mstate.ebp + -192);
                                          this.f2 /= this.f0;
                                          this.i2 += 1;
                                          si32(this.i2,mstate.ebp + -4);
                                          this.i24 = li32(mstate.ebp + -192);
                                          this.i25 = li32(mstate.ebp + -188);
                                          this.i2 = this.i29 + 1;
                                          this.i29 = int(this.f2);
                                          if(this.i29 == 0)
                                          {
                                             continue;
                                          }
                                          this.i2 = this.i28 + this.i2;
                                          this.i28 = this.i2;
                                          this.i2 = this.i29;
                                          §§goto(addr1fa2);
                                          this.i31 = this.i2;
                                          this.i2 = this.i29;
                                       }
                                       si32(this.i24,mstate.ebp + -176);
                                       si32(this.i25,mstate.ebp + -172);
                                       this.f2 = lf64(mstate.ebp + -176);
                                       this.f0 *= 0.5;
                                       this.i2 = this.i28 + this.i31;
                                       this.f3 = this.f1 + this.f0;
                                       if(this.f2 > this.f3)
                                       {
                                          this.i1 = this.i26;
                                          break loop31;
                                       }
                                       this.f0 -= this.f1;
                                       if(this.f2 < this.f0)
                                       {
                                          this.i2 = 0;
                                          do
                                          {
                                             this.i1 = this.i2 ^ -1;
                                             this.i1 = this.i31 + this.i1;
                                             this.i1 = this.i28 + this.i1;
                                             this.i1 = li8(this.i1);
                                             this.i2 += 1;
                                          }
                                          while(this.i1 == 48);
                                          this.f0 = 0;
                                          this.i2 += -1;
                                          this.i2 = this.i31 - this.i2;
                                          this.i2 = this.i28 + this.i2;
                                          if(this.f2 == this.f0)
                                          {
                                             this.i1 = 0;
                                             this.i3 = this.i11;
                                             this.i24 = this.i26;
                                             break loop30;
                                          }
                                          this.i1 = 16;
                                          this.i3 = this.i11;
                                          this.i24 = this.i26;
                                          break loop30;
                                       }
                                    }
                                 }
                              }
                              addr22c4:
                              if(this.i13 <= 14)
                              {
                                 if(this.i8 >= 0)
                                 {
                                    this.i1 = cmodule.cson.___tens_D2A;
                                    this.i2 = this.i13 << 3;
                                    this.i1 += this.i2;
                                    this.f0 = lf64(this.i1);
                                    if(this.i5 <= -1)
                                    {
                                       if(this.i22 <= 0)
                                       {
                                          if(this.i22 >= 0)
                                          {
                                             si32(this.i10,mstate.ebp + -200);
                                             si32(this.i9,mstate.ebp + -196);
                                             this.f1 = lf64(mstate.ebp + -200);
                                             this.f0 *= 5;
                                             if(this.f1 > this.f0)
                                             {
                                                this.i1 = 0;
                                                this.i2 = this.i11;
                                                this.i3 = this.i1;
                                                this.i4 = this.i13;
                                                addr1b94:
                                                break;
                                             }
                                          }
                                          break loop29;
                                       }
                                    }
                                    this.i1 = 1;
                                    si32(this.i1,mstate.ebp + -4);
                                    this.i1 = 0;
                                    this.i2 = this.i10;
                                    this.i3 = this.i9;
                                    while(true)
                                    {
                                       this.f1 = 0;
                                       si32(this.i2,mstate.ebp + -208);
                                       si32(this.i3,mstate.ebp + -204);
                                       this.f2 = lf64(mstate.ebp + -208);
                                       this.f3 = this.f2 / this.f0;
                                       this.i2 = int(this.f3);
                                       this.f3 = Number(this.i2);
                                       this.f3 *= this.f0;
                                       this.i3 = this.i2 + 48;
                                       this.i4 = this.i23 + this.i1;
                                       si8(this.i3,this.i4);
                                       this.i3 = this.i1 + 1;
                                       this.f2 -= this.f3;
                                       if(this.f2 == this.f1)
                                       {
                                          this.i1 = 0;
                                          this.i2 = this.i12 + this.i3;
                                          this.i3 = this.i11;
                                          this.i24 = this.i13;
                                          break loop30;
                                       }
                                       this.i4 = li32(mstate.ebp + -4);
                                       if(this.i4 != this.i22)
                                       {
                                          continue;
                                       }
                                       this.f2 += this.f2;
                                       this.i1 = this.i12 + this.i3;
                                       if(this.f2 <= this.f0)
                                       {
                                          if(this.f2 == this.f0)
                                          {
                                             this.i2 &= 1;
                                             if(this.i2 != 0)
                                             {
                                                addr24c1:
                                                this.i2 = this.i1;
                                                this.i1 = this.i13;
                                                break loop31;
                                             }
                                          }
                                          this.i4 = 16;
                                          this.i3 = this.i11;
                                          this.i2 = this.i1;
                                          this.i24 = this.i13;
                                          this.i1 = this.i4;
                                          break loop30;
                                       }
                                       §§goto(addr24c1);
                                       this.f1 = this.f2 * 10;
                                       sf64(this.f1,mstate.ebp + -216);
                                       this.i2 = this.i4 + 1;
                                       si32(this.i2,mstate.ebp + -4);
                                       this.i2 = li32(mstate.ebp + -216);
                                       this.i3 = li32(mstate.ebp + -212);
                                       this.i1 += 1;
                                    }
                                    break loop30;
                                 }
                              }
                              loop36:
                              while(true)
                              {
                                 while(true)
                                 {
                                    if(this.i20 == 0)
                                    {
                                       this.i2 = 0;
                                       this.i8 = this.i17;
                                       this.i17 = this.i18;
                                       this.i18 = this.i16;
                                       this.i24 = this.i15;
                                    }
                                    else
                                    {
                                       if(this.i19 <= 1)
                                       {
                                          this.i2 = 65 - this.i1;
                                          si32(this.i2,mstate.ebp + -4);
                                          this.i24 = 64 - this.i1;
                                          this.i24 = this.i8 - this.i24;
                                          if(this.i24 < -16445)
                                          {
                                             this.i2 = this.i8 + 16446;
                                             si32(this.i2,mstate.ebp + -4);
                                             this.i24 = li32(cmodule.cson._freelist + 4);
                                             this.i8 = this.i2 + this.i17;
                                             this.i2 += this.i15;
                                             if(this.i24 != 0)
                                             {
                                                this.i17 = li32(this.i24);
                                                si32(this.i17,cmodule.cson._freelist + 4);
                                             }
                                             else
                                             {
                                                this.i24 = cmodule.cson._private_mem;
                                                this.i17 = li32(cmodule.cson._pmem_next);
                                                this.i24 = this.i17 - this.i24;
                                                this.i24 >>= 3;
                                                this.i24 += 4;
                                                if(uint(this.i24) > uint(288))
                                                {
                                                   this.i24 = 32;
                                                   mstate.esp -= 4;
                                                   si32(this.i24,mstate.esp);
                                                   state = 11;
                                                   mstate.esp -= 4;
                                                   FSM_malloc.start();
                                                   return;
                                                }
                                                this.i24 = 1;
                                                this.i9 = this.i17 + 32;
                                                si32(this.i9,cmodule.cson._pmem_next);
                                                si32(this.i24,this.i17 + 4);
                                                this.i24 = 2;
                                                si32(this.i24,this.i17 + 8);
                                                this.i24 = this.i17;
                                             }
                                             addr28ef:
                                             this.i17 = 0;
                                             si32(this.i17,this.i24 + 12);
                                             this.i17 = 1;
                                             si32(this.i17,this.i24 + 20);
                                             si32(this.i17,this.i24 + 16);
                                             if(this.i8 >= 1)
                                             {
                                                if(this.i15 > 0)
                                                {
                                                   this.i17 = this.i16;
                                                   break;
                                                }
                                             }
                                             this.i17 = this.i16;
                                             break loop36;
                                          }
                                          this.i8 = this.i18;
                                          this.i18 = this.i16;
                                          this.i24 = this.i15;
                                       }
                                       else
                                       {
                                          this.i9 = this.i22 + -1;
                                          while(true)
                                          {
                                             if(this.i16 >= this.i9)
                                             {
                                                si32(this.i22,mstate.ebp + -4);
                                                this.i24 = this.i16 - this.i9;
                                                if(this.i22 >= 0)
                                                {
                                                   this.i2 = this.i22;
                                                   this.i8 = this.i18;
                                                   this.i18 = this.i24;
                                                   this.i24 = this.i15;
                                                   break;
                                                }
                                                this.i2 = this.i18;
                                                this.i18 = this.i24;
                                             }
                                             else
                                             {
                                                this.i2 = this.i9 - this.i16;
                                                si32(this.i22,mstate.ebp + -4);
                                                this.i16 = this.i2 + this.i18;
                                                if(this.i22 >= 0)
                                                {
                                                   this.i18 = 0;
                                                   this.i2 = this.i22;
                                                   this.i8 = this.i16;
                                                   this.i24 = this.i15;
                                                   this.i16 = this.i9;
                                                   break;
                                                }
                                                this.i18 = 0;
                                                this.i2 = this.i16;
                                                this.i16 = this.i9;
                                             }
                                             this.i24 = this.i2;
                                             this.i2 = 0;
                                             si32(this.i2,mstate.ebp + -4);
                                             this.i9 = this.i15 - this.i22;
                                             this.i8 = this.i24;
                                             this.i24 = this.i9;
                                             break;
                                          }
                                       }
                                       this.i9 = this.i8;
                                       this.i8 = li32(cmodule.cson._freelist + 4);
                                       this.i17 = this.i2 + this.i17;
                                       this.i15 = this.i2 + this.i15;
                                       if(this.i8 != 0)
                                       {
                                          this.i2 = li32(this.i8);
                                          si32(this.i2,cmodule.cson._freelist + 4);
                                          this.i2 = this.i8;
                                       }
                                       else
                                       {
                                          this.i2 = cmodule.cson._private_mem;
                                          this.i8 = li32(cmodule.cson._pmem_next);
                                          this.i2 = this.i8 - this.i2;
                                          this.i2 >>= 3;
                                          this.i2 += 4;
                                          if(uint(this.i2) > uint(288))
                                          {
                                             this.i2 = 32;
                                             mstate.esp -= 4;
                                             si32(this.i2,mstate.esp);
                                             state = 12;
                                             mstate.esp -= 4;
                                             FSM_malloc.start();
                                             return;
                                          }
                                          this.i2 = 1;
                                          this.i10 = this.i8 + 32;
                                          si32(this.i10,cmodule.cson._pmem_next);
                                          si32(this.i2,this.i8 + 4);
                                          this.i2 = 2;
                                          si32(this.i2,this.i8 + 8);
                                          this.i2 = this.i8;
                                       }
                                       addr2bd4:
                                       this.i8 = 0;
                                       si32(this.i8,this.i2 + 12);
                                       this.i8 = 1;
                                       si32(this.i8,this.i2 + 20);
                                       si32(this.i8,this.i2 + 16);
                                       this.i8 = this.i17;
                                       this.i17 = this.i9;
                                    }
                                    this.i9 = this.i18;
                                    this.i10 = this.i24;
                                    this.i25 = this.i15;
                                    if(this.i10 >= 1)
                                    {
                                       if(this.i8 > 0)
                                       {
                                          this.i18 = this.i17;
                                          this.i17 = this.i9;
                                          this.i15 = this.i10;
                                          this.i24 = this.i2;
                                          this.i2 = this.i25;
                                          break;
                                       }
                                    }
                                    this.i18 = this.i17;
                                    this.i17 = this.i9;
                                    this.i24 = this.i2;
                                    this.i15 = this.i10;
                                    this.i2 = this.i25;
                                    break loop36;
                                 }
                                 this.i9 = this.i8 <= this.i15 ? this.i8 : this.i15;
                                 si32(this.i9,mstate.ebp + -4);
                                 this.i8 -= this.i9;
                                 this.i15 -= this.i9;
                                 this.i2 -= this.i9;
                                 break;
                              }
                              this.i9 = this.i18;
                              this.i10 = this.i17;
                              if(this.i16 <= 0)
                              {
                                 this.i10 = this.i11;
                              }
                              else
                              {
                                 if(this.i20 == 0)
                                 {
                                    mstate.esp -= 8;
                                    si32(this.i11,mstate.esp);
                                    si32(this.i16,mstate.esp + 4);
                                    state = 17;
                                    mstate.esp -= 4;
                                    FSM___pow5mult_D2A.start();
                                    return;
                                 }
                                 if(this.i10 > 0)
                                 {
                                    mstate.esp -= 8;
                                    si32(this.i24,mstate.esp);
                                    si32(this.i10,mstate.esp + 4);
                                    state = 13;
                                    mstate.esp -= 4;
                                    FSM___pow5mult_D2A.start();
                                    return;
                                 }
                                 if(this.i16 != this.i10)
                                 {
                                    mstate.esp -= 8;
                                    this.i10 = this.i16 - this.i10;
                                    si32(this.i11,mstate.esp);
                                    si32(this.i10,mstate.esp + 4);
                                    state = 15;
                                    mstate.esp -= 4;
                                    FSM___pow5mult_D2A.start();
                                    return;
                                 }
                                 this.i10 = this.i11;
                              }
                              §§goto(addr30ba);
                           }
                           this.i11 = this.i4;
                           this.i13 = 49;
                           si8(this.i13,this.i12);
                           this.i13 = 32;
                           this.i4 = 0;
                           this.i11 += 1;
                           this.i24 = this.i12 + 1;
                           addr4e5a:
                           this.i5 = this.i11;
                           this.i8 = this.i13;
                           if(this.i1 != 0)
                           {
                              this.i11 = cmodule.cson._freelist;
                              this.i13 = li32(this.i1 + 4);
                              this.i13 <<= 2;
                              this.i11 += this.i13;
                              this.i13 = li32(this.i11);
                              si32(this.i13,this.i1);
                              si32(this.i1,this.i11);
                           }
                           if(this.i3 == 0)
                           {
                              this.i3 = this.i2;
                              this.i2 = this.i24;
                              this.i24 = this.i5;
                              this.i1 = this.i8;
                              break loop30;
                           }
                           this.i11 = this.i4;
                           this.i13 = this.i24;
                           this.i4 = this.i5;
                           this.i1 = this.i8;
                           §§goto(addr4eeb);
                        }
                        this.i3 = li8(this.i2 + -1);
                        this.i4 = this.i2 + -1;
                        this.i5 = this.i2;
                        if(this.i3 != 57)
                        {
                           this.i3 = this.i4;
                        }
                        else
                        {
                           this.i3 = 0;
                           this.i4 = this.i5;
                           this.i5 = this.i2;
                           while(true)
                           {
                              this.i8 = this.i3 ^ -1;
                              this.i8 = this.i2 + this.i8;
                              if(this.i8 == this.i12)
                              {
                                 break;
                              }
                              this.i5 = li8(this.i4 + -2);
                              this.i4 += -1;
                              this.i3 += 1;
                              if(this.i5 == 57)
                              {
                                 continue;
                              }
                              this.i3 = this.i4 + -1;
                              this.i2 = this.i8;
                              this.i5 = this.i8;
                           }
                           this.i3 = 48;
                           si8(this.i3,this.i8);
                           this.i1 += 1;
                           this.i2 = this.i5;
                           this.i3 = this.i8;
                        }
                        this.i4 = 32;
                        this.i5 = li8(this.i3);
                        this.i5 += 1;
                        si8(this.i5,this.i3);
                        this.i3 = this.i11;
                        this.i24 = this.i1;
                        this.i1 = this.i4;
                        break;
                     }
                     §§goto(addr503a);
                  }
                  this.i1 = 0;
                  this.i2 = this.i11;
                  this.i3 = this.i1;
                  break;
               }
               this.i4 = this.i5 ^ -1;
               if(this.i1 != 0)
               {
                  this.i11 = cmodule.cson._freelist;
                  this.i13 = li32(this.i1 + 4);
                  this.i13 <<= 2;
                  this.i11 += this.i13;
                  this.i13 = li32(this.i11);
                  si32(this.i13,this.i1);
                  si32(this.i1,this.i11);
               }
               if(this.i3 != 0)
               {
                  this.i1 = 16;
                  this.i11 = 0;
                  this.i13 = this.i12;
                  addr4eeb:
                  this.i24 = this.i4;
                  this.i4 = this.i11 == this.i3 ? 1 : 0;
                  this.i5 = this.i11 == 0 ? 1 : 0;
                  this.i4 |= this.i5;
                  if(this.i11 != 0)
                  {
                     this.i4 &= 1;
                     if(this.i4 == 0)
                     {
                        this.i4 = cmodule.cson._freelist;
                        this.i5 = li32(this.i11 + 4);
                        this.i5 <<= 2;
                        this.i4 += this.i5;
                        this.i5 = li32(this.i4);
                        si32(this.i5,this.i11);
                        si32(this.i11,this.i4);
                     }
                  }
                  if(this.i3 == 0)
                  {
                     this.i3 = this.i2;
                     this.i2 = this.i13;
                  }
                  else
                  {
                     this.i11 = cmodule.cson._freelist;
                     this.i4 = li32(this.i3 + 4);
                     this.i4 <<= 2;
                     this.i11 += this.i4;
                     this.i4 = li32(this.i11);
                     si32(this.i4,this.i3);
                     si32(this.i3,this.i11);
                     this.i3 = this.i2;
                     this.i2 = this.i13;
                  }
               }
               else
               {
                  this.i1 = 16;
                  this.i3 = this.i2;
                  this.i2 = this.i12;
                  this.i24 = this.i4;
               }
               addr503a:
               this.i4 = this.i24;
               if(this.i3 != 0)
               {
                  this.i5 = cmodule.cson._freelist;
                  this.i8 = li32(this.i3 + 4);
                  this.i8 <<= 2;
                  this.i5 += this.i8;
                  this.i8 = li32(this.i5);
                  si32(this.i8,this.i3);
                  si32(this.i3,this.i5);
               }
               this.i3 = 0;
               si8(this.i3,this.i2);
               this.i3 = this.i4 + 1;
               si32(this.i3,this.i6);
               if(this.i7 != 0)
               {
                  addr50c6:
                  si32(this.i2,this.i7);
                  this.i2 = li32(this.i0);
                  this.i2 |= this.i1;
                  si32(this.i2,this.i0);
               }
               else
               {
                  this.i2 = this.i1;
                  addr5101:
                  this.i1 = this.i2;
                  this.i2 = li32(this.i0);
                  this.i1 = this.i2 | this.i1;
                  si32(this.i1,this.i0);
               }
               addr5128:
               mstate.eax = this.i12;
               break;
            case 11:
               this.i24 = mstate.eax;
               mstate.esp += 4;
               this.i17 = 1;
               si32(this.i17,this.i24 + 4);
               this.i17 = 2;
               si32(this.i17,this.i24 + 8);
               §§goto(addr28ef);
            case 12:
               this.i2 = mstate.eax;
               mstate.esp += 4;
               this.i8 = 1;
               si32(this.i8,this.i2 + 4);
               this.i8 = 2;
               si32(this.i8,this.i2 + 8);
               §§goto(addr2bd4);
            case 14:
               this.i17 = mstate.eax;
               mstate.esp += 8;
               if(this.i11 == 0)
               {
                  this.i11 = this.i17;
               }
               else
               {
                  this.i18 = cmodule.cson._freelist;
                  this.i25 = li32(this.i11 + 4);
                  this.i25 <<= 2;
                  this.i18 += this.i25;
                  this.i25 = li32(this.i18);
                  si32(this.i25,this.i11);
                  si32(this.i11,this.i18);
                  this.i11 = this.i17;
               }
               §§goto(addr2e53);
            case 15:
               this.i10 = mstate.eax;
               mstate.esp += 8;
               this.i11 = li32(cmodule.cson._freelist + 4);
               if(this.i11 != 0)
               {
                  this.i16 = li32(this.i11);
                  si32(this.i16,cmodule.cson._freelist + 4);
               }
               else
               {
                  this.i11 = cmodule.cson._private_mem;
                  this.i16 = li32(cmodule.cson._pmem_next);
                  this.i11 = this.i16 - this.i11;
                  this.i11 >>= 3;
                  this.i11 += 4;
                  if(uint(this.i11) > uint(288))
                  {
                     this.i11 = 32;
                     mstate.esp -= 4;
                     si32(this.i11,mstate.esp);
                     state = 16;
                     mstate.esp -= 4;
                     FSM_malloc.start();
                     return;
                  }
                  this.i11 = 1;
                  this.i17 = this.i16 + 32;
                  si32(this.i17,cmodule.cson._pmem_next);
                  si32(this.i11,this.i16 + 4);
                  this.i11 = 2;
                  si32(this.i11,this.i16 + 8);
                  this.i11 = this.i16;
               }
               addr3016:
               this.i16 = 0;
               si32(this.i16,this.i11 + 12);
               this.i16 = 1;
               si32(this.i16,this.i11 + 20);
               si32(this.i16,this.i11 + 16);
               if(this.i9 <= 0)
               {
                  §§goto(addr32c5);
               }
               else
               {
                  §§goto(addr3264);
               }
            case 16:
               this.i11 = mstate.eax;
               mstate.esp += 4;
               this.i16 = 1;
               si32(this.i16,this.i11 + 4);
               this.i16 = 2;
               si32(this.i16,this.i11 + 8);
               §§goto(addr3016);
            case 17:
               this.i10 = mstate.eax;
               mstate.esp += 8;
               addr30ba:
               this.i11 = this.i10;
               this.i10 = li32(cmodule.cson._freelist + 4);
               if(this.i10 != 0)
               {
                  this.i16 = li32(this.i10);
                  si32(this.i16,cmodule.cson._freelist + 4);
               }
               else
               {
                  this.i10 = cmodule.cson._private_mem;
                  this.i16 = li32(cmodule.cson._pmem_next);
                  this.i10 = this.i16 - this.i10;
                  this.i10 >>= 3;
                  this.i10 += 4;
                  if(uint(this.i10) > uint(288))
                  {
                     this.i10 = 32;
                     mstate.esp -= 4;
                     si32(this.i10,mstate.esp);
                     state = 18;
                     mstate.esp -= 4;
                     FSM_malloc.start();
                     return;
                  }
                  this.i10 = 1;
                  this.i17 = this.i16 + 32;
                  si32(this.i17,cmodule.cson._pmem_next);
                  si32(this.i10,this.i16 + 4);
                  this.i10 = 2;
                  si32(this.i10,this.i16 + 8);
                  this.i10 = this.i16;
               }
               §§goto(addr31fd);
            case 18:
               this.i10 = mstate.eax;
               mstate.esp += 4;
               this.i16 = 1;
               si32(this.i16,this.i10 + 4);
               this.i16 = 2;
               si32(this.i16,this.i10 + 8);
               addr31fd:
               this.i16 = this.i10;
               this.i10 = 0;
               si32(this.i10,this.i16 + 12);
               this.i10 = 1;
               si32(this.i10,this.i16 + 20);
               si32(this.i10,this.i16 + 16);
               if(this.i9 <= 0)
               {
                  this.i10 = this.i11;
                  this.i11 = this.i16;
                  this.i16 = this.i19 < 2 ? 1 : 0;
                  this.i1 = this.i1 == 1 ? 1 : 0;
                  this.i1 &= this.i16;
                  this.i3 = this.i3 > -16444 ? 1 : 0;
                  this.i1 &= this.i3;
                  this.i3 = this.i1 & 1;
                  this.i2 += this.i3;
                  this.i3 = this.i8 + this.i3;
                  §§goto(addr32c5);
               }
               else
               {
                  addr3264:
               }
               this.i10 = this.i11;
               this.i11 = this.i16;
               mstate.esp -= 8;
               si32(this.i11,mstate.esp);
               si32(this.i9,mstate.esp + 4);
               state = 19;
               mstate.esp -= 4;
               FSM___pow5mult_D2A.start();
               return;
            case 19:
               this.i11 = mstate.eax;
               mstate.esp += 8;
               addr32c5:
               if(this.i9 == 0)
               {
                  this.i8 = 1;
               }
               else
               {
                  this.i8 = li32(this.i11 + 16);
                  this.i8 <<= 2;
                  this.i8 += this.i11;
                  this.i8 = li32(this.i8 + 16);
                  this.i9 = uint(this.i8) < uint(65536) ? 16 : 0;
                  this.i8 <<= this.i9;
                  this.i16 = uint(this.i8) < uint(16777216) ? 8 : 0;
                  this.i8 <<= this.i16;
                  this.i17 = uint(this.i8) < uint(268435456) ? 4 : 0;
                  this.i9 = this.i16 | this.i9;
                  this.i8 <<= this.i17;
                  this.i16 = uint(this.i8) < uint(1073741824) ? 2 : 0;
                  this.i9 |= this.i17;
                  this.i9 |= this.i16;
                  this.i8 <<= this.i16;
                  if(this.i8 <= -1)
                  {
                     this.i8 = this.i9;
                  }
                  else
                  {
                     this.i8 &= 1073741824;
                     this.i9 += 1;
                     this.i8 = this.i8 == 0 ? 32 : this.i9;
                  }
                  this.i8 = 32 - this.i8;
               }
               this.i8 += this.i3;
               this.i8 &= 31;
               this.i9 = 32 - this.i8;
               this.i8 = this.i8 == 0 ? this.i8 : this.i9;
               si32(this.i8,mstate.ebp + -4);
               if(this.i8 >= 5)
               {
                  this.i8 += -4;
                  si32(this.i8,mstate.ebp + -4);
                  this.i3 = this.i8 + this.i3;
                  this.i15 = this.i8 + this.i15;
                  this.i2 = this.i8 + this.i2;
                  if(this.i2 <= 0)
                  {
                     this.i2 = this.i3;
                     this.i3 = this.i15;
                     this.i15 = this.i10;
                     §§goto(addr367c);
                  }
               }
               else
               {
                  if(this.i8 < 4)
                  {
                     this.i8 += 28;
                     si32(this.i8,mstate.ebp + -4);
                     this.i3 = this.i8 + this.i3;
                     this.i15 = this.i8 + this.i15;
                     this.i2 = this.i8 + this.i2;
                  }
                  if(this.i2 <= 0)
                  {
                     this.i2 = this.i3;
                     this.i3 = this.i15;
                     this.i15 = this.i10;
                     §§goto(addr367c);
                  }
               }
               mstate.esp -= 8;
               si32(this.i10,mstate.esp);
               si32(this.i2,mstate.esp + 4);
               state = 20;
               mstate.esp -= 4;
               FSM___lshift_D2A.start();
               return;
            case 20:
               this.i8 = mstate.eax;
               mstate.esp += 8;
               this.i2 = this.i3;
               this.i3 = this.i15;
               this.i15 = this.i8;
               addr367c:
               this.i8 = this.i15;
               if(this.i2 <= 0)
               {
                  this.i2 = this.i11;
                  §§goto(addr36fc);
               }
               mstate.esp -= 8;
               si32(this.i11,mstate.esp);
               si32(this.i2,mstate.esp + 4);
               state = 21;
               mstate.esp -= 4;
               FSM___lshift_D2A.start();
               return;
            case 21:
               this.i2 = mstate.eax;
               mstate.esp += 8;
               addr36fc:
               this.i11 = this.i2;
               if(this.i14 != 0)
               {
                  this.i2 = li32(this.i8 + 16);
                  this.i9 = li32(this.i11 + 16);
                  this.i10 = this.i2 - this.i9;
                  if(this.i2 != this.i9)
                  {
                     this.i2 = this.i10;
                  }
                  else
                  {
                     this.i2 = 0;
                     while(true)
                     {
                        this.i10 = this.i2 ^ -1;
                        this.i10 = this.i9 + this.i10;
                        this.i14 = this.i10 << 2;
                        this.i15 = this.i8 + this.i14;
                        this.i14 = this.i11 + this.i14;
                        this.i15 = li32(this.i15 + 20);
                        this.i14 = li32(this.i14 + 20);
                        if(this.i15 != this.i14)
                        {
                           this.i2 = uint(this.i15) < uint(this.i14) ? -1 : 1;
                           break;
                        }
                        this.i2 += 1;
                        if(this.i10 <= 0)
                        {
                           this.i2 = 0;
                           break;
                        }
                     }
                  }
                  if(this.i2 <= -1)
                  {
                     this.i2 = 10;
                     mstate.esp -= 12;
                     this.i9 = 0;
                     si32(this.i8,mstate.esp);
                     si32(this.i2,mstate.esp + 4);
                     si32(this.i9,mstate.esp + 8);
                     state = 22;
                     mstate.esp -= 4;
                     FSM___multadd_D2A.start();
                     return;
                  }
               }
               this.i2 = this.i8;
               this.i8 = this.i13;
               this.i13 = this.i22;
               §§goto(addr395e);
            case 22:
               this.i2 = mstate.eax;
               mstate.esp += 12;
               this.i13 += -1;
               if(this.i20 != 0)
               {
                  this.i8 = 0;
                  mstate.esp -= 12;
                  this.i9 = 10;
                  si32(this.i24,mstate.esp);
                  si32(this.i9,mstate.esp + 4);
                  si32(this.i8,mstate.esp + 8);
                  state = 23;
                  mstate.esp -= 4;
                  FSM___multadd_D2A.start();
                  return;
               }
               this.i8 = this.i13;
               this.i13 = this.i21;
               §§goto(addr395e);
               break;
            case 23:
               this.i24 = mstate.eax;
               mstate.esp += 12;
               this.i8 = this.i13;
               this.i13 = this.i21;
               addr395e:
               if(this.i13 <= 0)
               {
                  if(this.i19 >= 3)
                  {
                     if(this.i13 <= -1)
                     {
                        this.i3 = this.i24;
                        this.i1 = this.i11;
                        break loop28;
                     }
                     this.i1 = 0;
                     mstate.esp -= 12;
                     this.i3 = 5;
                     si32(this.i11,mstate.esp);
                     si32(this.i3,mstate.esp + 4);
                     si32(this.i1,mstate.esp + 8);
                     state = 24;
                     mstate.esp -= 4;
                     FSM___multadd_D2A.start();
                     return;
                  }
               }
               if(this.i20 == 0)
               {
                  this.i1 = 1;
                  si32(this.i1,mstate.ebp + -4);
                  mstate.esp -= 8;
                  si32(this.i2,mstate.esp);
                  si32(this.i11,mstate.esp + 4);
                  mstate.esp -= 4;
                  FSM___quorem_D2A.start();
                  §§goto(addr3c27);
               }
               if(this.i3 <= 0)
               {
                  this.i3 = this.i24;
                  §§goto(addr3d0c);
               }
               mstate.esp -= 8;
               si32(this.i24,mstate.esp);
               si32(this.i3,mstate.esp + 4);
               state = 26;
               mstate.esp -= 4;
               FSM___lshift_D2A.start();
               return;
            case 25:
               addr3c27:
               this.i1 = mstate.eax;
               mstate.esp += 8;
               this.i1 += 48;
               si8(this.i1,this.i12);
               this.i3 = li32(mstate.ebp + -4);
               this.i4 = this.i12 + 1;
               if(this.i3 >= this.i13)
               {
                  this.i3 = 0;
                  this.i13 = this.i4;
                  this.i4 = this.i24;
                  §§goto(addr4b05);
               }
               else
               {
                  addr4953:
               }
               this.i1 = 0;
               this.i3 = 0;
               mstate.esp -= 12;
               this.i4 = 10;
               si32(this.i2,mstate.esp);
               si32(this.i4,mstate.esp + 4);
               si32(this.i3,mstate.esp + 8);
               state = 36;
               mstate.esp -= 4;
               FSM___multadd_D2A.start();
               return;
            case 26:
               this.i3 = mstate.eax;
               mstate.esp += 8;
               addr3d0c:
               this.i1 &= 1;
               if(this.i1 == 0)
               {
                  this.i1 = 1;
                  this.i24 = 0;
                  this.i5 = this.i3;
                  §§goto(addr3e67);
               }
               this.i1 = 1;
               this.i24 = li32(this.i3 + 4);
               mstate.esp -= 4;
               si32(this.i24,mstate.esp);
               state = 27;
               mstate.esp -= 4;
               FSM___Balloc_D2A.start();
               return;
            case 28:
               this.i9 = mstate.eax;
               mstate.esp += 8;
               this.i24 = 0;
               this.i5 = this.i3;
               this.i3 = this.i9;
               §§goto(addr3e67);
            case 33:
               this.i1 = mstate.eax;
               mstate.esp += 12;
               this.i3 = this.i1;
               §§goto(addr4904);
            case 35:
               this.i1 = mstate.eax;
               mstate.esp += 12;
               this.i3 = this.i5;
               addr4904:
               this.i9 = this.i1;
               this.i1 = li32(mstate.ebp + -4);
               this.i24 += 1;
               this.i1 += 1;
               this.i5 = this.i3;
               this.i3 = this.i9;
               addr3e67:
               si32(this.i1,mstate.ebp + -4);
               mstate.esp -= 8;
               si32(this.i2,mstate.esp);
               si32(this.i11,mstate.esp + 4);
               mstate.esp -= 4;
               FSM___quorem_D2A.start();
               §§goto(addr3eb4);
            case 29:
               addr3eb4:
               this.i1 = mstate.eax;
               mstate.esp += 8;
               this.i9 = li32(this.i2 + 16);
               this.i10 = li32(this.i5 + 16);
               this.i14 = this.i9 - this.i10;
               this.i15 = this.i2 + 16;
               this.i16 = this.i1 + 48;
               this.i17 = this.i23 + this.i24;
               if(this.i9 != this.i10)
               {
                  this.i10 = this.i14;
               }
               else
               {
                  this.i9 = 0;
                  while(true)
                  {
                     this.i14 = this.i9 ^ -1;
                     this.i14 = this.i10 + this.i14;
                     this.i18 = this.i14 << 2;
                     this.i20 = this.i2 + this.i18;
                     this.i18 = this.i5 + this.i18;
                     this.i20 = li32(this.i20 + 20);
                     this.i18 = li32(this.i18 + 20);
                     if(this.i20 != this.i18)
                     {
                        this.i9 = uint(this.i20) < uint(this.i18) ? -1 : 1;
                        this.i10 = this.i9;
                        break;
                     }
                     this.i9 += 1;
                     if(this.i14 <= 0)
                     {
                        this.i9 = 0;
                        this.i10 = this.i9;
                        break;
                     }
                  }
               }
               this.i9 = this.i10;
               mstate.esp -= 8;
               si32(this.i11,mstate.esp);
               si32(this.i3,mstate.esp + 4);
               state = 30;
               mstate.esp -= 4;
               FSM___diff_D2A.start();
               return;
            case 13:
               this.i24 = mstate.eax;
               mstate.esp += 8;
               mstate.esp -= 8;
               si32(this.i24,mstate.esp);
               si32(this.i11,mstate.esp + 4);
               state = 14;
               mstate.esp -= 4;
               FSM___mult_D2A.start();
               return;
            case 24:
               this.i1 = mstate.eax;
               mstate.esp += 12;
               this.i3 = li32(this.i2 + 16);
               this.i4 = li32(this.i1 + 16);
               this.i11 = this.i3 - this.i4;
               if(this.i3 != this.i4)
               {
                  this.i3 = this.i11;
               }
               else
               {
                  this.i3 = 0;
                  while(true)
                  {
                     this.i11 = this.i3 ^ -1;
                     this.i11 = this.i4 + this.i11;
                     this.i13 = this.i11 << 2;
                     this.i19 = this.i2 + this.i13;
                     this.i13 = this.i1 + this.i13;
                     this.i19 = li32(this.i19 + 20);
                     this.i13 = li32(this.i13 + 20);
                     if(this.i19 != this.i13)
                     {
                        break;
                     }
                     this.i3 += 1;
                     if(this.i11 > 0)
                     {
                        continue;
                     }
                     this.i3 = 0;
                  }
                  this.i3 = uint(this.i19) < uint(this.i13) ? -1 : 1;
               }
               if(this.i3 < 1)
               {
                  this.i3 = this.i24;
                  break loop28;
               }
               this.i3 = this.i24;
               this.i4 = this.i8;
               §§goto(addr1b94);
               break;
            case 27:
               this.i24 = mstate.eax;
               mstate.esp += 4;
               this.i5 = li32(this.i3 + 16);
               this.i9 = this.i24 + 12;
               this.i5 <<= 2;
               this.i10 = this.i3 + 12;
               this.i5 += 8;
               cmodule.cson.memcpy(this.i9,this.i10,this.i5);
               mstate.esp -= 8;
               si32(this.i24,mstate.esp);
               si32(this.i1,mstate.esp + 4);
               state = 28;
               mstate.esp -= 4;
               FSM___lshift_D2A.start();
               return;
            case 30:
               this.i10 = mstate.eax;
               mstate.esp += 8;
               this.i14 = li32(this.i10 + 12);
               if(this.i14 != 0)
               {
                  this.i14 = 1;
               }
               else
               {
                  this.i14 = li32(this.i15);
                  this.i18 = li32(this.i10 + 16);
                  this.i20 = this.i14 - this.i18;
                  if(this.i14 != this.i18)
                  {
                     this.i14 = this.i20;
                  }
                  else
                  {
                     this.i14 = 0;
                     while(true)
                     {
                        this.i20 = this.i14 ^ -1;
                        this.i20 = this.i18 + this.i20;
                        this.i21 = this.i20 << 2;
                        this.i22 = this.i2 + this.i21;
                        this.i21 = this.i10 + this.i21;
                        this.i22 = li32(this.i22 + 20);
                        this.i21 = li32(this.i21 + 20);
                        if(this.i22 != this.i21)
                        {
                           this.i14 = uint(this.i22) < uint(this.i21) ? -1 : 1;
                           break;
                        }
                        this.i14 += 1;
                        if(this.i20 <= 0)
                        {
                           this.i14 = 0;
                           break;
                        }
                     }
                  }
               }
               if(this.i10 != 0)
               {
                  this.i18 = cmodule.cson._freelist;
                  this.i20 = li32(this.i10 + 4);
                  this.i20 <<= 2;
                  this.i18 += this.i20;
                  this.i20 = li32(this.i18);
                  si32(this.i20,this.i10);
                  si32(this.i10,this.i18);
               }
               this.i10 = this.i14 | this.i19;
               loop39:
               while(true)
               {
                  while(true)
                  {
                     if(this.i10 == 0)
                     {
                        this.i10 = li32(this.i4);
                        this.i10 &= 1;
                        if(this.i10 == 0)
                        {
                           if(this.i16 == 57)
                           {
                              break;
                           }
                           if(this.i9 <= 0)
                           {
                              this.i1 = li32(this.i15);
                              if(this.i1 <= 1)
                              {
                                 this.i1 = li32(this.i2 + 20);
                                 if(this.i1 == 0)
                                 {
                                    this.i13 = 0;
                                    this.i1 = this.i24 + this.i12;
                                    si8(this.i16,this.i17);
                                    this.i24 = this.i1 + 1;
                                    this.i4 = this.i5;
                                    this.i1 = this.i11;
                                    this.i11 = this.i8;
                                    break loop39;
                                 }
                              }
                              this.i13 = 16;
                              this.i1 = this.i24 + this.i12;
                              si8(this.i16,this.i17);
                              this.i24 = this.i1 + 1;
                              this.i4 = this.i5;
                              this.i1 = this.i11;
                              this.i11 = this.i8;
                              break loop39;
                           }
                           this.i13 = 32;
                           this.i24 += this.i12;
                           this.i1 += 49;
                           si8(this.i1,this.i17);
                           this.i24 += 1;
                           this.i4 = this.i5;
                           this.i1 = this.i11;
                           this.i11 = this.i8;
                           break loop39;
                        }
                     }
                     if(this.i9 >= 0)
                     {
                        this.i9 |= this.i19;
                        if(this.i9 == 0)
                        {
                           this.i9 = li32(this.i4);
                           this.i9 &= 1;
                           if(this.i9 == 0)
                           {
                              §§goto(addr4357);
                           }
                        }
                        if(this.i14 >= 1)
                        {
                           if(this.i16 != 57)
                           {
                              this.i13 = 32;
                              this.i1 = this.i24 + this.i12;
                              this.i24 = this.i16 + 1;
                              si8(this.i24,this.i17);
                              this.i24 = this.i1 + 1;
                              this.i4 = this.i5;
                              this.i1 = this.i11;
                              this.i11 = this.i8;
                              break loop39;
                           }
                           break;
                        }
                        si8(this.i16,this.i17);
                        this.i1 = li32(mstate.ebp + -4);
                        this.i9 = this.i24 + 1;
                        if(this.i1 != this.i13)
                        {
                           this.i1 = 0;
                           mstate.esp -= 12;
                           this.i9 = 10;
                           si32(this.i2,mstate.esp);
                           si32(this.i9,mstate.esp + 4);
                           si32(this.i1,mstate.esp + 8);
                           state = 32;
                           mstate.esp -= 4;
                           FSM___multadd_D2A.start();
                           return;
                        }
                        this.i13 = this.i12 + this.i9;
                        this.i1 = this.i16;
                        this.i4 = this.i3;
                        this.i3 = this.i5;
                        §§goto(addr4b05);
                     }
                     addr4357:
                     if(this.i14 <= 0)
                     {
                        this.i1 = 0;
                        this.i13 = this.i16;
                        addr452f:
                        this.i14 = this.i1;
                        this.i1 = this.i13;
                        this.i13 = li32(this.i2 + 16);
                        if(this.i13 <= 1)
                        {
                           this.i13 = li32(this.i2 + 20);
                           if(this.i13 == 0)
                           {
                              this.i13 = this.i24 + this.i12;
                              si8(this.i1,this.i17);
                              this.i13 += 1;
                              this.i4 = this.i5;
                              this.i1 = this.i11;
                              this.i24 = this.i13;
                              this.i11 = this.i8;
                              this.i13 = this.i14;
                              break loop39;
                           }
                        }
                        this.i13 = 16;
                        this.i24 += this.i12;
                        si8(this.i1,this.i17);
                        this.i24 += 1;
                        this.i4 = this.i5;
                        this.i1 = this.i11;
                        this.i11 = this.i8;
                        break loop39;
                     }
                     this.i13 = 1;
                     mstate.esp -= 8;
                     si32(this.i2,mstate.esp);
                     si32(this.i13,mstate.esp + 4);
                     state = 31;
                     mstate.esp -= 4;
                     FSM___lshift_D2A.start();
                     return;
                  }
                  addr4669:
                  this.i1 = 57;
                  this.i13 = this.i24 + this.i12;
                  si8(this.i1,this.i17);
                  this.i1 = this.i13 + 1;
                  this.i13 = this.i23 + this.i24;
                  this.i24 = this.i5;
                  addr46ae:
                  this.i5 = this.i1;
                  if(this.i13 != this.i12)
                  {
                     this.i1 = this.i24;
                     while(true)
                     {
                        this.i24 = li8(this.i13 + -1);
                        this.i4 = this.i13 + -1;
                        if(this.i24 != 57)
                        {
                           break;
                        }
                        this.i24 = this.i1;
                        this.i1 = this.i13;
                        this.i13 = this.i4;
                        §§goto(addr46ae);
                        this.i1 = this.i24;
                     }
                     this.i5 = 32;
                     this.i24 += 1;
                     si8(this.i24,this.i4);
                     this.i4 = this.i1;
                     this.i1 = this.i11;
                     this.i24 = this.i13;
                     this.i11 = this.i8;
                     this.i13 = this.i5;
                     break;
                     addr4c89:
                  }
                  this.i1 = 49;
                  si8(this.i1,this.i13);
                  this.i13 = 32;
                  this.i8 += 1;
                  this.i4 = this.i24;
                  this.i1 = this.i11;
                  this.i24 = this.i5;
                  this.i11 = this.i8;
                  break;
               }
               §§goto(addr4e5a);
            case 31:
               this.i2 = mstate.eax;
               mstate.esp += 8;
               this.i13 = li32(this.i2 + 16);
               this.i4 = li32(this.i11 + 16);
               this.i14 = this.i13 - this.i4;
               if(this.i13 != this.i4)
               {
                  this.i13 = this.i14;
               }
               else
               {
                  this.i13 = 0;
                  while(true)
                  {
                     this.i14 = this.i13 ^ -1;
                     this.i14 = this.i4 + this.i14;
                     this.i19 = this.i14 << 2;
                     this.i9 = this.i2 + this.i19;
                     this.i19 = this.i11 + this.i19;
                     this.i9 = li32(this.i9 + 20);
                     this.i19 = li32(this.i19 + 20);
                     if(this.i9 != this.i19)
                     {
                        break;
                     }
                     this.i13 += 1;
                     if(this.i14 > 0)
                     {
                        continue;
                     }
                     this.i13 = 0;
                  }
                  this.i13 = uint(this.i9) < uint(this.i19) ? -1 : 1;
               }
               while(true)
               {
                  if(this.i13 <= 0)
                  {
                     if(this.i13 == 0)
                     {
                        this.i13 = this.i16 & 1;
                        if(this.i13 != 0)
                        {
                           addr450f:
                           this.i13 = this.i1 + 49;
                           if(this.i13 != 58)
                           {
                              this.i1 = 32;
                              break;
                           }
                           §§goto(addr4669);
                        }
                     }
                     this.i1 = 32;
                     this.i13 = this.i16;
                     break;
                  }
                  §§goto(addr450f);
               }
               §§goto(addr452f);
            case 32:
               this.i2 = mstate.eax;
               mstate.esp += 12;
               if(this.i5 == this.i3)
               {
                  this.i1 = 0;
                  mstate.esp -= 12;
                  this.i5 = 10;
                  si32(this.i3,mstate.esp);
                  si32(this.i5,mstate.esp + 4);
                  si32(this.i1,mstate.esp + 8);
                  state = 33;
                  mstate.esp -= 4;
                  FSM___multadd_D2A.start();
                  return;
               }
               this.i1 = 0;
               mstate.esp -= 12;
               this.i9 = 10;
               si32(this.i5,mstate.esp);
               si32(this.i9,mstate.esp + 4);
               si32(this.i1,mstate.esp + 8);
               state = 34;
               mstate.esp -= 4;
               FSM___multadd_D2A.start();
               return;
               break;
            case 34:
               this.i5 = mstate.eax;
               mstate.esp += 12;
               mstate.esp -= 12;
               si32(this.i3,mstate.esp);
               si32(this.i9,mstate.esp + 4);
               si32(this.i1,mstate.esp + 8);
               state = 35;
               mstate.esp -= 4;
               FSM___multadd_D2A.start();
               return;
            case 36:
               this.i2 = mstate.eax;
               mstate.esp += 12;
               this.i3 = li32(mstate.ebp + -4);
               this.i3 += 1;
               si32(this.i3,mstate.ebp + -4);
               mstate.esp -= 8;
               si32(this.i2,mstate.esp);
               si32(this.i11,mstate.esp + 4);
               mstate.esp -= 4;
               FSM___quorem_D2A.start();
            case 37:
               this.i3 = mstate.eax;
               mstate.esp += 8;
               this.i3 += 48;
               this.i4 = this.i23 + this.i1;
               si8(this.i3,this.i4 + 1);
               this.i4 = li32(mstate.ebp + -4);
               this.i1 += 1;
               if(this.i4 >= this.i13)
               {
                  this.i5 = 0;
                  this.i1 <<= 0;
                  this.i1 += this.i12;
                  this.i13 = this.i1 + 1;
                  this.i1 = this.i3;
                  this.i4 = this.i24;
                  this.i3 = this.i5;
                  addr4b05:
                  this.i24 = this.i4;
                  this.i4 = 1;
                  mstate.esp -= 8;
                  si32(this.i2,mstate.esp);
                  si32(this.i4,mstate.esp + 4);
                  state = 38;
                  mstate.esp -= 4;
                  FSM___lshift_D2A.start();
                  return;
               }
               §§goto(addr4953);
               break;
            case 38:
               this.i2 = mstate.eax;
               mstate.esp += 8;
               this.i4 = li32(this.i2 + 16);
               this.i5 = li32(this.i11 + 16);
               this.i9 = this.i4 - this.i5;
               if(this.i4 != this.i5)
               {
                  this.i4 = this.i9;
               }
               else
               {
                  this.i4 = 0;
                  while(true)
                  {
                     this.i9 = this.i4 ^ -1;
                     this.i9 = this.i5 + this.i9;
                     this.i10 = this.i9 << 2;
                     this.i14 = this.i2 + this.i10;
                     this.i10 = this.i11 + this.i10;
                     this.i14 = li32(this.i14 + 20);
                     this.i10 = li32(this.i10 + 20);
                     if(this.i14 != this.i10)
                     {
                        this.i4 = uint(this.i14) < uint(this.i10) ? -1 : 1;
                        break;
                     }
                     this.i4 += 1;
                     if(this.i9 <= 0)
                     {
                        this.i4 = 0;
                        break;
                     }
                  }
               }
               if(this.i4 < 1)
               {
                  if(this.i4 == 0)
                  {
                     this.i1 &= 1;
                     if(this.i1 != 0)
                     {
                        addr4c75:
                        this.i1 = this.i3;
                        this.i3 = this.i24;
                        §§goto(addr4c89);
                     }
                  }
                  this.i1 = li32(this.i2 + 16);
                  while(true)
                  {
                     if(this.i1 <= 1)
                     {
                        this.i1 = li32(this.i2 + 20);
                        if(this.i1 == 0)
                        {
                           this.i1 = 0;
                           break;
                        }
                     }
                     this.i1 = 16;
                     break;
                  }
                  this.i5 = this.i1;
                  this.i1 = 0;
                  do
                  {
                     this.i4 = this.i1 ^ -1;
                     this.i4 = this.i13 + this.i4;
                     this.i4 = li8(this.i4);
                     this.i1 += 1;
                  }
                  while(this.i4 == 48);
                  this.i1 += -1;
                  this.i13 -= this.i1;
                  this.i4 = this.i3;
                  this.i3 = this.i24;
                  this.i1 = this.i11;
                  this.i24 = this.i13;
                  this.i11 = this.i8;
                  this.i13 = this.i5;
                  break loop39;
               }
               §§goto(addr4c75);
            default:
               throw "Invalid state in ___gdtoa";
         }
         mstate.esp = mstate.ebp;
         mstate.ebp = li32(mstate.esp);
         mstate.esp += 4;
         mstate.esp += 4;
         mstate.gworker = caller;
      }
   }
}

