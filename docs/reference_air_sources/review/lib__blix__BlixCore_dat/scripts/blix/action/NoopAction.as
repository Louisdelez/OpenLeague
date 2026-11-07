package blix.action
{
   public class NoopAction extends BasicAction
   {
      
      public function NoopAction()
      {
         super(true);
      }
      
      override protected function doInvocation() : void
      {
         complete();
      }
   }
}

