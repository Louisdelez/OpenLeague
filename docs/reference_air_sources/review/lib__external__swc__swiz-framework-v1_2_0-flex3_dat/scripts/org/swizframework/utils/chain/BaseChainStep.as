package org.swizframework.utils.chain
{
   public class BaseChainStep implements IChainStep
   {
      
      protected var _chain:IChain;
      
      protected var _failed:Boolean = false;
      
      protected var _isComplete:Boolean = false;
      
      public function BaseChainStep()
      {
         super();
      }
      
      public function get chain() : IChain
      {
         return this._chain;
      }
      
      public function set chain(value:IChain) : void
      {
         this._chain = value;
      }
      
      public function get failed() : Boolean
      {
         return this._failed;
      }
      
      public function get isComplete() : Boolean
      {
         return this._isComplete;
      }
      
      public function complete() : void
      {
         if(!this._failed)
         {
            this._isComplete = true;
            if(this.chain != null)
            {
               this.chain.stepComplete();
            }
         }
      }
      
      public function error() : void
      {
         this._failed = true;
         this._isComplete = true;
         if(this.chain != null)
         {
            this.chain.stepError();
         }
      }
   }
}

