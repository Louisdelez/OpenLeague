package cmodule.cson
{
   import flash.display.*;
   import flash.events.*;
   import flash.net.*;
   import flash.system.*;
   import flash.text.*;
   import flash.utils.*;
   
   internal class CProcTypemap extends CTypemap
   {
      
      private var retTypemap:CTypemap;
      
      private var varargs:Boolean;
      
      private var argTypemaps:Array;
      
      private var async:Boolean;
      
      public function CProcTypemap(param1:CTypemap, param2:Array, param3:Boolean = false, param4:Boolean = false)
      {
         super();
         this.retTypemap = param1;
         this.argTypemaps = param2;
         this.varargs = param3;
         this.async = param4;
      }
      
      override public function createC(param1:*, param2:int = 0) : Array
      {
         var id:int = 0;
         var v:* = param1;
         var ptr:int = param2;
         id = cmodule.cson.regFunc(function():void
         {
            var args:* = undefined;
            var sp:* = undefined;
            var n:* = undefined;
            var tm:* = undefined;
            var aa:* = undefined;
            var ts:* = undefined;
            args = [];
            cmodule.cson.mstate.pop();
            sp = cmodule.cson.mstate.esp;
            n = 0;
            while(n < argTypemaps.length)
            {
               tm = argTypemaps[n];
               aa = [];
               ts = tm.typeSize;
               cmodule.cson.mstate.ds.position = sp;
               sp += ts;
               while(ts)
               {
                  aa.push(cmodule.cson.mstate.ds.readInt());
                  ts -= 4;
               }
               args.push(tm.fromC(aa));
               n++;
            }
            if(varargs)
            {
               args.push(sp);
            }
            try
            {
               retTypemap.toReturnRegs(cmodule.cson.mstate,v.apply(null,args));
            }
            catch(e:*)
            {
               cmodule.cson.mstate.eax = 0;
               cmodule.cson.mstate.edx = 0;
               cmodule.cson.mstate.st0 = 0;
               cmodule.cson.log(2,"v.apply: " + e.toString());
            }
         });
         return [id];
      }
      
      override public function destroyC(param1:Array) : void
      {
         cmodule.cson.unregFunc(int(param1[0]));
      }
      
      override public function fromC(param1:Array) : *
      {
         var v:Array = param1;
         return function(... rest):*
         {
            var sp:* = undefined;
            var cargs:* = undefined;
            var n:* = undefined;
            var asyncHandler:* = undefined;
            var oldWorker:* = undefined;
            var arg:* = undefined;
            var carg:* = undefined;
            var args:Array = rest;
            var cleanup:Function = function():void
            {
               n = cargs.length - 1;
               while(n >= 0)
               {
                  argTypemaps[n].destroyC(cargs[n]);
                  --n;
               }
               cmodule.cson.mstate.esp = sp;
               cmodule.cson.mstate.gworker = oldWorker;
            };
            sp = cmodule.cson.mstate.esp;
            cargs = [];
            oldWorker = cmodule.cson.mstate.gworker;
            if(async)
            {
               asyncHandler = args.shift();
               cmodule.cson.mstate.gworker = new NotifyMachine(function():Boolean
               {
                  var result:* = undefined;
                  result = retTypemap.fromReturnRegs(cmodule.cson.mstate);
                  cleanup();
                  try
                  {
                     asyncHandler(result);
                  }
                  catch(e:*)
                  {
                     cmodule.cson.log(1,"asyncHandler: " + e.toString());
                  }
                  return true;
               });
            }
            n = args.length - 1;
            while(n >= 0)
            {
               arg = args[n];
               if(n >= argTypemaps.length)
               {
                  push(arg);
               }
               else
               {
                  carg = argTypemaps[n].createC(arg);
                  cargs[n] = carg;
                  push(carg);
               }
               n--;
            }
            cmodule.cson.mstate.push(0);
            if(asyncHandler)
            {
               try
               {
                  cmodule.cson.mstate.funcs[int(v[0])]();
               }
               catch(e:AlchemyYield)
               {
               }
               catch(e:AlchemyDispatch)
               {
               }
               catch(e:AlchemyBlock)
               {
               }
               catch(e:*)
               {
                  cleanup();
                  throw e;
               }
               return;
            }
            try
            {
               try
               {
                  cmodule.cson.mstate.funcs[int(v[0])]();
               }
               catch(e:AlchemyYield)
               {
               }
               catch(e:AlchemyDispatch)
               {
               }
               while(cmodule.cson.mstate.gworker !== oldWorker)
               {
                  try
                  {
                     while(cmodule.cson.mstate.gworker !== oldWorker)
                     {
                        cmodule.cson.mstate.gworker.work();
                     }
                  }
                  catch(e:AlchemyYield)
                  {
                  }
                  catch(e:AlchemyDispatch)
                  {
                  }
               }
               return retTypemap.fromReturnRegs(cmodule.cson.mstate);
            }
            finally
            {
               cleanup();
            }
         };
      }
      
      private function push(param1:*) : void
      {
         var _loc2_:* = 0;
         if(param1 is Array)
         {
            _loc2_ = int(param1.length - 1);
            while(_loc2_ >= 0)
            {
               cmodule.cson.mstate.push(param1[_loc2_]);
               _loc2_--;
            }
         }
         else
         {
            cmodule.cson.mstate.push(param1);
         }
      }
   }
}

