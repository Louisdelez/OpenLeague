package com.riotgames.platform.common.responder
{
   public class Responder implements IResponder
   {
      
      protected var completeFunctions:Array;
      
      protected var resultFunctions:Array;
      
      protected var errorFunctions:Array;
      
      public function Responder()
      {
         super();
      }
      
      public function addResponder(param1:Function, param2:Function = null, param3:Function = null) : void
      {
         this.addResult(param1);
         this.addError(param2);
         this.addComplete(param3);
      }
      
      protected function onResult(param1:Object = null) : void
      {
         var _loc2_:Function = null;
         if(Boolean(this.resultFunctions))
         {
            for each(_loc2_ in this.resultFunctions)
            {
               _loc2_.apply(null,[param1]);
            }
         }
      }
      
      protected function addError(param1:Function) : void
      {
         if(!this.errorFunctions)
         {
            this.errorFunctions = new Array();
         }
         if(param1 != null)
         {
            this.errorFunctions.push(param1);
         }
      }
      
      protected function onError(param1:Object = null) : void
      {
         var _loc2_:Function = null;
         if(Boolean(this.errorFunctions))
         {
            for each(_loc2_ in this.errorFunctions)
            {
               _loc2_.apply(null,[param1]);
            }
         }
      }
      
      protected function onComplete(param1:Object = null) : void
      {
         var _loc2_:Function = null;
         if(Boolean(this.completeFunctions))
         {
            for each(_loc2_ in this.completeFunctions)
            {
               _loc2_.apply(null,[param1]);
            }
         }
      }
      
      protected function addComplete(param1:Function) : void
      {
         if(!this.completeFunctions)
         {
            this.completeFunctions = new Array();
         }
         if(param1 != null)
         {
            this.completeFunctions.push(param1);
         }
      }
      
      protected function addResult(param1:Function) : void
      {
         if(!this.resultFunctions)
         {
            this.resultFunctions = new Array();
         }
         if(param1 != null)
         {
            this.resultFunctions.push(param1);
         }
      }
   }
}

