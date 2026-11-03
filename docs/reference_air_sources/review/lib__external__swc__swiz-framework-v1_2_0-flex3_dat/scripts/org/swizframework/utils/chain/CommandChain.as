package org.swizframework.utils.chain
{
   public class CommandChain extends BaseCompositeChain
   {
      
      public function CommandChain(mode:String = "sequence", stopOnError:Boolean = true)
      {
         super(mode,stopOnError);
      }
      
      public function addCommand(command:CommandChainStep) : CommandChain
      {
         addStep(command);
         return this;
      }
      
      override public function doProceed() : void
      {
         if(currentStep is CommandChainStep)
         {
            CommandChainStep(currentStep).doProceed();
         }
         else
         {
            super.doProceed();
         }
      }
   }
}

