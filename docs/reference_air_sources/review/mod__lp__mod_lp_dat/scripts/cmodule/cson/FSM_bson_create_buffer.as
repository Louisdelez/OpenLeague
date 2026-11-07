package cmodule.cson
{
   import avm2.intrinsics.memory.li32;
   import avm2.intrinsics.memory.li8;
   import avm2.intrinsics.memory.si32;
   import avm2.intrinsics.memory.si8;
   
   public final class FSM_bson_create_buffer extends Machine
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
      
      public function FSM_bson_create_buffer()
      {
         super();
      }
      
      public static function start() : void
      {
         var _loc1_:FSM_bson_create_buffer = null;
         _loc1_ = new FSM_bson_create_buffer();
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
               this.i0 = 48;
               mstate.esp -= 8;
               this.i1 = 0;
               si32(this.i1,mstate.esp);
               si32(this.i0,mstate.esp + 4);
               state = 1;
               mstate.esp -= 4;
               FSM_pubrealloc.start();
               return;
            case 1:
               this.i0 = mstate.eax;
               mstate.esp += 8;
               this.i1 = li32(mstate.ebp + 8);
               this.i2 = li32(mstate.ebp + 12);
               this.i3 = this.i0;
               this.i4 = this.i0;
               if(this.i0 != 0)
               {
                  break;
               }
               §§goto(addr00fb);
               break;
            case 2:
               mstate.esp += 12;
               mstate.esp -= 4;
               this.i0 = 2;
               si32(this.i0,mstate.esp);
               state = 3;
               mstate.esp -= 4;
               FSM_exit.start();
               return;
            case 3:
               mstate.esp += 4;
               break;
            case 4:
               this.i5 = mstate.eax;
               mstate.esp += 8;
               si32(this.i5,this.i3 + 4);
               this.i6 = this.i3 + 4;
               if(this.i5 == 0)
               {
                  addr00fb:
                  this.i0 = cmodule.cson.___sF;
                  mstate.esp -= 12;
                  this.i1 = cmodule.cson.__2E_str260131;
                  this.i2 = cmodule.cson.__2E_str34133;
                  this.i0 += 176;
                  si32(this.i0,mstate.esp);
                  si32(this.i1,mstate.esp + 4);
                  si32(this.i2,mstate.esp + 8);
                  state = 2;
                  mstate.esp -= 4;
                  FSM_fprintf.start();
                  return;
               }
               this.i7 = 1;
               si32(this.i7,this.i3 + 20);
               this.i7 = li32(cmodule.cson._val_2E_1088);
               if(this.i0 != 0)
               {
                  this.i0 = 0;
                  si32(this.i0,this.i3 + 16);
                  si8(this.i0,this.i5);
                  this.i5 = li32(this.i6);
                  si8(this.i0,this.i5 + 1);
                  this.i5 = li32(this.i6);
                  si32(this.i5,this.i3 + 8);
                  this.i5 = 1;
                  si32(this.i5,this.i3 + 28);
                  si32(this.i0,this.i3 + 44);
                  this.i0 = li32(this.i2 + 44);
                  if(this.i0 == 0)
                  {
                     this.i5 = 0;
                  }
                  else
                  {
                     this.i5 = li32(this.i2 + 36);
                     this.i5 <<= 2;
                     this.i5 = this.i0 + this.i5;
                     this.i5 = li32(this.i5);
                  }
                  if(this.i5 == this.i3)
                  {
                     this.i5 = li32(this.i2 + 36);
                     this.i5 <<= 2;
                     this.i0 += this.i5;
                     this.i5 = li32(this.i0);
                     this.i5 = li32(this.i5 + 16);
                     si32(this.i5,this.i2 + 52);
                     this.i5 = li32(this.i0);
                     this.i5 = li32(this.i5 + 8);
                     si32(this.i5,this.i2 + 60);
                     si32(this.i5,this.i2 + 104);
                     this.i0 = li32(this.i0);
                     this.i0 = li32(this.i0);
                     si32(this.i0,this.i2 + 28);
                     this.i0 = li8(this.i5);
                     si8(this.i0,this.i2 + 48);
                  }
               }
               this.i0 = 1;
               si32(this.i1,this.i4);
               si32(this.i0,this.i3 + 40);
               this.i0 = li32(this.i2 + 44);
               if(this.i0 == 0)
               {
                  this.i0 = 0;
               }
               else
               {
                  this.i1 = li32(this.i2 + 36);
                  this.i1 <<= 2;
                  this.i0 += this.i1;
                  this.i0 = li32(this.i0);
               }
               this.i1 = this.i3 + 24;
               if(this.i0 != this.i3)
               {
                  this.i0 = 1;
                  si32(this.i0,this.i3 + 32);
                  this.i0 = 0;
                  si32(this.i0,this.i3 + 36);
               }
               else
               {
                  this.i0 = 0;
               }
               si32(this.i0,this.i1);
               si32(this.i7,cmodule.cson._val_2E_1088);
               mstate.eax = this.i3;
               mstate.esp = mstate.ebp;
               mstate.ebp = li32(mstate.esp);
               mstate.esp += 4;
               mstate.esp += 4;
               mstate.gworker = caller;
               return;
               break;
            default:
               throw "Invalid state in _bson_create_buffer";
         }
         this.i5 = 16384;
         si32(this.i5,this.i3 + 12);
         mstate.esp -= 8;
         this.i5 = 16386;
         this.i6 = 0;
         si32(this.i6,mstate.esp);
         si32(this.i5,mstate.esp + 4);
         state = 4;
         mstate.esp -= 4;
         FSM_pubrealloc.start();
      }
   }
}

