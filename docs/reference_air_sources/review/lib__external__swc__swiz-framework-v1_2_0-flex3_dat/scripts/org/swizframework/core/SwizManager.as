package org.swizframework.core
{
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.utils.Dictionary;
   import org.swizframework.processors.IMetadataProcessor;
   import org.swizframework.processors.IProcessor;
   
   public class SwizManager
   {
      
      public static var swizzes:Array = [];
      
      public static var wiredViews:Dictionary = new Dictionary(true);
      
      public static var metadataNames:Array = [];
      
      public function SwizManager()
      {
         super();
      }
      
      public static function addSwiz(swiz:ISwiz) : void
      {
         var p:IProcessor = null;
         swizzes.push(swiz);
         for each(p in swiz.processors)
         {
            if(p is IMetadataProcessor)
            {
               metadataNames = metadataNames.concat(IMetadataProcessor(p).metadataNames);
            }
         }
      }
      
      public static function removeSwiz(swiz:ISwiz) : void
      {
         swizzes.splice(swizzes.indexOf(swiz),1);
      }
      
      public static function setUp(view:DisplayObject) : void
      {
         var swiz:ISwiz = null;
         if(wiredViews[view] != null)
         {
            return;
         }
         for(var i:int = swizzes.length - 1; i > -1; i--)
         {
            swiz = ISwiz(swizzes[i]);
            if(DisplayObjectContainer(swiz.dispatcher).contains(view))
            {
               setUpView(view,swiz);
               return;
            }
         }
         setUpView(view,ISwiz(swizzes[0]));
      }
      
      private static function setUpView(viewToWire:DisplayObject, swizInstance:ISwiz) : void
      {
         wiredViews[viewToWire] = swizInstance;
         swizInstance.beanFactory.setUpBean(BeanFactory.constructBean(viewToWire,null,swizInstance.domain));
      }
      
      public static function tearDown(wiredView:DisplayObject) : void
      {
         var swiz:ISwiz = null;
         if(wiredViews[wiredView] == null)
         {
            return;
         }
         for(var i:int = swizzes.length - 1; i > -1; i--)
         {
            swiz = ISwiz(swizzes[i]);
            if(swiz.dispatcher == wiredView)
            {
               swiz.tearDown();
               return;
            }
         }
         tearDownWiredView(wiredView,wiredViews[wiredView]);
      }
      
      public static function tearDownWiredView(wiredView:DisplayObject, swizInstance:ISwiz) : void
      {
         delete wiredViews[wiredView];
         swizInstance.beanFactory.tearDownBean(BeanFactory.constructBean(wiredView,null,swizInstance.domain));
      }
      
      public static function tearDownAllWiredViewsForSwizInstance(swizInstance:ISwiz) : void
      {
         var wiredView:* = undefined;
         for(wiredView in wiredViews)
         {
            if(wiredViews[wiredView] == swizInstance)
            {
               tearDownWiredView(wiredView,swizInstance);
            }
         }
      }
   }
}

