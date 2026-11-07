package org.swizframework.utils.chain
{
   public class CommandChainStep extends BaseChainStep implements IAutonomousChainStep
   {
      
      public function CommandChainStep()
      {
         super();
      }
      
      public function execute() : void
      {
      }
      
      public function doProceed() : void
      {
         this.execute();
         complete();
      }
   }
}

