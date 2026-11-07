package org.swizframework.utils.chain
{
   import flash.events.EventDispatcher;
   import org.swizframework.events.ChainEvent;
   
   [Event(name="chainFail",type="org.swizframework.events.ChainEvent")]
   [Event(name="chainComplete",type="org.swizframework.events.ChainEvent")]
   [Event(name="chainStepError",type="org.swizframework.events.ChainEvent")]
   [Event(name="chainStepComplete",type="org.swizframework.events.ChainEvent")]
   [Event(name="chainStart",type="org.swizframework.events.ChainEvent")]
   public class AbstractChain extends EventDispatcher implements IChainStep
   {
      
      public var mode:String = "sequence";
      
      public var steps:Array = [];
      
      protected var _chain:IChain;
      
      protected var _isComplete:Boolean = true;
      
      protected var _isError:Boolean = false;
      
      protected var _position:int = -1;
      
      protected var _stopOnError:Boolean;
      
      public function AbstractChain(mode:String = "sequence", stopOnError:Boolean = true)
      {
         super();
         this.mode = mode;
         this.stopOnError = stopOnError;
      }
      
      public function get currentStep() : IChainStep
      {
         return IChainStep(this.steps[this.position]);
      }
      
      public function get chain() : IChain
      {
         return this._chain;
      }
      
      public function set chain(value:IChain) : void
      {
         this._chain = value;
      }
      
      public function get isComplete() : Boolean
      {
         return this._isComplete;
      }
      
      public function get isError() : Boolean
      {
         return this._isError;
      }
      
      public function get position() : int
      {
         return this._position;
      }
      
      public function set position(value:int) : void
      {
         this._position = value;
      }
      
      public function get stopOnError() : Boolean
      {
         return this._stopOnError;
      }
      
      public function set stopOnError(value:Boolean) : void
      {
         this._stopOnError = value;
      }
      
      public function addStep(step:IChainStep) : IChain
      {
         step.chain = IChain(this);
         this.steps.push(step);
         return IChain(this);
      }
      
      public function hasNext() : Boolean
      {
         return this.position + 1 < this.steps.length;
      }
      
      public function start() : void
      {
         if(this._isComplete)
         {
            this._isComplete = false;
            this._isError = false;
            this.position = -1;
            this.proceed();
         }
      }
      
      public function stepComplete() : void
      {
         var i:int = 0;
         dispatchEvent(new ChainEvent(ChainEvent.CHAIN_STEP_COMPLETE));
         if(this.mode == ChainType.SEQUENCE)
         {
            this.proceed();
         }
         else
         {
            for(i = 0; i < this.steps.length; i++)
            {
               if(!IChainStep(this.steps[i]).isComplete)
               {
                  return;
               }
            }
            this.complete();
         }
      }
      
      public function proceed() : void
      {
         var i:int = 0;
         if(this.position == -1)
         {
            dispatchEvent(new ChainEvent(ChainEvent.CHAIN_START));
         }
         if(!this._isError)
         {
            if(this.mode == ChainType.SEQUENCE)
            {
               if(this.hasNext())
               {
                  ++this.position;
                  IChain(this).doProceed();
               }
               else
               {
                  this.complete();
               }
            }
            else
            {
               for(i = 0; i < this.steps.length; i++)
               {
                  this.position = i;
                  IChain(this).doProceed();
               }
            }
         }
      }
      
      public function stepError() : void
      {
         dispatchEvent(new ChainEvent(ChainEvent.CHAIN_STEP_ERROR));
         if(!this.stopOnError)
         {
            this.proceed();
         }
         else
         {
            this.fail();
         }
      }
      
      public function complete() : void
      {
         dispatchEvent(new ChainEvent(ChainEvent.CHAIN_COMPLETE));
         this._isComplete = true;
         if(this.chain != null)
         {
            this.chain.stepComplete();
         }
      }
      
      public function error() : void
      {
         this.fail();
      }
      
      protected function fail() : void
      {
         dispatchEvent(new ChainEvent(ChainEvent.CHAIN_FAIL));
         this._isError = true;
         this._isComplete = true;
         if(this.chain != null)
         {
            this.chain.stepError();
         }
      }
   }
}

