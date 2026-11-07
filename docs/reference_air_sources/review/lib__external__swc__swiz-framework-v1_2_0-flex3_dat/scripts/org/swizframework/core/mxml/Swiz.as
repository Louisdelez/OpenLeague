package org.swizframework.core.mxml
{
   import flash.events.Event;
   import flash.events.IEventDispatcher;
   import mx.core.IMXMLObject;
   import mx.events.FlexEvent;
   import org.swizframework.core.IBeanFactory;
   import org.swizframework.core.ISwizConfig;
   import org.swizframework.core.Swiz;
   import org.swizframework.utils.DomainUtil;
   
   [DefaultProperty("beanProviders")]
   public class Swiz extends org.swizframework.core.Swiz implements IMXMLObject
   {
      
      public function Swiz(dispatcher:IEventDispatcher = null, config:ISwizConfig = null, beanFactory:IBeanFactory = null, beanProviders:Array = null, customProcessors:Array = null)
      {
         super(dispatcher,config,beanFactory,beanProviders,customProcessors);
      }
      
      public function initialized(document:Object, id:String) : void
      {
         if(document is IEventDispatcher && dispatcher == null)
         {
            dispatcher = IEventDispatcher(document);
            dispatcher.addEventListener(FlexEvent.PREINITIALIZE,this.handleContainerPreinitialize);
         }
      }
      
      protected function handleContainerPreinitialize(event:Event) : void
      {
         dispatcher.removeEventListener(FlexEvent.PREINITIALIZE,this.handleContainerPreinitialize);
         domain = DomainUtil.getModuleDomain(dispatcher);
         init();
      }
   }
}

