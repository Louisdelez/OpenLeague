package blix.components.loader
{
   import blix.action.QueueAction;
   import flash.net.URLRequest;
   import flash.system.ApplicationDomain;
   import flash.system.LoaderContext;
   
   public class BatchLoaderAction extends QueueAction
   {
      
      public function BatchLoaderAction()
      {
         super();
         autoInvoke = true;
         forgetActions = true;
         simultaneous = 4;
         singleInvocation = false;
      }
      
      public function addLoader(param1:LoaderX, param2:URLRequest, param3:LoaderContext) : void
      {
         param1.loaderAction.urlRequest = param2;
         param1.loaderAction.context = param3;
         param1.loaderAction.reset();
         addAction(param1.loaderAction);
      }
      
      public function addImage(param1:ImageX, param2:URLRequest, param3:LoaderContext = null) : void
      {
         if(param3 == null)
         {
            param3 = new LoaderContext();
            param3.applicationDomain = new ApplicationDomain(null);
            param3.checkPolicyFile = true;
         }
         this.addLoader(param1.getLoader(),param2,param3);
      }
      
      public function removeImage(param1:ImageX) : void
      {
         removeAction(param1.getLoader().loaderAction);
      }
   }
}

