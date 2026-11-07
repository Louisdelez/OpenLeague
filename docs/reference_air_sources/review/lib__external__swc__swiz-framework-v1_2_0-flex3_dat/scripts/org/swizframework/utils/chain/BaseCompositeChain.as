package org.swizframework.utils.chain
{
   public class BaseCompositeChain extends AbstractChain implements IChain
   {
      
      public function BaseCompositeChain(mode:String = "sequence", stopOnError:Boolean = true)
      {
         super(mode,stopOnError);
      }
      
      public function doProceed() : void
      {
         if(currentStep is IAutonomousChainStep)
         {
            IAutonomousChainStep(currentStep).doProceed();
         }
         else if(currentStep is IChain)
         {
            IChain(currentStep).start();
         }
      }
   }
}

