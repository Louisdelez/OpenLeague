package org.swizframework.utils.async
{
   import org.swizframework.events.ChainEvent;
   import org.swizframework.utils.chain.IChain;
   
   public class AsynchronousChainOperation extends AbstractAsynchronousOperation implements IAsynchronousOperation
   {
      
      public function AsynchronousChainOperation(chain:IChain)
      {
         super();
         this.addEventListeners(chain);
      }
      
      protected function addEventListeners(chain:IChain) : void
      {
         chain.addEventListener(ChainEvent.CHAIN_COMPLETE,this.chainCompleteHandler);
         chain.addEventListener(ChainEvent.CHAIN_FAIL,this.chainFailHandler);
      }
      
      protected function removeEventListeners(chain:IChain) : void
      {
         chain.removeEventListener(ChainEvent.CHAIN_COMPLETE,this.chainCompleteHandler);
         chain.removeEventListener(ChainEvent.CHAIN_FAIL,this.chainFailHandler);
      }
      
      protected function chainCompleteHandler(event:ChainEvent) : void
      {
         var chain:IChain = event.target as IChain;
         this.removeEventListeners(chain);
         complete(chain);
      }
      
      protected function chainFailHandler(event:ChainEvent) : void
      {
         var chain:IChain = event.target as IChain;
         this.removeEventListeners(chain);
         fail(chain);
      }
   }
}

