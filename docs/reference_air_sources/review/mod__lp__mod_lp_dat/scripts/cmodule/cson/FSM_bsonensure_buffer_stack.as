package cmodule.cson
{
   import avm2.intrinsics.memory.li32;
   import avm2.intrinsics.memory.si32;
   
   public final class FSM_bsonensure_buffer_stack extends Machine
   {
      
      public static const intRegCount:int = 6;
      
      public static const NumberRegCount:int = 0;
      
      public var i0:int;
      
      public var i1:int;
      
      public var i2:int;
      
      public var i3:int;
      
      public var i4:int;
      
      public var i5:int;
      
      public function FSM_bsonensure_buffer_stack()
      {
         super();
      }
      
      public static function start() : void
      {
         var _loc1_:FSM_bsonensure_buffer_stack = null;
         _loc1_ = new FSM_bsonensure_buffer_stack();
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
               if(this.i1 == 0)
               {
                  this.i1 = 4;
                  mstate.esp -= 8;
                  this.i3 = 0;
                  si32(this.i3,mstate.esp);
                  si32(this.i1,mstate.esp + 4);
                  state = 1;
                  mstate.esp -= 4;
                  FSM_pubrealloc.start();
                  return;
               }
               this.i3 = li32(this.i0 + 40);
               this.i4 = li32(this.i0 + 36);
               this.i0 += 40;
               this.i5 = this.i3 + -1;
               if(uint(this.i4) >= uint(this.i5))
               {
                  this.i3 += 8;
                  mstate.esp -= 8;
                  this.i4 = this.i3 << 2;
                  si32(this.i1,mstate.esp);
                  si32(this.i4,mstate.esp + 4);
                  state = 4;
                  mstate.esp -= 4;
                  FSM_pubrealloc.start();
                  return;
               }
               break;
            case 1:
               this.i1 = mstate.eax;
               mstate.esp += 8;
               si32(this.i1,this.i2);
               if(this.i1 == 0)
               {
                  this.i1 = cmodule.cson.___sF;
                  mstate.esp -= 12;
                  this.i0 = cmodule.cson.__2E_str260131;
                  this.i2 = cmodule.cson.__2E_str32131;
                  this.i1 += 176;
                  si32(this.i1,mstate.esp);
                  si32(this.i0,mstate.esp + 4);
                  si32(this.i2,mstate.esp + 8);
                  state = 2;
                  mstate.esp -= 4;
                  FSM_fprintf.start();
                  return;
               }
               addr01e4:
               this.i2 = 0;
               si32(this.i2,this.i1);
               this.i1 = 1;
               si32(this.i1,this.i0 + 40);
               si32(this.i2,this.i0 + 36);
               break;
            case 2:
               mstate.esp += 12;
               mstate.esp -= 4;
               this.i1 = 2;
               si32(this.i1,mstate.esp);
               §§goto(addr01b5);
            case 3:
               mstate.esp += 4;
               §§goto(addr01e4);
            case 4:
               this.i1 = mstate.eax;
               mstate.esp += 8;
               si32(this.i1,this.i2);
               if(this.i1 == 0)
               {
                  this.i0 = cmodule.cson.___sF;
                  mstate.esp -= 12;
                  this.i1 = cmodule.cson.__2E_str260131;
                  this.i3 = cmodule.cson.__2E_str32131;
                  this.i0 += 176;
                  si32(this.i0,mstate.esp);
                  si32(this.i1,mstate.esp + 4);
                  si32(this.i3,mstate.esp + 8);
                  state = 5;
                  mstate.esp -= 4;
                  FSM_fprintf.start();
                  return;
               }
               this.i2 = 0;
               this.i4 = li32(this.i0);
               this.i4 <<= 2;
               this.i1 += this.i4;
               si32(this.i2,this.i1);
               si32(this.i2,this.i1 + 4);
               si32(this.i2,this.i1 + 8);
               si32(this.i2,this.i1 + 12);
               si32(this.i2,this.i1 + 16);
               si32(this.i2,this.i1 + 20);
               si32(this.i2,this.i1 + 24);
               si32(this.i2,this.i1 + 28);
               si32(this.i3,this.i0);
               break;
            case 5:
               mstate.esp += 12;
               mstate.esp -= 4;
               this.i0 = 2;
               si32(this.i0,mstate.esp);
               addr01b5:
               state = 3;
               mstate.esp -= 4;
               FSM_exit.start();
               return;
            default:
               throw "Invalid state in _bsonensure_buffer_stack";
         }
         mstate.esp = mstate.ebp;
         mstate.ebp = li32(mstate.esp);
         mstate.esp += 4;
         mstate.esp += 4;
         mstate.gworker = caller;
      }
   }
}

