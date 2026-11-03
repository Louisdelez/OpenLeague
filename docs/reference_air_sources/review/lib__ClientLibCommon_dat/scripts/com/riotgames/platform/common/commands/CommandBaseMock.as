package com.riotgames.platform.common.commands
{
   public class CommandBaseMock extends CommandBase
   {
      
      private var shouldSucceed:Boolean = false;
      
      public function CommandBaseMock(param1:Boolean)
      {
         super();
         this.shouldSucceed = param1;
      }
      
      override public function execute() : void
      {
         super.execute();
         if(this.shouldSucceed)
         {
            onResult();
         }
         else
         {
            onError();
         }
         onComplete();
      }
   }
}

