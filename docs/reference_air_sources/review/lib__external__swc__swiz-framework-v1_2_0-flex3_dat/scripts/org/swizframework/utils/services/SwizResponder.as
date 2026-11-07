package org.swizframework.utils.services
{
   import mx.rpc.IResponder;
   
   [ExcludeClass]
   public class SwizResponder implements IResponder
   {
      
      private var resultHandler:Function;
      
      private var faultHandler:Function;
      
      private var handlerArgs:Array;
      
      public function SwizResponder(resultHandler:Function, faultHandler:Function = null, handlerArgs:Array = null)
      {
         super();
         this.resultHandler = resultHandler;
         this.faultHandler = faultHandler;
         this.handlerArgs = handlerArgs;
      }
      
      public function result(data:Object) : void
      {
         if(this.handlerArgs == null)
         {
            this.resultHandler(data);
         }
         else
         {
            this.resultHandler.apply(null,[data].concat(this.handlerArgs));
         }
      }
      
      public function fault(info:Object) : void
      {
         if(this.faultHandler != null)
         {
            if(this.handlerArgs == null)
            {
               this.faultHandler(info);
            }
            else
            {
               try
               {
                  this.faultHandler(info);
               }
               catch(e:Error)
               {
                  faultHandler.apply(null,[info].concat(handlerArgs));
               }
            }
         }
      }
   }
}

