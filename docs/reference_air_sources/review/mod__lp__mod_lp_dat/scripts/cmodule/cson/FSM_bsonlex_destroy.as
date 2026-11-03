package cmodule.cson
{
   import avm2.intrinsics.memory.li32;
   import avm2.intrinsics.memory.li8;
   import avm2.intrinsics.memory.si32;
   import avm2.intrinsics.memory.si8;
   
   public final class FSM_bsonlex_destroy extends Machine
   {
      
      public static const intRegCount:int = 14;
      
      public static const NumberRegCount:int = 0;
      
      public var i10:int;
      
      public var i11:int;
      
      public var i12:int;
      
      public var i13:int;
      
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
      
      public function FSM_bsonlex_destroy()
      {
         super();
      }
      
      public static function start() : void
      {
         var _loc1_:FSM_bsonlex_destroy = null;
         _loc1_ = new FSM_bsonlex_destroy();
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
               this.i1 = li32(this.i0 + 44);
               this.i2 = this.i0 + 44;
               this.i3 = this.i0;
               if(this.i1 != 0)
               {
                  this.i4 = this.i3 + 72;
                  this.i5 = this.i3 + 48;
                  this.i6 = this.i3 + 28;
                  this.i7 = this.i3 + 104;
                  this.i8 = this.i3 + 60;
                  this.i9 = this.i3 + 52;
                  this.i10 = this.i3 + 36;
                  addr0508:
                  this.i11 = this.i1;
                  this.i1 = li32(this.i10);
                  this.i1 <<= 2;
                  this.i12 = this.i11 + this.i1;
                  this.i1 = li32(this.i12);
                  if(this.i1 != 0)
                  {
                     §§push(this);
                     if(this.i11 == 0)
                     {
                        addr00ae:
                        §§pop().i1 = 0;
                        if(this.i1 == 0)
                        {
                           addr01bc:
                           this.i1 = 0;
                           this.i11 = li32(this.i10);
                           this.i12 = li32(this.i2);
                           this.i11 <<= 2;
                           this.i11 = this.i12 + this.i11;
                           si32(this.i1,this.i11);
                           this.i1 = li32(this.i2);
                           if(this.i1 == 0)
                           {
                              while(true)
                              {
                                 if(this.i1 != 0)
                                 {
                                    §§goto(addr0508);
                                 }
                                 else
                                 {
                                    addr04b3:
                                 }
                                 §§goto(addr054e);
                              }
                              addr0546:
                              this.i1 = this.i11;
                              addr054e:
                              this.i4 = 0;
                              mstate.esp -= 8;
                              si32(this.i1,mstate.esp);
                              si32(this.i4,mstate.esp + 4);
                              state = 5;
                              mstate.esp -= 4;
                              FSM_pubrealloc.start();
                              return;
                              addr04a4:
                           }
                           this.i11 = li32(this.i10);
                           this.i11 <<= 2;
                           this.i11 = this.i1 + this.i11;
                           this.i12 = li32(this.i11);
                           if(this.i12 != 0)
                           {
                              §§push(this);
                              if(this.i1 == 0)
                              {
                                 §§pop().i1 = 0;
                                 if(this.i1 == 0)
                                 {
                                    while(true)
                                    {
                                       this.i1 = 0;
                                       this.i11 = li32(this.i10);
                                       this.i12 = li32(this.i2);
                                       this.i11 <<= 2;
                                       this.i11 = this.i12 + this.i11;
                                       si32(this.i1,this.i11);
                                       this.i1 = li32(this.i10);
                                       if(this.i1 != 0)
                                       {
                                          this.i1 += -1;
                                          si32(this.i1,this.i10);
                                       }
                                       this.i11 = li32(this.i2);
                                       while(true)
                                       {
                                          if(this.i11 != 0)
                                          {
                                             this.i1 <<= 2;
                                             this.i1 = this.i11 + this.i1;
                                             this.i12 = li32(this.i1);
                                             if(this.i12 != 0)
                                             {
                                                this.i13 = 1;
                                                this.i12 = li32(this.i12 + 16);
                                                si32(this.i12,this.i9);
                                                this.i12 = li32(this.i1);
                                                this.i12 = li32(this.i12 + 8);
                                                si32(this.i12,this.i8);
                                                si32(this.i12,this.i7);
                                                this.i1 = li32(this.i1);
                                                this.i1 = li32(this.i1);
                                                si32(this.i1,this.i6);
                                                this.i1 = li8(this.i12);
                                                si8(this.i1,this.i5);
                                                si32(this.i13,this.i4);
                                                this.i1 = this.i11;
                                                break;
                                             }
                                          }
                                          this.i1 = this.i11;
                                          break;
                                       }
                                       §§goto(addr04a4);
                                    }
                                    §§goto(addr04b3);
                                    addr036c:
                                 }
                                 this.i12 = 0;
                                 si32(this.i12,this.i11);
                                 this.i11 = li32(this.i1 + 20);
                                 if(this.i11 != 0)
                                 {
                                    this.i11 = 0;
                                    this.i12 = li32(this.i1 + 4);
                                    mstate.esp -= 8;
                                    si32(this.i12,mstate.esp);
                                    si32(this.i11,mstate.esp + 4);
                                    state = 3;
                                    mstate.esp -= 4;
                                    FSM_pubrealloc.start();
                                    return;
                                 }
                                 §§goto(addr0305);
                              }
                              §§goto(addr025e);
                              §§push(this.i12);
                           }
                           §§goto(addr020f);
                        }
                        this.i11 = 0;
                        si32(this.i11,this.i12);
                        this.i11 = li32(this.i1 + 20);
                        if(this.i11 != 0)
                        {
                           this.i11 = 0;
                           this.i12 = li32(this.i1 + 4);
                           mstate.esp -= 8;
                           si32(this.i12,mstate.esp);
                           si32(this.i11,mstate.esp + 4);
                           state = 1;
                           mstate.esp -= 4;
                           FSM_pubrealloc.start();
                           return;
                        }
                        break;
                     }
                     §§goto(addr00ae);
                     §§push(this.i1);
                  }
                  §§goto(addr0546);
               }
               §§goto(addr054e);
            case 1:
               this.i11 = mstate.eax;
               mstate.esp += 8;
               break;
            case 2:
               this.i1 = mstate.eax;
               mstate.esp += 8;
               §§goto(addr01bc);
            case 3:
               this.i11 = mstate.eax;
               mstate.esp += 8;
               addr0305:
               this.i11 = 0;
               mstate.esp -= 8;
               si32(this.i1,mstate.esp);
               si32(this.i11,mstate.esp + 4);
               state = 4;
               mstate.esp -= 4;
               FSM_pubrealloc.start();
               return;
            case 4:
               this.i1 = mstate.eax;
               mstate.esp += 8;
               §§goto(addr036c);
            case 5:
               this.i1 = mstate.eax;
               mstate.esp += 8;
               si32(this.i4,this.i2);
               this.i1 = li32(this.i3 + 84);
               mstate.esp -= 8;
               si32(this.i1,mstate.esp);
               si32(this.i4,mstate.esp + 4);
               state = 6;
               mstate.esp -= 4;
               FSM_pubrealloc.start();
               return;
            case 6:
               this.i1 = mstate.eax;
               mstate.esp += 8;
               si32(this.i4,this.i2);
               si32(this.i4,this.i3 + 36);
               si32(this.i4,this.i3 + 40);
               si32(this.i4,this.i3 + 60);
               si32(this.i4,this.i3 + 64);
               si32(this.i4,this.i3 + 68);
               si32(this.i4,this.i3 + 76);
               si32(this.i4,this.i3 + 80);
               si32(this.i4,this.i3 + 84);
               si32(this.i4,this.i3 + 28);
               si32(this.i4,this.i3 + 32);
               mstate.esp -= 8;
               si32(this.i0,mstate.esp);
               si32(this.i4,mstate.esp + 4);
               state = 7;
               mstate.esp -= 4;
               FSM_pubrealloc.start();
               return;
            case 7:
               this.i0 = mstate.eax;
               mstate.esp += 8;
               mstate.esp = mstate.ebp;
               mstate.ebp = li32(mstate.esp);
               mstate.esp += 4;
               mstate.esp += 4;
               mstate.gworker = caller;
               return;
            default:
               throw "Invalid state in _bsonlex_destroy";
         }
         this.i11 = 0;
         mstate.esp -= 8;
         si32(this.i1,mstate.esp);
         si32(this.i11,mstate.esp + 4);
         state = 2;
         mstate.esp -= 4;
         FSM_pubrealloc.start();
      }
   }
}

