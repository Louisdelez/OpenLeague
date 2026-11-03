package cmodule.cson
{
   import flash.display.*;
   import flash.events.*;
   import flash.net.*;
   import flash.system.*;
   import flash.text.*;
   import flash.utils.*;
   
   public class MState extends MemUser
   {
      
      public var esp:int;
      
      public const syms:Object;
      
      public const ds:ByteArray;
      
      public var eax:int;
      
      public var cf:uint;
      
      public var gworker:Machine;
      
      public var st0:Number;
      
      public var ebp:int;
      
      public var funcs:Vector.<Object>;
      
      public var edx:int;
      
      public var system:CSystem;
      
      public function MState(param1:Machine)
      {
         this.ds = cmodule.cson.gstate == null || cmodule.cson.gstate.ds == null ? GLEByteArrayProvider.get() : cmodule.cson.gstate.ds;
         this.syms = cmodule.cson.gstate == null ? {} : cmodule.cson.gstate.syms;
         this.system = cmodule.cson.gstate == null ? null : cmodule.cson.gstate.system;
         this.funcs = cmodule.cson.gstate == null ? new Vector.<Object>(1) : cmodule.cson.gstate.funcs;
         super();
         if(param1)
         {
            this.gworker = param1;
            this.gworker.mstate = this;
         }
         if(cmodule.cson.gstate == null)
         {
            this.ds.length += cmodule.cson.gstackSize;
            this.esp = this.ds.length;
         }
      }
      
      public function copyTo(param1:MState) : void
      {
         param1.esp = this.esp;
         param1.ebp = this.ebp;
         param1.eax = this.eax;
         param1.edx = this.edx;
         param1.st0 = this.st0;
         param1.cf = this.cf;
         param1.gworker = this.gworker;
      }
      
      public function pop() : int
      {
         var _loc1_:int = 0;
         _loc1_ = _mr32(this.esp);
         this.esp += 4;
         return _loc1_;
      }
      
      public function push(param1:int) : void
      {
         this.esp -= 4;
         _mw32(this.esp,param1);
      }
   }
}

