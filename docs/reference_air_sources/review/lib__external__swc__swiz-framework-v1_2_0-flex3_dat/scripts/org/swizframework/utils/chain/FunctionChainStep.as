package org.swizframework.utils.chain
{
   public class FunctionChainStep extends BaseChainStep implements IAutonomousChainStep
   {
      
      public var functionRef:Function;
      
      public var functionArgArray:Array;
      
      public var functionThisArg:*;
      
      public var returnValue:*;
      
      public function FunctionChainStep(functionRef:Function, functionArgArray:Array = null, functionThisArg:* = null)
      {
         super();
         this.functionRef = functionRef;
         this.functionArgArray = functionArgArray;
         this.functionThisArg = functionThisArg;
      }
      
      public function doProceed() : void
      {
         this.returnValue = this.functionRef.apply(this.functionThisArg,this.functionArgArray);
         complete();
      }
   }
}

