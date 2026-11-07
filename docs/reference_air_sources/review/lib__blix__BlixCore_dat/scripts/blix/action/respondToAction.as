package blix.action
{
   public function respondToAction(param1:IAction, param2:Function, param3:Function, param4:Boolean = false, param5:Boolean = true) : void
   {
      if(!param1.getIsFinished())
      {
         if(param5 && !param1.getHasBeenInvoked())
         {
            param1.invoke();
         }
         if(param1.getIsOptional())
         {
            param1.getAborted().add(param2,param4);
            param1.getErred().add(param2,param4);
            param1.getCompleted().add(param2,param4);
         }
         else
         {
            param1.getAborted().add(param3,param4);
            param1.getErred().add(param3,param4);
            param1.getCompleted().add(param2,param4);
         }
      }
      else if(param1.getIsOptional())
      {
         if(!param4 && param2.length == 0)
         {
            param2();
         }
         else
         {
            param2(param1);
         }
      }
      else if(param1.getHasAborted() || param1.getHasErred())
      {
         if(!param4 && param3.length == 0)
         {
            param3();
         }
         else
         {
            param3(param1);
         }
      }
      else if(!param4 && param2.length == 0)
      {
         param2();
      }
      else
      {
         param2(param1);
      }
   }
}

